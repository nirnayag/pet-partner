import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/core/models/pet_owner.dart';
import 'package:partner/services/pet_owner_service.dart';
import 'package:partner/services/pet_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the pet-owner detail screen.
class PetOwnerDetailViewModel
    extends BaseViewModel
    with ErrorHandlingMixin {
  /// Creates a [PetOwnerDetailViewModel].
  PetOwnerDetailViewModel({
    required this.ownerId,
  });

  /// The ID of the pet owner to display.
  final String ownerId;

  final _petOwnerService =
      locator<PetOwnerService>();
  final _petService = locator<PetService>();
  final _navigationService =
      locator<NavigationService>();

  // ------------------------------------------------
  // State
  // ------------------------------------------------

  PetOwner? _owner;

  /// The loaded pet owner details.
  PetOwner? get owner => _owner;

  List<Pet> _pets = <Pet>[];

  /// Pets belonging to this owner.
  List<Pet> get pets => _pets;

  // ------------------------------------------------
  // Lifecycle
  // ------------------------------------------------

  /// Loads the owner details and their pets.
  Future<void> initialise() async {
    setBusy(true);
    await runSafe(() async {
      _owner = await _petOwnerService
          .getPetOwnerById(ownerId);
      final petResponse =
          await _petService.getPets();
      _pets = petResponse.items;
    });
    setBusy(false);
  }

  /// Pull-to-refresh handler.
  Future<void> refresh() async {
    clearError();
    await initialise();
  }

  // ------------------------------------------------
  // Navigation
  // ------------------------------------------------

  /// Navigate to the edit form for this owner.
  void onEditTapped() {
    if (_owner == null) return;
    _navigationService.navigateToPetOwnerFormView(
      owner: _owner,
    );
  }

  /// Navigate to a pet profile.
  void onPetTapped(Pet pet) {
    _navigationService
        .navigateToPatientProfileView(
      petId: pet.id,
    );
  }

  /// Navigate to book an appointment.
  void onBookAppointment() {
    _navigationService
        .navigateToAppointmentFormView();
  }

  /// Go back.
  void onBackTapped() {
    _navigationService.back<void>();
  }
}

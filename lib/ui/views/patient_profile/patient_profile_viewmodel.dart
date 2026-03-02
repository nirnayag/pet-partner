import 'dart:async';

import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/core/utils/permission_utils.dart';
import 'package:partner/services/auth_service.dart';
import 'package:partner/services/pet_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the patient profile screen.
///
/// Fetches a single pet by ID and exposes its data
/// plus permission checks for the current user.
class PatientProfileViewModel extends BaseViewModel
    with ErrorHandlingMixin {
  /// Creates a [PatientProfileViewModel].
  ///
  /// Requires [petId] to load the correct pet.
  PatientProfileViewModel({required this.petId});

  /// The pet ID to fetch.
  final String petId;

  final _petService = locator<PetService>();
  final _navigationService =
      locator<NavigationService>();
  final _authService = locator<AuthService>();

  // --------------------------------------------------
  // State
  // --------------------------------------------------

  Pet? _pet;

  /// The loaded pet, or `null` while loading.
  Pet? get pet => _pet;

  int _currentTabIndex = 0;

  /// The currently selected tab index.
  int get currentTabIndex => _currentTabIndex;

  Map<String, dynamic>? _medicalSummary;

  /// The medical summary data, if loaded.
  Map<String, dynamic>? get medicalSummary =>
      _medicalSummary;

  // --------------------------------------------------
  // Permissions
  // --------------------------------------------------

  /// Whether the current user can edit pet data.
  bool get canEditPet {
    final role = _authService.currentRole;
    if (role == null) return false;
    return PermissionUtils.hasPermission(
      role,
      'pets:update',
    );
  }

  // --------------------------------------------------
  // Lifecycle
  // --------------------------------------------------

  /// Called once when the view is ready.
  Future<void> initialise() async {
    await _loadPet();
  }

  // --------------------------------------------------
  // Data loading
  // --------------------------------------------------

  Future<void> _loadPet() async {
    setBusy(true);
    await runSafe(() async {
      _pet = await _petService.getPetById(petId);
      unawaited(_loadMedicalSummary());
    });
    setBusy(false);
  }

  Future<void> _loadMedicalSummary() async {
    await runSafe(() async {
      _medicalSummary = await _petService
          .getPetMedicalSummary(petId);
      notifyListeners();
    });
  }

  /// Retry loading after an error.
  Future<void> retry() async {
    await _loadPet();
  }

  // --------------------------------------------------
  // Tab management
  // --------------------------------------------------

  /// Updates the active tab.
  void setTabIndex(int index) {
    _currentTabIndex = index;
    notifyListeners();
  }

  // --------------------------------------------------
  // Navigation
  // --------------------------------------------------

  /// Navigates to the edit form for the current pet.
  void navigateToEditPet() {
    if (_pet == null) return;
    _navigationService.navigateToPetFormView(
      pet: _pet,
    );
  }

  /// Pops back to the previous screen.
  void goBack() {
    _navigationService.back<void>();
  }
}

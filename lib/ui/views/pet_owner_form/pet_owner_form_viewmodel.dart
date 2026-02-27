import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/pet_owner.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/pet_owner_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for creating or editing a pet owner.
class PetOwnerFormViewModel extends BaseViewModel {
  /// Creates a [PetOwnerFormViewModel].
  ///
  /// When [owner] is provided the form opens in
  /// edit mode with pre-populated fields.
  PetOwnerFormViewModel({this.owner});

  /// The owner being edited, or `null` for
  /// create mode.
  final PetOwner? owner;

  final _petOwnerService =
      locator<PetOwnerService>();
  final _navigationService =
      locator<NavigationService>();

  // ---- Controllers ----

  /// Controller for the first name field.
  final firstNameController =
      TextEditingController();

  /// Controller for the last name field.
  final lastNameController =
      TextEditingController();

  /// Controller for the phone field.
  final phoneController = TextEditingController();

  /// Controller for the email field.
  final emailController = TextEditingController();

  // ---- Form state ----

  /// Whether the form is in edit mode.
  bool get isEditMode => owner != null;

  /// Validation / API error message.
  String? errorMessage;

  PetOwner? _lookupResult;

  /// The result of a phone lookup, if any.
  PetOwner? get lookupResult => _lookupResult;

  bool _isLookingUp = false;

  /// Whether a phone lookup is in progress.
  bool get isLookingUp => _isLookingUp;

  // ---- Lifecycle ----

  /// Initialises the form. Pre-populates fields
  /// when editing an existing owner.
  void initialise() {
    if (owner == null) return;
    firstNameController.text = owner!.firstName;
    lastNameController.text = owner!.lastName;
    phoneController.text = owner!.phone;
    emailController.text = owner!.email ?? '';
    notifyListeners();
  }

  // ---- Phone lookup ----

  /// Looks up whether a pet owner with the given
  /// phone number already exists.
  Future<void> lookupByPhone() async {
    final phone = phoneController.text.trim();
    if (phone.isEmpty) return;

    _isLookingUp = true;
    _lookupResult = null;
    notifyListeners();

    try {
      _lookupResult =
          await _petOwnerService.lookupByPhone(
        phone,
      );
    } on ApiException catch (e) {
      errorMessage = e.message;
    }

    _isLookingUp = false;
    notifyListeners();
  }

  /// Clears the phone lookup result.
  void clearLookup() {
    _lookupResult = null;
    notifyListeners();
  }

  // ---- Save ----

  /// Validates fields and creates or updates
  /// the pet owner.
  Future<void> save() async {
    errorMessage = null;

    final firstName =
        firstNameController.text.trim();
    final lastName =
        lastNameController.text.trim();
    final phone = phoneController.text.trim();

    if (firstName.isEmpty) {
      errorMessage = 'First name is required.';
      notifyListeners();
      return;
    }
    if (lastName.isEmpty) {
      errorMessage = 'Last name is required.';
      notifyListeners();
      return;
    }
    if (phone.isEmpty) {
      errorMessage = 'Phone number is required.';
      notifyListeners();
      return;
    }

    final email = emailController.text.trim();

    final data = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      if (email.isNotEmpty) 'email': email,
    };

    setBusy(true);
    try {
      if (isEditMode) {
        await _petOwnerService.updatePetOwner(
          owner!.id,
          data,
        );
      } else {
        await _petOwnerService
            .createPetOwner(data);
      }
      _navigationService.back<void>();
    } on ApiException catch (e) {
      errorMessage = e.message;
    }
    setBusy(false);
  }

  /// Navigates back without saving.
  void onBackTapped() {
    _navigationService.back<void>();
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    phoneController.dispose();
    emailController.dispose();
    super.dispose();
  }
}

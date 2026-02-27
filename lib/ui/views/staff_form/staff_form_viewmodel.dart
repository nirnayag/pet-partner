import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/enums/user_role.dart';
import 'package:partner/core/models/auth/user.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/user_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for creating or editing a staff
/// member.
class StaffFormViewModel extends BaseViewModel {
  /// Creates a [StaffFormViewModel].
  ///
  /// When [user] is provided the form opens in
  /// edit mode.
  StaffFormViewModel({this.user});

  /// The user being edited, or `null` for create.
  final User? user;

  final _userService = locator<UserService>();
  final _navigationService =
      locator<NavigationService>();

  // ---- Controllers ----

  /// Controller for the first name field.
  final firstNameController =
      TextEditingController();

  /// Controller for the last name field.
  final lastNameController =
      TextEditingController();

  /// Controller for the email field.
  final emailController = TextEditingController();

  /// Controller for the phone field.
  final phoneController = TextEditingController();

  /// Controller for the password field.
  final passwordController =
      TextEditingController();

  /// Controller for the specialization field.
  final specializationController =
      TextEditingController();

  /// Controller for the bio field.
  final bioController = TextEditingController();

  // ---- State ----

  UserRole _selectedRole = UserRole.staff;

  /// The selected role.
  UserRole get selectedRole => _selectedRole;

  /// Whether the form is in edit mode.
  bool get isEditMode => user != null;

  /// Whether vet-specific fields are shown.
  bool get showVetFields =>
      _selectedRole == UserRole.veterinarian;

  /// Validation error message, if any.
  String? errorMessage;

  // ---- Lifecycle ----

  /// Initialises form fields from the user
  /// (edit mode).
  void initialise() {
    if (user != null) {
      firstNameController.text = user!.firstName;
      lastNameController.text = user!.lastName;
      emailController.text = user!.email ?? '';
      phoneController.text = user!.phone ?? '';
      _selectedRole = user!.activeRole;
      specializationController.text =
          user!.specialization ?? '';
      bioController.text = user!.bio ?? '';
      notifyListeners();
    }
  }

  // ---- Setters ----

  /// Sets the selected role.
  void setRole(UserRole role) {
    _selectedRole = role;
    notifyListeners();
  }

  // ---- Save ----

  /// Validates and saves the staff member.
  Future<void> save() async {
    errorMessage = null;

    final firstName =
        firstNameController.text.trim();
    final lastName =
        lastNameController.text.trim();
    final email = emailController.text.trim();

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

    if (email.isEmpty) {
      errorMessage = 'Email is required.';
      notifyListeners();
      return;
    }

    if (!isEditMode &&
        passwordController.text.trim().isEmpty) {
      errorMessage = 'Password is required.';
      notifyListeners();
      return;
    }

    final data = <String, dynamic>{
      'firstName': firstName,
      'lastName': lastName,
      'email': email,
      'role': _selectedRole.value,
    };

    final phone = phoneController.text.trim();
    if (phone.isNotEmpty) {
      data['phone'] = phone;
    }

    if (!isEditMode) {
      data['password'] =
          passwordController.text.trim();
    }

    if (_selectedRole == UserRole.veterinarian) {
      final spec =
          specializationController.text.trim();
      if (spec.isNotEmpty) {
        data['specialization'] = spec;
      }
      final bio = bioController.text.trim();
      if (bio.isNotEmpty) {
        data['bio'] = bio;
      }
    }

    setBusy(true);
    try {
      if (isEditMode) {
        await _userService.updateUser(
          user!.id,
          data,
        );
      } else {
        await _userService.createUser(data);
      }
      _navigationService.back();
    } on ApiException catch (e) {
      errorMessage = e.message;
    }
    setBusy(false);
  }

  @override
  void dispose() {
    firstNameController.dispose();
    lastNameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    passwordController.dispose();
    specializationController.dispose();
    bioController.dispose();
    super.dispose();
  }
}

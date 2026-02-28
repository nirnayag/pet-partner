import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/clinic/clinic.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/clinic_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the clinic settings screen.
///
/// Loads clinic info and settings, then saves
/// updates back to the API.
class ClinicSettingsViewModel
    extends BaseViewModel {
  final _clinicService = locator<ClinicService>();
  final _navigationService =
      locator<NavigationService>();

  // ---- Controllers ----

  /// Clinic name controller.
  final nameController = TextEditingController();

  /// Clinic email controller.
  final emailController = TextEditingController();

  /// Clinic phone controller.
  final phoneController = TextEditingController();

  /// Street address controller.
  final streetController = TextEditingController();

  /// City controller.
  final cityController = TextEditingController();

  /// State controller.
  final stateController = TextEditingController();

  /// Zip code controller.
  final zipCodeController =
      TextEditingController();

  /// Country controller.
  final countryController =
      TextEditingController();

  // ---- State ----

  Clinic? _clinic;

  /// The loaded clinic info.
  Clinic? get clinic => _clinic;

  Map<String, dynamic> _settings =
      <String, dynamic>{};

  /// The loaded clinic settings map.
  Map<String, dynamic> get settings => _settings;

  String? _errorMessage;

  /// Error message, or `null`.
  String? get errorMessage => _errorMessage;

  bool _isSaving = false;

  /// Whether a save operation is running.
  bool get isSaving => _isSaving;

  /// Success feedback message.
  String? successMessage;

  // ---- Lifecycle ----

  /// Loads clinic info and settings.
  Future<void> initialise() async {
    setBusy(true);
    _errorMessage = null;
    try {
      _clinic = await _clinicService
          .getClinicInfo();
      _settings = await _clinicService
          .getClinicSettings();
      _populateFields();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    }
    setBusy(false);
  }

  void _populateFields() {
    if (_clinic == null) return;
    nameController.text = _clinic!.name;
    emailController.text = _clinic!.email ?? '';
    phoneController.text = _clinic!.phone ?? '';
    streetController.text =
        _clinic!.address?.street ?? '';
    cityController.text =
        _clinic!.address?.city ?? '';
    stateController.text =
        _clinic!.address?.state ?? '';
    zipCodeController.text =
        _clinic!.address?.zipCode ?? '';
    countryController.text =
        _clinic!.address?.country ?? '';
  }

  // ---- Save ----

  /// Saves the clinic info updates.
  Future<void> saveClinicInfo() async {
    _isSaving = true;
    _errorMessage = null;
    successMessage = null;
    notifyListeners();
    try {
      final data = <String, dynamic>{
        'name': nameController.text.trim(),
        'email': emailController.text.trim(),
        'phone': phoneController.text.trim(),
        'address': <String, dynamic>{
          'street': streetController.text.trim(),
          'city': cityController.text.trim(),
          'state': stateController.text.trim(),
          'zipCode':
              zipCodeController.text.trim(),
          'country':
              countryController.text.trim(),
        },
      };

      _clinic = await _clinicService
          .updateClinicInfo(data);
      successMessage = 'Clinic info saved.';
    } on ApiException catch (e) {
      _errorMessage = e.message;
    }
    _isSaving = false;
    notifyListeners();
  }

  /// Saves the clinic settings updates.
  Future<void> saveSettings(
    Map<String, dynamic> data,
  ) async {
    _isSaving = true;
    _errorMessage = null;
    successMessage = null;
    notifyListeners();
    try {
      _settings = await _clinicService
          .updateClinicSettings(data);
      successMessage = 'Settings saved.';
    } on ApiException catch (e) {
      _errorMessage = e.message;
    }
    _isSaving = false;
    notifyListeners();
  }

  /// Navigates back.
  void goBack() {
    _navigationService.back();
  }

  @override
  void dispose() {
    nameController.dispose();
    emailController.dispose();
    phoneController.dispose();
    streetController.dispose();
    cityController.dispose();
    stateController.dispose();
    zipCodeController.dispose();
    countryController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/clinic/clinic_branding.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/clinic_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the clinic branding screen.
///
/// Loads and saves the clinic's logo and primary
/// colour.
class ClinicBrandingViewModel
    extends BaseViewModel {
  final _clinicService = locator<ClinicService>();
  final _navigationService =
      locator<NavigationService>();

  // ---- State ----

  ClinicBranding? _branding;

  /// The loaded branding configuration.
  ClinicBranding? get branding => _branding;

  String? _logoUrl;

  /// The current logo URL.
  String? get logoUrl => _logoUrl;

  String _primaryColor = '#13EC13';

  /// The selected primary colour as hex.
  String get primaryColor => _primaryColor;

  String? _errorMessage;

  /// Error message, or `null`.
  String? get errorMessage => _errorMessage;

  bool _isSaving = false;

  /// Whether a save operation is running.
  bool get isSaving => _isSaving;

  /// Success feedback message.
  String? successMessage;

  // ---- Lifecycle ----

  /// Loads the clinic branding info.
  Future<void> initialise() async {
    setBusy(true);
    _errorMessage = null;
    try {
      _branding = await _clinicService
          .getClinicBranding();
      _logoUrl = _branding?.logoUrl;
      _primaryColor =
          _branding?.primaryColor ?? '#13EC13';
    } on ApiException catch (e) {
      _errorMessage = e.message;
    }
    setBusy(false);
  }

  // ---- Setters ----

  /// Updates the primary colour.
  void setPrimaryColor(String hex) {
    _primaryColor = hex;
    notifyListeners();
  }

  /// Updates the logo URL.
  void setLogoUrl(String url) {
    _logoUrl = url;
    notifyListeners();
  }

  // ---- Save ----

  /// Saves the branding changes.
  Future<void> save() async {
    _isSaving = true;
    _errorMessage = null;
    successMessage = null;
    notifyListeners();
    try {
      _branding = await _clinicService
          .updateClinicBranding(
        <String, dynamic>{
          'primaryColor': _primaryColor,
          if (_logoUrl != null)
            'logoUrl': _logoUrl,
        },
      );
      successMessage = 'Branding saved.';
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

  /// Parses a hex colour string to a [Color].
  Color get parsedColor {
    try {
      final hex = _primaryColor.replaceAll(
        '#',
        '',
      );
      return Color(
        int.parse('FF$hex', radix: 16),
      );
    } on Object {
      return const Color(0xFF13EC13);
    }
  }
}

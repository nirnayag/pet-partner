import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/clinic/clinic_branding.dart';
import 'package:partner/services/clinic_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the clinic branding screen.
///
/// Loads and saves the clinic's logo and primary
/// colour.
class ClinicBrandingViewModel
    extends BaseViewModel
    with ErrorHandlingMixin {
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

  // errorMessage and hasError provided by
  // ErrorHandlingMixin.

  bool _isSaving = false;

  /// Whether a save operation is running.
  bool get isSaving => _isSaving;

  /// Success feedback message.
  String? successMessage;

  // ---- Lifecycle ----

  /// Loads the clinic branding info.
  Future<void> initialise() async {
    setBusy(true);
    clearError();
    final result = await runSafe(
      () => _clinicService.getClinicBranding(),
    );
    if (result != null) {
      _branding = result;
      _logoUrl = _branding?.logoUrl;
      _primaryColor =
          _branding?.primaryColor ?? '#13EC13';
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
    clearError();
    successMessage = null;
    notifyListeners();

    final result = await runSafe(
      () => _clinicService.updateClinicBranding(
        <String, dynamic>{
          'primaryColor': _primaryColor,
          if (_logoUrl != null)
            'logoUrl': _logoUrl,
        },
      ),
    );
    if (result != null) {
      _branding = result;
      successMessage = 'Branding saved.';
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

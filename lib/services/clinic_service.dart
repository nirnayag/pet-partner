import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/core/models/clinic/clinic.dart';
import 'package:partner/core/models/clinic/clinic_branding.dart';
import 'package:partner/services/api_client.dart';

/// Handles clinic info, settings, and branding
/// API calls.
class ClinicService {
  final _apiClient = locator<ApiClient>();

  /// Fetches the current clinic information.
  Future<Clinic> getClinicInfo() async {
    final body = await _apiClient.get(
      ApiConfig.clinicEndpoint,
    ) as Map<String, dynamic>;

    return Clinic.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Updates the clinic information.
  Future<Clinic> updateClinicInfo(
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.clinicEndpoint,
      data: data,
    ) as Map<String, dynamic>;

    return Clinic.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Fetches the clinic settings.
  Future<Map<String, dynamic>>
      getClinicSettings() async {
    final body = await _apiClient.get(
      ApiConfig.settingsEndpoint,
    ) as Map<String, dynamic>;

    return body['data'] as Map<String, dynamic>;
  }

  /// Updates the clinic settings.
  Future<Map<String, dynamic>>
      updateClinicSettings(
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.settingsEndpoint,
      data: data,
    ) as Map<String, dynamic>;

    return body['data'] as Map<String, dynamic>;
  }

  /// Fetches the clinic branding.
  Future<ClinicBranding>
      getClinicBranding() async {
    final body = await _apiClient.get(
      ApiConfig.brandingEndpoint,
    ) as Map<String, dynamic>;

    final data =
        body['data'] as Map<String, dynamic>;
    return ClinicBranding.fromJson(
      data['branding'] as Map<String, dynamic>,
    );
  }

  /// Updates the clinic branding.
  Future<ClinicBranding> updateClinicBranding(
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.brandingEndpoint,
      data: data,
    ) as Map<String, dynamic>;

    return ClinicBranding.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }
}

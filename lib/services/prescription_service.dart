import 'dart:typed_data';

import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/core/models/medical/prescription.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/services/api_client.dart';

/// Handles prescription-related API calls.
class PrescriptionService {
  final _apiClient = locator<ApiClient>();

  /// Fetches a paginated list of prescriptions.
  ///
  /// Optionally filter by [petId] or [isActive].
  Future<PaginatedResponse<Prescription>>
      getPrescriptions({
    int page = 1,
    int limit = 20,
    String? petId,
    bool? isActive,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (petId != null) 'petId': petId,
      if (isActive != null)
        'isActive': isActive,
    };

    final body = await _apiClient.get(
      ApiConfig.prescriptionsEndpoint,
      queryParameters: queryParams,
    ) as Map<String, dynamic>;

    return PaginatedResponse<Prescription>
        .fromJson(
      body['data'] as Map<String, dynamic>,
      Prescription.fromJson,
    );
  }

  /// Fetches a single prescription by [id].
  Future<Prescription> getPrescriptionById(
    String id,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.prescriptionByIdEndpoint(id),
    ) as Map<String, dynamic>;

    return Prescription.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Creates a new prescription.
  Future<Prescription> createPrescription(
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.post(
      ApiConfig.prescriptionsEndpoint,
      data: data,
    ) as Map<String, dynamic>;

    return Prescription.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Updates an existing prescription by [id].
  Future<Prescription> updatePrescription(
    String id,
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.prescriptionByIdEndpoint(id),
      data: data,
    ) as Map<String, dynamic>;

    return Prescription.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Deletes a prescription by [id].
  Future<void> deletePrescription(
    String id,
  ) async {
    await _apiClient.delete(
      ApiConfig.prescriptionByIdEndpoint(id),
    );
  }

  /// Downloads a prescription PDF by [id].
  Future<Uint8List> downloadPrescriptionPdf(
    String id,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.prescriptionPdfEndpoint(id),
    );

    if (body is List<int>) {
      return Uint8List.fromList(body);
    }
    return Uint8List(0);
  }

  /// Fetches all prescriptions for a pet.
  Future<List<Prescription>>
      getPetPrescriptions(
    String petId,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.petPrescriptionsEndpoint(petId),
    ) as Map<String, dynamic>;

    final items =
        body['data'] as List<dynamic>;
    return items
        .map(
          (e) => Prescription.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}

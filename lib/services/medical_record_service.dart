import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/core/models/medical/medical_record.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/services/api_client.dart';

/// Handles medical record API calls.
class MedicalRecordService {
  final _apiClient = locator<ApiClient>();

  /// Fetches a paginated list of medical records.
  ///
  /// Optionally filter by [petId].
  Future<PaginatedResponse<MedicalRecord>>
      getMedicalRecords({
    int page = 1,
    int limit = 20,
    String? petId,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (petId != null) 'petId': petId,
    };

    final body = await _apiClient.get(
      ApiConfig.medicalRecordsEndpoint,
      queryParameters: queryParams,
    ) as Map<String, dynamic>;

    return PaginatedResponse<MedicalRecord>
        .fromJson(
      body['data'] as Map<String, dynamic>,
      MedicalRecord.fromJson,
    );
  }

  /// Fetches a single medical record by [id].
  Future<MedicalRecord> getMedicalRecordById(
    String id,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.medicalRecordByIdEndpoint(id),
    ) as Map<String, dynamic>;

    return MedicalRecord.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Creates a new medical record.
  Future<MedicalRecord> createMedicalRecord(
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.post(
      ApiConfig.medicalRecordsEndpoint,
      data: data,
    ) as Map<String, dynamic>;

    return MedicalRecord.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Updates an existing medical record by [id].
  Future<MedicalRecord> updateMedicalRecord(
    String id,
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.medicalRecordByIdEndpoint(id),
      data: data,
    ) as Map<String, dynamic>;

    return MedicalRecord.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Deletes a medical record by [id].
  Future<void> deleteMedicalRecord(
    String id,
  ) async {
    await _apiClient.delete(
      ApiConfig.medicalRecordByIdEndpoint(id),
    );
  }

  /// Fetches all medical records for a pet.
  Future<List<MedicalRecord>>
      getPetMedicalRecords(
    String petId,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.petMedicalRecordsEndpoint(petId),
    ) as Map<String, dynamic>;

    final items =
        body['data'] as List<dynamic>;
    return items
        .map(
          (e) => MedicalRecord.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}

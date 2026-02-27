import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/core/models/medical/vaccination.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/services/api_client.dart';

/// Handles vaccination-related API calls.
class VaccinationService {
  final _apiClient = locator<ApiClient>();

  /// Fetches a paginated list of vaccinations.
  ///
  /// Optionally filter by [petId].
  Future<PaginatedResponse<Vaccination>>
      getVaccinations({
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
      ApiConfig.vaccinationsEndpoint,
      queryParameters: queryParams,
    ) as Map<String, dynamic>;

    return PaginatedResponse<Vaccination>
        .fromJson(
      body['data'] as Map<String, dynamic>,
      Vaccination.fromJson,
    );
  }

  /// Fetches a single vaccination by [id].
  Future<Vaccination> getVaccinationById(
    String id,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.vaccinationByIdEndpoint(id),
    ) as Map<String, dynamic>;

    return Vaccination.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Creates a new vaccination record.
  Future<Vaccination> createVaccination(
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.post(
      ApiConfig.vaccinationsEndpoint,
      data: data,
    ) as Map<String, dynamic>;

    return Vaccination.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Updates an existing vaccination by [id].
  Future<Vaccination> updateVaccination(
    String id,
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.vaccinationByIdEndpoint(id),
      data: data,
    ) as Map<String, dynamic>;

    return Vaccination.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Deletes a vaccination by [id].
  Future<void> deleteVaccination(
    String id,
  ) async {
    await _apiClient.delete(
      ApiConfig.vaccinationByIdEndpoint(id),
    );
  }

  /// Fetches all vaccinations for a pet.
  Future<List<Vaccination>> getPetVaccinations(
    String petId,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.petVaccinationsEndpoint(petId),
    ) as Map<String, dynamic>;

    final items =
        body['data'] as List<dynamic>;
    return items
        .map(
          (e) => Vaccination.fromJson(
            e as Map<String, dynamic>,
          ),
        )
        .toList();
  }
}

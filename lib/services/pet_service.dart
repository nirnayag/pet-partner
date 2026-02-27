import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/services/api_client.dart';

/// Handles pet-related API calls.
class PetService {
  final _apiClient = locator<ApiClient>();

  /// Fetches a paginated list of pets.
  ///
  /// Optionally filter by [species] or [isActive].
  Future<PaginatedResponse<Pet>> getPets({
    int page = 1,
    int limit = 20,
    String? species,
    bool? isActive,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (species != null) 'species': species,
      if (isActive != null) 'isActive': isActive,
    };

    final body = await _apiClient.get(
      ApiConfig.petsEndpoint,
      queryParameters: queryParams,
    ) as Map<String, dynamic>;

    return PaginatedResponse<Pet>.fromJson(
      body['data'] as Map<String, dynamic>,
      Pet.fromJson,
    );
  }

  /// Fetches a single pet by [petId].
  Future<Pet> getPetById(String petId) async {
    final body = await _apiClient.get(
      ApiConfig.petByIdEndpoint(petId),
    ) as Map<String, dynamic>;

    return Pet.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Creates a new pet record.
  Future<Pet> createPet(
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.post(
      ApiConfig.petsEndpoint,
      data: data,
    ) as Map<String, dynamic>;

    return Pet.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Updates an existing pet by [petId].
  Future<Pet> updatePet(
    String petId,
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.petByIdEndpoint(petId),
      data: data,
    ) as Map<String, dynamic>;

    return Pet.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Deletes a pet by [petId].
  Future<void> deletePet(String petId) async {
    await _apiClient.delete(
      ApiConfig.petByIdEndpoint(petId),
    );
  }

  /// Fetches the medical summary for a pet.
  ///
  /// Returns the raw summary map as the structure
  /// varies across endpoints.
  Future<Map<String, dynamic>> getPetMedicalSummary(
    String petId,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.petMedicalSummaryEndpoint(petId),
    ) as Map<String, dynamic>;

    return body['data'] as Map<String, dynamic>;
  }
}

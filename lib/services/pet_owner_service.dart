import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/core/models/pet_owner.dart';
import 'package:partner/services/api_client.dart';

/// Handles pet-owner-related API calls.
class PetOwnerService {
  final _apiClient = locator<ApiClient>();

  /// Fetches a paginated list of pet owners.
  ///
  /// Optionally filter by a [search] query string.
  Future<PaginatedResponse<PetOwner>> getPetOwners({
    int page = 1,
    int limit = 20,
    String? search,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (search != null) 'search': search,
    };

    final body = await _apiClient.get(
      ApiConfig.petOwnersEndpoint,
      queryParameters: queryParams,
    ) as Map<String, dynamic>;

    return PaginatedResponse<PetOwner>.fromJson(
      body['data'] as Map<String, dynamic>,
      PetOwner.fromJson,
    );
  }

  /// Fetches a single pet owner by [ownerId].
  Future<PetOwner> getPetOwnerById(
    String ownerId,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.petOwnerByIdEndpoint(ownerId),
    ) as Map<String, dynamic>;

    return PetOwner.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Creates a new pet owner record.
  Future<PetOwner> createPetOwner(
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.post(
      ApiConfig.petOwnersEndpoint,
      data: data,
    ) as Map<String, dynamic>;

    return PetOwner.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Updates an existing pet owner by [ownerId].
  Future<PetOwner> updatePetOwner(
    String ownerId,
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.petOwnerByIdEndpoint(ownerId),
      data: data,
    ) as Map<String, dynamic>;

    return PetOwner.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Looks up a pet owner by [phone] number.
  ///
  /// Returns `null` when no owner is found (404).
  Future<PetOwner?> lookupByPhone(
    String phone,
  ) async {
    try {
      final body = await _apiClient.get(
        ApiConfig.petOwnerLookupByPhoneEndpoint,
        queryParameters: <String, dynamic>{
          'phone': phone,
        },
      ) as Map<String, dynamic>;

      final data = body['data'];
      if (data == null) return null;

      return PetOwner.fromJson(
        data as Map<String, dynamic>,
      );
    } on ApiException catch (e) {
      // 404 means no owner exists for this phone.
      if (e.statusCode == 404) return null;
      rethrow;
    }
  }

  /// Creates a pet owner with minimal info (used
  /// during appointment booking flow).
  Future<PetOwner> quickCreate(
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.post(
      ApiConfig.petOwnerQuickCreateEndpoint,
      data: data,
    ) as Map<String, dynamic>;

    return PetOwner.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }
}

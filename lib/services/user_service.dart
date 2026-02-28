import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/core/models/auth/user.dart';
import 'package:partner/core/models/clinic/bulk_create_result.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/services/api_client.dart';

/// Handles user/staff management API calls.
class UserService {
  final _apiClient = locator<ApiClient>();

  /// Fetches a paginated list of users.
  ///
  /// Optionally filter by [role] or [isActive].
  Future<PaginatedResponse<User>> getUsers({
    int page = 1,
    int limit = 20,
    String? role,
    bool? isActive,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (role != null) 'role': role,
      if (isActive != null)
        'isActive': isActive,
    };

    final body = await _apiClient.get(
      ApiConfig.usersEndpoint,
      queryParameters: queryParams,
    ) as Map<String, dynamic>;

    return PaginatedResponse<User>.fromJson(
      body['data'] as Map<String, dynamic>,
      User.fromJson,
    );
  }

  /// Fetches a single user by [id].
  Future<User> getUserById(String id) async {
    final body = await _apiClient.get(
      ApiConfig.userByIdEndpoint(id),
    ) as Map<String, dynamic>;

    return User.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Creates a new staff user.
  Future<User> createUser(
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.post(
      ApiConfig.usersEndpoint,
      data: data,
    ) as Map<String, dynamic>;

    return User.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Updates an existing user by [id].
  Future<User> updateUser(
    String id,
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.userByIdEndpoint(id),
      data: data,
    ) as Map<String, dynamic>;

    return User.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Deactivates a user by [id].
  Future<void> deactivateUser(String id) async {
    await _apiClient.patch(
      ApiConfig.userByIdEndpoint(id),
      data: <String, dynamic>{
        'isActive': false,
      },
    );
  }

  /// Bulk creates multiple users.
  Future<BulkCreateResult> bulkCreateUsers(
    List<Map<String, dynamic>> users,
  ) async {
    final body = await _apiClient.post(
      ApiConfig.usersBulkEndpoint,
      data: <String, dynamic>{'users': users},
    ) as Map<String, dynamic>;

    return BulkCreateResult.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }
}

import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:partner/core/constants/storage_keys.dart';

/// Wraps [FlutterSecureStorage] for sensitive data
/// such as authentication tokens and cached user JSON.
class SecureStorageService {
  final FlutterSecureStorage _storage =
      const FlutterSecureStorage();

  // --------------------------------------------------
  // Access token
  // --------------------------------------------------

  /// Saves the short-lived JWT access token.
  Future<void> saveAccessToken(String token) async {
    await _storage.write(
      key: StorageKeys.accessToken,
      value: token,
    );
  }

  /// Returns the stored access token, or `null`.
  Future<String?> getAccessToken() async {
    return _storage.read(
      key: StorageKeys.accessToken,
    );
  }

  // --------------------------------------------------
  // Refresh token
  // --------------------------------------------------

  /// Saves the long-lived refresh token.
  Future<void> saveRefreshToken(String token) async {
    await _storage.write(
      key: StorageKeys.refreshToken,
      value: token,
    );
  }

  /// Returns the stored refresh token, or `null`.
  Future<String?> getRefreshToken() async {
    return _storage.read(
      key: StorageKeys.refreshToken,
    );
  }

  // --------------------------------------------------
  // User JSON (full user object as JSON string)
  // --------------------------------------------------

  /// Stores the full user object as a JSON string.
  Future<void> saveUserJson(String json) async {
    await _storage.write(
      key: StorageKeys.userJson,
      value: json,
    );
  }

  /// Returns the stored user JSON string, or `null`.
  Future<String?> getUserJson() async {
    return _storage.read(
      key: StorageKeys.userJson,
    );
  }

  // --------------------------------------------------
  // Helpers
  // --------------------------------------------------

  /// Deletes all stored tokens and cached user data.
  Future<void> clearTokens() async {
    await Future.wait([
      _storage.delete(key: StorageKeys.accessToken),
      _storage.delete(key: StorageKeys.refreshToken),
      _storage.delete(key: StorageKeys.userJson),
    ]);
  }

  /// Returns `true` when both access and refresh
  /// tokens are present and non-empty.
  Future<bool> hasTokens() async {
    final access = await getAccessToken();
    final refresh = await getRefreshToken();
    return access != null &&
        access.isNotEmpty &&
        refresh != null &&
        refresh.isNotEmpty;
  }
}

/// Centralised storage key constants used by
/// `SecureStorageService` and
/// `SharedPreferencesService`.
class StorageKeys {
  // Secure storage (tokens & user JSON)
  static const String accessToken = 'access_token';
  static const String refreshToken = 'refresh_token';
  static const String userJson = 'user_json';

  // Shared preferences (non-sensitive)
  static const String userId = 'user_id';
  static const String userRole = 'user_role';
  static const String clinicId = 'clinic_id';
  static const String userName = 'user_name';
  static const String avatarUrl = 'avatar_url';
}

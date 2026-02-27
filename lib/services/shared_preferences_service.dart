import 'package:partner/core/constants/storage_keys.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Wraps [SharedPreferences] for non-sensitive data
/// such as user info and app preferences.
///
/// Call [init] once at app startup (before
/// `setupLocator`) so the underlying instance is
/// ready synchronously for all later reads.
class SharedPreferencesService {
  SharedPreferences? _prefs;

  /// Eagerly initialises the [SharedPreferences]
  /// instance.  Call this in `main()` before
  /// `setupLocator()`.
  Future<void> init() async {
    _prefs = await SharedPreferences.getInstance();
  }

  Future<SharedPreferences> get _instance async {
    _prefs ??= await SharedPreferences.getInstance();
    return _prefs!;
  }

  // --------------------------------------------------
  // User role
  // --------------------------------------------------

  /// Persists the user role string.
  Future<void> saveUserRole(String role) async {
    final prefs = await _instance;
    await prefs.setString(StorageKeys.userRole, role);
  }

  /// Returns the stored role string, or `null`.
  Future<String?> getUserRole() async {
    final prefs = await _instance;
    return prefs.getString(StorageKeys.userRole);
  }

  // --------------------------------------------------
  // User ID
  // --------------------------------------------------

  /// Persists the user ID.
  Future<void> saveUserId(String id) async {
    final prefs = await _instance;
    await prefs.setString(StorageKeys.userId, id);
  }

  /// Returns the stored user ID, or `null`.
  Future<String?> getUserId() async {
    final prefs = await _instance;
    return prefs.getString(StorageKeys.userId);
  }

  // --------------------------------------------------
  // Clinic ID
  // --------------------------------------------------

  /// Persists the clinic ID.
  Future<void> saveClinicId(String id) async {
    final prefs = await _instance;
    await prefs.setString(StorageKeys.clinicId, id);
  }

  /// Returns the stored clinic ID, or `null`.
  Future<String?> getClinicId() async {
    final prefs = await _instance;
    return prefs.getString(StorageKeys.clinicId);
  }

  // --------------------------------------------------
  // User name
  // --------------------------------------------------

  /// Persists the user's display name.
  Future<void> saveUserName(String name) async {
    final prefs = await _instance;
    await prefs.setString(StorageKeys.userName, name);
  }

  /// Returns the stored user name, or `null`.
  Future<String?> getUserName() async {
    final prefs = await _instance;
    return prefs.getString(StorageKeys.userName);
  }

  // --------------------------------------------------
  // Avatar URL
  // --------------------------------------------------

  /// Persists the user's avatar URL.
  Future<void> saveAvatarUrl(String url) async {
    final prefs = await _instance;
    await prefs.setString(StorageKeys.avatarUrl, url);
  }

  /// Returns the stored avatar URL, or `null`.
  Future<String?> getAvatarUrl() async {
    final prefs = await _instance;
    return prefs.getString(StorageKeys.avatarUrl);
  }

  // --------------------------------------------------
  // Clear
  // --------------------------------------------------

  /// Removes all stored preferences.
  Future<void> clearAll() async {
    final prefs = await _instance;
    await prefs.clear();
  }
}

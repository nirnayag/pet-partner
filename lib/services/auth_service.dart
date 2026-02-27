import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/core/enums/user_role.dart';
import 'package:partner/core/models/auth/user.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/secure_storage_service.dart';
import 'package:partner/services/shared_preferences_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// Orchestrates authentication flows using
/// `ApiClient`, `SecureStorageService`, and
/// `SharedPreferencesService`.
class AuthService with ListenableServiceMixin {
  final _apiClient = locator<ApiClient>();
  final _secureStorage =
      locator<SecureStorageService>();
  final _prefs =
      locator<SharedPreferencesService>();

  User? _cachedUser;
  UserRole? _currentRole;

  // ------------------------------------------------
  // In-memory state (read by UI widgets)
  // ------------------------------------------------

  /// The active role for the current session.
  UserRole? get currentRole => _currentRole;

  /// All roles available to the current user.
  List<UserRole> get availableRoles =>
      _cachedUser?.availableRoles ?? <UserRole>[];

  /// Whether the user can switch roles.
  bool get hasMultipleRoles =>
      _cachedUser?.hasMultipleRoles ?? false;

  /// The cached [User] loaded from storage.
  User? get cachedUser => _cachedUser;

  /// Hydrates in-memory state from secure storage
  /// and shared preferences.
  Future<void> loadUserFromStorage() async {
    final roleStr = await _prefs.getUserRole();
    if (roleStr != null && roleStr.isNotEmpty) {
      try {
        _currentRole = UserRole.fromString(roleStr);
      } on Object {
        // ignore invalid stored role
      }
    }

    final userJson =
        await _secureStorage.getUserJson();
    if (userJson != null && userJson.isNotEmpty) {
      try {
        _cachedUser = User.fromJsonString(userJson);
      } on Object {
        // ignore parse errors
      }
    }

    notifyListeners();
  }

  // --------------------------------------------------
  // Login
  // --------------------------------------------------

  /// Authenticates with [email] and [password].
  ///
  /// On success the tokens and user profile are
  /// persisted and the [User] is returned.
  Future<User> login(
    String email,
    String password,
  ) async {
    final body = await _apiClient.post(
      ApiConfig.mobileLoginEndpoint,
      data: <String, dynamic>{
        'email': email,
        'password': password,
      },
    ) as Map<String, dynamic>;

    final data =
        body['data'] as Map<String, dynamic>;
    final user = User.fromJson(
      data['user'] as Map<String, dynamic>,
    );

    final accessToken =
        data['accessToken'] as String;
    final refreshToken =
        data['refreshToken'] as String;

    await _persistSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );

    _cachedUser = user;
    _currentRole = user.activeRole;
    notifyListeners();

    return user;
  }

  // --------------------------------------------------
  // Refresh token
  // --------------------------------------------------

  /// Refreshes the access token using the stored
  /// refresh token.
  ///
  /// Called by `ApiClient` on 401 responses. May
  /// also be called manually.
  Future<void> refreshToken() async {
    final storedRefresh =
        await _secureStorage.getRefreshToken();

    if (storedRefresh == null ||
        storedRefresh.isEmpty) {
      throw const ApiException(
        message: 'No refresh token available',
      );
    }

    final body = await _apiClient.post(
      ApiConfig.refreshTokenEndpoint,
      data: <String, dynamic>{
        'refreshToken': storedRefresh,
      },
    ) as Map<String, dynamic>;

    final data =
        body['data'] as Map<String, dynamic>;
    final accessToken =
        data['accessToken'] as String;
    final refreshToken =
        data['refreshToken'] as String;

    await _secureStorage
        .saveAccessToken(accessToken);
    await _secureStorage
        .saveRefreshToken(refreshToken);
  }

  // --------------------------------------------------
  // Switch role
  // --------------------------------------------------

  /// Switches the active role to [newRole].
  ///
  /// The backend re-issues tokens scoped to the new
  /// role. Returns the updated [User].
  Future<User> switchRole(UserRole newRole) async {
    final body = await _apiClient.post(
      ApiConfig.switchRoleEndpoint,
      data: <String, dynamic>{
        'role': newRole.value,
      },
    ) as Map<String, dynamic>;

    final data =
        body['data'] as Map<String, dynamic>;
    final user = User.fromJson(
      data['user'] as Map<String, dynamic>,
    );

    final accessToken =
        data['accessToken'] as String;
    final refreshToken =
        data['refreshToken'] as String;

    await _persistSession(
      accessToken: accessToken,
      refreshToken: refreshToken,
      user: user,
    );

    _cachedUser = user;
    _currentRole = user.activeRole;
    notifyListeners();

    return user;
  }

  // --------------------------------------------------
  // Logout
  // --------------------------------------------------

  /// Logs out the current user.
  ///
  /// Revokes the refresh token on the server, clears
  /// all local storage, and navigates to the login
  /// screen.
  Future<void> logout() async {
    try {
      final refreshToken =
          await _secureStorage.getRefreshToken();
      if (refreshToken != null &&
          refreshToken.isNotEmpty) {
        await _apiClient.post(
          ApiConfig.mobileLogoutEndpoint,
          data: <String, dynamic>{
            'refreshToken': refreshToken,
          },
        );
      }
    } on Object catch (_) {
      // Best-effort server logout -- continue even
      // if it fails so local state is always cleared.
    }

    await _secureStorage.clearTokens();
    await _prefs.clearAll();

    _cachedUser = null;
    _currentRole = null;
    notifyListeners();

    try {
      await locator<NavigationService>()
          .clearStackAndShow<void>(
        Routes.loginView,
      );
    } on Object catch (_) {
      // NavigationService unavailable (e.g. tests)
    }
  }

  // --------------------------------------------------
  // Cached user helpers
  // --------------------------------------------------

  /// Returns the currently cached [User], or `null`
  /// if no user data is stored.
  Future<User?> getCurrentUser() async {
    final json =
        await _secureStorage.getUserJson();
    if (json == null || json.isEmpty) return null;
    try {
      return User.fromJsonString(json);
    } on Object catch (_) {
      return null;
    }
  }

  /// Returns `true` when valid tokens exist in
  /// secure storage.
  Future<bool> isLoggedIn() =>
      _secureStorage.hasTokens();

  /// Returns the stored [UserRole], or `null` if no
  /// role has been persisted.
  Future<UserRole?> getUserRole() async {
    final role = await _prefs.getUserRole();
    if (role == null || role.isEmpty) return null;
    try {
      return UserRole.fromString(role);
    } on Object catch (_) {
      return null;
    }
  }

  // --------------------------------------------------
  // Private helpers
  // --------------------------------------------------

  Future<void> _persistSession({
    required String accessToken,
    required String refreshToken,
    required User user,
  }) async {
    await Future.wait([
      _secureStorage.saveAccessToken(accessToken),
      _secureStorage
          .saveRefreshToken(refreshToken),
      _secureStorage
          .saveUserJson(user.toJsonString()),
      _prefs.saveUserId(user.id),
      _prefs.saveUserRole(user.role),
      _prefs.saveUserName(user.fullName),
      if (user.clinicId != null)
        _prefs.saveClinicId(user.clinicId!),
      if (user.avatarUrl != null)
        _prefs.saveAvatarUrl(user.avatarUrl!),
    ]);
  }
}

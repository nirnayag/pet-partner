import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/auth/user.dart';
import 'package:partner/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the doctor / staff profile screen.
///
/// Reads the current user from [AuthService] and
/// provides notification toggle state.
class DoctorProfileViewModel extends BaseViewModel {
  final _navigationService =
      locator<NavigationService>();
  final _authService = locator<AuthService>();

  // --------------------------------------------------
  // User data
  // --------------------------------------------------

  /// The currently logged-in user.
  User? get currentUser =>
      _authService.cachedUser;

  /// User's full name for display.
  String get userName =>
      currentUser?.fullName ?? 'Doctor';

  /// User's specialization, e.g. "Veterinarian".
  String get specialization =>
      currentUser?.specialization ??
      (currentUser?.activeRole.displayName ?? '');

  /// User's email.
  String get email => currentUser?.email ?? '';

  /// User's avatar URL, if any.
  String? get avatarUrl => currentUser?.avatarUrl;

  // --------------------------------------------------
  // Notification toggles (local-only for now)
  // --------------------------------------------------

  bool _isEmailAlertsEnabled = false;

  /// Whether email alerts are enabled.
  bool get isEmailAlertsEnabled =>
      _isEmailAlertsEnabled;

  bool _isInAppAlertsEnabled = true;

  /// Whether in-app alerts are enabled.
  bool get isInAppAlertsEnabled =>
      _isInAppAlertsEnabled;

  bool _isSmsUpdatesEnabled = false;

  /// Whether SMS updates are enabled.
  bool get isSmsUpdatesEnabled =>
      _isSmsUpdatesEnabled;

  /// Toggles the email alerts setting.
  void toggleEmailAlerts({required bool value}) {
    _isEmailAlertsEnabled = value;
    notifyListeners();
  }

  /// Toggles the in-app alerts setting.
  void toggleInAppAlerts({required bool value}) {
    _isInAppAlertsEnabled = value;
    notifyListeners();
  }

  /// Toggles the SMS updates setting.
  void toggleSmsUpdates({required bool value}) {
    _isSmsUpdatesEnabled = value;
    notifyListeners();
  }

  // --------------------------------------------------
  // Actions
  // --------------------------------------------------

  /// Logs out the current user and navigates to the
  /// login screen.
  Future<void> logout() async {
    setBusy(true);
    await _authService.logout();
    setBusy(false);
  }

  /// Pops back to the previous screen.
  void goBack() {
    _navigationService.back<void>();
  }
}

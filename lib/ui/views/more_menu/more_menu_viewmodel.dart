import 'package:partner/app/app.locator.dart';
import 'package:partner/core/enums/user_role.dart';
import 'package:partner/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the role-specific "More" menu tab.
///
/// Exposes navigation methods to screens that are
/// role-specific (staff or clinic admin features).
class MoreMenuViewModel extends BaseViewModel {
  final _authService = locator<AuthService>();
  final _navigationService =
      locator<NavigationService>();

  /// The active user role.
  UserRole get currentRole =>
      _authService.currentRole ??
      UserRole.veterinarian;

  /// Navigates to the given [routeName].
  void navigateTo(String routeName) {
    _navigationService.navigateTo<dynamic>(
      routeName,
    );
  }
}

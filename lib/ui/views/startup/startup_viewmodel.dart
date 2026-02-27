import 'dart:async';

import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/services/auth_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// Handles the initial launch logic.
///
/// Checks whether the user is already logged in and
/// navigates to either the main view or login view.
class StartupViewModel extends BaseViewModel {
  final _navigationService =
      locator<NavigationService>();

  final _authService = locator<AuthService>();

  /// Runs on view ready -- decides where to navigate.
  Future<void> runStartupLogic() async {
    // Brief splash delay so branding is visible.
    await Future<void>.delayed(
      const Duration(seconds: 2),
    );

    final loggedIn = await _authService.isLoggedIn();

    if (loggedIn) {
      // Hydrate cached user data from storage.
      await _authService.loadUserFromStorage();

      unawaited(
        _navigationService.clearStackAndShow<void>(
          Routes.mainView,
        ),
      );
    } else {
      unawaited(
        _navigationService.replaceWithLoginView(),
      );
    }
  }
}

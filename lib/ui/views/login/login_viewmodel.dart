import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/services/auth_service.dart';
import 'package:partner/services/layout_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the login screen.
///
/// Handles email + password authentication for
/// clinic-side users.
class LoginViewModel extends BaseViewModel
    with ErrorHandlingMixin {
  final _authService = locator<AuthService>();
  final _navigationService =
      locator<NavigationService>();

  /// Controller for the email field.
  final emailController = TextEditingController();

  /// Controller for the password field.
  final passwordController = TextEditingController();

  bool _obscurePassword = true;

  /// Whether to hide the password text.
  bool get obscurePassword => _obscurePassword;

  /// Toggles password visibility.
  void togglePasswordVisibility() {
    _obscurePassword = !_obscurePassword;
    notifyListeners();
  }

  /// Validates inputs and performs login.
  Future<void> login() async {
    final email = emailController.text.trim();
    final password = passwordController.text;

    if (email.isEmpty) {
      setError('Email is required.');
      return;
    }
    if (password.isEmpty) {
      setError('Password is required.');
      return;
    }

    setBusy(true);
    final user = await runSafe(
      () => _authService.login(email, password),
      fallbackMessage:
          'Login failed. Please try again.',
    );
    setBusy(false);

    if (user != null) {
      locator<LayoutService>().resetIndex();
      _navigationService.clearStackAndShow<void>(
        Routes.mainView,
      );
    }
  }

  @override
  void dispose() {
    emailController.dispose();
    passwordController.dispose();
    super.dispose();
  }
}

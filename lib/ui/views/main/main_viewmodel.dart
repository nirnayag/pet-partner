import 'package:partner/app/app.locator.dart';
import 'package:partner/core/enums/user_role.dart';
import 'package:partner/services/auth_service.dart';
import 'package:partner/services/layout_service.dart';
import 'package:stacked/stacked.dart';

/// ViewModel for the main container view.
///
/// Manages the bottom navigation index via
/// [LayoutService] and exposes the current user role
/// from [AuthService].
class MainViewModel extends ReactiveViewModel {
  final LayoutService _layoutService =
      locator<LayoutService>();

  final AuthService _authService =
      locator<AuthService>();

  @override
  List<ListenableServiceMixin> get listenableServices =>
      [_layoutService, _authService];

  /// The currently selected bottom tab index.
  int get currentIndex => _layoutService.currentIndex;

  /// The active role for the logged-in user.
  UserRole get currentRole =>
      _authService.currentRole ?? UserRole.veterinarian;

  /// Updates the selected bottom tab index.
  void setIndex(int index) {
    _layoutService.setIndex(index);
  }
}

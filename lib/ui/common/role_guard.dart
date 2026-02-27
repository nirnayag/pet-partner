import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/enums/user_role.dart';
import 'package:partner/services/auth_service.dart';

/// Conditionally renders [child] when the current
/// user's role is contained in [allowedRoles].
///
/// Shows [fallback] (or [SizedBox.shrink]) when the
/// role does not match.
///
/// ```dart
/// RoleGuard(
///   allowedRoles: [UserRole.clinicAdmin],
///   child: StaffManagementButton(),
/// )
/// ```
class RoleGuard extends StatelessWidget {
  /// Creates a role guard.
  const RoleGuard({
    required this.allowedRoles,
    required this.child,
    this.fallback,
    super.key,
  });

  /// Roles that are permitted to see [child].
  final List<UserRole> allowedRoles;

  /// Widget shown when the role is allowed.
  final Widget child;

  /// Widget shown when the role is **not** allowed.
  ///
  /// Defaults to [SizedBox.shrink] when omitted.
  final Widget? fallback;

  @override
  Widget build(BuildContext context) {
    final authService = locator<AuthService>();
    final currentRole = authService.currentRole;

    if (currentRole != null &&
        allowedRoles.contains(currentRole)) {
      return child;
    }

    return fallback ?? const SizedBox.shrink();
  }
}

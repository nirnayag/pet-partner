import 'package:partner/app/app.router.dart';
import 'package:partner/core/enums/user_role.dart';

/// Utilities for role-based routing and permission
/// checks.
class PermissionUtils {
  /// Returns the home route for a given [role].
  ///
  /// All roles currently land on [Routes.mainView].
  static String homeRouteForRole(UserRole role) {
    switch (role) {
      case UserRole.clinicAdmin:
        return Routes.mainView;
      case UserRole.veterinarian:
        return Routes.mainView;
      case UserRole.staff:
        return Routes.mainView;
    }
  }

  /// Returns `true` when [role] includes
  /// [permission].
  static bool hasPermission(
    UserRole role,
    String permission,
  ) {
    return _rolePermissions[role]
            ?.contains(permission) ??
        false;
  }

  static const Map<UserRole, Set<String>>
      _rolePermissions = {
    UserRole.clinicAdmin: {
      'clinic:manage',
      'users:manage',
      'pets:manage',
      'appointments:manage',
      'medical-records:manage',
      'prescriptions:manage',
      'documents:manage',
      'reminders:manage',
      'reminders:send',
      'reports:view',
    },
    UserRole.veterinarian: {
      'appointments:view',
      'pets:view',
      'pets:create',
      'pets:update',
      'medical-records:manage',
      'prescriptions:manage',
      'documents:manage',
      'vaccinations:manage',
      'reminders:view',
      'reminders:create',
      'reminders:update',
    },
    UserRole.staff: {
      'appointments:view',
      'appointments:create',
      'appointments:update',
      'appointments:manage',
      'pets:view',
      'pets:create',
      'pets:update',
      'documents:view',
      'documents:upload',
      'reminders:view',
      'reminders:create',
    },
  };
}

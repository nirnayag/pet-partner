import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/enums/user_role.dart';
import 'package:partner/services/auth_service.dart';
import 'package:partner/ui/common/app_colors.dart';

/// A dropdown widget that lets users with multiple
/// roles switch their active role.
///
/// When the user only has a single role the widget
/// renders [SizedBox.shrink] (invisible).
class RoleSwitcher extends StatelessWidget {
  /// Creates a role switcher.
  const RoleSwitcher({super.key});

  @override
  Widget build(BuildContext context) {
    final authService = locator<AuthService>();
    final availableRoles = authService.availableRoles;
    final currentRole = authService.currentRole;

    if (availableRoles.length <= 1) {
      return const SizedBox.shrink();
    }

    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: kcPrimaryColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<UserRole>(
          value: currentRole,
          isDense: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: kcPrimaryColorDark,
            size: 20,
          ),
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: kcPrimaryColorDark,
          ),
          dropdownColor: Colors.white,
          items: availableRoles.map((role) {
            return DropdownMenuItem<UserRole>(
              value: role,
              child: Text(role.displayName),
            );
          }).toList(),
          onChanged: (newRole) {
            if (newRole == null ||
                newRole == currentRole) {
              return;
            }
            authService.switchRole(newRole);
          },
        ),
      ),
    );
  }
}

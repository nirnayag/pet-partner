import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/enums/user_role.dart';
import 'package:partner/core/models/auth/user.dart';
import 'package:partner/ui/common/app_colors.dart';

/// A card displaying a staff member's summary
/// information.
class StaffMemberCard extends StatelessWidget {
  /// Creates a [StaffMemberCard].
  const StaffMemberCard({
    required this.user,
    required this.onTap,
    super.key,
  });

  /// The staff member to display.
  final User user;

  /// Callback when the card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.04),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            _buildAvatar(),
            const SizedBox(width: 14),
            Expanded(child: _buildInfo()),
            _buildStatusDot(),
          ],
        ),
      ),
    );
  }

  Widget _buildAvatar() {
    return CircleAvatar(
      radius: 24,
      backgroundColor: kcVeryLightGrey,
      backgroundImage: user.avatarUrl != null
          ? NetworkImage(user.avatarUrl!)
          : null,
      child: user.avatarUrl == null
          ? Text(
              _initials,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w800,
                color: kcMediumGrey,
              ),
            )
          : null,
    );
  }

  Widget _buildInfo() {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          user.fullName,
          style: GoogleFonts.manrope(
            fontSize: 15,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
          maxLines: 1,
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            _RoleBadge(role: user.activeRole),
            if (user.email != null) ...[
              const SizedBox(width: 8),
              Expanded(
                child: Text(
                  user.email!,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kcMediumGrey,
                  ),
                  maxLines: 1,
                  overflow:
                      TextOverflow.ellipsis,
                ),
              ),
            ],
          ],
        ),
      ],
    );
  }

  Widget _buildStatusDot() {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        color: user.isActive
            ? kcPrimaryColor
            : kcLightGrey,
        shape: BoxShape.circle,
      ),
    );
  }

  String get _initials {
    final first = user.firstName.isNotEmpty
        ? user.firstName[0]
        : '';
    final last = user.lastName.isNotEmpty
        ? user.lastName[0]
        : '';
    return '$first$last'.toUpperCase();
  }
}

class _RoleBadge extends StatelessWidget {
  const _RoleBadge({required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: _badgeColor.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        role.displayName,
        style: GoogleFonts.manrope(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: _badgeColor,
        ),
      ),
    );
  }

  Color get _badgeColor {
    switch (role) {
      case UserRole.veterinarian:
        return Colors.blue;
      case UserRole.staff:
        return Colors.orange;
      case UserRole.clinicAdmin:
        return kcPrimaryColorDark;
    }
  }
}

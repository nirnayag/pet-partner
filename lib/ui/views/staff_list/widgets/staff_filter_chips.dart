import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Filter chips for the staff list screen.
class StaffFilterChips extends StatelessWidget {
  /// Creates a [StaffFilterChips].
  const StaffFilterChips({
    required this.roleFilter,
    required this.statusFilter,
    required this.onRoleChanged,
    required this.onStatusChanged,
    super.key,
  });

  /// The active role filter label.
  final String roleFilter;

  /// The active status filter label.
  final String statusFilter;

  /// Callback when a role filter is tapped.
  final ValueChanged<String> onRoleChanged;

  /// Callback when a status filter is tapped.
  final ValueChanged<String> onStatusChanged;

  static const _roleFilters = [
    'All',
    'Veterinarians',
    'Staff',
  ];

  static const _statusFilters = [
    'Active',
    'Inactive',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _roleFilters
                .map(
                  (f) => _Chip(
                    label: f,
                    isActive: roleFilter == f,
                    onTap: () =>
                        onRoleChanged(f),
                  ),
                )
                .toList(),
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 36,
          child: ListView(
            scrollDirection: Axis.horizontal,
            children: _statusFilters
                .map(
                  (f) => _Chip(
                    label: f,
                    isActive: statusFilter == f,
                    onTap: () =>
                        onStatusChanged(f),
                  ),
                )
                .toList(),
          ),
        ),
      ],
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? kcNeutral900
              : Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          boxShadow: isActive
              ? null
              : [
                  BoxShadow(
                    color: Colors.black
                        .withValues(alpha: 0.03),
                    blurRadius: 5,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isActive
                  ? Colors.white
                  : kcMediumGrey,
            ),
          ),
        ),
      ),
    );
  }
}

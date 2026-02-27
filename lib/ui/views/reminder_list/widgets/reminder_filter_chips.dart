import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Filter chips for the reminder list screen.
class ReminderFilterChips
    extends StatelessWidget {
  /// Creates a [ReminderFilterChips].
  const ReminderFilterChips({
    required this.statusFilter,
    required this.onStatusChanged,
    super.key,
  });

  /// The active status filter label.
  final String statusFilter;

  /// Callback when a filter is tapped.
  final ValueChanged<String> onStatusChanged;

  static const _filters = [
    'All',
    'Pending',
    'Sent',
    'Failed',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _filters
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

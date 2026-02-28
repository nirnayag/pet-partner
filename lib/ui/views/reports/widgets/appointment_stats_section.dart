import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Appointment breakdown stats section.
class AppointmentStatsSection
    extends StatelessWidget {
  /// Creates an [AppointmentStatsSection].
  const AppointmentStatsSection({
    required this.total,
    required this.pending,
    required this.completed,
    super.key,
  });

  /// Total appointments.
  final int total;

  /// Pending appointments.
  final int pending;

  /// Completed appointments.
  final int completed;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Appointment Breakdown',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(20),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: 0.04),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: Column(
            children: [
              _StatRow(
                label: 'Total',
                value: total,
                color: kcDarkGreyColor,
              ),
              const Divider(height: 24),
              _StatRow(
                label: 'Pending',
                value: pending,
                color: Colors.orange,
              ),
              const Divider(height: 24),
              _StatRow(
                label: 'Completed',
                value: completed,
                color: kcPrimaryColorDark,
              ),
              if (total > 0) ...[
                const Divider(height: 24),
                _ProgressBar(
                  completed: completed,
                  total: total,
                ),
              ],
            ],
          ),
        ),
      ],
    );
  }
}

class _StatRow extends StatelessWidget {
  const _StatRow({
    required this.label,
    required this.value,
    required this.color,
  });

  final String label;
  final int value;
  final Color color;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Row(
          children: [
            Container(
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: color,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w600,
                color: kcMediumGrey,
              ),
            ),
          ],
        ),
        Text(
          '$value',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
      ],
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({
    required this.completed,
    required this.total,
  });

  final int completed;
  final int total;

  @override
  Widget build(BuildContext context) {
    final ratio = total > 0
        ? completed / total
        : 0.0;
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Completion Rate: '
          '${(ratio * 100).toStringAsFixed(1)}%',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kcMediumGrey,
          ),
        ),
        const SizedBox(height: 8),
        ClipRRect(
          borderRadius:
              BorderRadius.circular(4),
          child: LinearProgressIndicator(
            value: ratio,
            backgroundColor: kcVeryLightGrey,
            valueColor:
                const AlwaysStoppedAnimation(
              kcPrimaryColor,
            ),
            minHeight: 8,
          ),
        ),
      ],
    );
  }
}

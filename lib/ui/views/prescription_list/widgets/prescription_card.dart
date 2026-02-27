import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/core/models/medical/prescription.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Card displaying a single prescription.
class PrescriptionCard extends StatelessWidget {
  /// Creates a [PrescriptionCard].
  const PrescriptionCard({
    required this.prescription,
    this.onTap,
    super.key,
  });

  /// The prescription to display.
  final Prescription prescription;

  /// Callback when the card is tapped.
  final VoidCallback? onTap;

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
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Expanded(
                  child: Text(
                    prescription.medicationName,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w800,
                      color: kcDarkGreyColor,
                    ),
                  ),
                ),
                _StatusBadge(
                  isActive:
                      prescription.isActive,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons.medication_outlined,
              text:
                  '${prescription.dosage}'
                  ' - ${prescription.frequency}',
            ),
            if (prescription.duration !=
                null) ...[
              const SizedBox(height: 4),
              _DetailRow(
                icon: Icons.timer_outlined,
                text: prescription.duration!,
              ),
            ],
            const SizedBox(height: 4),
            _DetailRow(
              icon:
                  Icons.calendar_today_rounded,
              text:
                  'Started ${DateFormat('dd MMM yyyy').format(
                prescription.startDate,
              )}',
            ),
          ],
        ),
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({
    required this.isActive,
  });

  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: isActive
            ? kcPrimaryColor.withValues(
                alpha: 0.12,
              )
            : kcLightGrey.withValues(
                alpha: 0.3,
              ),
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Text(
        isActive ? 'Active' : 'Inactive',
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: isActive
              ? kcPrimaryColorDark
              : kcMediumGrey,
        ),
      ),
    );
  }
}

class _DetailRow extends StatelessWidget {
  const _DetailRow({
    required this.icon,
    required this.text,
  });

  final IconData icon;
  final String text;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 14,
          color: kcMediumGrey,
        ),
        const SizedBox(width: 6),
        Expanded(
          child: Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: kcMediumGrey,
            ),
          ),
        ),
      ],
    );
  }
}

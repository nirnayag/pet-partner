import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/core/models/medical/vaccination.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Card displaying a single vaccination.
class VaccinationCard extends StatelessWidget {
  /// Creates a [VaccinationCard].
  const VaccinationCard({
    required this.vaccination,
    this.onTap,
    super.key,
  });

  /// The vaccination to display.
  final Vaccination vaccination;

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
          border: Border.all(
            color: _borderColor,
            width: 1.5,
          ),
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
                _StatusDot(
                  status: vaccination.status,
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    vaccination.vaccineName,
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w800,
                      color: kcDarkGreyColor,
                    ),
                  ),
                ),
                _StatusLabel(
                  status: vaccination.status,
                ),
              ],
            ),
            const SizedBox(height: 8),
            _DetailRow(
              icon: Icons
                  .calendar_today_rounded,
              text:
                  'Given ${DateFormat('dd MMM yyyy').format(
                vaccination.dateAdministered,
              )}',
            ),
            if (vaccination.nextDueDate !=
                null) ...[
              const SizedBox(height: 4),
              _DetailRow(
                icon: Icons.event_outlined,
                text:
                    'Due ${DateFormat('dd MMM yyyy').format(
                  vaccination.nextDueDate!,
                )}',
              ),
            ],
            if (vaccination.manufacturer !=
                null) ...[
              const SizedBox(height: 4),
              _DetailRow(
                icon: Icons.business_outlined,
                text:
                    vaccination.manufacturer!,
              ),
            ],
            if (vaccination.batchNumber !=
                null) ...[
              const SizedBox(height: 4),
              _DetailRow(
                icon: Icons.tag_outlined,
                text:
                    'Batch: '
                    '${vaccination.batchNumber}',
              ),
            ],
          ],
        ),
      ),
    );
  }

  Color get _borderColor {
    switch (vaccination.status) {
      case 'overdue':
        return Colors.red.withValues(
          alpha: 0.3,
        );
      case 'due_soon':
        return Colors.orange.withValues(
          alpha: 0.3,
        );
      case 'up_to_date':
      default:
        return kcPrimaryColor.withValues(
          alpha: 0.2,
        );
    }
  }
}

class _StatusDot extends StatelessWidget {
  const _StatusDot({
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 10,
      height: 10,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        color: _color,
      ),
    );
  }

  Color get _color {
    switch (status) {
      case 'overdue':
        return Colors.red;
      case 'due_soon':
        return Colors.orange;
      case 'up_to_date':
      default:
        return kcPrimaryColor;
    }
  }
}

class _StatusLabel extends StatelessWidget {
  const _StatusLabel({
    required this.status,
  });

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius:
            BorderRadius.circular(12),
      ),
      child: Text(
        _label,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _textColor,
        ),
      ),
    );
  }

  String get _label {
    switch (status) {
      case 'overdue':
        return 'Overdue';
      case 'due_soon':
        return 'Due Soon';
      case 'up_to_date':
      default:
        return 'Up to Date';
    }
  }

  Color get _backgroundColor {
    switch (status) {
      case 'overdue':
        return Colors.red
            .withValues(alpha: 0.1);
      case 'due_soon':
        return Colors.orange
            .withValues(alpha: 0.1);
      case 'up_to_date':
      default:
        return kcPrimaryColor
            .withValues(alpha: 0.1);
    }
  }

  Color get _textColor {
    switch (status) {
      case 'overdue':
        return Colors.red[700]!;
      case 'due_soon':
        return Colors.orange[700]!;
      case 'up_to_date':
      default:
        return kcPrimaryColorDark;
    }
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

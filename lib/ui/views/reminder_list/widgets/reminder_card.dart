import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/core/models/reminder/reminder.dart';
import 'package:partner/ui/common/app_colors.dart';

/// A card displaying a reminder's summary.
class ReminderCard extends StatelessWidget {
  /// Creates a [ReminderCard].
  const ReminderCard({
    required this.reminder,
    required this.onTap,
    required this.onDelete,
    super.key,
  });

  /// The reminder to display.
  final Reminder reminder;

  /// Callback when the card is tapped.
  final VoidCallback onTap;

  /// Callback when delete is tapped.
  final VoidCallback onDelete;

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
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                _buildTypeIcon(),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        reminder.title,
                        style:
                            GoogleFonts.manrope(
                          fontSize: 15,
                          fontWeight:
                              FontWeight.w800,
                          color: kcDarkGreyColor,
                        ),
                        maxLines: 1,
                        overflow: TextOverflow
                            .ellipsis,
                      ),
                      const SizedBox(height: 2),
                      Text(
                        reminder.reminderType
                            .displayName,
                        style:
                            GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                          color: kcMediumGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                _StatusBadge(
                  status: reminder.status,
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                Icon(
                  Icons.schedule_rounded,
                  size: 14,
                  color: kcMediumGrey,
                ),
                const SizedBox(width: 4),
                Text(
                  DateFormat('MMM dd, yyyy HH:mm')
                      .format(
                    reminder.scheduledFor,
                  ),
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kcMediumGrey,
                  ),
                ),
                const Spacer(),
                if (reminder.channels
                    .isNotEmpty) ...[
                  ...reminder.channels.map(
                    _channelIcon,
                  ),
                ],
                const SizedBox(width: 8),
                GestureDetector(
                  onTap: onDelete,
                  child: const Icon(
                    Icons.delete_outline_rounded,
                    size: 18,
                    color: kcLightGrey,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildTypeIcon() {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: kcPrimaryColor
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Icon(
        _typeIcon,
        color: kcPrimaryColorDark,
        size: 20,
      ),
    );
  }

  IconData get _typeIcon {
    switch (reminder.reminderType.value) {
      case 'appointment':
        return Icons.calendar_today_rounded;
      case 'vaccination':
        return Icons.vaccines_rounded;
      case 'medication':
        return Icons.medication_rounded;
      case 'checkup':
        return Icons.health_and_safety_rounded;
      case 'grooming':
        return Icons.content_cut_rounded;
      case 'deworming':
        return Icons.bug_report_rounded;
      default:
        return Icons.notifications_rounded;
    }
  }

  Widget _channelIcon(String channel) {
    IconData icon;
    switch (channel) {
      case 'sms':
        icon = Icons.sms_outlined;
      case 'email':
        icon = Icons.email_outlined;
      case 'push':
        icon = Icons.notifications_outlined;
      default:
        icon = Icons.send_outlined;
    }
    return Padding(
      padding: const EdgeInsets.only(right: 4),
      child: Icon(
        icon,
        size: 14,
        color: kcMediumGrey,
      ),
    );
  }
}

class _StatusBadge extends StatelessWidget {
  const _StatusBadge({required this.status});

  final String status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status[0].toUpperCase() +
            status.substring(1),
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: _color,
        ),
      ),
    );
  }

  Color get _color {
    switch (status) {
      case 'pending':
        return Colors.orange;
      case 'sent':
        return kcPrimaryColorDark;
      case 'failed':
        return Colors.red;
      default:
        return kcMediumGrey;
    }
  }
}

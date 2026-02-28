import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Operational settings section (working hours,
/// slot duration, etc.).
class OperationalSettingsSection
    extends StatelessWidget {
  /// Creates an [OperationalSettingsSection].
  const OperationalSettingsSection({
    required this.settings,
    required this.onSave,
    super.key,
  });

  /// The current settings map.
  final Map<String, dynamic> settings;

  /// Callback to save settings.
  final ValueChanged<Map<String, dynamic>> onSave;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Operational Settings',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 16),
        _SettingTile(
          icon: Icons.access_time_rounded,
          title: 'Default Slot Duration',
          subtitle:
              '${settings['slotDuration'] ?? 30}'
              ' minutes',
        ),
        const SizedBox(height: 8),
        _SettingTile(
          icon: Icons.calendar_today_rounded,
          title: 'Working Days',
          subtitle:
              settings['workingDays']?.toString() ??
                  'Mon - Sat',
        ),
        const SizedBox(height: 8),
        _SettingTile(
          icon: Icons.schedule_rounded,
          title: 'Working Hours',
          subtitle:
              settings['workingHours']
                      ?.toString() ??
                  '9:00 AM - 6:00 PM',
        ),
      ],
    );
  }
}

class _SettingTile extends StatelessWidget {
  const _SettingTile({
    required this.icon,
    required this.title,
    required this.subtitle,
  });

  final IconData icon;
  final String title;
  final String subtitle;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: kcPrimaryColor
                  .withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: kcPrimaryColorDark,
              size: 20,
            ),
          ),
          const SizedBox(width: 14),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w700,
                    color: kcDarkGreyColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w500,
                    color: kcMediumGrey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.chevron_right_rounded,
            color: kcLightGrey,
          ),
        ],
      ),
    );
  }
}

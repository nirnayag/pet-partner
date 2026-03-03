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
          subtitle: _formatWorkingDays(
            settings['workingDays'],
          ),
        ),
        const SizedBox(height: 8),
        _SettingTile(
          icon: Icons.schedule_rounded,
          title: 'Working Hours',
          subtitle: _formatWorkingHours(
            settings['workingHours'] ??
                settings['businessHours'],
          ),
        ),
      ],
    );
  }
}

const _dayLabels = <String, String>{
  'monday': 'Mon',
  'tuesday': 'Tue',
  'wednesday': 'Wed',
  'thursday': 'Thu',
  'friday': 'Fri',
  'saturday': 'Sat',
  'sunday': 'Sun',
};

String _formatWorkingDays(dynamic value) {
  if (value == null) return 'Mon - Sat';
  if (value is List) {
    final names = value
        .map(
          (e) =>
              _dayLabels[e.toString().toLowerCase()]
                  ?? e.toString(),
        )
        .toList();
    return names.join(', ');
  }
  return value.toString();
}

String _formatWorkingHours(dynamic value) {
  if (value == null || value is! Map) {
    return '9:00 AM - 6:00 PM';
  }
  final hours = value as Map<String, dynamic>;

  // Find open days and summarise hours.
  final openDays = <String, String>{};
  for (final entry in hours.entries) {
    final day = entry.key;
    final info = entry.value;
    if (info is Map) {
      final closed = info['closed'] == true;
      if (closed) continue;
      final open = info['open'] ?? '';
      final close = info['close'] ?? '';
      openDays[_dayLabels[day] ?? day] =
          '$open - $close';
    }
  }
  if (openDays.isEmpty) return 'Closed';

  // Group consecutive days with same hours.
  final uniqueHours = openDays.values.toSet();
  if (uniqueHours.length == 1) {
    return uniqueHours.first;
  }

  final buf = StringBuffer();
  for (final h in uniqueHours) {
    final days = openDays.entries
        .where((e) => e.value == h)
        .map((e) => e.key)
        .join(', ');
    if (buf.isNotEmpty) buf.write('\n');
    buf.write('$days: $h');
  }
  return buf.toString();
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

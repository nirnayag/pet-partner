import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Notification preferences section.
class NotificationSettingsSection
    extends StatelessWidget {
  /// Creates a [NotificationSettingsSection].
  const NotificationSettingsSection({
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
    final smsEnabled =
        settings['smsEnabled'] as bool? ?? false;
    final emailEnabled =
        settings['emailEnabled'] as bool? ?? true;
    final pushEnabled =
        settings['pushEnabled'] as bool? ?? true;

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Notification Preferences',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 16),
        _ToggleTile(
          icon: Icons.sms_outlined,
          title: 'SMS Notifications',
          subtitle: 'Send reminders via SMS',
          value: smsEnabled,
          onChanged: (v) => onSave(
            <String, dynamic>{
              ...settings,
              'smsEnabled': v,
            },
          ),
        ),
        const SizedBox(height: 8),
        _ToggleTile(
          icon: Icons.email_outlined,
          title: 'Email Notifications',
          subtitle:
              'Send reminders via email',
          value: emailEnabled,
          onChanged: (v) => onSave(
            <String, dynamic>{
              ...settings,
              'emailEnabled': v,
            },
          ),
        ),
        const SizedBox(height: 8),
        _ToggleTile(
          icon:
              Icons.notifications_outlined,
          title: 'Push Notifications',
          subtitle:
              'Send push notifications',
          value: pushEnabled,
          onChanged: (v) => onSave(
            <String, dynamic>{
              ...settings,
              'pushEnabled': v,
            },
          ),
        ),
      ],
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.value,
    required this.onChanged,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final bool value;
  final ValueChanged<bool> onChanged;

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
          Switch(
            value: value,
            onChanged: onChanged,
            activeColor: kcPrimaryColor,
          ),
        ],
      ),
    );
  }
}

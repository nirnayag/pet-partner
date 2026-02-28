import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:url_launcher/url_launcher.dart';

/// Quick action buttons: Book, Call, Email.
class OwnerQuickActions extends StatelessWidget {
  /// Creates an [OwnerQuickActions].
  const OwnerQuickActions({
    required this.phone,
    required this.onBookAppointment,
    this.email,
    super.key,
  });

  /// Phone number for the call action.
  final String phone;

  /// Email for the email action.
  final String? email;

  /// Called when "Book Appointment" is tapped.
  final VoidCallback onBookAppointment;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _ActionButton(
          icon: Icons.calendar_today_rounded,
          label: 'Book',
          color: kcPrimaryColor,
          onTap: onBookAppointment,
        ),
        const SizedBox(width: 12),
        _ActionButton(
          icon: Icons.phone_rounded,
          label: 'Call',
          color: Colors.blue,
          onTap: () => _makeCall(phone),
        ),
        if (email != null) ...[
          const SizedBox(width: 12),
          _ActionButton(
            icon: Icons.email_rounded,
            label: 'Email',
            color: Colors.orange,
            onTap: () => _sendEmail(email!),
          ),
        ],
      ],
    );
  }

  Future<void> _makeCall(String phone) async {
    final uri = Uri(
      scheme: 'tel',
      path: phone,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }

  Future<void> _sendEmail(String email) async {
    final uri = Uri(
      scheme: 'mailto',
      path: email,
    );
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri);
    }
  }
}

class _ActionButton extends StatelessWidget {
  const _ActionButton({
    required this.icon,
    required this.label,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(
            vertical: 14,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.1),
            borderRadius:
                BorderRadius.circular(14),
          ),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w700,
                  color: color,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

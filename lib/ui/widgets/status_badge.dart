import 'package:flutter/material.dart';
import 'package:partner/core/enums/appointment_status.dart';
import 'package:partner/ui/common/app_colors.dart';

/// A small color-coded badge displaying an appointment
/// status label.
class StatusBadge extends StatelessWidget {
  /// Creates a [StatusBadge].
  const StatusBadge({
    required this.status,
    super.key,
  });

  /// The appointment status to display.
  final AppointmentStatus status;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 10,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: _backgroundColor,
        borderRadius: BorderRadius.circular(12),
      ),
      child: Text(
        status.displayName,
        style: const TextStyle(
          color: Colors.white,
          fontSize: 12,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }

  Color get _backgroundColor {
    switch (status) {
      case AppointmentStatus.pending:
        return Colors.orange;
      case AppointmentStatus.scheduled:
        return Colors.blue;
      case AppointmentStatus.confirmed:
        return const Color(0xFF009688);
      case AppointmentStatus.checkedIn:
        return Colors.indigo;
      case AppointmentStatus.inProgress:
        return kcPrimaryColor;
      case AppointmentStatus.completed:
        return kcMediumGrey;
      case AppointmentStatus.cancelled:
        return Colors.red;
      case AppointmentStatus.noShow:
        return kcDarkGreyColor;
    }
  }
}

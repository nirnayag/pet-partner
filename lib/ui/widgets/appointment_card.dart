import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:partner/core/utils/ui_helpers.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/widgets/status_badge.dart';

/// A summary card for an appointment, used in list
/// views.
class AppointmentCard extends StatelessWidget {
  /// Creates an [AppointmentCard].
  const AppointmentCard({
    required this.appointment,
    required this.onTap,
    super.key,
  });

  /// The appointment to display.
  final Appointment appointment;

  /// Callback when the card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              _buildHeader(),
              verticalSpaceSmall,
              _buildBody(),
              verticalSpaceSmall,
              _buildFooter(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildHeader() {
    final timeFormat = DateFormat('HH:mm');
    final startTime = timeFormat.format(
      appointment.scheduledStart,
    );

    return Row(
      children: [
        const Icon(
          Icons.access_time,
          size: 16,
          color: kcMediumGrey,
        ),
        horizontalSpaceTiny,
        Text(
          startTime,
          style: const TextStyle(
            fontSize: 15,
            fontWeight: FontWeight.w600,
            color: kcDarkGreyColor,
          ),
        ),
        if (appointment.durationMinutes != null) ...[
          horizontalSpaceSmall,
          Text(
            '${appointment.durationMinutes} min',
            style: const TextStyle(
              fontSize: 13,
              color: kcMediumGrey,
            ),
          ),
        ],
        const Spacer(),
        StatusBadge(status: appointment.status),
      ],
    );
  }

  Widget _buildBody() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        if (appointment.pet != null)
          Row(
            children: [
              Icon(
                _speciesIcon(
                  appointment.pet!.species,
                ),
                size: 16,
                color: kcMediumGrey,
              ),
              horizontalSpaceTiny,
              Expanded(
                child: Text(
                  appointment.pet!.name,
                  style: const TextStyle(
                    fontSize: 15,
                    fontWeight: FontWeight.w500,
                    color: kcDarkGreyColor,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        if (appointment.owner != null) ...[
          verticalSpaceTiny,
          Row(
            children: [
              const Icon(
                Icons.person_outline,
                size: 16,
                color: kcMediumGrey,
              ),
              horizontalSpaceTiny,
              Expanded(
                child: Text(
                  appointment.owner!.fullName,
                  style: const TextStyle(
                    fontSize: 13,
                    color: kcMediumGrey,
                  ),
                  overflow: TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }

  Widget _buildFooter() {
    return Row(
      children: [
        if (appointment.appointmentType !=
            null) ...[
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 8,
              vertical: 3,
            ),
            decoration: BoxDecoration(
              color: kcVeryLightGrey,
              borderRadius:
                  BorderRadius.circular(6),
            ),
            child: Text(
              appointment.appointmentType!,
              style: const TextStyle(
                fontSize: 12,
                color: kcMediumGrey,
              ),
            ),
          ),
          horizontalSpaceSmall,
        ],
        if (appointment.veterinarian != null)
          Expanded(
            child: Row(
              children: [
                const Icon(
                  Icons.medical_services_outlined,
                  size: 14,
                  color: kcMediumGrey,
                ),
                horizontalSpaceTiny,
                Expanded(
                  child: Text(
                    'Dr. ${appointment.veterinarian!.lastName}',
                    style: const TextStyle(
                      fontSize: 12,
                      color: kcMediumGrey,
                    ),
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
      ],
    );
  }

  static IconData _speciesIcon(String species) {
    switch (species.toLowerCase()) {
      case 'cat':
        return Icons.catching_pokemon;
      case 'bird':
        return Icons.flutter_dash;
      case 'rabbit':
        return Icons.cruelty_free;
      default:
        return Icons.pets;
    }
  }
}

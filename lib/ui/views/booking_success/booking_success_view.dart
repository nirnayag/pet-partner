import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:partner/ui/common/app_colors.dart';
// ignore: lines_longer_than_80_chars, long generated path
import 'package:partner/ui/views/booking_success/booking_success_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// Confirmation screen shown after successfully
/// booking an appointment.
class BookingSuccessView
    extends StackedView<BookingSuccessViewmodel> {
  /// Creates a [BookingSuccessView].
  const BookingSuccessView({
    required this.appointment,
    super.key,
  });

  /// The appointment that was just booked.
  final Appointment appointment;

  @override
  BookingSuccessViewmodel viewModelBuilder(
    BuildContext context,
  ) =>
      BookingSuccessViewmodel(
        appointment: appointment,
      );

  @override
  Widget builder(
    BuildContext context,
    BookingSuccessViewmodel viewModel,
    Widget? child,
  ) {
    return PopScope(
      canPop: false,
      child: Scaffold(
        backgroundColor: kcBackgroundColor,
        body: SafeArea(
          child: Padding(
            padding: const EdgeInsets.symmetric(
              horizontal: 24,
            ),
            child: Column(
              children: [
                const Spacer(),
                _SuccessIcon(),
                const SizedBox(height: 24),
                Text(
                  'Appointment Booked!',
                  style: GoogleFonts.manrope(
                    fontSize: 26,
                    fontWeight: FontWeight.w900,
                    color: kcDarkGreyColor,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  'Your appointment is pending'
                  ' approval from the clinic.',
                  textAlign: TextAlign.center,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w600,
                    color: kcMediumGrey,
                  ),
                ),
                const SizedBox(height: 32),
                _SummaryCard(
                  appointment:
                      viewModel.appointment,
                ),
                const Spacer(),
                _ViewAppointmentButton(
                  onTap:
                      viewModel.viewAppointment,
                ),
                const SizedBox(height: 12),
                _BackToHomeButton(
                  onTap: viewModel.goToHome,
                ),
                const SizedBox(height: 40),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

// ---- Private Widgets ----

class _SuccessIcon extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Container(
      width: 100,
      height: 100,
      decoration: BoxDecoration(
        color:
            Colors.green.withValues(alpha: 0.1),
        shape: BoxShape.circle,
      ),
      child: Center(
        child: Container(
          width: 72,
          height: 72,
          decoration: BoxDecoration(
            color: Colors.green
                .withValues(alpha: 0.2),
            shape: BoxShape.circle,
          ),
          child: const Icon(
            Icons.check_rounded,
            size: 40,
            color: Colors.green,
          ),
        ),
      ),
    );
  }
}

class _SummaryCard extends StatelessWidget {
  const _SummaryCard({
    required this.appointment,
  });

  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    final dateLabel = DateFormat('EEE, dd MMM yyyy')
        .format(appointment.scheduledStart);
    final timeLabel = DateFormat('hh:mm a')
        .format(appointment.scheduledStart);

    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.04),
            blurRadius: 20,
            offset: const Offset(0, 8),
          ),
        ],
      ),
      child: Column(
        children: [
          _SummaryRow(
            icon: Icons.pets_rounded,
            label: 'Pet',
            value: appointment.pet?.name ??
                'Not specified',
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            icon: Icons.calendar_today_rounded,
            label: 'Date',
            value: dateLabel,
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            icon: Icons.access_time_rounded,
            label: 'Time',
            value: timeLabel,
          ),
          const SizedBox(height: 14),
          _SummaryRow(
            icon: Icons.medical_services_rounded,
            label: 'Type',
            value: _formatType(
              appointment.appointmentType,
            ),
          ),
          if (appointment.veterinarian !=
              null) ...[
            const SizedBox(height: 14),
            _SummaryRow(
              icon: Icons.person_rounded,
              label: 'Vet',
              value:
                  'Dr. ${appointment.veterinarian!.firstName}'
                  ' ${appointment.veterinarian!.lastName}',
            ),
          ],
          const SizedBox(height: 16),
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: kcStatusPending
                  .withValues(alpha: 0.1),
              borderRadius:
                  BorderRadius.circular(8),
              border: Border.all(
                color: kcStatusPending
                    .withValues(alpha: 0.3),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const CircleAvatar(
                  radius: 4,
                  backgroundColor:
                      kcStatusPending,
                ),
                const SizedBox(width: 8),
                Text(
                  'Pending Approval',
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: kcStatusPending,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String _formatType(String? type) {
    if (type == null || type.isEmpty) {
      return 'General';
    }
    return '${type[0].toUpperCase()}'
        '${type.substring(1)}';
  }
}

class _SummaryRow extends StatelessWidget {
  const _SummaryRow({
    required this.icon,
    required this.label,
    required this.value,
  });

  final IconData icon;
  final String label;
  final String value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 18, color: kcLightGrey),
        const SizedBox(width: 10),
        SizedBox(
          width: 48,
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kcLightGrey,
            ),
          ),
        ),
        const SizedBox(width: 8),
        Expanded(
          child: Text(
            value,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: kcDarkGreyColor,
            ),
          ),
        ),
      ],
    );
  }
}

class _ViewAppointmentButton
    extends StatelessWidget {
  const _ViewAppointmentButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(18),
          border: Border.all(
            color: kcVeryLightGrey,
          ),
        ),
        child: Center(
          child: Text(
            'View Appointment',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
        ),
      ),
    );
  }
}

class _BackToHomeButton extends StatelessWidget {
  const _BackToHomeButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        height: 56,
        decoration: BoxDecoration(
          color: kcPrimaryColor,
          borderRadius:
              BorderRadius.circular(18),
          boxShadow: [
            BoxShadow(
              color: kcPrimaryColor
                  .withValues(alpha: 0.3),
              blurRadius: 12,
            ),
          ],
        ),
        child: Center(
          child: Text(
            'Back to Home',
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w900,
              color: kcNeutral900,
            ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/core/enums/appointment_status.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/appointment_detail/appointment_detail_viewmodel.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:partner/ui/widgets/status_badge.dart';
import 'package:stacked/stacked.dart';

/// Detail screen for a single appointment.
///
/// Receives [appointmentId] via constructor (passed
/// through the Stacked router).
class AppointmentDetailView
    extends StackedView<AppointmentDetailViewModel> {
  /// Creates an [AppointmentDetailView].
  const AppointmentDetailView({
    required this.appointmentId,
    super.key,
  });

  /// The appointment to display.
  final String appointmentId;

  @override
  Widget builder(
    BuildContext context,
    AppointmentDetailViewModel viewModel,
    Widget? child,
  ) {
    // Loading
    if (viewModel.isBusy) {
      return Scaffold(
        backgroundColor: kcBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _AppBar(viewModel: viewModel),
              const Expanded(
                child: LoadingShimmer(
                  type: ShimmerType.detail,
                ),
              ),
            ],
          ),
        ),
      );
    }

    // Error
    if (viewModel.errorMessage != null &&
        viewModel.appointment == null) {
      return Scaffold(
        backgroundColor: kcBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _AppBar(viewModel: viewModel),
              Expanded(
                child: ErrorState(
                  message:
                      viewModel.errorMessage!,
                  onRetry: viewModel.retry,
                ),
              ),
            ],
          ),
        ),
      );
    }

    final appt = viewModel.appointment;
    if (appt == null) {
      return Scaffold(
        backgroundColor: kcBackgroundColor,
        body: SafeArea(
          child: Column(
            children: [
              _AppBar(viewModel: viewModel),
              const Expanded(
                child: Center(
                  child: Text(
                    'Appointment not found',
                  ),
                ),
              ),
            ],
          ),
        ),
      );
    }

    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              _AppBar(viewModel: viewModel),
              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.only(
                    bottom: 120,
                  ),
                  child: Column(
                    children: [
                      _PetProfileHeader(
                        appointment: appt,
                        viewModel: viewModel,
                      ),
                      const SizedBox(height: 12),
                      _VisitInfoCard(
                        appointment: appt,
                        onViewMedicalRecord:
                            viewModel
                                .showMedicalRecordSheet,
                      ),
                      const SizedBox(height: 12),
                      const _ConsultationNotesCard(),
                      if (appt.status ==
                          AppointmentStatus
                              .pending)
                        _PendingApprovalCard(
                          viewModel: viewModel,
                        ),
                    ],
                  ),
                ),
              ),
            ],
          ),
          if (viewModel.canManageAppointment)
            _BottomStickyActions(
              viewModel: viewModel,
              appointment: appt,
            ),
        ],
      ),
    );
  }

  @override
  AppointmentDetailViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      AppointmentDetailViewModel(
        appointmentId: appointmentId,
      );

  @override
  void onViewModelReady(
    AppointmentDetailViewModel viewModel,
  ) =>
      viewModel.initialise();
}

// ====================================================
// App bar
// ====================================================

class _AppBar extends StatelessWidget {
  const _AppBar({required this.viewModel});

  final AppointmentDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        50,
        16,
        16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: kcVeryLightGrey,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: viewModel.goBack,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: kcDarkGreyColor,
            ),
          ),
          Text(
            'Appointment Details',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
          const Icon(
            Icons.more_vert_rounded,
            color: kcDarkGreyColor,
          ),
        ],
      ),
    );
  }
}

// ====================================================
// Pet profile header
// ====================================================

class _PetProfileHeader extends StatelessWidget {
  const _PetProfileHeader({
    required this.appointment,
    required this.viewModel,
  });

  final Appointment appointment;
  final AppointmentDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final pet = appointment.pet;
    final owner = appointment.owner;
    final petName = pet?.name ?? 'Unknown Pet';
    final subtitle = _buildPetSubtitle();

    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              // Pet photo
              GestureDetector(
                onTap:
                    viewModel
                        .navigateToPatientProfile,
                child: Container(
                  width: 100,
                  height: 100,
                  decoration: BoxDecoration(
                    borderRadius:
                        BorderRadius.circular(24),
                    color: kcVeryLightGrey,
                    image: pet?.photoUrl != null
                        ? DecorationImage(
                            image: NetworkImage(
                              pet!.photoUrl!,
                            ),
                            fit: BoxFit.cover,
                          )
                        : null,
                  ),
                  child: pet?.photoUrl == null
                      ? const Icon(
                          Icons.pets,
                          size: 36,
                          color: kcLightGrey,
                        )
                      : null,
                ),
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      petName,
                      style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight:
                            FontWeight.w900,
                        color: kcDarkGreyColor,
                      ),
                    ),
                    Text(
                      subtitle,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w600,
                        color: kcMediumGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    StatusBadge(
                      status:
                          appointment.status,
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          // Owner card
          if (owner != null)
            _OwnerActionCard(
              ownerName: owner.fullName,
            ),
        ],
      ),
    );
  }

  String _buildPetSubtitle() {
    final pet = appointment.pet;
    if (pet == null) return '';
    final parts = <String>[
      if (pet.breed != null) pet.breed!,
      if (pet.gender != null) pet.gender!,
    ];
    return parts.join(' \u2022 ');
  }
}

// ====================================================
// Owner action card
// ====================================================

class _OwnerActionCard extends StatelessWidget {
  const _OwnerActionCard({
    required this.ownerName,
  });

  final String ownerName;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kcVeryLightGrey.withValues(
          alpha: 0.2,
        ),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color: kcVeryLightGrey.withValues(
            alpha: 0.5,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: kcVeryLightGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person,
              color: kcMediumGrey,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  'OWNER',
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: kcLightGrey,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  ownerName,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: kcDarkGreyColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _iconButton(
                Icons.chat_bubble_rounded,
                Colors.white,
                Colors.green,
              ),
              const SizedBox(width: 10),
              _iconButton(
                Icons.call_rounded,
                kcPrimaryColor,
                kcNeutral900,
              ),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(
    IconData icon,
    Color bg,
    Color iconColor,
  ) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 10,
          ),
        ],
      ),
      child: Icon(
        icon,
        color: iconColor,
        size: 20,
      ),
    );
  }
}

// ====================================================
// Visit info card
// ====================================================

class _VisitInfoCard extends StatelessWidget {
  const _VisitInfoCard({
    required this.appointment,
    required this.onViewMedicalRecord,
  });

  final Appointment appointment;
  final VoidCallback onViewMedicalRecord;

  @override
  Widget build(BuildContext context) {
    final timeStr = DateFormat('HH:mm').format(
      appointment.scheduledStart,
    );
    final duration =
        appointment.durationMinutes != null
            ? '${appointment.durationMinutes} min'
            : timeStr;

    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,
                  children: [
                    Text(
                      'REASON FOR VISIT',
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight:
                            FontWeight.w900,
                        color: kcLightGrey,
                        letterSpacing: 1,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      appointment.title,
                      style: GoogleFonts.manrope(
                        fontSize: 20,
                        fontWeight:
                            FontWeight.w800,
                        color: kcDarkGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 6,
                ),
                decoration: BoxDecoration(
                  color: Colors.blue.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Text(
                  duration,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          if (appointment.appointmentType !=
              null) ...[
            const SizedBox(height: 16),
            _tag(appointment.appointmentType!),
          ],
          if (appointment.description !=
              null) ...[
            const SizedBox(height: 12),
            Text(
              appointment.description!,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: kcMediumGrey,
              ),
            ),
          ],
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onViewMedicalRecord,
            child: Container(
              width: double.infinity,
              padding:
                  const EdgeInsets.symmetric(
                vertical: 16,
              ),
              decoration: BoxDecoration(
                color:
                    const Color(0xFF0C141F),
                borderRadius:
                    BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment:
                    MainAxisAlignment.center,
                children: [
                  const Icon(
                    Icons
                        .history_edu_rounded,
                    color: Colors.white,
                    size: 20,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'View Full Medical Record',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight:
                          FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 12,
        vertical: 6,
      ),
      decoration: BoxDecoration(
        color: kcVeryLightGrey.withValues(
          alpha: 0.4,
        ),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: kcMediumGrey,
        ),
      ),
    );
  }
}

// ====================================================
// Consultation notes card
// ====================================================

class _ConsultationNotesCard
    extends StatelessWidget {
  const _ConsultationNotesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(
                    Icons.edit_note_rounded,
                    color: kcPrimaryColor,
                    size: 24,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    'Consultation Notes',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w800,
                      color: kcDarkGreyColor,
                    ),
                  ),
                ],
              ),
              Text(
                'Auto-save',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kcLightGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color:
                  kcVeryLightGrey.withValues(
                alpha: 0.2,
              ),
              borderRadius:
                  BorderRadius.circular(16),
            ),
            child: TextField(
              maxLines: null,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: kcDarkGreyColor,
              ),
              decoration:
                  InputDecoration.collapsed(
                hintText:
                    'Enter clinical '
                    'observations, '
                    'diagnosis, and '
                    'treatment plan...',
                hintStyle: GoogleFonts.manrope(
                  fontSize: 14,
                  color: kcLightGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================
// Pending approval card
// ====================================================

class _PendingApprovalCard
    extends StatelessWidget {
  const _PendingApprovalCard({
    required this.viewModel,
  });

  final AppointmentDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (!viewModel.canManageAppointment) {
      return const SizedBox.shrink();
    }
    return Container(
      margin: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        0,
      ),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.orange.withValues(
          alpha: 0.08,
        ),
        borderRadius: BorderRadius.circular(24),
        border: Border.all(
          color: Colors.orange.withValues(
            alpha: 0.2,
          ),
        ),
      ),
      child: Column(
        children: [
          Row(
            children: [
              const Icon(
                Icons.pending_actions,
                color: Colors.orange,
              ),
              const SizedBox(width: 8),
              Text(
                'Pending Approval',
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: Colors.orange[800],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            child: ElevatedButton(
              onPressed:
                  viewModel.busy(
                        AppointmentDetailViewModel
                            .kApproveBusyKey,
                      )
                      ? null
                      : viewModel
                          .approveAppointment,
              style: ElevatedButton.styleFrom(
                backgroundColor: kcPrimaryColor,
                foregroundColor: kcNeutral900,
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                padding:
                    const EdgeInsets.symmetric(
                  vertical: 14,
                ),
              ),
              child: Text(
                'Approve Appointment',
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w800,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================
// Bottom sticky actions
// ====================================================

class _BottomStickyActions extends StatelessWidget {
  const _BottomStickyActions({
    required this.viewModel,
    required this.appointment,
  });

  final AppointmentDetailViewModel viewModel;
  final Appointment appointment;

  @override
  Widget build(BuildContext context) {
    // Only show for non-terminal statuses.
    if (appointment.status ==
            AppointmentStatus.completed ||
        appointment.status ==
            AppointmentStatus.cancelled ||
        appointment.status ==
            AppointmentStatus.noShow) {
      return const SizedBox.shrink();
    }

    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(
          20,
          20,
          20,
          40,
        ),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kcBackgroundColor.withValues(
                alpha: 0,
              ),
              kcBackgroundColor,
              kcBackgroundColor,
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.1,
                ),
                blurRadius: 30,
              ),
            ],
          ),
          child: Row(
            children: [
              _actionButton(
                label: _nextStatusLabel,
                icon: _nextStatusIcon,
                color: kcPrimaryColor,
                textColor: kcNeutral900,
                onTap: () => viewModel
                    .updateStatus(_nextStatus),
              ),
              const SizedBox(width: 8),
              if (appointment.status !=
                  AppointmentStatus
                      .completed) ...[
                _actionButton(
                  label: 'Complete',
                  icon: Icons.check_rounded,
                  color: kcVeryLightGrey
                      .withValues(alpha: 0.4),
                  textColor: kcDarkGreyColor,
                  onTap: () =>
                      viewModel.updateStatus(
                    AppointmentStatus.completed,
                  ),
                ),
                const SizedBox(width: 8),
              ],
              GestureDetector(
                onTap: () =>
                    viewModel.updateStatus(
                  AppointmentStatus.noShow,
                ),
                child: Container(
                  width: 56,
                  height: 56,
                  decoration: BoxDecoration(
                    color:
                        kcVeryLightGrey.withValues(
                      alpha: 0.4,
                    ),
                    borderRadius:
                        BorderRadius.circular(
                      18,
                    ),
                  ),
                  child: const Icon(
                    Icons.person_off_rounded,
                    color: kcLightGrey,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _actionButton({
    required String label,
    required IconData icon,
    required Color color,
    required Color textColor,
    required VoidCallback onTap,
  }) {
    return Expanded(
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: color,
            borderRadius:
                BorderRadius.circular(18),
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              Icon(icon, color: textColor),
              const SizedBox(width: 4),
              Text(
                label,
                style: GoogleFonts.manrope(
                  fontWeight: FontWeight.w900,
                  fontSize: 14,
                  color: textColor,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  AppointmentStatus get _nextStatus {
    switch (appointment.status) {
      case AppointmentStatus.pending:
      case AppointmentStatus.scheduled:
        return AppointmentStatus.confirmed;
      case AppointmentStatus.confirmed:
        return AppointmentStatus.checkedIn;
      case AppointmentStatus.checkedIn:
        return AppointmentStatus.inProgress;
      case AppointmentStatus.inProgress:
      case AppointmentStatus.completed:
      case AppointmentStatus.cancelled:
      case AppointmentStatus.noShow:
        return AppointmentStatus.completed;
    }
  }

  String get _nextStatusLabel {
    switch (appointment.status) {
      case AppointmentStatus.pending:
      case AppointmentStatus.scheduled:
        return 'Confirm';
      case AppointmentStatus.confirmed:
        return 'Check In';
      case AppointmentStatus.checkedIn:
        return 'In-Progress';
      case AppointmentStatus.inProgress:
        return 'Complete';
      case AppointmentStatus.completed:
      case AppointmentStatus.cancelled:
      case AppointmentStatus.noShow:
        return 'Update';
    }
  }

  IconData get _nextStatusIcon {
    switch (appointment.status) {
      case AppointmentStatus.pending:
      case AppointmentStatus.scheduled:
        return Icons.check_rounded;
      case AppointmentStatus.confirmed:
        return Icons.login_rounded;
      case AppointmentStatus.checkedIn:
        return Icons.play_arrow_rounded;
      case AppointmentStatus.inProgress:
        return Icons.done_all_rounded;
      case AppointmentStatus.completed:
      case AppointmentStatus.cancelled:
      case AppointmentStatus.noShow:
        return Icons.check_rounded;
    }
  }
}

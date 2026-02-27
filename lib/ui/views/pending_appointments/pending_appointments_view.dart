import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:partner/ui/common/app_colors.dart';
// ignore: lines_longer_than_80_chars, long generated path
import 'package:partner/ui/views/pending_appointments/pending_appointments_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// View showing appointments awaiting approval.
class PendingAppointmentsView extends StackedView<
    PendingAppointmentsViewmodel> {
  /// Creates a [PendingAppointmentsView].
  const PendingAppointmentsView({super.key});

  @override
  PendingAppointmentsViewmodel viewModelBuilder(
    BuildContext context,
  ) =>
      PendingAppointmentsViewmodel();

  @override
  void onViewModelReady(
    PendingAppointmentsViewmodel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    PendingAppointmentsViewmodel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Column(
        children: [
          _PendingAppBar(
            onBack: () =>
                Navigator.of(context).pop(),
          ),
          Expanded(
            child: _buildBody(viewModel),
          ),
        ],
      ),
    );
  }

  Widget _buildBody(
    PendingAppointmentsViewmodel viewModel,
  ) {
    if (viewModel.isBusy) {
      return const _LoadingState();
    }

    if (viewModel.errorMessage != null) {
      return _ErrorState(
        message: viewModel.errorMessage!,
        onRetry: viewModel.refresh,
      );
    }

    if (viewModel
        .pendingAppointments.isEmpty) {
      return const _EmptyState();
    }

    return RefreshIndicator(
      onRefresh: viewModel.refresh,
      color: kcPrimaryColor,
      child: ListView.builder(
        padding: const EdgeInsets.fromLTRB(
          20,
          12,
          20,
          24,
        ),
        itemCount:
            viewModel.pendingAppointments.length +
                (viewModel.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >=
              viewModel
                  .pendingAppointments.length) {
            return _LoadMoreIndicator(
              onLoadMore: viewModel.loadMore,
              isLoading:
                  viewModel.isLoadingMore,
            );
          }

          final apt = viewModel
              .pendingAppointments[index];

          return _PendingCard(
            appointment: apt,
            isBusy: viewModel.busy(apt.id),
            onApprove: () => viewModel
                .approveAppointment(apt.id),
            onReject: () => viewModel
                .rejectAppointment(apt.id),
            onTap: () =>
                viewModel.viewDetails(apt),
          );
        },
      ),
    );
  }
}

// ---- Private Widgets ----

class _PendingAppBar extends StatelessWidget {
  const _PendingAppBar({required this.onBack});

  final VoidCallback onBack;

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
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: kcDarkGreyColor,
            ),
          ),
          Text(
            'Pending Appointments',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}

class _PendingCard extends StatelessWidget {
  const _PendingCard({
    required this.appointment,
    required this.isBusy,
    required this.onApprove,
    required this.onReject,
    required this.onTap,
  });

  final Appointment appointment;
  final bool isBusy;
  final VoidCallback onApprove;
  final VoidCallback onReject;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dateLabel =
        DateFormat('EEE, dd MMM').format(
      appointment.scheduledStart,
    );
    final timeLabel = DateFormat('hh:mm a')
        .format(appointment.scheduledStart);

    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 44,
                  height: 44,
                  decoration: BoxDecoration(
                    color: kcStatusPending
                        .withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(14),
                  ),
                  child: const Icon(
                    Icons.pets_rounded,
                    color: kcStatusPending,
                    size: 22,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      Text(
                        appointment.pet?.name ??
                            appointment.title,
                        style:
                            GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight:
                              FontWeight.w800,
                          color: kcDarkGreyColor,
                        ),
                      ),
                      if (appointment.owner !=
                          null)
                        Text(
                          'Owner: '
                          '${appointment.owner!.fullName}',
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
                Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 10,
                    vertical: 5,
                  ),
                  decoration: BoxDecoration(
                    color: kcStatusPending
                        .withValues(alpha: 0.1),
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                  child: Text(
                    _formatType(
                      appointment.appointmentType,
                    ),
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w700,
                      color: kcStatusPending,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 12),
            Row(
              children: [
                const Icon(
                  Icons.calendar_today_rounded,
                  size: 14,
                  color: kcLightGrey,
                ),
                const SizedBox(width: 6),
                Text(
                  dateLabel,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kcMediumGrey,
                  ),
                ),
                const SizedBox(width: 16),
                const Icon(
                  Icons.access_time_rounded,
                  size: 14,
                  color: kcLightGrey,
                ),
                const SizedBox(width: 6),
                Text(
                  timeLabel,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kcMediumGrey,
                  ),
                ),
                if (appointment
                        .durationMinutes !=
                    null) ...[
                  const SizedBox(width: 16),
                  const Icon(
                    Icons.timelapse_rounded,
                    size: 14,
                    color: kcLightGrey,
                  ),
                  const SizedBox(width: 6),
                  Text(
                    '${appointment.durationMinutes}'
                    ' min',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kcMediumGrey,
                    ),
                  ),
                ],
              ],
            ),
            const SizedBox(height: 16),
            if (isBusy)
              const Center(
                child: SizedBox(
                  width: 24,
                  height: 24,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2.5,
                    color: kcPrimaryColor,
                  ),
                ),
              )
            else
              Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: onReject,
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.red
                              .withValues(
                            alpha: 0.08,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'Reject',
                            style: GoogleFonts
                                .manrope(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w800,
                              color:
                                  Colors.red[600],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: GestureDetector(
                      onTap: onApprove,
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: Colors.green
                              .withValues(
                            alpha: 0.1,
                          ),
                          borderRadius:
                              BorderRadius
                                  .circular(14),
                        ),
                        child: Center(
                          child: Text(
                            'Approve',
                            style: GoogleFonts
                                .manrope(
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w800,
                              color: Colors
                                  .green[700],
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
          ],
        ),
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

class _LoadMoreIndicator extends StatelessWidget {
  const _LoadMoreIndicator({
    required this.onLoadMore,
    required this.isLoading,
  });

  final VoidCallback onLoadMore;
  final bool isLoading;

  @override
  Widget build(BuildContext context) {
    if (!isLoading) {
      WidgetsBinding.instance
          .addPostFrameCallback((_) {
        onLoadMore();
      });
    }

    return const Padding(
      padding: EdgeInsets.symmetric(
        vertical: 24,
      ),
      child: Center(
        child: SizedBox(
          width: 24,
          height: 24,
          child: CircularProgressIndicator(
            strokeWidth: 2.5,
            color: kcPrimaryColor,
          ),
        ),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  const _EmptyState();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 80,
            height: 80,
            decoration: BoxDecoration(
              color: kcVeryLightGrey.withValues(
                alpha: 0.4,
              ),
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.event_available_rounded,
              size: 40,
              color: kcLightGrey,
            ),
          ),
          const SizedBox(height: 16),
          Text(
            'No pending appointment\nrequests',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 16,
              fontWeight: FontWeight.w700,
              color: kcMediumGrey,
            ),
          ),
          const SizedBox(height: 8),
          Text(
            'All appointment requests have\n'
            'been processed.',
            textAlign: TextAlign.center,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: kcLightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

class _LoadingState extends StatelessWidget {
  const _LoadingState();

  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.all(20),
      itemCount: 5,
      itemBuilder: (_, __) => Container(
        margin:
            const EdgeInsets.only(bottom: 16),
        height: 160,
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(24),
        ),
        child: Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  _shimmerBox(44, 44, 14),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Column(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,
                      children: [
                        _shimmerBox(16, 120, 6),
                        const SizedBox(height: 6),
                        _shimmerBox(12, 80, 6),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 14),
              _shimmerBox(12, 200, 6),
              const Spacer(),
              Row(
                children: [
                  Expanded(
                    child:
                        _shimmerBox(44, 999, 14),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child:
                        _shimmerBox(44, 999, 14),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _shimmerBox(
    double height,
    double width,
    double radius,
  ) {
    return Container(
      height: height,
      width: width,
      decoration: BoxDecoration(
        color: kcVeryLightGrey.withValues(
          alpha: 0.5,
        ),
        borderRadius:
            BorderRadius.circular(radius),
      ),
    );
  }
}

class _ErrorState extends StatelessWidget {
  const _ErrorState({
    required this.message,
    required this.onRetry,
  });

  final String message;
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(32),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                color:
                    Colors.red.withValues(
                  alpha: 0.08,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                Icons
                    .error_outline_rounded,
                size: 40,
                color: Colors.red[400],
              ),
            ),
            const SizedBox(height: 16),
            Text(
              'Something went wrong',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: kcDarkGreyColor,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              message,
              textAlign: TextAlign.center,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w500,
                color: kcMediumGrey,
              ),
            ),
            const SizedBox(height: 24),
            GestureDetector(
              onTap: onRetry,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 24,
                  vertical: 12,
                ),
                decoration: BoxDecoration(
                  color: kcPrimaryColor,
                  borderRadius:
                      BorderRadius.circular(14),
                ),
                child: Text(
                  'Retry',
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: kcNeutral900,
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/schedule/schedule_viewmodel.dart';
import 'package:partner/ui/widgets/appointment_card.dart';
import 'package:partner/ui/widgets/empty_state.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

/// The schedule / calendar screen showing
/// appointments for a selected date.
class ScheduleView
    extends StackedView<ScheduleViewModel> {
  /// Creates a [ScheduleView].
  const ScheduleView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ScheduleViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      floatingActionButton:
          viewModel.canCreateAppointment
              ? FloatingActionButton(
                  onPressed:
                      viewModel.navigateToAddAppointment,
                  backgroundColor: kcPrimaryColor,
                  elevation: 8,
                  shape: const CircleBorder(),
                  child: const Icon(
                    Icons.add,
                    color: kcNeutral900,
                    size: 32,
                  ),
                )
              : null,
      body: SafeArea(
        child: Column(
          children: [
            _ScheduleHeader(viewModel: viewModel),
            _DateSelector(viewModel: viewModel),
            const Divider(
              height: 1,
              color: kcVeryLightGrey,
            ),
            Expanded(
              child: _AppointmentList(
                viewModel: viewModel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ScheduleViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ScheduleViewModel();

  @override
  void onViewModelReady(
    ScheduleViewModel viewModel,
  ) =>
      viewModel.initialise();
}

// ====================================================
// Header
// ====================================================

class _ScheduleHeader extends StatelessWidget {
  const _ScheduleHeader({
    required this.viewModel,
  });

  final ScheduleViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        10,
      ),
      child: Row(
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Schedule',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: kcDarkGreyColor,
                ),
              ),
              const SizedBox(height: 2),
              Text(
                viewModel.userName,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kcMediumGrey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              const Icon(
                Icons
                    .notifications_none_rounded,
                color: kcDarkGreyColor,
                size: 28,
              ),
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration:
                      const BoxDecoration(
                    color: kcPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

// ====================================================
// Date selector
// ====================================================

class _DateSelector extends StatelessWidget {
  const _DateSelector({required this.viewModel});

  final ScheduleViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    final selected = viewModel.selectedDate;
    final monthYear =
        DateFormat('MMMM yyyy').format(selected);

    // Build 5-day range around the selected date
    final days = List.generate(
      5,
      (i) => selected.add(Duration(days: i - 2)),
    );

    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(
            horizontal: 20,
            vertical: 8,
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              GestureDetector(
                onTap: () =>
                    viewModel.shiftDate(-7),
                child: const Icon(
                  Icons.chevron_left,
                  color: kcLightGrey,
                ),
              ),
              Text(
                monthYear,
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: kcDarkGreyColor,
                ),
              ),
              GestureDetector(
                onTap: () =>
                    viewModel.shiftDate(7),
                child: const Icon(
                  Icons.chevron_right,
                  color: kcLightGrey,
                ),
              ),
            ],
          ),
        ),
        const SizedBox(height: 8),
        SizedBox(
          height: 90,
          child: ListView.builder(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(
              horizontal: 20,
            ),
            itemCount: days.length,
            itemBuilder: (_, i) {
              final day = days[i];
              final isActive =
                  day.day == selected.day &&
                      day.month ==
                          selected.month &&
                      day.year == selected.year;
              return _DayCard(
                date: day,
                isActive: isActive,
                onTap: () =>
                    viewModel.onDateSelected(day),
              );
            },
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }
}

class _DayCard extends StatelessWidget {
  const _DayCard({
    required this.date,
    required this.isActive,
    required this.onTap,
  });

  final DateTime date;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final dayName =
        DateFormat('EEE').format(date);
    final dayNum = date.day.toString();

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 65,
        margin: const EdgeInsets.only(right: 12),
        decoration: BoxDecoration(
          color: isActive
              ? kcPrimaryColor
              : Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color:
                        kcPrimaryColor.withValues(
                      alpha: 0.3,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ]
              : [
                  BoxShadow(
                    color:
                        Colors.black.withValues(
                      alpha: 0.02,
                    ),
                    blurRadius: 5,
                  ),
                ],
          border: !isActive
              ? Border.all(
                  color:
                      kcVeryLightGrey.withValues(
                    alpha: 0.5,
                  ),
                )
              : null,
        ),
        child: Column(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            Text(
              dayName,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: isActive
                    ? FontWeight.w800
                    : FontWeight.w600,
                color: isActive
                    ? kcNeutral900
                    : kcLightGrey,
              ),
            ),
            const SizedBox(height: 4),
            Text(
              dayNum,
              style: GoogleFonts.manrope(
                fontSize: 20,
                fontWeight: FontWeight.w800,
                color: isActive
                    ? kcNeutral900
                    : kcDarkGreyColor,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// Appointment list body
// ====================================================

class _AppointmentList extends StatelessWidget {
  const _AppointmentList({
    required this.viewModel,
  });

  final ScheduleViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    // Loading
    if (viewModel.isBusy) {
      return const LoadingShimmer();
    }

    // Error
    if (viewModel.errorMessage != null) {
      return ErrorState(
        message: viewModel.errorMessage!,
        onRetry: viewModel.refresh,
      );
    }

    // Empty
    if (viewModel.appointments.isEmpty) {
      return EmptyState(
        icon: Icons.calendar_today_rounded,
        title: 'No appointments',
        description:
            'There are no appointments for this'
            ' date.',
        actionLabel:
            viewModel.canCreateAppointment
                ? 'Add Appointment'
                : null,
        onAction: viewModel.canCreateAppointment
            ? viewModel.navigateToAddAppointment
            : null,
      );
    }

    // List
    return RefreshIndicator(
      color: kcPrimaryColor,
      onRefresh: viewModel.refresh,
      child: ListView.separated(
        padding: const EdgeInsets.all(20),
        itemCount:
            viewModel.appointments.length,
        separatorBuilder: (_, __) =>
            const SizedBox(height: 12),
        itemBuilder: (_, index) {
          final appt =
              viewModel.appointments[index];
          return AppointmentCard(
            appointment: appt,
            onTap: () => viewModel
                .onAppointmentTapped(appt),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/common/app_snackbar.dart';
import 'package:partner/ui/views/home/home_viewmodel.dart';
import 'package:partner/ui/widgets/appointment_card.dart';
import 'package:partner/ui/widgets/empty_state.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

/// The home / dashboard screen.
///
/// Shows summary stats and today's appointments
/// loaded from the API.
class HomeView extends StackedView<HomeViewModel> {
  /// Creates a [HomeView].
  const HomeView({super.key});

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _DashboardHeader(
              viewModel: viewModel,
            ),
            Expanded(
              child: _DashboardBody(
                viewModel: viewModel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      HomeViewModel();

  @override
  void onViewModelReady(
    HomeViewModel viewModel,
  ) =>
      viewModel.initialise();
}

// ====================================================
// Header
// ====================================================

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader({
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                _greeting,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kcMediumGrey,
                ),
              ),
              Text(
                viewModel.displayName,
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: kcDarkGreyColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          GestureDetector(
            onTap: () => _showComingSoon(context),
            child: Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(16),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withValues(
                      alpha: 0.05,
                    ),
                    blurRadius: 10,
                  ),
                ],
              ),
              child: const Icon(
                Icons
                    .notifications_outlined,
                color: kcDarkGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }

  void _showComingSoon(BuildContext context) {
    AppSnackbar.showInfo(
      context,
      'Notifications coming soon',
    );
  }

  String get _greeting {
    final hour = DateTime.now().hour;
    if (hour < 12) return 'Good Morning,';
    if (hour < 17) return 'Good Afternoon,';
    return 'Good Evening,';
  }
}

// ====================================================
// Body
// ====================================================

class _DashboardBody extends StatelessWidget {
  const _DashboardBody({
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    // Loading
    if (viewModel.isBusy) {
      return const LoadingShimmer();
    }

    // Error
    if (viewModel.errorMessage != null &&
        viewModel.todayAppointments.isEmpty) {
      return ErrorState(
        message: viewModel.errorMessage!,
        onRetry: viewModel.refresh,
      );
    }

    return RefreshIndicator(
      color: kcPrimaryColor,
      onRefresh: viewModel.refresh,
      child: ListView(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        children: [
          const SizedBox(height: 10),
          _SummaryStatsGrid(
            viewModel: viewModel,
          ),
          const SizedBox(height: 24),
          _AppointmentsSectionHeader(
            viewModel: viewModel,
          ),
          const SizedBox(height: 16),
          _AppointmentsList(
            viewModel: viewModel,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

// ====================================================
// Summary stats grid
// ====================================================

class _SummaryStatsGrid extends StatelessWidget {
  const _SummaryStatsGrid({
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard(
          '${viewModel.totalCount}',
          'TOTAL',
        ),
        const SizedBox(width: 12),
        _statCard(
          '${viewModel.pendingCount}',
          'PENDING',
          isPrimary: true,
        ),
        const SizedBox(width: 12),
        _statCard(
          '${viewModel.completedCount}',
          'DONE',
          isDone: true,
        ),
      ],
    );
  }

  Widget _statCard(
    String value,
    String label, {
    bool isPrimary = false,
    bool isDone = false,
  }) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(
          vertical: 20,
        ),
        decoration: BoxDecoration(
          color: isPrimary
              ? kcPrimaryColor.withValues(
                  alpha: 0.1,
                )
              : Colors.white,
          borderRadius:
              BorderRadius.circular(24),
          border: isPrimary
              ? Border.all(
                  color:
                      kcPrimaryColor.withValues(
                    alpha: 0.2,
                  ),
                )
              : Border.all(
                  color:
                      kcVeryLightGrey.withValues(
                    alpha: 0.5,
                  ),
                ),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: isDone
                    ? kcLightGrey
                    : (isPrimary
                        ? kcPrimaryColorDark
                        : kcDarkGreyColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: isDone
                    ? kcLightGrey
                    : (isPrimary
                        ? kcPrimaryColorDark
                        : kcMediumGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// Appointments section header
// ====================================================

class _AppointmentsSectionHeader
    extends StatelessWidget {
  const _AppointmentsSectionHeader({
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment:
          MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Appointments",
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kcDarkGreyColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              viewModel.todayFormatted,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kcPrimaryColorDark,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap:
              viewModel.navigateToScheduleView,
          child: Row(
            children: [
              Text(
                'Calendar',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kcPrimaryColorDark,
                ),
              ),
              const Icon(
                Icons.chevron_right,
                color: kcPrimaryColorDark,
                size: 20,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

// ====================================================
// Appointments list
// ====================================================

class _AppointmentsList extends StatelessWidget {
  const _AppointmentsList({
    required this.viewModel,
  });

  final HomeViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.todayAppointments.isEmpty) {
      return const Padding(
        padding: EdgeInsets.only(top: 40),
        child: EmptyState(
          icon: Icons.calendar_today_rounded,
          title: 'No appointments today',
          description:
              'Your schedule is clear for today.',
        ),
      );
    }

    return ListView.separated(
      shrinkWrap: true,
      physics:
          const NeverScrollableScrollPhysics(),
      itemCount:
          viewModel.todayAppointments.length,
      separatorBuilder: (_, __) =>
          const SizedBox(height: 12),
      itemBuilder: (context, index) {
        final appt =
            viewModel.todayAppointments[index];
        return AppointmentCard(
          appointment: appt,
          onTap: () => viewModel
              .navigateToAppointmentDetail(appt),
        );
      },
    );
  }
}

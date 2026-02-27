import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/reports/reports_viewmodel.dart';
import 'package:partner/ui/views/reports/widgets/appointment_stats_section.dart';
import 'package:partner/ui/views/reports/widgets/period_selector.dart';
import 'package:partner/ui/views/reports/widgets/stats_overview_cards.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

/// The reports / analytics dashboard screen.
class ReportsView
    extends StackedView<ReportsViewModel> {
  /// Creates a [ReportsView].
  const ReportsView({super.key});

  @override
  ReportsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReportsViewModel();

  @override
  void onViewModelReady(
    ReportsViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    ReportsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(),
            Expanded(
              child: _buildBody(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    ReportsViewModel viewModel,
  ) {
    if (viewModel.isBusy) {
      return const LoadingShimmer(
        type: ShimmerType.detail,
      );
    }

    if (viewModel.errorMessage != null) {
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
          const SizedBox(height: 8),
          PeriodSelector(
            selected: viewModel.selectedPeriod,
            options:
                ReportsViewModel.periodOptions,
            onChanged: viewModel.setPeriod,
          ),
          const SizedBox(height: 24),
          StatsOverviewCards(
            activePets: viewModel.activePets,
            petOwners: viewModel.petOwners,
            staffCount: viewModel.staffCount,
            appointments:
                viewModel.appointments,
          ),
          const SizedBox(height: 32),
          AppointmentStatsSection(
            total: viewModel.appointments,
            pending:
                viewModel.pendingAppointments,
            completed:
                viewModel.completedAppointments,
          ),
          const SizedBox(height: 40),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: kcDarkGreyColor,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Reports',
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}

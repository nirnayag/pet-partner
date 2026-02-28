import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/prescription_list/prescription_list_viewmodel.dart';
import 'package:partner/ui/views/prescription_list/widgets/prescription_card.dart';
import 'package:partner/ui/views/prescription_list/widgets/prescription_filter_chips.dart';
import 'package:partner/ui/widgets/empty_state.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

/// Paginated list of prescriptions.
class PrescriptionListView
    extends StackedView<
        PrescriptionListViewModel> {
  /// Creates a [PrescriptionListView].
  const PrescriptionListView({
    this.petId,
    super.key,
  });

  /// Optional pet ID to scope the list.
  final String? petId;

  @override
  PrescriptionListViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PrescriptionListViewModel(petId: petId);

  @override
  void onViewModelReady(
    PrescriptionListViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    PrescriptionListViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _ListAppBar(
              onBack: viewModel.goBack,
            ),
            Padding(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 20,
                vertical: 12,
              ),
              child: PrescriptionFilterChips(
                selected: viewModel.filter,
                onSelected: viewModel.setFilter,
              ),
            ),
            Expanded(
              child: _ListBody(
                viewModel: viewModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ListAppBar extends StatelessWidget {
  const _ListAppBar({
    required this.onBack,
  });

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        8,
        16,
        8,
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
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: kcDarkGreyColor,
            ),
          ),
          const SizedBox(width: 16),
          Text(
            'Prescriptions',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _ListBody extends StatelessWidget {
  const _ListBody({
    required this.viewModel,
  });

  final PrescriptionListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isBusy) {
      return const LoadingShimmer();
    }

    if (viewModel.errorMessage != null &&
        viewModel.prescriptions.isEmpty) {
      return ErrorState(
        message: viewModel.errorMessage!,
        onRetry: viewModel.refresh,
      );
    }

    if (viewModel.prescriptions.isEmpty) {
      return const EmptyState(
        icon: Icons.medication_outlined,
        title: 'No prescriptions',
        description:
            'No prescriptions found.',
      );
    }

    return RefreshIndicator(
      color: kcPrimaryColor,
      onRefresh: viewModel.refresh,
      child: ListView.separated(
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
          vertical: 12,
        ),
        itemCount:
            viewModel.prescriptions.length +
                (viewModel.hasMore ? 1 : 0),
        separatorBuilder: (_, __) =>
            const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >=
              viewModel
                  .prescriptions.length) {
            viewModel.loadMore();
            return const Padding(
              padding: EdgeInsets.all(16),
              child: Center(
                child:
                    CircularProgressIndicator(
                  color: kcPrimaryColor,
                ),
              ),
            );
          }
          return PrescriptionCard(
            prescription:
                viewModel.prescriptions[index],
          );
        },
      ),
    );
  }
}

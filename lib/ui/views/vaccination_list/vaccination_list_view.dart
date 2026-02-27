import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/vaccination_list/vaccination_list_viewmodel.dart';
import 'package:partner/ui/views/vaccination_list/widgets/vaccination_card.dart';
import 'package:partner/ui/widgets/empty_state.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

/// Paginated list of vaccinations.
class VaccinationListView
    extends StackedView<
        VaccinationListViewModel> {
  /// Creates a [VaccinationListView].
  const VaccinationListView({
    this.petId,
    super.key,
  });

  /// Optional pet ID to scope the list.
  final String? petId;

  @override
  VaccinationListViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      VaccinationListViewModel(petId: petId);

  @override
  void onViewModelReady(
    VaccinationListViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    VaccinationListViewModel viewModel,
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
            'Vaccinations',
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

  final VaccinationListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    if (viewModel.isBusy) {
      return const LoadingShimmer();
    }

    if (viewModel.errorMessage != null &&
        viewModel.vaccinations.isEmpty) {
      return ErrorState(
        message: viewModel.errorMessage!,
        onRetry: viewModel.refresh,
      );
    }

    if (viewModel.vaccinations.isEmpty) {
      return const EmptyState(
        icon: Icons.vaccines_outlined,
        title: 'No vaccinations',
        description:
            'No vaccination records found.',
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
            viewModel.vaccinations.length +
                (viewModel.hasMore ? 1 : 0),
        separatorBuilder: (_, __) =>
            const SizedBox(height: 12),
        itemBuilder: (context, index) {
          if (index >=
              viewModel
                  .vaccinations.length) {
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
          return VaccinationCard(
            vaccination:
                viewModel.vaccinations[index],
          );
        },
      ),
    );
  }
}

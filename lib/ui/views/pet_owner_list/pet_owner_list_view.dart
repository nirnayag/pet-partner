import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/pet_owner_list/pet_owner_list_viewmodel.dart';
import 'package:partner/ui/views/pet_owner_list/widgets/pet_owner_card.dart';
import 'package:partner/ui/views/pet_owner_list/widgets/pet_owner_search_bar.dart';
import 'package:partner/ui/widgets/empty_state.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

/// Paginated pet-owner list with search.
class PetOwnerListView
    extends StackedView<PetOwnerListViewModel> {
  /// Creates a [PetOwnerListView].
  const PetOwnerListView({super.key});

  @override
  Widget builder(
    BuildContext context,
    PetOwnerListViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.onAddOwnerTapped,
        backgroundColor: kcPrimaryColor,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: kcNeutral900,
          size: 32,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _Header(viewModel: viewModel),
            Expanded(
              child: _Body(
                viewModel: viewModel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  PetOwnerListViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PetOwnerListViewModel();

  @override
  void onViewModelReady(
    PetOwnerListViewModel viewModel,
  ) =>
      viewModel.initialise();
}

// ---------------------------------------------------
// Header
// ---------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.viewModel});

  final PetOwnerListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        10,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Pet Owners',
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
          const SizedBox(height: 16),
          PetOwnerSearchBar(
            onChanged:
                viewModel.onSearchChanged,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------
// Body
// ---------------------------------------------------

class _Body extends StatefulWidget {
  const _Body({required this.viewModel});

  final PetOwnerListViewModel viewModel;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll =
        _scrollController.position.maxScrollExtent;
    final current =
        _scrollController.position.pixels;
    if (current >= maxScroll - 200) {
      widget.viewModel.loadMoreOwners();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    if (vm.isBusy) {
      return const LoadingShimmer();
    }

    if (vm.errorMessage != null) {
      return ErrorState(
        message: vm.errorMessage!,
        onRetry: vm.refresh,
      );
    }

    if (vm.owners.isEmpty) {
      return EmptyState(
        icon: Icons.people_outline_rounded,
        title: 'No pet owners found',
        description:
            'Registered pet owners will '
            'appear here.',
        actionLabel: 'Add Pet Owner',
        onAction: vm.onAddOwnerTapped,
      );
    }

    return RefreshIndicator(
      color: kcPrimaryColor,
      onRefresh: vm.refresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        itemCount: vm.owners.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 16,
              ),
              child: Text(
                'Showing ${vm.totalCount}'
                ' owners',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kcPrimaryColor,
                ),
              ),
            );
          }

          final ownerIndex = index - 1;

          if (ownerIndex == vm.owners.length) {
            if (vm.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child:
                      CircularProgressIndicator(
                    color: kcPrimaryColor,
                    strokeWidth: 2,
                  ),
                ),
              );
            }
            return const SizedBox(height: 100);
          }

          final owner = vm.owners[ownerIndex];
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            child: PetOwnerCard(
              owner: owner,
              onTap: () =>
                  vm.onOwnerTapped(owner),
            ),
          );
        },
      ),
    );
  }
}

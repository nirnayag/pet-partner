import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/patient_registry/patient_registry_viewmodel.dart';
import 'package:partner/ui/widgets/empty_state.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:partner/ui/widgets/pet_card.dart';
import 'package:stacked/stacked.dart';

/// The patient registry screen, listing all pets
/// from the API with search, filter, and pagination.
class PatientRegistryView
    extends StackedView<PatientRegistryViewModel> {
  /// Creates a [PatientRegistryView].
  const PatientRegistryView({super.key});

  @override
  Widget builder(
    BuildContext context,
    PatientRegistryViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      floatingActionButton: viewModel.canCreatePet
          ? FloatingActionButton(
              onPressed: () {
                // TODO(pets): navigate to add pet
              },
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
            _Header(viewModel: viewModel),
            Expanded(child: _Body(viewModel: viewModel)),
          ],
        ),
      ),
    );
  }

  @override
  PatientRegistryViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PatientRegistryViewModel();

  @override
  void onViewModelReady(
    PatientRegistryViewModel viewModel,
  ) =>
      viewModel.initialise();
}

// ----------------------------------------------------
// Header with search + filter chips
// ----------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.viewModel});

  final PatientRegistryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Patient Registry',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: kcDarkGreyColor,
                ),
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(
                            alpha: 0.05,
                          ),
                          blurRadius: 10,
                          offset:
                              const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons
                          .notifications_none_rounded,
                      color: kcDarkGreyColor,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          _SearchField(viewModel: viewModel),
          const SizedBox(height: 16),
          _FilterChips(viewModel: viewModel),
        ],
      ),
    );
  }
}

// ----------------------------------------------------
// Search field
// ----------------------------------------------------

class _SearchField extends StatelessWidget {
  const _SearchField({required this.viewModel});

  final PatientRegistryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          child: Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
            ),
            height: 52,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(
                    alpha: 0.03,
                  ),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: Row(
              children: [
                const Icon(
                  Icons.search_rounded,
                  color: kcLightGrey,
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: TextField(
                    onChanged:
                        viewModel.onSearchChanged,
                    decoration: InputDecoration(
                      hintText:
                          'Search name, owner...',
                      hintStyle:
                          GoogleFonts.manrope(
                        color: kcLightGrey,
                        fontSize: 14,
                        fontWeight: FontWeight.w500,
                      ),
                      border: InputBorder.none,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
        const SizedBox(width: 12),
        Container(
          height: 52,
          width: 52,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(
                  alpha: 0.03,
                ),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: const Icon(
            Icons.tune_rounded,
            color: kcMediumGrey,
          ),
        ),
      ],
    );
  }
}

// ----------------------------------------------------
// Filter chips
// ----------------------------------------------------

class _FilterChips extends StatelessWidget {
  const _FilterChips({required this.viewModel});

  final PatientRegistryViewModel viewModel;

  static const _filters = [
    'All',
    'Dogs',
    'Cats',
    'Birds',
    'Small Pets',
  ];

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: _filters
            .map(
              (f) => _FilterChip(
                label: f,
                isActive:
                    viewModel.activeFilter == f,
                onTap: () =>
                    viewModel.onFilterChanged(f),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? kcNeutral900
              : Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          boxShadow: isActive
              ? null
              : [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: 0.03,
                    ),
                    blurRadius: 5,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isActive
                  ? Colors.white
                  : kcMediumGrey,
            ),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// Body: loading / error / empty / list
// ----------------------------------------------------

class _Body extends StatefulWidget {
  const _Body({required this.viewModel});

  final PatientRegistryViewModel viewModel;

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
    final current = _scrollController.position.pixels;
    if (current >= maxScroll - 200) {
      widget.viewModel.loadMorePets();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    // Loading state
    if (vm.isBusy) {
      return const LoadingShimmer();
    }

    // Error state
    if (vm.errorMessage != null) {
      return ErrorState(
        message: vm.errorMessage!,
        onRetry: vm.refresh,
      );
    }

    // Empty state
    if (vm.pets.isEmpty) {
      return EmptyState(
        icon: Icons.pets_rounded,
        title: 'No patients found',
        description:
            'Registered pets will appear here.',
        actionLabel:
            vm.canCreatePet ? 'Add Pet' : null,
        onAction: vm.canCreatePet
            ? () {
                // TODO(pets): navigate to add pet
              }
            : null,
      );
    }

    // List
    return RefreshIndicator(
      color: kcPrimaryColor,
      onRefresh: vm.refresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        itemCount: vm.pets.length + 1,
        itemBuilder: (context, index) {
          // Record count header
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 16,
              ),
              child: Text(
                'Showing ${vm.totalCount}'
                ' patients',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kcPrimaryColor,
                ),
              ),
            );
          }

          final petIndex = index - 1;

          // Loading more indicator
          if (petIndex == vm.pets.length) {
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

          final pet = vm.pets[petIndex];
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            child: PetCard(
              pet: pet,
              onTap: () => vm.onPetTapped(pet),
            ),
          );
        },
      ),
    );
  }
}

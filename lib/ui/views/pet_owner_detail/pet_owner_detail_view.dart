import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/pet_owner_detail/pet_owner_detail_viewmodel.dart';
import 'package:partner/ui/views/pet_owner_detail/widgets/owner_info_header.dart';
import 'package:partner/ui/views/pet_owner_detail/widgets/owner_pet_card.dart';
import 'package:partner/ui/views/pet_owner_detail/widgets/owner_quick_actions.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

/// Detail screen for a single pet owner.
class PetOwnerDetailView
    extends StackedView<PetOwnerDetailViewModel> {
  /// Creates a [PetOwnerDetailView].
  const PetOwnerDetailView({
    required this.ownerId,
    super.key,
  });

  /// The pet owner to display.
  final String ownerId;

  @override
  PetOwnerDetailViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PetOwnerDetailViewModel(ownerId: ownerId);

  @override
  void onViewModelReady(
    PetOwnerDetailViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    PetOwnerDetailViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(
              onBack: viewModel.onBackTapped,
              onEdit: viewModel.onEditTapped,
            ),
            Expanded(
              child: _Body(viewModel: viewModel),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------
// AppBar
// ---------------------------------------------------

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.onBack,
    required this.onEdit,
  });

  final VoidCallback onBack;
  final VoidCallback onEdit;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        12,
        16,
        12,
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
            'Pet Owner',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
          GestureDetector(
            onTap: onEdit,
            child: const Icon(
              Icons.edit_rounded,
              color: kcDarkGreyColor,
              size: 22,
            ),
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------
// Body
// ---------------------------------------------------

class _Body extends StatelessWidget {
  const _Body({required this.viewModel});

  final PetOwnerDetailViewModel viewModel;

  @override
  Widget build(BuildContext context) {
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

    final owner = viewModel.owner;
    if (owner == null) {
      return const Center(
        child: Text('Owner not found'),
      );
    }

    return RefreshIndicator(
      color: kcPrimaryColor,
      onRefresh: viewModel.refresh,
      child: SingleChildScrollView(
        physics:
            const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(20),
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            OwnerInfoHeader(owner: owner),
            const SizedBox(height: 24),
            OwnerQuickActions(
              phone: owner.phone,
              email: owner.email,
              onBookAppointment:
                  viewModel.onBookAppointment,
            ),
            const SizedBox(height: 28),
            _PetsSection(
              pets: viewModel.pets,
              onPetTapped: viewModel.onPetTapped,
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------
// Pets section
// ---------------------------------------------------

class _PetsSection extends StatelessWidget {
  const _PetsSection({
    required this.pets,
    required this.onPetTapped,
  });

  final List<Pet> pets;
  final void Function(Pet pet) onPetTapped;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Pets',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 12),
        if (pets.isEmpty)
          Text(
            'No pets registered yet.',
            style: GoogleFonts.manrope(
              fontSize: 14,
              color: kcMediumGrey,
            ),
          )
        else
          ...pets.map(
            (pet) => Padding(
              padding: const EdgeInsets.only(
                bottom: 10,
              ),
              child: OwnerPetCard(
                pet: pet,
                onTap: () => onPetTapped(pet),
              ),
            ),
          ),
      ],
    );
  }
}

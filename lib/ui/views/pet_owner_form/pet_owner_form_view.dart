import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/models/pet_owner.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/pet_owner_form/pet_owner_form_viewmodel.dart';
import 'package:partner/ui/views/pet_owner_form/widgets/pet_owner_form_fields.dart';
import 'package:stacked/stacked.dart';

/// Create / edit form for a pet owner.
class PetOwnerFormView
    extends StackedView<PetOwnerFormViewModel> {
  /// Creates a [PetOwnerFormView].
  const PetOwnerFormView({
    this.owner,
    super.key,
  });

  /// The owner to edit, or `null` for create.
  final PetOwner? owner;

  @override
  PetOwnerFormViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PetOwnerFormViewModel(owner: owner);

  @override
  void onViewModelReady(
    PetOwnerFormViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    PetOwnerFormViewModel viewModel,
    Widget? child,
  ) {
    final lookupHint = viewModel.lookupResult !=
            null
        ? 'Owner found: '
            '${viewModel.lookupResult!.fullName}'
        : null;

    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Column(
        children: [
          _AppBar(
            isEditMode: viewModel.isEditMode,
            onBack: viewModel.onBackTapped,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                120,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (viewModel.errorMessage !=
                      null)
                    _ErrorBanner(
                      message: viewModel
                          .errorMessage!,
                    ),
                  PetOwnerFormFields(
                    firstNameController: viewModel
                        .firstNameController,
                    lastNameController: viewModel
                        .lastNameController,
                    phoneController:
                        viewModel.phoneController,
                    emailController:
                        viewModel.emailController,
                    onPhoneLookup:
                        viewModel.lookupByPhone,
                    isLookingUp:
                        viewModel.isLookingUp,
                    lookupHint: lookupHint,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _SaveButton(
        isBusy: viewModel.isBusy,
        isEditMode: viewModel.isEditMode,
        onTap: viewModel.save,
      ),
    );
  }
}

// ---------------------------------------------------
// Private widgets
// ---------------------------------------------------

class _AppBar extends StatelessWidget {
  const _AppBar({
    required this.isEditMode,
    required this.onBack,
  });

  final bool isEditMode;
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
            isEditMode
                ? 'Edit Pet Owner'
                : 'Add Pet Owner',
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

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        message,
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.red[700],
        ),
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.isBusy,
    required this.isEditMode,
    required this.onTap,
  });

  final bool isBusy;
  final bool isEditMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        40,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: isBusy ? null : onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isBusy
                ? kcLightGrey
                : kcPrimaryColor,
            borderRadius:
                BorderRadius.circular(18),
            boxShadow: isBusy
                ? null
                : [
                    BoxShadow(
                      color: kcPrimaryColor
                          .withValues(
                        alpha: 0.3,
                      ),
                      blurRadius: 12,
                    ),
                  ],
          ),
          child: Center(
            child: isBusy
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    isEditMode
                        ? 'Update Owner'
                        : 'Save Owner',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: kcNeutral900,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

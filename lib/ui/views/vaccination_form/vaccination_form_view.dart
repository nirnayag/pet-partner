import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/models/medical/vaccination.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/vaccination_form/vaccination_form_viewmodel.dart';
import 'package:partner/ui/views/vaccination_form/widgets/vaccination_form_fields.dart';
import 'package:stacked/stacked.dart';

/// Form view for creating or editing a
/// vaccination record.
class VaccinationFormView
    extends StackedView<
        VaccinationFormViewModel> {
  /// Creates a [VaccinationFormView].
  const VaccinationFormView({
    this.vaccination,
    this.petId,
    super.key,
  });

  /// The vaccination to edit, or `null`.
  final Vaccination? vaccination;

  /// Pre-selected pet ID.
  final String? petId;

  @override
  VaccinationFormViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      VaccinationFormViewModel(
        vaccination: vaccination,
        petId: petId,
      );

  @override
  void onViewModelReady(
    VaccinationFormViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    VaccinationFormViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Column(
        children: [
          _FormAppBar(
            isEditMode: viewModel.isEditMode,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.fromLTRB(
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
                  VaccinationFormFields(
                    viewModel: viewModel,
                    onPickDate: () =>
                        _pickDate(
                      context,
                      viewModel,
                      isDue: false,
                    ),
                    onPickDueDate: () =>
                        _pickDate(
                      context,
                      viewModel,
                      isDue: true,
                    ),
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
        onTap: viewModel.saveVaccination,
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    VaccinationFormViewModel viewModel, {
    required bool isDue,
  }) async {
    final now = DateTime.now();
    final initial = isDue
        ? (viewModel.nextDueDate ?? now)
        : viewModel.dateAdministered;
    final picked = await showDatePicker(
      context: context,
      initialDate: initial,
      firstDate: DateTime(2000),
      lastDate: DateTime(2030),
    );
    if (picked != null) {
      if (isDue) {
        viewModel.setNextDueDate(picked);
      } else {
        viewModel.setDateAdministered(picked);
      }
    }
  }
}

class _FormAppBar extends StatelessWidget {
  const _FormAppBar({
    required this.isEditMode,
  });

  final bool isEditMode;

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
            onTap: () =>
                Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: kcDarkGreyColor,
            ),
          ),
          Text(
            isEditMode
                ? 'Edit Vaccination'
                : 'New Vaccination',
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
  const _ErrorBanner({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin:
          const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red
            .withValues(alpha: 0.1),
        borderRadius:
            BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red
              .withValues(alpha: 0.3),
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
            color: Colors.black
                .withValues(alpha: 0.05),
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
                        ? 'Update'
                        : 'Save',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w900,
                      color: kcNeutral900,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/models/medical/medical_record.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/medical_record_form/medical_record_form_viewmodel.dart';
import 'package:partner/ui/views/medical_record_form/widgets/medical_record_form_fields.dart';
import 'package:partner/ui/views/medical_record_form/widgets/pet_info_header.dart';
import 'package:stacked/stacked.dart';

/// Form view for creating or editing a
/// medical record.
class MedicalRecordFormView
    extends StackedView<
        MedicalRecordFormViewModel> {
  /// Creates a [MedicalRecordFormView].
  const MedicalRecordFormView({
    this.record,
    this.petId,
    this.appointmentId,
    super.key,
  });

  /// The record to edit, or `null` for create.
  final MedicalRecord? record;

  /// Pre-selected pet ID.
  final String? petId;

  /// Pre-selected appointment ID.
  final String? appointmentId;

  @override
  MedicalRecordFormViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MedicalRecordFormViewModel(
        record: record,
        petId: petId,
        appointmentId: appointmentId,
      );

  @override
  void onViewModelReady(
    MedicalRecordFormViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    MedicalRecordFormViewModel viewModel,
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
                  if (viewModel.pet != null) ...[
                    PetInfoHeader(
                      pet: viewModel.pet!,
                    ),
                    const SizedBox(height: 20),
                  ],
                  MedicalRecordFormFields(
                    viewModel: viewModel,
                    onPickDate: () =>
                        _pickDate(
                      context,
                      viewModel,
                    ),
                  ),
                  if (viewModel
                      .isEditMode) ...[
                    const SizedBox(height: 24),
                    _DeleteButton(
                      onTap:
                          viewModel.deleteRecord,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _SaveButton(
        isBusy: viewModel.isBusy,
        isEditMode: viewModel.isEditMode,
        onTap: viewModel.saveRecord,
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    MedicalRecordFormViewModel viewModel,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate: viewModel.visitDate,
      firstDate: DateTime(2000),
      lastDate: now,
    );
    if (picked != null) {
      viewModel.setVisitDate(picked);
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
                ? 'Edit Record'
                : 'New Record',
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

class _DeleteButton extends StatelessWidget {
  const _DeleteButton({
    required this.onTap,
  });

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      child: OutlinedButton.icon(
        onPressed: onTap,
        icon: const Icon(
          Icons.delete_outline_rounded,
          size: 18,
        ),
        label: Text(
          'Delete Record',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w700,
          ),
        ),
        style: OutlinedButton.styleFrom(
          foregroundColor: Colors.red,
          side: const BorderSide(
            color: Colors.red,
          ),
          padding:
              const EdgeInsets.symmetric(
            vertical: 14,
          ),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(16),
          ),
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
                        ? 'Update Record'
                        : 'Save Record',
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

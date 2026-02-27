import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/pet_form/pet_form_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// Form view for creating or editing a pet.
class PetFormView
    extends StackedView<PetFormViewmodel> {
  /// Creates a [PetFormView].
  const PetFormView({
    this.pet,
    this.ownerId,
    super.key,
  });

  /// The pet to edit, or `null` for create mode.
  final Pet? pet;

  /// The owner ID to associate with the new pet.
  final String? ownerId;

  @override
  PetFormViewmodel viewModelBuilder(
    BuildContext context,
  ) =>
      PetFormViewmodel(
        pet: pet,
        ownerId: ownerId,
      );

  @override
  void onViewModelReady(
    PetFormViewmodel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    PetFormViewmodel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Column(
        children: [
          _AppBar(
            isEditMode: viewModel.isEditMode,
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
                      message:
                          viewModel.errorMessage!,
                    ),
                  const _SectionLabel(label: 'NAME *'),
                  const SizedBox(height: 8),
                  _TextField(
                    controller:
                        viewModel.nameController,
                    hint: 'Enter pet name',
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel(label: 'SPECIES *'),
                  const SizedBox(height: 8),
                  _DropdownField<String>(
                    value:
                        viewModel.selectedSpecies,
                    items:
                        PetFormViewmodel
                            .speciesOptions,
                    onChanged:
                        viewModel.setSpecies,
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel(label: 'BREED'),
                  const SizedBox(height: 8),
                  _TextField(
                    controller:
                        viewModel.breedController,
                    hint: 'e.g. Golden Retriever',
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel(label: 'GENDER'),
                  const SizedBox(height: 8),
                  _DropdownField<String>(
                    value:
                        viewModel.selectedGender,
                    items:
                        PetFormViewmodel
                            .genderOptions,
                    onChanged:
                        viewModel.setGender,
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel(label: 'COLOUR'),
                  const SizedBox(height: 8),
                  _TextField(
                    controller:
                        viewModel.colorController,
                    hint: 'e.g. Brown, White',
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel(
                    label: 'DATE OF BIRTH',
                  ),
                  const SizedBox(height: 8),
                  _DatePickerField(
                    date: viewModel.dateOfBirth,
                    onTap: () =>
                        _pickDate(context, viewModel),
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel(label: 'WEIGHT'),
                  const SizedBox(height: 8),
                  _WeightRow(viewModel: viewModel),
                  const SizedBox(height: 20),
                  const _SectionLabel(label: 'ALLERGIES'),
                  const SizedBox(height: 8),
                  _TextField(
                    controller: viewModel
                        .allergiesController,
                    hint:
                        'Comma-separated list',
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel(
                    label: 'CHRONIC CONDITIONS',
                  ),
                  const SizedBox(height: 8),
                  _TextField(
                    controller: viewModel
                        .chronicConditionsController,
                    hint:
                        'Comma-separated list',
                  ),
                  const SizedBox(height: 20),
                  const _SectionLabel(label: 'NOTES'),
                  const SizedBox(height: 8),
                  _TextField(
                    controller:
                        viewModel.notesController,
                    hint:
                        'Additional notes...',
                    maxLines: 4,
                  ),
                  if (viewModel.isEditMode) ...[
                    const SizedBox(height: 24),
                    _EditModeActions(
                      viewModel: viewModel,
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
        onTap: viewModel.savePet,
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    PetFormViewmodel viewModel,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          viewModel.dateOfBirth ?? now,
      firstDate: DateTime(1990),
      lastDate: now,
    );
    if (picked != null) {
      viewModel.setDateOfBirth(picked);
    }
  }
}

// ---- Private Widgets ----

class _AppBar extends StatelessWidget {
  const _AppBar({required this.isEditMode});

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
            isEditMode ? 'Edit Pet' : 'Add Pet',
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

class _SectionLabel extends StatelessWidget {
  const _SectionLabel({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: kcLightGrey,
        letterSpacing: 1,
      ),
    );
  }
}

class _TextField extends StatelessWidget {
  const _TextField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        keyboardType: keyboardType,
        style: GoogleFonts.manrope(
          fontSize: 14,
          color: kcDarkGreyColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.manrope(
            color: kcLightGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _DropdownField<T> extends StatelessWidget {
  const _DropdownField({
    required this.value,
    required this.items,
    required this.onChanged,
    super.key,
  });

  final T value;
  final List<T> items;
  final ValueChanged<T> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<T>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: kcMediumGrey,
          ),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: kcDarkGreyColor,
          ),
          items: items
              .map(
                (e) => DropdownMenuItem<T>(
                  value: e,
                  child: Text(e.toString()),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }
}

class _DatePickerField extends StatelessWidget {
  const _DatePickerField({
    required this.date,
    required this.onTap,
  });

  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = date != null
        ? DateFormat('dd MMM yyyy').format(date!)
        : 'Select date';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: date != null
                    ? kcDarkGreyColor
                    : kcLightGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
            const Icon(
              Icons.calendar_today_rounded,
              size: 18,
              color: kcMediumGrey,
            ),
          ],
        ),
      ),
    );
  }
}

class _WeightRow extends StatelessWidget {
  const _WeightRow({required this.viewModel});

  final PetFormViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _TextField(
            controller:
                viewModel.weightController,
            hint: '0.0',
            keyboardType:
                const TextInputType.numberWithOptions(
              decimal: true,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _DropdownField<String>(
            value: viewModel.weightUnit,
            items:
                PetFormViewmodel.weightUnitOptions,
            onChanged:
                viewModel.setWeightUnit,
          ),
        ),
      ],
    );
  }
}

class _EditModeActions extends StatelessWidget {
  const _EditModeActions({
    required this.viewModel,
  });

  final PetFormViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const Divider(color: kcVeryLightGrey),
        const SizedBox(height: 8),
        if (!viewModel.isDeceased)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed:
                  viewModel.markAsDeceased,
              icon: const Icon(
                Icons.warning_amber_rounded,
                size: 18,
              ),
              label: Text(
                'Mark as Deceased',
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
          ),
        const SizedBox(height: 12),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Active',
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: kcDarkGreyColor,
              ),
            ),
            Switch(
              value: viewModel.isActive,
              onChanged: (_) =>
                  viewModel.toggleActive(),
              activeThumbColor: kcPrimaryColor,
            ),
          ],
        ),
      ],
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
        color: Colors.red.withValues(alpha: 0.1),
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
                        ? 'Update Pet'
                        : 'Save Pet',
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

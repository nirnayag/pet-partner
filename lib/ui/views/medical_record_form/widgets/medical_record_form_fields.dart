import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/medical_record_form/medical_record_form_viewmodel.dart';

/// Form fields for the medical record form.
class MedicalRecordFormFields
    extends StatelessWidget {
  /// Creates [MedicalRecordFormFields].
  const MedicalRecordFormFields({
    required this.viewModel,
    required this.onPickDate,
    super.key,
  });

  /// The viewmodel to read state from.
  final MedicalRecordFormViewModel viewModel;

  /// Callback when the date picker is tapped.
  final VoidCallback onPickDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _label('VISIT DATE *'),
        const SizedBox(height: 8),
        _DateField(
          date: viewModel.visitDate,
          onTap: onPickDate,
        ),
        const SizedBox(height: 20),
        _label('VISIT REASON *'),
        const SizedBox(height: 8),
        _InputField(
          controller:
              viewModel.visitReasonController,
          hint: 'e.g. Annual checkup',
        ),
        const SizedBox(height: 20),
        _label('DIAGNOSIS'),
        const SizedBox(height: 8),
        _InputField(
          controller:
              viewModel.diagnosisController,
          hint: 'Enter diagnosis',
          maxLines: 3,
        ),
        const SizedBox(height: 20),
        _label('TREATMENT'),
        const SizedBox(height: 8),
        _InputField(
          controller:
              viewModel.treatmentController,
          hint: 'Enter treatment',
          maxLines: 3,
        ),
        const SizedBox(height: 20),
        _label('NOTES'),
        const SizedBox(height: 8),
        _InputField(
          controller:
              viewModel.notesController,
          hint: 'Additional notes...',
          maxLines: 4,
        ),
        const SizedBox(height: 20),
        _label('WEIGHT'),
        const SizedBox(height: 8),
        _WeightRow(viewModel: viewModel),
        const SizedBox(height: 20),
        _label('TEMPERATURE'),
        const SizedBox(height: 8),
        _TemperatureRow(viewModel: viewModel),
      ],
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: kcLightGrey,
        letterSpacing: 1,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
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
        borderRadius:
            BorderRadius.circular(16),
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

class _DateField extends StatelessWidget {
  const _DateField({
    required this.date,
    required this.onTap,
  });

  final DateTime date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
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
              DateFormat('dd MMM yyyy')
                  .format(date),
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: kcDarkGreyColor,
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
  const _WeightRow({
    required this.viewModel,
  });

  final MedicalRecordFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _InputField(
            controller:
                viewModel.weightController,
            hint: '0.0',
            keyboardType: const TextInputType
                .numberWithOptions(
              decimal: true,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _UnitDropdown(
            value: viewModel.weightUnit,
            items: MedicalRecordFormViewModel
                .weightUnitOptions,
            onChanged:
                viewModel.setWeightUnit,
          ),
        ),
      ],
    );
  }
}

class _TemperatureRow extends StatelessWidget {
  const _TemperatureRow({
    required this.viewModel,
  });

  final MedicalRecordFormViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Expanded(
          flex: 2,
          child: _InputField(
            controller:
                viewModel.temperatureController,
            hint: '0.0',
            keyboardType: const TextInputType
                .numberWithOptions(
              decimal: true,
            ),
          ),
        ),
        const SizedBox(width: 12),
        Expanded(
          child: _UnitDropdown(
            value: viewModel.temperatureUnit,
            items: MedicalRecordFormViewModel
                .temperatureUnitOptions,
            onChanged:
                viewModel.setTemperatureUnit,
          ),
        ),
      ],
    );
  }
}

class _UnitDropdown extends StatelessWidget {
  const _UnitDropdown({
    required this.value,
    required this.items,
    required this.onChanged,
  });

  final String value;
  final List<String> items;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius:
            BorderRadius.circular(16),
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
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons
                .keyboard_arrow_down_rounded,
            color: kcMediumGrey,
          ),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: kcDarkGreyColor,
          ),
          items: items
              .map(
                (e) =>
                    DropdownMenuItem<String>(
                  value: e,
                  child: Text(e),
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

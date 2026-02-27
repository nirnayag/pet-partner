import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/prescription_form/prescription_form_viewmodel.dart';

/// Form fields for the prescription form.
class PrescriptionFormFields
    extends StatelessWidget {
  /// Creates [PrescriptionFormFields].
  const PrescriptionFormFields({
    required this.viewModel,
    required this.onPickStartDate,
    required this.onPickEndDate,
    super.key,
  });

  /// The viewmodel to read state from.
  final PrescriptionFormViewModel viewModel;

  /// Callback when start date is tapped.
  final VoidCallback onPickStartDate;

  /// Callback when end date is tapped.
  final VoidCallback onPickEndDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _label('MEDICATION NAME *'),
        const SizedBox(height: 8),
        _InputField(
          controller: viewModel
              .medicationNameController,
          hint: 'e.g. Amoxicillin',
        ),
        const SizedBox(height: 20),
        _label('DOSAGE *'),
        const SizedBox(height: 8),
        _InputField(
          controller:
              viewModel.dosageController,
          hint: 'e.g. 10 mg',
        ),
        const SizedBox(height: 20),
        _label('FREQUENCY *'),
        const SizedBox(height: 8),
        _InputField(
          controller:
              viewModel.frequencyController,
          hint: 'e.g. Twice daily',
        ),
        const SizedBox(height: 20),
        _label('DURATION'),
        const SizedBox(height: 8),
        _InputField(
          controller:
              viewModel.durationController,
          hint: 'e.g. 7 days',
        ),
        const SizedBox(height: 20),
        _label('INSTRUCTIONS'),
        const SizedBox(height: 8),
        _InputField(
          controller:
              viewModel.instructionsController,
          hint: 'Additional instructions...',
          maxLines: 3,
        ),
        const SizedBox(height: 20),
        _label('START DATE *'),
        const SizedBox(height: 8),
        _DateField(
          date: viewModel.startDate,
          onTap: onPickStartDate,
        ),
        const SizedBox(height: 20),
        _label('END DATE'),
        const SizedBox(height: 8),
        _DateField(
          date: viewModel.endDate,
          onTap: onPickEndDate,
          placeholder: 'Select end date',
        ),
        const SizedBox(height: 20),
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
              activeColor: kcPrimaryColor,
            ),
          ],
        ),
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
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

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
    required this.onTap,
    this.date,
    this.placeholder,
  });

  final DateTime? date;
  final VoidCallback onTap;
  final String? placeholder;

  @override
  Widget build(BuildContext context) {
    final label = date != null
        ? DateFormat('dd MMM yyyy')
            .format(date!)
        : (placeholder ?? 'Select date');

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

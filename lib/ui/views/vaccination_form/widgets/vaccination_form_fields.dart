import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/vaccination_form/vaccination_form_viewmodel.dart';

/// Form fields for the vaccination form.
class VaccinationFormFields
    extends StatelessWidget {
  /// Creates [VaccinationFormFields].
  const VaccinationFormFields({
    required this.viewModel,
    required this.onPickDate,
    required this.onPickDueDate,
    super.key,
  });

  /// The viewmodel to read state from.
  final VaccinationFormViewModel viewModel;

  /// Callback when date administered is tapped.
  final VoidCallback onPickDate;

  /// Callback when next due date is tapped.
  final VoidCallback onPickDueDate;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _label('VACCINE NAME *'),
        const SizedBox(height: 8),
        _InputField(
          controller:
              viewModel.vaccineNameController,
          hint: 'e.g. Rabies',
        ),
        const SizedBox(height: 20),
        _label('DATE ADMINISTERED *'),
        const SizedBox(height: 8),
        _DateField(
          date: viewModel.dateAdministered,
          onTap: onPickDate,
        ),
        const SizedBox(height: 20),
        _label('NEXT DUE DATE'),
        const SizedBox(height: 8),
        _DateField(
          date: viewModel.nextDueDate,
          onTap: onPickDueDate,
          placeholder:
              'Select next due date',
        ),
        const SizedBox(height: 20),
        _label('BATCH NUMBER'),
        const SizedBox(height: 8),
        _InputField(
          controller:
              viewModel.batchNumberController,
          hint: 'e.g. LOT-12345',
        ),
        const SizedBox(height: 20),
        _label('MANUFACTURER'),
        const SizedBox(height: 8),
        _InputField(
          controller:
              viewModel.manufacturerController,
          hint: 'e.g. Zoetis',
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

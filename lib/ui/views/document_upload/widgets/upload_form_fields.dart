import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/enums/document_type.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Form fields for the document upload screen.
class UploadFormFields extends StatelessWidget {
  /// Creates [UploadFormFields].
  const UploadFormFields({
    required this.titleController,
    required this.descriptionController,
    required this.petIdController,
    required this.selectedType,
    required this.onTypeChanged,
    required this.showPetIdField,
    super.key,
  });

  /// Controller for the title field.
  final TextEditingController titleController;

  /// Controller for the description field.
  final TextEditingController
      descriptionController;

  /// Controller for the pet ID field.
  final TextEditingController petIdController;

  /// The currently selected document type.
  final DocumentType selectedType;

  /// Called when the type changes.
  final ValueChanged<DocumentType> onTypeChanged;

  /// Whether to show the pet ID field.
  final bool showPetIdField;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _Label(label: 'TITLE *'),
        const SizedBox(height: 8),
        _Field(
          controller: titleController,
          hint: 'Enter document title',
        ),
        const SizedBox(height: 20),
        _Label(label: 'DOCUMENT TYPE'),
        const SizedBox(height: 8),
        _TypeDropdown(
          value: selectedType,
          onChanged: onTypeChanged,
        ),
        if (showPetIdField) ...[
          const SizedBox(height: 20),
          _Label(label: 'PET ID *'),
          const SizedBox(height: 8),
          _Field(
            controller: petIdController,
            hint: 'Enter pet ID',
          ),
        ],
        const SizedBox(height: 20),
        _Label(label: 'DESCRIPTION'),
        const SizedBox(height: 8),
        _Field(
          controller: descriptionController,
          hint: 'Optional description...',
          maxLines: 3,
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label});

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

class _Field extends StatelessWidget {
  const _Field({
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
        borderRadius: BorderRadius.circular(16),
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

class _TypeDropdown extends StatelessWidget {
  const _TypeDropdown({
    required this.value,
    required this.onChanged,
  });

  final DocumentType value;
  final ValueChanged<DocumentType> onChanged;

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
            color: Colors.black.withValues(
              alpha: 0.03,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<DocumentType>(
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
          items: DocumentType.values
              .map(
                (t) =>
                    DropdownMenuItem<DocumentType>(
                  value: t,
                  child: Text(t.displayName),
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

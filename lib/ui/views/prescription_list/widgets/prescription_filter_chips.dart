import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/prescription_list/prescription_list_viewmodel.dart';

/// Row of filter chips for the prescription
/// list.
class PrescriptionFilterChips
    extends StatelessWidget {
  /// Creates [PrescriptionFilterChips].
  const PrescriptionFilterChips({
    required this.selected,
    required this.onSelected,
    super.key,
  });

  /// The currently selected filter.
  final PrescriptionFilter selected;

  /// Callback when a filter is selected.
  final ValueChanged<PrescriptionFilter>
      onSelected;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: PrescriptionFilter.values
          .map(
            (f) => Padding(
              padding: const EdgeInsets.only(
                right: 8,
              ),
              child: _Chip(
                label: _label(f),
                isSelected: f == selected,
                onTap: () => onSelected(f),
              ),
            ),
          )
          .toList(),
    );
  }

  String _label(PrescriptionFilter f) {
    switch (f) {
      case PrescriptionFilter.all:
        return 'All';
      case PrescriptionFilter.active:
        return 'Active';
      case PrescriptionFilter.inactive:
        return 'Inactive';
    }
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isSelected,
    required this.onTap,
  });

  final String label;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isSelected
              ? kcPrimaryColor.withValues(
                  alpha: 0.15,
                )
              : Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: isSelected
                ? kcPrimaryColor
                : kcVeryLightGrey,
          ),
        ),
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 13,
            fontWeight: FontWeight.w700,
            color: isSelected
                ? kcPrimaryColorDark
                : kcMediumGrey,
          ),
        ),
      ),
    );
  }
}

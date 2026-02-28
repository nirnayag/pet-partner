import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Horizontal list of document-type filter chips.
class DocumentFilterChips extends StatelessWidget {
  /// Creates [DocumentFilterChips].
  const DocumentFilterChips({
    required this.labels,
    required this.activeLabel,
    required this.onSelected,
    super.key,
  });

  /// All available filter labels.
  final List<String> labels;

  /// The currently active label.
  final String activeLabel;

  /// Called when a chip is tapped.
  final ValueChanged<String> onSelected;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 36,
      child: ListView(
        scrollDirection: Axis.horizontal,
        children: labels
            .map(
              (label) => _Chip(
                label: label,
                isActive: activeLabel == label,
                onTap: () => onSelected(label),
              ),
            )
            .toList(),
      ),
    );
  }
}

class _Chip extends StatelessWidget {
  const _Chip({
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(right: 8),
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: isActive
              ? kcNeutral900
              : Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          boxShadow: isActive
              ? null
              : [
                  BoxShadow(
                    color:
                        Colors.black.withValues(
                      alpha: 0.03,
                    ),
                    blurRadius: 5,
                  ),
                ],
        ),
        child: Center(
          child: Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w700,
              color: isActive
                  ? Colors.white
                  : kcMediumGrey,
            ),
          ),
        ),
      ),
    );
  }
}

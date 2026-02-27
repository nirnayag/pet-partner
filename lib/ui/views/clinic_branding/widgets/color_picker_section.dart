import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Section for selecting the clinic's primary
/// brand colour.
class ColorPickerSection extends StatelessWidget {
  /// Creates a [ColorPickerSection].
  const ColorPickerSection({
    required this.selectedColor,
    required this.onColorSelected,
    super.key,
  });

  /// The currently selected hex colour.
  final String selectedColor;

  /// Callback when a colour is selected.
  final ValueChanged<String> onColorSelected;

  static const _presetColors = <String>[
    '#13EC13',
    '#2196F3',
    '#FF5722',
    '#9C27B0',
    '#FF9800',
    '#009688',
    '#E91E63',
    '#795548',
    '#607D8B',
    '#3F51B5',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Primary Color',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 16),
        Wrap(
          spacing: 12,
          runSpacing: 12,
          children: _presetColors
              .map(
                (hex) => _ColorCircle(
                  hex: hex,
                  isSelected:
                      selectedColor == hex,
                  onTap: () =>
                      onColorSelected(hex),
                ),
              )
              .toList(),
        ),
        const SizedBox(height: 12),
        Text(
          'Selected: $selectedColor',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kcMediumGrey,
          ),
        ),
      ],
    );
  }
}

class _ColorCircle extends StatelessWidget {
  const _ColorCircle({
    required this.hex,
    required this.isSelected,
    required this.onTap,
  });

  final String hex;
  final bool isSelected;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final cleanHex = hex.replaceAll('#', '');
    final color = Color(
      int.parse('FF$cleanHex', radix: 16),
    );

    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 44,
        height: 44,
        decoration: BoxDecoration(
          color: color,
          shape: BoxShape.circle,
          border: isSelected
              ? Border.all(
                  color: kcDarkGreyColor,
                  width: 3,
                )
              : null,
          boxShadow: [
            BoxShadow(
              color: color
                  .withValues(alpha: 0.3),
              blurRadius: 8,
              offset: const Offset(0, 2),
            ),
          ],
        ),
        child: isSelected
            ? const Icon(
                Icons.check,
                color: Colors.white,
                size: 20,
              )
            : null,
      ),
    );
  }
}

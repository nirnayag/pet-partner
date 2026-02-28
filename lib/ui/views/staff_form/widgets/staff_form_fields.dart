import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Reusable text input field for the staff form.
class StaffFormField extends StatelessWidget {
  /// Creates a [StaffFormField].
  const StaffFormField({
    required this.controller,
    required this.label,
    required this.hint,
    this.maxLines = 1,
    this.obscureText = false,
    this.keyboardType,
    super.key,
  });

  /// Text controller for the field.
  final TextEditingController controller;

  /// Label displayed above the field.
  final String label;

  /// Placeholder text.
  final String hint;

  /// Maximum number of lines.
  final int maxLines;

  /// Whether to obscure text (password).
  final bool obscureText;

  /// Keyboard type for the field.
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          label.toUpperCase(),
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: kcLightGrey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
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
            obscureText: obscureText,
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
        ),
      ],
    );
  }
}

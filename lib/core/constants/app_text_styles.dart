import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

class AppTextStyles {
  // Headings
  static TextStyle get heading => GoogleFonts.manrope(
        fontSize: 36,
        fontWeight: FontWeight.w800,
        color: kcDarkGreyColor,
      );

  static TextStyle get headingSmall => GoogleFonts.manrope(
        fontSize: 24,
        fontWeight: FontWeight.w700,
        color: kcDarkGreyColor,
      );

  // Body
  static TextStyle get bodyRegular => GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w500,
        color: kcDarkGreyColor,
      );

  static TextStyle get bodySmall => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w500,
        color: kcMediumGrey,
      );

  // Buttons
  static TextStyle get button => GoogleFonts.manrope(
        fontSize: 18,
        fontWeight: FontWeight.w700,
        color: Colors.white,
      );

  // Labels
  static TextStyle get label => GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: kcDarkGreyColor,
      );

  // Captions
  static TextStyle get caption => GoogleFonts.manrope(
        fontSize: 12,
        fontWeight: FontWeight.w500,
        color: kcMediumGrey,
      );
}

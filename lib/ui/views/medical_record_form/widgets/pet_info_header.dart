import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Displays pet info at the top of the
/// medical record form.
class PetInfoHeader extends StatelessWidget {
  /// Creates a [PetInfoHeader].
  const PetInfoHeader({
    required this.pet,
    super.key,
  });

  /// The pet to display.
  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kcPrimaryColor.withValues(
          alpha: 0.08,
        ),
        borderRadius:
            BorderRadius.circular(16),
        border: Border.all(
          color: kcPrimaryColor.withValues(
            alpha: 0.2,
          ),
        ),
      ),
      child: Row(
        children: [
          CircleAvatar(
            radius: 24,
            backgroundColor:
                kcPrimaryColor.withValues(
              alpha: 0.2,
            ),
            child: Text(
              pet.name.isNotEmpty
                  ? pet.name[0].toUpperCase()
                  : '?',
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kcPrimaryColorDark,
              ),
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  pet.name,
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: kcDarkGreyColor,
                  ),
                ),
                const SizedBox(height: 2),
                Text(
                  _subtitle,
                  style: GoogleFonts.manrope(
                    fontSize: 13,
                    fontWeight: FontWeight.w500,
                    color: kcMediumGrey,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  String get _subtitle {
    final parts = <String>[
      pet.species,
      if (pet.breed != null) pet.breed!,
    ];
    return parts.join(' / ');
  }
}

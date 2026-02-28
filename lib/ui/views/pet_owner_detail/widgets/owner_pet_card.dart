import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/ui/common/app_colors.dart';

/// A compact card for a pet belonging to an owner.
class OwnerPetCard extends StatelessWidget {
  /// Creates an [OwnerPetCard].
  const OwnerPetCard({
    required this.pet,
    required this.onTap,
    super.key,
  });

  /// The pet to display.
  final Pet pet;

  /// Called when the card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Container(
                width: 44,
                height: 44,
                decoration: BoxDecoration(
                  color: kcNeutral50,
                  borderRadius:
                      BorderRadius.circular(10),
                ),
                child: Icon(
                  _speciesIcon(pet.species),
                  color: kcPrimaryColorDark,
                  size: 24,
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
                        fontSize: 15,
                        fontWeight:
                            FontWeight.w700,
                        color: kcDarkGreyColor,
                      ),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      _subtitle,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        color: kcMediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
              const Icon(
                Icons.chevron_right_rounded,
                color: kcLightGrey,
              ),
            ],
          ),
        ),
      ),
    );
  }

  String get _subtitle {
    final parts = <String>[
      pet.species,
      if (pet.breed != null) pet.breed!,
    ];
    return parts.join(' - ');
  }

  static IconData _speciesIcon(String species) {
    switch (species.toLowerCase()) {
      case 'cat':
        return Icons.catching_pokemon;
      case 'bird':
        return Icons.flutter_dash;
      case 'rabbit':
        return Icons.cruelty_free;
      default:
        return Icons.pets;
    }
  }
}

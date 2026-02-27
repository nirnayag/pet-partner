import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/core/utils/ui_helpers.dart';
import 'package:partner/ui/common/app_colors.dart';

/// A summary card for a pet, used in list views.
class PetCard extends StatelessWidget {
  /// Creates a [PetCard].
  const PetCard({
    required this.pet,
    required this.onTap,
    super.key,
  });

  /// The pet to display.
  final Pet pet;

  /// Callback when the card is tapped.
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final opacity =
        pet.isDeceased || !pet.isActive ? 0.5 : 1.0;

    return Opacity(
      opacity: opacity,
      child: Card(
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
                _PetPhoto(photoUrl: pet.photoUrl),
                horizontalSpaceSmall,
                Expanded(
                  child: _PetDetails(pet: pet),
                ),
                if (pet.isDeceased)
                  _buildBadge(
                    'Deceased',
                    kcMediumGrey,
                  )
                else if (!pet.isActive)
                  _buildBadge(
                    'Inactive',
                    Colors.orange,
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildBadge(String label, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 4,
      ),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.15),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        label,
        style: TextStyle(
          fontSize: 11,
          fontWeight: FontWeight.w600,
          color: color,
        ),
      ),
    );
  }
}

class _PetPhoto extends StatelessWidget {
  const _PetPhoto({this.photoUrl});

  final String? photoUrl;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 56,
        height: 56,
        child: photoUrl != null
            ? CachedNetworkImage(
                imageUrl: photoUrl!,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    _placeholderIcon(),
                errorWidget: (_, __, ___) =>
                    _placeholderIcon(),
              )
            : _placeholderIcon(),
      ),
    );
  }

  Widget _placeholderIcon() {
    return Container(
      color: kcVeryLightGrey,
      alignment: Alignment.center,
      child: const Icon(
        Icons.pets,
        color: kcLightGrey,
        size: 28,
      ),
    );
  }
}

class _PetDetails extends StatelessWidget {
  const _PetDetails({required this.pet});

  final Pet pet;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(
              _speciesIcon(pet.species),
              size: 16,
              color: kcMediumGrey,
            ),
            horizontalSpaceTiny,
            Expanded(
              child: Text(
                pet.name,
                style: const TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w600,
                  color: kcDarkGreyColor,
                ),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ],
        ),
        verticalSpaceTiny,
        Text(
          _subtitle,
          style: const TextStyle(
            fontSize: 13,
            color: kcMediumGrey,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        if (_details.isNotEmpty) ...[
          verticalSpaceTiny,
          Text(
            _details,
            style: const TextStyle(
              fontSize: 12,
              color: kcLightGrey,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ],
    );
  }

  String get _subtitle {
    final parts = <String>[
      pet.species,
      if (pet.breed != null) pet.breed!,
    ];
    return parts.join(' - ');
  }

  String get _details {
    final parts = <String>[
      if (pet.dateOfBirth != null)
        _calculateAge(pet.dateOfBirth!),
      if (pet.weight != null)
        '${pet.weight} ${pet.weightUnit ?? 'kg'}',
    ];
    return parts.join(' | ');
  }

  static String _calculateAge(DateTime dateOfBirth) {
    final now = DateTime.now();
    var years = now.year - dateOfBirth.year;
    var months = now.month - dateOfBirth.month;

    if (now.day < dateOfBirth.day) {
      months--;
    }
    if (months < 0) {
      years--;
      months += 12;
    }

    if (years > 0) {
      return '$years yr${years > 1 ? 's' : ''}';
    }
    return '$months mo';
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

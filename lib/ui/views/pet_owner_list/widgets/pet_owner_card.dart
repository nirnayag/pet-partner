import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/models/pet_owner.dart';
import 'package:partner/ui/common/app_colors.dart';

/// A summary card for a pet owner in lists.
class PetOwnerCard extends StatelessWidget {
  /// Creates a [PetOwnerCard].
  const PetOwnerCard({
    required this.owner,
    required this.onTap,
    super.key,
  });

  /// The pet owner to display.
  final PetOwner owner;

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
              _Avatar(url: owner.avatarUrl),
              const SizedBox(width: 12),
              Expanded(
                child: _Details(owner: owner),
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
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(10),
      child: SizedBox(
        width: 52,
        height: 52,
        child: url != null
            ? CachedNetworkImage(
                imageUrl: url!,
                fit: BoxFit.cover,
                placeholder: (_, __) =>
                    _placeholder(),
                errorWidget: (_, __, ___) =>
                    _placeholder(),
              )
            : _placeholder(),
      ),
    );
  }

  Widget _placeholder() {
    return Container(
      color: kcVeryLightGrey,
      alignment: Alignment.center,
      child: const Icon(
        Icons.person,
        color: kcLightGrey,
        size: 28,
      ),
    );
  }
}

class _Details extends StatelessWidget {
  const _Details({required this.owner});

  final PetOwner owner;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          owner.fullName,
          style: GoogleFonts.manrope(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: kcDarkGreyColor,
          ),
          overflow: TextOverflow.ellipsis,
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            const Icon(
              Icons.phone_outlined,
              size: 14,
              color: kcMediumGrey,
            ),
            const SizedBox(width: 4),
            Text(
              owner.phone,
              style: GoogleFonts.manrope(
                fontSize: 13,
                color: kcMediumGrey,
              ),
            ),
          ],
        ),
        if (owner.email != null) ...[
          const SizedBox(height: 2),
          Row(
            children: [
              const Icon(
                Icons.email_outlined,
                size: 14,
                color: kcMediumGrey,
              ),
              const SizedBox(width: 4),
              Expanded(
                child: Text(
                  owner.email!,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    color: kcLightGrey,
                  ),
                  overflow:
                      TextOverflow.ellipsis,
                ),
              ),
            ],
          ),
        ],
        if (owner.petCount != null &&
            owner.petCount! > 0) ...[
          const SizedBox(height: 2),
          Text(
            '${owner.petCount} '
            'pet${owner.petCount! > 1 ? 's' : ''}',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kcPrimaryColorDark,
            ),
          ),
        ],
      ],
    );
  }
}

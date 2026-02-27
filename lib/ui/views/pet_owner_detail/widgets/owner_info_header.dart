import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/core/models/pet_owner.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Displays the pet owner's avatar, name,
/// phone, email, and member-since date.
class OwnerInfoHeader extends StatelessWidget {
  /// Creates an [OwnerInfoHeader].
  const OwnerInfoHeader({
    required this.owner,
    super.key,
  });

  /// The owner to display.
  final PetOwner owner;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _Avatar(url: owner.avatarUrl),
        const SizedBox(height: 16),
        Text(
          owner.fullName,
          style: GoogleFonts.manrope(
            fontSize: 22,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
          textAlign: TextAlign.center,
        ),
        const SizedBox(height: 8),
        Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.phone_outlined,
              size: 16,
              color: kcMediumGrey,
            ),
            const SizedBox(width: 6),
            Text(
              owner.phone,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: kcMediumGrey,
              ),
            ),
          ],
        ),
        if (owner.email != null) ...[
          const SizedBox(height: 4),
          Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.email_outlined,
                size: 16,
                color: kcMediumGrey,
              ),
              const SizedBox(width: 6),
              Text(
                owner.email!,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  color: kcMediumGrey,
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Text(
          'Member since '
          '${DateFormat('MMM yyyy').format(
            owner.createdAt,
          )}',
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w600,
            color: kcLightGrey,
          ),
        ),
      ],
    );
  }
}

class _Avatar extends StatelessWidget {
  const _Avatar({this.url});

  final String? url;

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(40),
      child: SizedBox(
        width: 80,
        height: 80,
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
        size: 40,
      ),
    );
  }
}

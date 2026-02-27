import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Section for displaying and selecting a clinic
/// logo.
class LogoPickerSection extends StatelessWidget {
  /// Creates a [LogoPickerSection].
  const LogoPickerSection({
    required this.logoUrl,
    super.key,
  });

  /// The current logo URL, or `null`.
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Clinic Logo',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 16),
        Center(
          child: Container(
            width: 120,
            height: 120,
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius:
                  BorderRadius.circular(20),
              boxShadow: [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: 0.05),
                  blurRadius: 15,
                  offset: const Offset(0, 4),
                ),
              ],
            ),
            child: logoUrl != null
                ? ClipRRect(
                    borderRadius:
                        BorderRadius.circular(20),
                    child: Image.network(
                      logoUrl!,
                      fit: BoxFit.cover,
                      errorBuilder: (
                        _,
                        __,
                        ___,
                      ) =>
                          _placeholder(),
                    ),
                  )
                : _placeholder(),
          ),
        ),
        const SizedBox(height: 12),
        Center(
          child: Text(
            'Logo upload coming soon',
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w500,
              color: kcMediumGrey,
            ),
          ),
        ),
      ],
    );
  }

  Widget _placeholder() {
    return Center(
      child: Icon(
        Icons.add_photo_alternate_outlined,
        size: 40,
        color: kcLightGrey,
      ),
    );
  }
}

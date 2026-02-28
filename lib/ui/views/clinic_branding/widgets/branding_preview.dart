import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// A live preview of the clinic branding.
class BrandingPreview extends StatelessWidget {
  /// Creates a [BrandingPreview].
  const BrandingPreview({
    required this.primaryColor,
    required this.logoUrl,
    super.key,
  });

  /// The primary colour to preview.
  final Color primaryColor;

  /// The logo URL to preview.
  final String? logoUrl;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Preview',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color: kcVeryLightGrey,
            ),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 40,
                    height: 40,
                    decoration: BoxDecoration(
                      color: primaryColor
                          .withValues(
                        alpha: 0.1,
                      ),
                      borderRadius:
                          BorderRadius.circular(
                        12,
                      ),
                    ),
                    child: logoUrl != null
                        ? ClipRRect(
                            borderRadius:
                                BorderRadius
                                    .circular(
                              12,
                            ),
                            child: Image.network(
                              logoUrl!,
                              fit: BoxFit.cover,
                              errorBuilder: (
                                _,
                                __,
                                ___,
                              ) =>
                                  Icon(
                                Icons
                                    .local_hospital,
                                color:
                                    primaryColor,
                                size: 20,
                              ),
                            ),
                          )
                        : Icon(
                            Icons
                                .local_hospital,
                            color: primaryColor,
                            size: 20,
                          ),
                  ),
                  const SizedBox(width: 12),
                  Text(
                    'Your Clinic',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: kcDarkGreyColor,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),
              Container(
                height: 40,
                decoration: BoxDecoration(
                  color: primaryColor,
                  borderRadius:
                      BorderRadius.circular(12),
                ),
                child: Center(
                  child: Text(
                    'Sample Button',
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

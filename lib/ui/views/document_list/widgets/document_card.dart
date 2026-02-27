import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/core/models/document/document.dart';
import 'package:partner/ui/common/app_colors.dart';

/// A card displaying a document's summary info.
class DocumentCard extends StatelessWidget {
  /// Creates a [DocumentCard].
  const DocumentCard({
    required this.document,
    super.key,
  });

  /// The document to display.
  final Document document;

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 1,
      margin: EdgeInsets.zero,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(12),
      ),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            _FileIcon(
              documentType:
                  document.documentType,
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    document.title,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w700,
                      color: kcDarkGreyColor,
                    ),
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      _TypeBadge(
                        type: document
                            .documentType,
                      ),
                      const SizedBox(width: 8),
                      Text(
                        DateFormat('dd MMM yyyy')
                            .format(
                          document.createdAt,
                        ),
                        style:
                            GoogleFonts.manrope(
                          fontSize: 12,
                          color: kcLightGrey,
                        ),
                      ),
                    ],
                  ),
                  if (document.description !=
                      null) ...[
                    const SizedBox(height: 4),
                    Text(
                      document.description!,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        color: kcMediumGrey,
                      ),
                      maxLines: 1,
                      overflow:
                          TextOverflow.ellipsis,
                    ),
                  ],
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _FileIcon extends StatelessWidget {
  const _FileIcon({required this.documentType});

  final String documentType;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: 44,
      height: 44,
      decoration: BoxDecoration(
        color: _colorForType(documentType)
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Icon(
        _iconForType(documentType),
        color: _colorForType(documentType),
        size: 22,
      ),
    );
  }

  static IconData _iconForType(String type) {
    switch (type) {
      case 'lab_result':
        return Icons.biotech_rounded;
      case 'xray':
        return Icons.image_rounded;
      case 'intake_form':
        return Icons.description_rounded;
      case 'referral_letter':
        return Icons.forward_to_inbox_rounded;
      default:
        return Icons.insert_drive_file_rounded;
    }
  }

  static Color _colorForType(String type) {
    switch (type) {
      case 'lab_result':
        return Colors.purple;
      case 'xray':
        return Colors.blue;
      case 'intake_form':
        return Colors.teal;
      case 'referral_letter':
        return Colors.orange;
      default:
        return kcMediumGrey;
    }
  }
}

class _TypeBadge extends StatelessWidget {
  const _TypeBadge({required this.type});

  final String type;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 8,
        vertical: 2,
      ),
      decoration: BoxDecoration(
        color: kcVeryLightGrey,
        borderRadius: BorderRadius.circular(6),
      ),
      child: Text(
        _displayName(type),
        style: GoogleFonts.manrope(
          fontSize: 10,
          fontWeight: FontWeight.w700,
          color: kcMediumGrey,
        ),
      ),
    );
  }

  static String _displayName(String type) {
    switch (type) {
      case 'lab_result':
        return 'Lab Result';
      case 'xray':
        return 'X-Ray';
      case 'intake_form':
        return 'Intake Form';
      case 'referral_letter':
        return 'Referral';
      default:
        return 'Other';
    }
  }
}

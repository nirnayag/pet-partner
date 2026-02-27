import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// A tappable area for selecting a file to upload.
class FilePickerArea extends StatelessWidget {
  /// Creates a [FilePickerArea].
  const FilePickerArea({
    required this.onTap,
    required this.onClear,
    this.fileName,
    super.key,
  });

  /// Called when the area is tapped.
  final VoidCallback onTap;

  /// Called to clear the selection.
  final VoidCallback onClear;

  /// Display name of the selected file.
  final String? fileName;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: double.infinity,
        padding: const EdgeInsets.symmetric(
          vertical: 32,
          horizontal: 20,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: kcVeryLightGrey,
            width: 1.5,
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(
                alpha: 0.03,
              ),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: fileName != null
            ? _SelectedState(
                fileName: fileName!,
                onClear: onClear,
              )
            : _EmptyState(),
      ),
    );
  }
}

class _EmptyState extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        const Icon(
          Icons.cloud_upload_outlined,
          size: 48,
          color: kcPrimaryColor,
        ),
        const SizedBox(height: 12),
        Text(
          'Tap to select a file',
          style: GoogleFonts.manrope(
            fontSize: 15,
            fontWeight: FontWeight.w700,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'PDF, images, or documents',
          style: GoogleFonts.manrope(
            fontSize: 13,
            color: kcMediumGrey,
          ),
        ),
      ],
    );
  }
}

class _SelectedState extends StatelessWidget {
  const _SelectedState({
    required this.fileName,
    required this.onClear,
  });

  final String fileName;
  final VoidCallback onClear;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        const Icon(
          Icons.insert_drive_file_rounded,
          color: kcPrimaryColor,
          size: 32,
        ),
        const SizedBox(width: 12),
        Expanded(
          child: Text(
            fileName,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: kcDarkGreyColor,
            ),
            overflow: TextOverflow.ellipsis,
          ),
        ),
        GestureDetector(
          onTap: onClear,
          child: const Icon(
            Icons.close_rounded,
            color: kcMediumGrey,
            size: 22,
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Reusable button with built-in loading state.
///
/// When [isLoading] is `true`, the label is replaced
/// with a [CircularProgressIndicator] and the button
/// is disabled.
class AppButton extends StatelessWidget {
  /// Creates an [AppButton].
  const AppButton({
    required this.label,
    required this.onPressed,
    this.isLoading = false,
    this.isOutlined = false,
    this.color,
    this.width,
    super.key,
  });

  /// The button label text.
  final String label;

  /// Called when the button is tapped.
  final VoidCallback? onPressed;

  /// Whether to show a loading spinner.
  final bool isLoading;

  /// Whether to use an outlined style.
  final bool isOutlined;

  /// Custom button colour (defaults to primary).
  final Color? color;

  /// Optional fixed width.
  final double? width;

  @override
  Widget build(BuildContext context) {
    final buttonColor = color ?? kcPrimaryColor;

    if (isOutlined) {
      return SizedBox(
        width: width ?? double.infinity,
        height: 50,
        child: OutlinedButton(
          onPressed: isLoading ? null : onPressed,
          style: OutlinedButton.styleFrom(
            foregroundColor: buttonColor,
            side: BorderSide(color: buttonColor),
            shape: RoundedRectangleBorder(
              borderRadius:
                  BorderRadius.circular(12),
            ),
          ),
          child: _buildChild(buttonColor),
        ),
      );
    }

    return SizedBox(
      width: width ?? double.infinity,
      height: 50,
      child: ElevatedButton(
        onPressed: isLoading ? null : onPressed,
        style: ElevatedButton.styleFrom(
          backgroundColor: buttonColor,
          foregroundColor: Colors.white,
          disabledBackgroundColor:
              buttonColor.withValues(alpha: 0.6),
          shape: RoundedRectangleBorder(
            borderRadius:
                BorderRadius.circular(12),
          ),
        ),
        child: _buildChild(Colors.white),
      ),
    );
  }

  Widget _buildChild(Color foreground) {
    if (isLoading) {
      return SizedBox(
        width: 22,
        height: 22,
        child: CircularProgressIndicator(
          strokeWidth: 2.5,
          color: foreground,
        ),
      );
    }

    return Text(
      label,
      style: GoogleFonts.manrope(
        fontSize: 16,
        fontWeight: FontWeight.w700,
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

/// Consistent snackbar notifications for success,
/// error, info, and warning messages.
class AppSnackbar {
  /// Shows a green success snackbar.
  static void showSuccess(
    BuildContext context,
    String message,
  ) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.green.shade700,
      icon: Icons.check_circle_outline,
    );
  }

  /// Shows a red error snackbar.
  static void showError(
    BuildContext context,
    String message,
  ) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.red.shade700,
      icon: Icons.error_outline,
    );
  }

  /// Shows a blue info snackbar.
  static void showInfo(
    BuildContext context,
    String message,
  ) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.blue.shade700,
      icon: Icons.info_outline,
    );
  }

  /// Shows an orange warning snackbar.
  static void showWarning(
    BuildContext context,
    String message,
  ) {
    _show(
      context,
      message: message,
      backgroundColor: Colors.orange.shade700,
      icon: Icons.warning_amber_outlined,
    );
  }

  static void _show(
    BuildContext context, {
    required String message,
    required Color backgroundColor,
    required IconData icon,
  }) {
    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Row(
            children: [
              Icon(icon, color: Colors.white, size: 20),
              const SizedBox(width: 10),
              Expanded(
                child: Text(
                  message,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w500,
                    color: Colors.white,
                  ),
                ),
              ),
            ],
          ),
          backgroundColor: backgroundColor,
          behavior: SnackBarBehavior.floating,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          duration: const Duration(seconds: 3),
          dismissDirection: DismissDirection.horizontal,
        ),
      );
  }
}

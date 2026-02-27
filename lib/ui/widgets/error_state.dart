import 'package:flutter/material.dart';
import 'package:partner/core/utils/ui_helpers.dart';
import 'package:partner/ui/common/app_colors.dart';

/// An error state widget with an icon, message, and
/// retry button.
class ErrorState extends StatelessWidget {
  /// Creates an [ErrorState].
  const ErrorState({
    required this.message,
    required this.onRetry,
    super.key,
  });

  /// The error message to display.
  final String message;

  /// Callback when the retry button is tapped.
  final VoidCallback onRetry;

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.symmetric(
          horizontal: 32,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Icon(
              Icons.error_outline,
              size: 64,
              color: Colors.red,
            ),
            verticalSpaceMedium,
            Text(
              message,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 16,
                color: kcDarkGreyColor,
              ),
            ),
            verticalSpaceMedium,
            OutlinedButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Retry'),
              style: OutlinedButton.styleFrom(
                foregroundColor: kcPrimaryColor,
                side: const BorderSide(
                  color: kcPrimaryColor,
                ),
                shape: RoundedRectangleBorder(
                  borderRadius:
                      BorderRadius.circular(8),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

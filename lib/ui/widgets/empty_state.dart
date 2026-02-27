import 'package:flutter/material.dart';
import 'package:partner/core/utils/ui_helpers.dart';
import 'package:partner/ui/common/app_colors.dart';

/// A generic empty-state placeholder with an icon,
/// title, optional description, and optional action
/// button.
class EmptyState extends StatelessWidget {
  /// Creates an [EmptyState].
  const EmptyState({
    required this.icon,
    required this.title,
    this.description,
    this.actionLabel,
    this.onAction,
    super.key,
  });

  /// The icon displayed above the title.
  final IconData icon;

  /// The main heading text.
  final String title;

  /// An optional body description.
  final String? description;

  /// Label for the optional action button.
  final String? actionLabel;

  /// Callback when the action button is tapped.
  final VoidCallback? onAction;

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
            Icon(
              icon,
              size: 64,
              color: kcLightGrey,
            ),
            verticalSpaceMedium,
            Text(
              title,
              textAlign: TextAlign.center,
              style: const TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.w600,
                color: kcDarkGreyColor,
              ),
            ),
            if (description != null) ...[
              verticalSpaceSmall,
              Text(
                description!,
                textAlign: TextAlign.center,
                style: const TextStyle(
                  fontSize: 14,
                  color: kcMediumGrey,
                ),
              ),
            ],
            if (actionLabel != null &&
                onAction != null) ...[
              verticalSpaceMedium,
              ElevatedButton(
                onPressed: onAction,
                style: ElevatedButton.styleFrom(
                  backgroundColor: kcPrimaryColor,
                  foregroundColor: Colors.white,
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(8),
                  ),
                ),
                child: Text(actionLabel!),
              ),
            ],
          ],
        ),
      ),
    );
  }
}

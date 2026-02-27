import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/enums/reminder_type.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Type dropdown for the reminder form.
class ReminderTypeDropdown
    extends StatelessWidget {
  /// Creates a [ReminderTypeDropdown].
  const ReminderTypeDropdown({
    required this.value,
    required this.onChanged,
    super.key,
  });

  /// The currently selected type.
  final ReminderType value;

  /// Callback when the type changes.
  final ValueChanged<ReminderType> onChanged;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'TYPE',
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: kcLightGrey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Container(
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color: Colors.black
                    .withValues(alpha: 0.03),
                blurRadius: 10,
                offset: const Offset(0, 4),
              ),
            ],
          ),
          child: DropdownButtonHideUnderline(
            child: DropdownButton<ReminderType>(
              value: value,
              isExpanded: true,
              icon: const Icon(
                Icons
                    .keyboard_arrow_down_rounded,
                color: kcMediumGrey,
              ),
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: kcDarkGreyColor,
              ),
              items: ReminderType.values
                  .map(
                    (t) => DropdownMenuItem(
                      value: t,
                      child: Text(
                        t.displayName,
                      ),
                    ),
                  )
                  .toList(),
              onChanged: (v) {
                if (v != null) onChanged(v);
              },
            ),
          ),
        ),
      ],
    );
  }
}

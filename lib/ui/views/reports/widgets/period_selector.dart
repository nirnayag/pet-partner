import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Period selector for the reports dashboard.
class PeriodSelector extends StatelessWidget {
  /// Creates a [PeriodSelector].
  const PeriodSelector({
    required this.selected,
    required this.options,
    required this.onChanged,
    super.key,
  });

  /// The currently selected period.
  final String selected;

  /// Available period options.
  final List<String> options;

  /// Callback when a period is selected.
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: options
          .map(
            (period) => Expanded(
              child: GestureDetector(
                onTap: () => onChanged(period),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 12,
                  ),
                  decoration: BoxDecoration(
                    color: selected == period
                        ? kcNeutral900
                        : Colors.white,
                    borderRadius:
                        BorderRadius.circular(14),
                    boxShadow: selected == period
                        ? null
                        : [
                            BoxShadow(
                              color: Colors.black
                                  .withValues(
                                alpha: 0.03,
                              ),
                              blurRadius: 5,
                            ),
                          ],
                  ),
                  child: Center(
                    child: Text(
                      period,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w700,
                        color:
                            selected == period
                                ? Colors.white
                                : kcMediumGrey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

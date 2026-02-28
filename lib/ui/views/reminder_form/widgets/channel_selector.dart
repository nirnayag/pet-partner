import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Multi-select chips for delivery channels.
class ChannelSelector extends StatelessWidget {
  /// Creates a [ChannelSelector].
  const ChannelSelector({
    required this.selected,
    required this.onToggle,
    super.key,
  });

  /// Currently selected channels.
  final Set<String> selected;

  /// Callback when a channel is toggled.
  final ValueChanged<String> onToggle;

  static const _channels = <String>[
    'sms',
    'email',
    'push',
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'CHANNELS',
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: kcLightGrey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _channels
              .map(
                (ch) => Expanded(
                  child: GestureDetector(
                    onTap: () => onToggle(ch),
                    child: Container(
                      margin:
                          const EdgeInsets.only(
                        right: 8,
                      ),
                      padding:
                          const EdgeInsets
                              .symmetric(
                        vertical: 14,
                      ),
                      decoration: BoxDecoration(
                        color:
                            selected.contains(ch)
                                ? kcNeutral900
                                : Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                        boxShadow:
                            selected.contains(ch)
                                ? null
                                : [
                                    BoxShadow(
                                      color: Colors
                                          .black
                                          .withValues(
                                        alpha:
                                            0.03,
                                      ),
                                      blurRadius:
                                          5,
                                    ),
                                  ],
                      ),
                      child: Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .center,
                        children: [
                          Icon(
                            _iconFor(ch),
                            size: 16,
                            color: selected
                                    .contains(ch)
                                ? Colors.white
                                : kcMediumGrey,
                          ),
                          const SizedBox(
                            width: 4,
                          ),
                          Text(
                            ch.toUpperCase(),
                            style: GoogleFonts
                                .manrope(
                              fontSize: 11,
                              fontWeight:
                                  FontWeight.w700,
                              color: selected
                                      .contains(
                                ch,
                              )
                                  ? Colors.white
                                  : kcMediumGrey,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              )
              .toList(),
        ),
      ],
    );
  }

  IconData _iconFor(String channel) {
    switch (channel) {
      case 'sms':
        return Icons.sms_outlined;
      case 'email':
        return Icons.email_outlined;
      case 'push':
        return Icons.notifications_outlined;
      default:
        return Icons.send_outlined;
    }
  }
}

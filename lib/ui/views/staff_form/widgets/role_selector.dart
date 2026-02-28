import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/enums/user_role.dart';
import 'package:partner/ui/common/app_colors.dart';

/// A segmented control for selecting a user role.
class RoleSelector extends StatelessWidget {
  /// Creates a [RoleSelector].
  const RoleSelector({
    required this.selectedRole,
    required this.onChanged,
    super.key,
  });

  /// The currently selected role.
  final UserRole selectedRole;

  /// Callback when a role is selected.
  final ValueChanged<UserRole> onChanged;

  static const _roles = [
    UserRole.staff,
    UserRole.veterinarian,
  ];

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'ROLE',
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: kcLightGrey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        Row(
          children: _roles
              .map(
                (role) => Expanded(
                  child: GestureDetector(
                    onTap: () =>
                        onChanged(role),
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
                            selectedRole == role
                                ? kcNeutral900
                                : Colors.white,
                        borderRadius:
                            BorderRadius.circular(
                          14,
                        ),
                        boxShadow:
                            selectedRole == role
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
                      child: Center(
                        child: Text(
                          role.displayName,
                          style:
                              GoogleFonts.manrope(
                            fontSize: 13,
                            fontWeight:
                                FontWeight.w700,
                            color: selectedRole ==
                                    role
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
        ),
      ],
    );
  }
}

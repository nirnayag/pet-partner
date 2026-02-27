import 'package:flutter/gestures.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/utils/ui_helpers.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/register/register_viewmodel.dart';
import 'package:stacked/stacked.dart';

class RegisterView
    extends StackedView<RegisterViewModel> {
  const RegisterView({super.key});

  @override
  Widget builder(
    BuildContext context,
    RegisterViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFEFF6EF),
              Color(0xFFF6F8F6),
            ],
          ),
        ),
        child: SafeArea(
          child: Column(
            children: [
              // Back Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 20,
                  vertical: 10,
                ),
                child: Align(
                  alignment: Alignment.centerLeft,
                  child: GestureDetector(
                    onTap: viewModel.goBack,
                    child: Container(
                      height: 44,
                      width: 44,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        shape: BoxShape.circle,
                        boxShadow: [
                          BoxShadow(
                            blurRadius: 10,
                            color: Colors.black
                                .withValues(
                              alpha: .05,
                            ),
                          ),
                        ],
                      ),
                      child: const Icon(
                        Icons
                            .arrow_back_ios_new_rounded,
                        size: 18,
                      ),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 24,
                  ),
                  child: Column(
                    crossAxisAlignment:
                        CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 10),

                      /// Title
                      Text(
                        'Create Your\nAccount',
                        style: GoogleFonts.manrope(
                          fontSize: 32,
                          fontWeight:
                              FontWeight.w800,
                          height: 1.2,
                          color: kcDarkGreyColor,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        'Sign up to manage your '
                        "pet's health and "
                        'appointments easily.',
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          color: kcMediumGrey,
                        ),
                      ),

                      const SizedBox(height: 30),

                      /// FULL NAME
                      _label('Full Name'),
                      const SizedBox(height: 8),
                      _textField(
                        icon:
                            Icons.person_outline,
                        hint: 'e.g. Sarah Jenkins',
                      ),

                      const SizedBox(height: 20),

                      /// MOBILE
                      _label('Mobile Number'),
                      const SizedBox(height: 8),
                      Row(
                        children: [
                          Container(
                            padding:
                                const EdgeInsets
                                    .symmetric(
                              horizontal: 14,
                            ),
                            height: 56,
                            decoration:
                                _inputDecoration(),
                            child: const Row(
                              children: [
                                Text(
                                  '\u{1f1fa}\u{1f1f8}',
                                  style: TextStyle(
                                    fontSize: 18,
                                  ),
                                ),
                                SizedBox(width: 6),
                                Text(
                                  '+1',
                                  style: TextStyle(
                                    fontWeight:
                                        FontWeight
                                            .w600,
                                    fontSize: 15,
                                  ),
                                ),
                                Icon(
                                  Icons
                                      .keyboard_arrow_down_rounded,
                                  size: 20,
                                ),
                              ],
                            ),
                          ),
                          const SizedBox(width: 10),
                          Expanded(
                            child: _textField(
                              isMobile: true,
                              icon: Icons
                                  .smartphone_outlined,
                              hint: '000 000 0000',
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),

                      /// EMAIL
                      Row(
                        mainAxisAlignment:
                            MainAxisAlignment
                                .spaceBetween,
                        children: [
                          _label('Email Address'),
                          Text(
                            'OPTIONAL',
                            style:
                                GoogleFonts.manrope(
                              fontSize: 12,
                              letterSpacing: 1,
                              color: kcMediumGrey
                                  .withValues(
                                alpha: 0.5,
                              ),
                              fontWeight:
                                  FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      const SizedBox(height: 8),
                      _textField(
                        icon:
                            Icons.email_outlined,
                        hint: 'sarah@example.com',
                      ),

                      const SizedBox(height: 18),

                      /// TERMS
                      Row(
                        crossAxisAlignment:
                            CrossAxisAlignment
                                .start,
                        children: [
                          SizedBox(
                            height: 24,
                            width: 24,
                            child: Checkbox(
                              value: false,
                              onChanged: (v) {},
                              activeColor:
                                  kcPrimaryColor,
                              shape:
                                  RoundedRectangleBorder(
                                borderRadius:
                                    BorderRadius
                                        .circular(
                                  6,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(width: 12),
                          Expanded(
                            child: RichText(
                              text: TextSpan(
                                style: GoogleFonts
                                    .manrope(
                                  color:
                                      kcMediumGrey,
                                  fontSize: 14,
                                ),
                                children: [
                                  const TextSpan(
                                    text:
                                        'I agree to the ',
                                  ),
                                  TextSpan(
                                    text:
                                        'Terms of Service',
                                    style:
                                        const TextStyle(
                                      color:
                                          kcPrimaryColor,
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap =
                                              () {},
                                  ),
                                  const TextSpan(
                                    text: ' and ',
                                  ),
                                  TextSpan(
                                    text:
                                        'Privacy Policy',
                                    style:
                                        const TextStyle(
                                      color:
                                          kcPrimaryColor,
                                      fontWeight:
                                          FontWeight
                                              .w700,
                                    ),
                                    recognizer:
                                        TapGestureRecognizer()
                                          ..onTap =
                                              () {},
                                  ),
                                  const TextSpan(
                                    text: '.',
                                  ),
                                ],
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 30),

                      /// BUTTON
                      GestureDetector(
                        onTap:
                            viewModel.navigateToOtp,
                        child: Container(
                          height: 60,
                          decoration:
                              BoxDecoration(
                            borderRadius: kbrLarge,
                            gradient:
                                const LinearGradient(
                              colors: [
                                kcPrimaryColor,
                                kcPrimaryColorDark,
                              ],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: kcPrimaryColor
                                    .withValues(
                                  alpha: .3,
                                ),
                                blurRadius: 20,
                                offset:
                                    const Offset(
                                  0,
                                  8,
                                ),
                              ),
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment:
                                  MainAxisAlignment
                                      .center,
                              children: [
                                Text(
                                  'Get OTP',
                                  style: GoogleFonts
                                      .manrope(
                                    fontSize: 18,
                                    fontWeight:
                                        FontWeight
                                            .bold,
                                    color: Colors
                                        .white,
                                  ),
                                ),
                                const SizedBox(
                                  width: 8,
                                ),
                                const Icon(
                                  Icons
                                      .arrow_forward_rounded,
                                  color:
                                      Colors.white,
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// LOGIN
                      Center(
                        child: GestureDetector(
                          onTap: viewModel
                              .navigateToLogin,
                          child: RichText(
                            text: TextSpan(
                              style: GoogleFonts
                                  .manrope(
                                color:
                                    kcMediumGrey,
                                fontSize: 15,
                              ),
                              children: const [
                                TextSpan(
                                  text:
                                      'Already have an account? ',
                                ),
                                TextSpan(
                                  text: 'Login',
                                  style: TextStyle(
                                    color:
                                        kcPrimaryColor,
                                    fontWeight:
                                        FontWeight
                                            .w800,
                                  ),
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 30),
                    ],
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _label(String text) {
    return Text(
      text,
      style: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w700,
        color: kcDarkGreyColor,
      ),
    );
  }

  Widget _textField({
    required IconData icon,
    required String hint,
    bool isMobile = false,
  }) {
    return Container(
      height: 56,
      decoration: _inputDecoration(),
      child: TextField(
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: kcMediumGrey.withValues(
              alpha: 0.5,
            ),
            size: 22,
          ),
          hintText: hint,
          hintStyle: GoogleFonts.manrope(
            color: kcMediumGrey.withValues(
              alpha: 0.3,
            ),
            fontWeight: FontWeight.w500,
          ),
          contentPadding:
              const EdgeInsets.symmetric(
            horizontal: 16,
            vertical: 16,
          ),
        ),
        style: GoogleFonts.manrope(
          fontWeight: FontWeight.w600,
          color: kcDarkGreyColor,
        ),
      ),
    );
  }

  BoxDecoration _inputDecoration() {
    return BoxDecoration(
      color: Colors.white,
      borderRadius: kbrLarge,
      boxShadow: [
        BoxShadow(
          color:
              Colors.black.withValues(alpha: .03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        ),
      ],
    );
  }

  @override
  RegisterViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      RegisterViewModel();
}

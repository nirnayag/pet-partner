import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/common/ui_helpers.dart';
import 'package:stacked/stacked.dart';

import 'login_viewmodel.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    LoginViewModel viewModel,
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
              /// Back Button
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
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
                            color: Colors.black.withOpacity(.05),
                          )
                        ],
                      ),
                      child: const Icon(Icons.arrow_back_ios_new_rounded,
                          size: 18),
                    ),
                  ),
                ),
              ),

              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.symmetric(horizontal: 24),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const SizedBox(height: 20),

                      /// Title
                      Text(
                        "Welcome\nBack",
                        style: GoogleFonts.manrope(
                          fontSize: 32,
                          fontWeight: FontWeight.w800,
                          height: 1.2,
                          color: kcDarkGreyColor,
                        ),
                      ),

                      const SizedBox(height: 12),

                      Text(
                        "Enter your mobile number to access your account",
                        style: GoogleFonts.manrope(
                          fontSize: 15,
                          color: kcMediumGrey,
                        ),
                      ),

                      const SizedBox(height: 40),

                      /// Mobile Label
                      Text(
                        "Mobile Number",
                        style: GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: kcDarkGreyColor,
                        ),
                      ),

                      const SizedBox(height: 8),

                      Row(
                        children: [
                          /// Country Code Box
                          Container(
                            height: 56,
                            padding: const EdgeInsets.symmetric(horizontal: 14),
                            decoration: _inputDecoration(),
                            child: const Row(
                              children: [
                                Text("🇺🇸", style: TextStyle(fontSize: 18)),
                                SizedBox(width: 6),
                                Text("+1",
                                    style: TextStyle(
                                        fontWeight: FontWeight.w600,
                                        fontSize: 15)),
                                Icon(Icons.keyboard_arrow_down_rounded,
                                    size: 20),
                              ],
                            ),
                          ),

                          const SizedBox(width: 12),

                          /// Mobile Input
                          Expanded(
                            child: Container(
                              height: 56,
                              decoration: _inputDecoration(),
                              child: TextField(
                                keyboardType: TextInputType.phone,
                                decoration: InputDecoration(
                                  border: InputBorder.none,
                                  prefixIcon: Icon(Icons.smartphone_outlined,
                                      color: kcMediumGrey.withOpacity(0.5),
                                      size: 22),
                                  hintText: "000 000 0000",
                                  hintStyle: GoogleFonts.manrope(
                                      color: kcMediumGrey.withOpacity(0.3),
                                      fontWeight: FontWeight.w500),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 16, vertical: 16),
                                ),
                                style: GoogleFonts.manrope(
                                  fontWeight: FontWeight.w600,
                                  color: kcDarkGreyColor,
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),

                      const SizedBox(height: 40),

                      /// Get OTP Button
                      GestureDetector(
                        onTap: viewModel.navigateToOtp,
                        child: Container(
                          height: 60,
                          decoration: BoxDecoration(
                            borderRadius: kbrLarge,
                            gradient: const LinearGradient(
                              colors: [kcPrimaryColor, kcPrimaryColorDark],
                            ),
                            boxShadow: [
                              BoxShadow(
                                color: kcPrimaryColor.withOpacity(.3),
                                blurRadius: 20,
                                offset: const Offset(0, 8),
                              )
                            ],
                          ),
                          child: Center(
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Text(
                                  "Get OTP",
                                  style: GoogleFonts.manrope(
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold,
                                    color: Colors.white,
                                  ),
                                ),
                                const SizedBox(width: 8),
                                const Icon(Icons.arrow_forward_rounded,
                                    color: Colors.white)
                              ],
                            ),
                          ),
                        ),
                      ),

                      const SizedBox(height: 80),
                    ],
                  ),
                ),
              ),

              /// Bottom Sign Up Text
              Padding(
                padding: const EdgeInsets.only(bottom: 30),
                child: GestureDetector(
                  onTap: viewModel.navigateToSignUp,
                  child: RichText(
                    text: TextSpan(
                      style: GoogleFonts.manrope(
                        color: kcMediumGrey,
                        fontSize: 15,
                      ),
                      children: const [
                        TextSpan(text: "Don’t have an account? "),
                        TextSpan(
                          text: "Sign Up",
                          style: TextStyle(
                            color: kcPrimaryColor,
                            fontWeight: FontWeight.w800,
                          ),
                        )
                      ],
                    ),
                  ),
                ),
              ),
            ],
          ),
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
          color: Colors.black.withOpacity(.03),
          blurRadius: 10,
          offset: const Offset(0, 4),
        )
      ],
    );
  }

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}

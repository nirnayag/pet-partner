import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'verify_otp_viewmodel.dart';

class VerifyOtpView extends StackedView<VerifyOtpViewModel> {
  const VerifyOtpView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    VerifyOtpViewModel viewModel,
    Widget? child,
  ) {
    return const _VerifyOtpBody();
  }

  @override
  VerifyOtpViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      VerifyOtpViewModel();
}

class _VerifyOtpBody extends StatefulWidget {
  const _VerifyOtpBody();

  @override
  State<_VerifyOtpBody> createState() => _VerifyOtpBodyState();
}

class _VerifyOtpBodyState extends State<_VerifyOtpBody> {
  final List<FocusNode> _focusNodes = List.generate(4, (index) => FocusNode());
  final List<TextEditingController> _controllers =
      List.generate(4, (index) => TextEditingController());

  @override
  void dispose() {
    for (var node in _focusNodes) {
      node.dispose();
    }
    for (var controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final viewModel = getParentViewModel<VerifyOtpViewModel>(context);

    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Container(
        decoration: const BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topRight,
            end: Alignment.bottomLeft,
            colors: [
              Color(0xFFF6F8F6),
              Color(0xFFEFF6EF),
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
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    /// TOP CONTENT
                    Column(
                      children: [
                        const SizedBox(height: 20),

                        /// Icon Container
                        Container(
                          height: 90,
                          width: 90,
                          decoration: BoxDecoration(
                            color: kcPrimaryColor.withOpacity(.1),
                            borderRadius: BorderRadius.circular(28),
                            boxShadow: [
                              BoxShadow(
                                color: kcPrimaryColor.withOpacity(.2),
                                blurRadius: 30,
                              )
                            ],
                          ),
                          child: const Icon(
                            Icons.sms_rounded,
                            color: kcPrimaryColor,
                            size: 40,
                          ),
                        ),

                        const SizedBox(height: 30),

                        Text(
                          "Verify Mobile",
                          style: GoogleFonts.manrope(
                            fontSize: 30,
                            fontWeight: FontWeight.bold,
                            color: kcDarkGreyColor,
                          ),
                        ),

                        const SizedBox(height: 10),

                        Text(
                          "Enter the 4-digit code sent to",
                          style: GoogleFonts.manrope(
                            fontSize: 14,
                            color: kcMediumGrey,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "+1 234-567-8900",
                          style: GoogleFonts.manrope(
                            fontWeight: FontWeight.bold,
                            fontSize: 16,
                            color: kcDarkGreyColor,
                          ),
                        ),

                        const SizedBox(height: 40),

                        /// OTP Boxes
                        Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: List.generate(
                            4,
                            (index) => Padding(
                              padding:
                                  const EdgeInsets.symmetric(horizontal: 8),
                              child: _otpBox(index),
                            ),
                          ),
                        ),

                        const SizedBox(height: 30),

                        /// Resend Timer
                        Column(
                          children: [
                            RichText(
                              text: TextSpan(
                                text: "Resend code in ",
                                style: GoogleFonts.manrope(
                                  color: kcMediumGrey,
                                  fontSize: 14,
                                ),
                                children: const [
                                  TextSpan(
                                    text: "0:45",
                                    style: TextStyle(
                                      color: kcPrimaryColor,
                                      fontWeight: FontWeight.bold,
                                    ),
                                  )
                                ],
                              ),
                            ),
                            const SizedBox(height: 8),
                            TextButton(
                              onPressed: () {},
                              child: Text(
                                "RESEND CODE",
                                style: GoogleFonts.manrope(
                                  fontSize: 12,
                                  letterSpacing: 1,
                                  color: kcMediumGrey.withOpacity(0.5),
                                  fontWeight: FontWeight.w700,
                                ),
                              ),
                            )
                          ],
                        )
                      ],
                    ),

                    /// BOTTOM BUTTON
                    Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 24, vertical: 20),
                      child: Column(
                        children: [
                          GestureDetector(
                            onTap: () {
                              String otp =
                                  _controllers.map((c) => c.text).join();
                              viewModel.verifyOtp(otp);
                            },
                            child: Container(
                              height: 60,
                              decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(22),
                                gradient: const LinearGradient(
                                  colors: [kcPrimaryColor, kcPrimaryColorDark],
                                ),
                                boxShadow: [
                                  BoxShadow(
                                    color: kcPrimaryColor.withOpacity(.4),
                                    blurRadius: 20,
                                    offset: const Offset(0, 8),
                                  )
                                ],
                              ),
                              child: const Center(
                                child: Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Text(
                                      "Verify & Continue",
                                      style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Icon(Icons.arrow_forward_rounded,
                                        color: Colors.white)
                                  ],
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 16),
                          Text(
                            "By verifying, you agree to our Terms of Service & Privacy Policy.",
                            textAlign: TextAlign.center,
                            style: GoogleFonts.manrope(
                              fontSize: 11,
                              color: kcMediumGrey.withOpacity(0.6),
                            ),
                          )
                        ],
                      ),
                    )
                  ],
                ),
              )
            ],
          ),
        ),
      ),
    );
  }

  Widget _otpBox(int index) {
    return SizedBox(
      width: 65,
      height: 65,
      child: TextField(
        controller: _controllers[index],
        focusNode: _focusNodes[index],
        textAlign: TextAlign.center,
        style: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.bold,
          color: kcDarkGreyColor,
        ),
        keyboardType: TextInputType.number,
        inputFormatters: [
          FilteringTextInputFormatter.digitsOnly,
          LengthLimitingTextInputFormatter(1),
        ],
        decoration: InputDecoration(
          filled: true,
          fillColor: Colors.white,
          hintText: "-",
          hintStyle: TextStyle(color: kcMediumGrey.withOpacity(0.3)),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: Color(0xFFE0E0E0),
              width: 1.5,
            ),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(20),
            borderSide: const BorderSide(
              color: kcPrimaryColor,
              width: 2,
            ),
          ),
          contentPadding: EdgeInsets.zero,
        ),
        onChanged: (value) {
          if (value.isNotEmpty && index < 3) {
            FocusScope.of(context).requestFocus(_focusNodes[index + 1]);
          } else if (value.isEmpty && index > 0) {
            FocusScope.of(context).requestFocus(_focusNodes[index - 1]);
          }
        },
      ),
    );
  }
}

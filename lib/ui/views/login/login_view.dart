import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/utils/ui_helpers.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/login/login_viewmodel.dart';
import 'package:partner/ui/widgets/app_button.dart';
import 'package:stacked/stacked.dart';

class LoginView extends StackedView<LoginViewModel> {
  const LoginView({super.key});

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
          child: Center(
            child: SingleChildScrollView(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 24,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  verticalSpaceLarge,

                  // Logo / Branding
                  Center(
                    child: Container(
                      height: 80,
                      width: 80,
                      decoration: BoxDecoration(
                        color: kcPrimaryColor
                            .withValues(alpha: .1),
                        borderRadius:
                            BorderRadius.circular(24),
                      ),
                      child: const Icon(
                        Icons.pets,
                        color: kcPrimaryColor,
                        size: 40,
                      ),
                    ),
                  ),

                  verticalSpaceMedium,

                  Center(
                    child: Text(
                      'Pet Partner',
                      style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.w800,
                        color: kcDarkGreyColor,
                      ),
                    ),
                  ),

                  const SizedBox(height: 8),

                  Center(
                    child: Text(
                      'Sign in to your clinic account',
                      style: GoogleFonts.manrope(
                        fontSize: 15,
                        color: kcMediumGrey,
                      ),
                    ),
                  ),

                  const SizedBox(height: 40),

                  // Email
                  _label('Email'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller:
                        viewModel.emailController,
                    hint: 'you@clinic.com',
                    icon: Icons.email_outlined,
                    keyboardType:
                        TextInputType.emailAddress,
                  ),

                  const SizedBox(height: 20),

                  // Password
                  _label('Password'),
                  const SizedBox(height: 8),
                  _buildTextField(
                    controller:
                        viewModel.passwordController,
                    hint: 'Enter your password',
                    icon: Icons.lock_outline,
                    obscure: viewModel.obscurePassword,
                    suffixIcon: IconButton(
                      icon: Icon(
                        viewModel.obscurePassword
                            ? Icons.visibility_off
                            : Icons.visibility,
                        color: kcLightGrey,
                        size: 22,
                      ),
                      onPressed: viewModel
                          .togglePasswordVisibility,
                    ),
                  ),

                  // Error message
                  if (viewModel.hasError) ...[
                    const SizedBox(height: 16),
                    Container(
                      padding:
                          const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 10,
                      ),
                      decoration: BoxDecoration(
                        color: Colors.red.shade50,
                        borderRadius:
                            BorderRadius.circular(8),
                      ),
                      child: Row(
                        children: [
                          Icon(
                            Icons.error_outline,
                            color:
                                Colors.red.shade700,
                            size: 18,
                          ),
                          const SizedBox(width: 8),
                          Expanded(
                            child: Text(
                              viewModel.errorMessage ??
                                  '',
                              style:
                                  GoogleFonts.manrope(
                                fontSize: 13,
                                color: Colors
                                    .red.shade700,
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],

                  const SizedBox(height: 32),

                  // Login button
                  AppButton(
                    label: 'Sign In',
                    isLoading: viewModel.isBusy,
                    onPressed: viewModel.login,
                  ),

                  verticalSpaceLarge,
                ],
              ),
            ),
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

  Widget _buildTextField({
    required TextEditingController controller,
    required String hint,
    required IconData icon,
    TextInputType keyboardType =
        TextInputType.text,
    bool obscure = false,
    Widget? suffixIcon,
  }) {
    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: .03,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        obscureText: obscure,
        keyboardType: keyboardType,
        decoration: InputDecoration(
          border: InputBorder.none,
          prefixIcon: Icon(
            icon,
            color: kcMediumGrey.withValues(
              alpha: 0.5,
            ),
            size: 22,
          ),
          suffixIcon: suffixIcon,
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

  @override
  LoginViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      LoginViewModel();
}

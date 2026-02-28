import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

/// Reusable form field widgets for the pet-owner
/// create/edit form.
class PetOwnerFormFields extends StatelessWidget {
  /// Creates [PetOwnerFormFields].
  const PetOwnerFormFields({
    required this.firstNameController,
    required this.lastNameController,
    required this.phoneController,
    required this.emailController,
    required this.onPhoneLookup,
    required this.isLookingUp,
    this.lookupHint,
    super.key,
  });

  /// Controller for first name.
  final TextEditingController firstNameController;

  /// Controller for last name.
  final TextEditingController lastNameController;

  /// Controller for phone.
  final TextEditingController phoneController;

  /// Controller for email.
  final TextEditingController emailController;

  /// Called to trigger phone lookup.
  final VoidCallback onPhoneLookup;

  /// Whether a phone lookup is in progress.
  final bool isLookingUp;

  /// Hint text after phone lookup.
  final String? lookupHint;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        _Label(label: 'FIRST NAME *'),
        const SizedBox(height: 8),
        _Field(
          controller: firstNameController,
          hint: 'Enter first name',
        ),
        const SizedBox(height: 20),
        _Label(label: 'LAST NAME *'),
        const SizedBox(height: 8),
        _Field(
          controller: lastNameController,
          hint: 'Enter last name',
        ),
        const SizedBox(height: 20),
        _Label(label: 'PHONE *'),
        const SizedBox(height: 8),
        _PhoneField(
          controller: phoneController,
          onLookup: onPhoneLookup,
          isLookingUp: isLookingUp,
        ),
        if (lookupHint != null) ...[
          const SizedBox(height: 6),
          Text(
            lookupHint!,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: kcStatusPending,
            ),
          ),
        ],
        const SizedBox(height: 20),
        _Label(label: 'EMAIL'),
        const SizedBox(height: 8),
        _Field(
          controller: emailController,
          hint: 'Enter email (optional)',
          keyboardType:
              TextInputType.emailAddress,
        ),
      ],
    );
  }
}

class _Label extends StatelessWidget {
  const _Label({required this.label});

  final String label;

  @override
  Widget build(BuildContext context) {
    return Text(
      label,
      style: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: kcLightGrey,
        letterSpacing: 1,
      ),
    );
  }
}

class _Field extends StatelessWidget {
  const _Field({
    required this.controller,
    required this.hint,
    this.keyboardType,
  });

  final TextEditingController controller;
  final String hint;
  final TextInputType? keyboardType;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.03,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        keyboardType: keyboardType,
        style: GoogleFonts.manrope(
          fontSize: 14,
          color: kcDarkGreyColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.manrope(
            color: kcLightGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _PhoneField extends StatelessWidget {
  const _PhoneField({
    required this.controller,
    required this.onLookup,
    required this.isLookingUp,
  });

  final TextEditingController controller;
  final VoidCallback onLookup;
  final bool isLookingUp;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.03,
            ),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Row(
        children: [
          Expanded(
            child: TextField(
              controller: controller,
              keyboardType: TextInputType.phone,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: kcDarkGreyColor,
              ),
              decoration: InputDecoration(
                hintText: 'Enter phone number',
                hintStyle: GoogleFonts.manrope(
                  color: kcLightGrey,
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                ),
                border: InputBorder.none,
                contentPadding:
                    const EdgeInsets.symmetric(
                  vertical: 16,
                ),
              ),
            ),
          ),
          if (isLookingUp)
            const SizedBox(
              width: 20,
              height: 20,
              child:
                  CircularProgressIndicator(
                strokeWidth: 2,
                color: kcPrimaryColor,
              ),
            )
          else
            GestureDetector(
              onTap: onLookup,
              child: const Icon(
                Icons.search_rounded,
                color: kcPrimaryColor,
              ),
            ),
        ],
      ),
    );
  }
}

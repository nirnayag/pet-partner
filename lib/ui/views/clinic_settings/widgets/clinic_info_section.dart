import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/staff_form/widgets/staff_form_fields.dart';

/// The clinic info section of the settings
/// screen.
class ClinicInfoSection extends StatelessWidget {
  /// Creates a [ClinicInfoSection].
  const ClinicInfoSection({
    required this.nameController,
    required this.emailController,
    required this.phoneController,
    required this.streetController,
    required this.cityController,
    required this.stateController,
    required this.zipCodeController,
    required this.countryController,
    super.key,
  });

  /// Name controller.
  final TextEditingController nameController;

  /// Email controller.
  final TextEditingController emailController;

  /// Phone controller.
  final TextEditingController phoneController;

  /// Street controller.
  final TextEditingController streetController;

  /// City controller.
  final TextEditingController cityController;

  /// State controller.
  final TextEditingController stateController;

  /// Zip code controller.
  final TextEditingController zipCodeController;

  /// Country controller.
  final TextEditingController countryController;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Clinic Information',
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 16),
        StaffFormField(
          controller: nameController,
          label: 'Clinic Name',
          hint: 'My Vet Clinic',
        ),
        const SizedBox(height: 12),
        StaffFormField(
          controller: emailController,
          label: 'Email',
          hint: 'contact@clinic.com',
          keyboardType:
              TextInputType.emailAddress,
        ),
        const SizedBox(height: 12),
        StaffFormField(
          controller: phoneController,
          label: 'Phone',
          hint: '+1 234 567 890',
          keyboardType: TextInputType.phone,
        ),
        const SizedBox(height: 16),
        Text(
          'Address',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w700,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 12),
        StaffFormField(
          controller: streetController,
          label: 'Street',
          hint: '123 Main St',
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StaffFormField(
                controller: cityController,
                label: 'City',
                hint: 'New York',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StaffFormField(
                controller: stateController,
                label: 'State',
                hint: 'NY',
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            Expanded(
              child: StaffFormField(
                controller: zipCodeController,
                label: 'Zip Code',
                hint: '10001',
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: StaffFormField(
                controller: countryController,
                label: 'Country',
                hint: 'US',
              ),
            ),
          ],
        ),
      ],
    );
  }
}

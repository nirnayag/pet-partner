import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/models/auth/user.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/staff_form/staff_form_viewmodel.dart';
import 'package:partner/ui/views/staff_form/widgets/role_selector.dart';
import 'package:partner/ui/views/staff_form/widgets/staff_form_fields.dart';
import 'package:stacked/stacked.dart';

/// Form view for creating or editing a staff
/// member.
class StaffFormView
    extends StackedView<StaffFormViewModel> {
  /// Creates a [StaffFormView].
  const StaffFormView({this.user, super.key});

  /// The user to edit, or `null` for create.
  final User? user;

  @override
  StaffFormViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StaffFormViewModel(user: user);

  @override
  void onViewModelReady(
    StaffFormViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    StaffFormViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Column(
        children: [
          _FormAppBar(
            isEditMode: viewModel.isEditMode,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                120,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (viewModel.errorMessage !=
                      null)
                    _ErrorBanner(
                      message: viewModel
                          .errorMessage!,
                    ),
                  StaffFormField(
                    controller: viewModel
                        .firstNameController,
                    label: 'First Name *',
                    hint: 'John',
                  ),
                  const SizedBox(height: 16),
                  StaffFormField(
                    controller: viewModel
                        .lastNameController,
                    label: 'Last Name *',
                    hint: 'Doe',
                  ),
                  const SizedBox(height: 16),
                  StaffFormField(
                    controller: viewModel
                        .emailController,
                    label: 'Email *',
                    hint: 'john@clinic.com',
                    keyboardType: TextInputType
                        .emailAddress,
                  ),
                  const SizedBox(height: 16),
                  StaffFormField(
                    controller: viewModel
                        .phoneController,
                    label: 'Phone',
                    hint: '+1 234 567 890',
                    keyboardType:
                        TextInputType.phone,
                  ),
                  const SizedBox(height: 16),
                  RoleSelector(
                    selectedRole:
                        viewModel.selectedRole,
                    onChanged: viewModel.setRole,
                  ),
                  if (!viewModel.isEditMode) ...[
                    const SizedBox(height: 16),
                    StaffFormField(
                      controller: viewModel
                          .passwordController,
                      label: 'Password *',
                      hint: 'Min 8 characters',
                      obscureText: true,
                    ),
                  ],
                  if (viewModel
                      .showVetFields) ...[
                    const SizedBox(height: 16),
                    StaffFormField(
                      controller: viewModel
                          .specializationController,
                      label: 'Specialization',
                      hint: 'e.g. Surgery',
                    ),
                    const SizedBox(height: 16),
                    StaffFormField(
                      controller:
                          viewModel.bioController,
                      label: 'Bio',
                      hint: 'Short biography...',
                      maxLines: 3,
                    ),
                  ],
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _SubmitButton(
        isBusy: viewModel.isBusy,
        isEditMode: viewModel.isEditMode,
        onTap: viewModel.save,
      ),
    );
  }
}

class _FormAppBar extends StatelessWidget {
  const _FormAppBar({required this.isEditMode});

  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        50,
        16,
        16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: kcVeryLightGrey,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: kcDarkGreyColor,
            ),
          ),
          Text(
            isEditMode
                ? 'Edit Staff'
                : 'Add Staff',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red
              .withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        message,
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.red[700],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.isBusy,
    required this.isEditMode,
    required this.onTap,
  });

  final bool isBusy;
  final bool isEditMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        40,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: isBusy ? null : onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isBusy
                ? kcLightGrey
                : kcPrimaryColor,
            borderRadius:
                BorderRadius.circular(18),
          ),
          child: Center(
            child: isBusy
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    isEditMode
                        ? 'Update Staff'
                        : 'Create Staff',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: kcNeutral900,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

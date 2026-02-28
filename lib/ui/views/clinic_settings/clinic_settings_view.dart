import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/clinic_settings/clinic_settings_viewmodel.dart';
import 'package:partner/ui/views/clinic_settings/widgets/clinic_info_section.dart';
import 'package:partner/ui/views/clinic_settings/widgets/notification_settings_section.dart';
import 'package:partner/ui/views/clinic_settings/widgets/operational_settings_section.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

/// Clinic settings screen with info, operational
/// settings, and notification preferences.
class ClinicSettingsView
    extends StackedView<ClinicSettingsViewModel> {
  /// Creates a [ClinicSettingsView].
  const ClinicSettingsView({super.key});

  @override
  ClinicSettingsViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ClinicSettingsViewModel();

  @override
  void onViewModelReady(
    ClinicSettingsViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    ClinicSettingsViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            _AppBar(viewModel: viewModel),
            Expanded(
              child: _buildBody(viewModel),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildBody(
    ClinicSettingsViewModel viewModel,
  ) {
    if (viewModel.isBusy) {
      return const LoadingShimmer(
        type: ShimmerType.detail,
      );
    }

    if (viewModel.errorMessage != null &&
        viewModel.clinic == null) {
      return ErrorState(
        message: viewModel.errorMessage!,
        onRetry: viewModel.initialise,
      );
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        40,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          if (viewModel.successMessage != null)
            _SuccessBanner(
              message:
                  viewModel.successMessage!,
            ),
          if (viewModel.errorMessage != null)
            _ErrorBanner(
              message:
                  viewModel.errorMessage!,
            ),
          ClinicInfoSection(
            nameController:
                viewModel.nameController,
            emailController:
                viewModel.emailController,
            phoneController:
                viewModel.phoneController,
            streetController:
                viewModel.streetController,
            cityController:
                viewModel.cityController,
            stateController:
                viewModel.stateController,
            zipCodeController:
                viewModel.zipCodeController,
            countryController:
                viewModel.countryController,
          ),
          const SizedBox(height: 16),
          _SaveButton(
            isBusy: viewModel.isSaving,
            label: 'Save Clinic Info',
            onTap: viewModel.saveClinicInfo,
          ),
          const SizedBox(height: 32),
          OperationalSettingsSection(
            settings: viewModel.settings,
            onSave: viewModel.saveSettings,
          ),
          const SizedBox(height: 32),
          NotificationSettingsSection(
            settings: viewModel.settings,
            onSave: viewModel.saveSettings,
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({required this.viewModel});

  final ClinicSettingsViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          GestureDetector(
            onTap: () =>
                Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: kcDarkGreyColor,
            ),
          ),
          const SizedBox(width: 12),
          Text(
            'Clinic Settings',
            style: GoogleFonts.manrope(
              fontSize: 22,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _SaveButton extends StatelessWidget {
  const _SaveButton({
    required this.isBusy,
    required this.label,
    required this.onTap,
  });

  final bool isBusy;
  final String label;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isBusy ? null : onTap,
      child: Container(
        height: 48,
        decoration: BoxDecoration(
          color: isBusy
              ? kcLightGrey
              : kcPrimaryColor,
          borderRadius:
              BorderRadius.circular(14),
        ),
        child: Center(
          child: isBusy
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child:
                      CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: kcNeutral900,
                  ),
                ),
        ),
      ),
    );
  }
}

class _SuccessBanner extends StatelessWidget {
  const _SuccessBanner({
    required this.message,
  });

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: kcPrimaryColor
            .withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: kcPrimaryColor
              .withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        message,
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: kcPrimaryColorDark,
        ),
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

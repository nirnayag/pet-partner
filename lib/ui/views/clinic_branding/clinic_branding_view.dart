import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/clinic_branding/clinic_branding_viewmodel.dart';
import 'package:partner/ui/views/clinic_branding/widgets/branding_preview.dart';
import 'package:partner/ui/views/clinic_branding/widgets/color_picker_section.dart';
import 'package:partner/ui/views/clinic_branding/widgets/logo_picker_section.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

/// Clinic branding screen for logo and colour
/// configuration.
class ClinicBrandingView
    extends StackedView<ClinicBrandingViewModel> {
  /// Creates a [ClinicBrandingView].
  const ClinicBrandingView({super.key});

  @override
  ClinicBrandingViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ClinicBrandingViewModel();

  @override
  void onViewModelReady(
    ClinicBrandingViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    ClinicBrandingViewModel viewModel,
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
      bottomSheet: viewModel.branding != null
          ? _SaveButton(
              isBusy: viewModel.isSaving,
              onTap: viewModel.save,
            )
          : null,
    );
  }

  Widget _buildBody(
    ClinicBrandingViewModel viewModel,
  ) {
    if (viewModel.isBusy) {
      return const LoadingShimmer(
        type: ShimmerType.detail,
      );
    }

    if (viewModel.errorMessage != null &&
        viewModel.branding == null) {
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
        120,
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
          LogoPickerSection(
            logoUrl: viewModel.logoUrl,
          ),
          const SizedBox(height: 32),
          ColorPickerSection(
            selectedColor:
                viewModel.primaryColor,
            onColorSelected:
                viewModel.setPrimaryColor,
          ),
          const SizedBox(height: 32),
          BrandingPreview(
            primaryColor: viewModel.parsedColor,
            logoUrl: viewModel.logoUrl,
          ),
        ],
      ),
    );
  }
}

class _AppBar extends StatelessWidget {
  const _AppBar({required this.viewModel});

  final ClinicBrandingViewModel viewModel;

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
            'Clinic Branding',
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
    required this.onTap,
  });

  final bool isBusy;
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
                    'Save Branding',
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

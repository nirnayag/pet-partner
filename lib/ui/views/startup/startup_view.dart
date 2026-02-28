import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/startup/startup_viewmodel.dart';
import 'package:stacked/stacked.dart';

class StartupView
    extends StackedView<StartupViewModel> {
  const StartupView({super.key});

  @override
  Widget builder(
    BuildContext context,
    StartupViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcPrimaryColor,
      body: Center(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            // App Icon
            Container(
              height: 100,
              width: 100,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius:
                    BorderRadius.circular(28),
              ),
              child: const Icon(
                Icons.pets,
                color: kcPrimaryColor,
                size: 52,
              ),
            ),
            const SizedBox(height: 24),
            Text(
              'Pet Partner',
              style: GoogleFonts.manrope(
                fontSize: 32,
                fontWeight: FontWeight.w800,
                color: Colors.white,
              ),
            ),
            const SizedBox(height: 8),
            Text(
              'Clinic Management',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w500,
                color: Colors.white.withValues(
                  alpha: 0.8,
                ),
              ),
            ),
            const SizedBox(height: 48),
            const SizedBox(
              width: 28,
              height: 28,
              child: CircularProgressIndicator(
                color: Colors.white,
                strokeWidth: 3,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  StartupViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StartupViewModel();

  @override
  void onViewModelReady(
    StartupViewModel viewModel,
  ) =>
      SchedulerBinding.instance
          .addPostFrameCallback(
        (_) => viewModel.runStartupLogic(),
      );
}

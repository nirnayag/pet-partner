import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/common/app_snackbar.dart';
import 'package:partner/ui/views/doctor_profile/doctor_profile_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// Profile screen for the logged-in clinic user.
///
/// Displays real user data from the auth service
/// and supports notification toggles and logout.
class DoctorProfileView
    extends StackedView<DoctorProfileViewModel> {
  /// Creates a [DoctorProfileView].
  const DoctorProfileView({super.key});

  @override
  Widget builder(
    BuildContext context,
    DoctorProfileViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: ListView(
                padding:
                    const EdgeInsets.all(20),
                children: [
                  _ProfileSection(
                    viewModel: viewModel,
                  ),
                  const SizedBox(height: 24),
                  const _WorkingHours(),
                  const SizedBox(height: 24),
                  _NotificationSection(
                    viewModel: viewModel,
                  ),
                  const SizedBox(height: 20),
                  const _HelpButton(),
                  const SizedBox(height: 16),
                  _LogoutButton(
                    onTap: viewModel.logout,
                    isBusy: viewModel.isBusy,
                  ),
                  const SizedBox(height: 120),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  DoctorProfileViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DoctorProfileViewModel();
}

// ====================================================
// Header
// ====================================================

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 16,
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
          Text(
            'Profile',
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
          GestureDetector(
            onTap: () => AppSnackbar.showInfo(
              context,
              'Settings coming soon',
            ),
            child: const Icon(
              Icons.settings_outlined,
              color: kcDarkGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================
// Profile section (real user data)
// ====================================================

class _ProfileSection extends StatelessWidget {
  const _ProfileSection({
    required this.viewModel,
  });

  final DoctorProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            Container(
              decoration: BoxDecoration(
                shape: BoxShape.circle,
                border: Border.all(
                  color: Colors.white,
                  width: 4,
                ),
                boxShadow: [
                  BoxShadow(
                    color:
                        Colors.black.withValues(
                      alpha: 0.1,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: CircleAvatar(
                radius: 48,
                backgroundColor: kcVeryLightGrey,
                backgroundImage:
                    viewModel.avatarUrl != null
                        ? NetworkImage(
                            viewModel.avatarUrl!,
                          )
                        : null,
                child:
                    viewModel.avatarUrl == null
                        ? const Icon(
                            Icons.person,
                            size: 40,
                            color: kcLightGrey,
                          )
                        : null,
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: GestureDetector(
                onTap: () =>
                    AppSnackbar.showInfo(
                  context,
                  'Photo upload coming soon',
                ),
                child: Container(
                  padding:
                      const EdgeInsets.all(6),
                  decoration:
                      const BoxDecoration(
                    color: kcPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.edit,
                    size: 14,
                    color: Colors.white,
                  ),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Text(
          viewModel.userName,
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          viewModel.specialization,
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: kcPrimaryColor,
          ),
        ),
        if (viewModel.email.isNotEmpty) ...[
          const SizedBox(height: 12),
          Container(
            padding:
                const EdgeInsets.symmetric(
              horizontal: 12,
              vertical: 6,
            ),
            decoration: BoxDecoration(
              color: kcNeutral100,
              borderRadius:
                  BorderRadius.circular(20),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                const Icon(
                  Icons.email_outlined,
                  size: 14,
                  color: kcNeutral500,
                ),
                const SizedBox(width: 6),
                Text(
                  viewModel.email,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w700,
                    color: kcNeutral800,
                  ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

// ====================================================
// Working hours (static for now)
// ====================================================

class _WorkingHours extends StatelessWidget {
  const _WorkingHours();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            Text(
              'Working Hours',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: kcDarkGreyColor,
              ),
            ),
            GestureDetector(
              onTap: () => AppSnackbar.showInfo(
                context,
                'Working hours management'
                ' coming soon',
              ),
              child: Text(
                'Manage',
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: kcPrimaryColor,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(24),
            border: Border.all(
              color:
                  kcVeryLightGrey.withValues(
                alpha: 0.5,
              ),
            ),
          ),
          child: const Column(
            children: [
              _WorkingHourTile(
                days: 'Mon - Fri',
                time: '09:00 AM - 05:00 PM',
                label: 'Standard Shift',
                icon: Icons
                    .calendar_today_rounded,
                iconColor: Colors.blue,
              ),
              Divider(height: 1, indent: 64),
              _WorkingHourTile(
                days: 'Saturday',
                time: '10:00 AM - 02:00 PM',
                label: 'Half Day',
                icon: Icons.weekend_rounded,
                iconColor: Colors.purple,
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _WorkingHourTile extends StatelessWidget {
  const _WorkingHourTile({
    required this.days,
    required this.time,
    required this.label,
    required this.icon,
    required this.iconColor,
    this.isLast = false,
  });

  final String days;
  final String time;
  final String label;
  final IconData icon;
  final Color iconColor;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: iconColor.withValues(
                alpha: 0.1,
              ),
              shape: BoxShape.circle,
            ),
            child: Icon(
              icon,
              color: iconColor,
              size: 18,
            ),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                Text(
                  days,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: kcDarkGreyColor,
                  ),
                ),
                Text(
                  label,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kcMediumGrey,
                  ),
                ),
              ],
            ),
          ),
          Text(
            time,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w700,
              color: kcDarkGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}

// ====================================================
// Notification section
// ====================================================

class _NotificationSection
    extends StatelessWidget {
  const _NotificationSection({
    required this.viewModel,
  });

  final DoctorProfileViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'Notification Preferences',
          style: GoogleFonts.manrope(
            fontSize: 16,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(24),
            border: Border.all(
              color:
                  kcVeryLightGrey.withValues(
                alpha: 0.5,
              ),
            ),
          ),
          child: Column(
            children: [
              _ToggleTile(
                title: 'Email Alerts',
                icon: Icons.email_outlined,
                value: viewModel
                    .isEmailAlertsEnabled,
                onChanged: (v) => viewModel
                    .toggleEmailAlerts(
                  value: v,
                ),
              ),
              const Divider(
                height: 1,
                indent: 56,
              ),
              _ToggleTile(
                title: 'In-App Alerts',
                icon: Icons
                    .notifications_active_outlined,
                value: viewModel
                    .isInAppAlertsEnabled,
                onChanged: (v) => viewModel
                    .toggleInAppAlerts(
                  value: v,
                ),
              ),
              const Divider(
                height: 1,
                indent: 56,
              ),
              _ToggleTile(
                title: 'SMS Updates',
                icon: Icons.sms_outlined,
                value: viewModel
                    .isSmsUpdatesEnabled,
                onChanged: (v) => viewModel
                    .toggleSmsUpdates(
                  value: v,
                ),
                isLast: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ToggleTile extends StatelessWidget {
  const _ToggleTile({
    required this.title,
    required this.icon,
    required this.value,
    required this.onChanged,
    this.isLast = false,
  });

  final String title;
  final IconData icon;
  final bool value;
  final ValueChanged<bool> onChanged;
  final bool isLast;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      child: Row(
        children: [
          Icon(
            icon,
            color: kcLightGrey,
            size: 22,
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Text(
              title,
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: kcDarkGreyColor,
              ),
            ),
          ),
          Switch.adaptive(
            value: value,
            onChanged: onChanged,
            activeTrackColor: kcPrimaryColor,
          ),
        ],
      ),
    );
  }
}

// ====================================================
// Help button
// ====================================================

class _HelpButton extends StatelessWidget {
  const _HelpButton();

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () => AppSnackbar.showInfo(
        context,
        'Help & Support coming soon',
      ),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(20),
          border: Border.all(
            color: kcVeryLightGrey.withValues(
              alpha: 0.5,
            ),
          ),
        ),
        child: Row(
          children: [
            const Icon(
              Icons.help_outline_rounded,
              color: kcLightGrey,
            ),
            const SizedBox(width: 12),
            Text(
              'Help & Support',
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: kcDarkGreyColor,
              ),
            ),
            const Spacer(),
            const Icon(
              Icons.chevron_right_rounded,
              color: kcLightGrey,
            ),
          ],
        ),
      ),
    );
  }
}

// ====================================================
// Logout button
// ====================================================

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({
    required this.onTap,
    required this.isBusy,
  });

  final VoidCallback onTap;
  final bool isBusy;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isBusy ? null : onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius:
              BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            if (isBusy)
              const SizedBox(
                width: 20,
                height: 20,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color: Colors.red,
                ),
              )
            else
              const Icon(
                Icons.logout_rounded,
                color: Colors.red,
                size: 20,
              ),
            const SizedBox(width: 8),
            Text(
              isBusy
                  ? 'Logging out...'
                  : 'Log Out',
              style: GoogleFonts.manrope(
                fontSize: 15,
                fontWeight: FontWeight.w800,
                color: Colors.red,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

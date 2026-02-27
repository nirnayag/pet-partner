import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/doctor_profile/doctor_profile_viewmodel.dart';
import 'package:stacked/stacked.dart';

class DoctorProfileView
    extends StackedView<DoctorProfileViewModel> {
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
                padding: const EdgeInsets.all(20),
                children: [
                  const _ProfileSection(),
                  const SizedBox(height: 24),
                  const _DigitalSignature(),
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
          const Icon(
            Icons.settings_outlined,
            color: kcDarkGreyColor,
          ),
        ],
      ),
    );
  }
}

class _ProfileSection extends StatelessWidget {
  const _ProfileSection();

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
                    color: Colors.black.withValues(
                      alpha: 0.1,
                    ),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: const CircleAvatar(
                radius: 48,
                backgroundImage: NetworkImage(
                  'https://lh3.googleusercontent'
                  '.com/aida-public/AB6AXuDZw0fxq'
                  'VSMpmJRdqJMLQGYmOVcVjbL1nIx_zle'
                  'fzpBXaYPsLmuGlbj7zDKAjlWzvu4SsF'
                  'wP6mnPlIZ9rdl4g2Ne9guBp2D9sPHFUh'
                  '2rRkdprMDms600_J5ghMrnMOcKtOHURl'
                  'h1CykiK_NLAmJ_l57Xs-7jQ8sbNFRfMv'
                  'YeRwyNtjxFMDIIPaTPJStcaQrultw0AN8'
                  'oGpces9ZhbvV2pT4264vbcjiCl733TPfs'
                  'DFkQFAD5tBBlrjM2M8o6xWfvhIzgMc8X'
                  'WShLE4',
                ),
              ),
            ),
            Positioned(
              bottom: 4,
              right: 4,
              child: Container(
                padding: const EdgeInsets.all(6),
                decoration: const BoxDecoration(
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
          ],
        ),
        const SizedBox(height: 16),
        Text(
          'Dr. Alex',
          style: GoogleFonts.manrope(
            fontSize: 24,
            fontWeight: FontWeight.w900,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 4),
        Text(
          'Senior Veterinarian',
          style: GoogleFonts.manrope(
            fontSize: 14,
            fontWeight: FontWeight.w700,
            color: kcPrimaryColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.symmetric(
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
                Icons.verified_rounded,
                size: 14,
                color: kcNeutral500,
              ),
              const SizedBox(width: 6),
              Text(
                'LIC-88294-VET',
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
    );
  }
}

class _DigitalSignature extends StatelessWidget {
  const _DigitalSignature();

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
              'Digital Signature',
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w800,
                color: kcDarkGreyColor,
              ),
            ),
            Text(
              'Edit',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: kcPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        Container(
          height: 96,
          width: double.infinity,
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(24),
            border: Border.all(
              color: kcVeryLightGrey.withValues(
                alpha: 0.5,
              ),
            ),
            image: const DecorationImage(
              image: NetworkImage(
                'https://lh3.googleusercontent'
                '.com/aida-public/AB6AXuBbjiMjzS'
                '-3nA79HHO50durmkFMxrI0vf0K5QAFXDq'
                '3sTFeNRoZJ_RxzxC6USan4kDAWzrfdxOp'
                'Erk158EOckOZa9JsV7b8ze5yebpvWN8Nh'
                'eoN5DqCnus5XuvzzCHhf4Kki-h_1sFr2g'
                'fzsv_l0knhQ0ILKj-2VeudtNtfqsmt9FE'
                '0QUWtHOvZzJa0Nsn544RnhIud4DMNIyx3'
                'kpulYwDLrNjFtLUCSsQ9EUdiVz6ysf8bQ'
                'hxGpTXSTDQ1q9oHPlXPBCymbxvwtFE',
              ),
              fit: BoxFit.contain,
              opacity: 0.7,
            ),
          ),
        ),
      ],
    );
  }
}

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
            Text(
              'Manage',
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: kcPrimaryColor,
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
              color: kcVeryLightGrey.withValues(
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
                icon:
                    Icons.calendar_today_rounded,
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
              color: kcVeryLightGrey.withValues(
                alpha: 0.5,
              ),
            ),
          ),
          child: Column(
            children: [
              _ToggleTile(
                title: 'Email Alerts',
                icon: Icons.email_outlined,
                value:
                    viewModel.isEmailAlertsEnabled,
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
                value:
                    viewModel.isInAppAlertsEnabled,
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
                value:
                    viewModel.isSmsUpdatesEnabled,
                onChanged: (v) => viewModel
                    .toggleSmsUpdates(value: v),
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
          Icon(icon, color: kcLightGrey, size: 22),
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

class _HelpButton extends StatelessWidget {
  const _HelpButton();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
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
    );
  }
}

class _LogoutButton extends StatelessWidget {
  const _LogoutButton({required this.onTap});

  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 56,
        decoration: BoxDecoration(
          color: const Color(0xFFFFEBEE),
          borderRadius: BorderRadius.circular(20),
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.center,
          children: [
            const Icon(
              Icons.logout_rounded,
              color: Colors.red,
              size: 20,
            ),
            const SizedBox(width: 8),
            Text(
              'Log Out',
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

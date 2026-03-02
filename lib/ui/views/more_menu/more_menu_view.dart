import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/enums/user_role.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/more_menu/more_menu_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// A role-specific menu screen shown as a bottom
/// navigation tab for staff and clinic admin users.
///
/// Provides quick access to views that are not part
/// of the shared bottom navigation (e.g. pet owners,
/// documents, staff management, reports).
class MoreMenuView
    extends StackedView<MoreMenuViewModel> {
  /// Creates a [MoreMenuView].
  const MoreMenuView({super.key});

  @override
  Widget builder(
    BuildContext context,
    MoreMenuViewModel viewModel,
    Widget? child,
  ) {
    final items = _menuItemsForRole(
      viewModel.currentRole,
    );

    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: SafeArea(
        child: Column(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            _Header(role: viewModel.currentRole),
            Expanded(
              child: ListView.separated(
                padding: const EdgeInsets.all(20),
                itemCount: items.length,
                separatorBuilder: (_, __) =>
                    const SizedBox(height: 12),
                itemBuilder: (_, index) {
                  final item = items[index];
                  return _MenuTile(
                    icon: item.icon,
                    title: item.title,
                    subtitle: item.subtitle,
                    color: item.color,
                    onTap: () => viewModel
                        .navigateTo(item.route),
                  );
                },
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  MoreMenuViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MoreMenuViewModel();

  List<_MenuItem> _menuItemsForRole(UserRole role) {
    switch (role) {
      case UserRole.staff:
        return const [
          _MenuItem(
            icon: Icons.people_outline_rounded,
            title: 'Pet Owners',
            subtitle: 'Manage pet owner accounts',
            color: Colors.blue,
            route: Routes.petOwnerListView,
          ),
          _MenuItem(
            icon: Icons.folder_outlined,
            title: 'Documents',
            subtitle: 'Upload and manage documents',
            color: Colors.orange,
            route: Routes.documentListView,
          ),
          _MenuItem(
            icon: Icons.pending_actions_rounded,
            title: 'Pending Appointments',
            subtitle: 'Review pending requests',
            color: Colors.purple,
            route: Routes.pendingAppointmentsView,
          ),
        ];
      case UserRole.clinicAdmin:
        return const [
          _MenuItem(
            icon: Icons.badge_outlined,
            title: 'Staff Management',
            subtitle: 'Manage clinic staff',
            color: Colors.blue,
            route: Routes.staffListView,
          ),
          _MenuItem(
            icon: Icons.settings_outlined,
            title: 'Clinic Settings',
            subtitle: 'Configure clinic preferences',
            color: Colors.teal,
            route: Routes.clinicSettingsView,
          ),
          _MenuItem(
            icon: Icons
                .notifications_active_outlined,
            title: 'Reminders',
            subtitle:
                'Manage appointment reminders',
            color: Colors.orange,
            route: Routes.reminderListView,
          ),
          _MenuItem(
            icon: Icons.bar_chart_rounded,
            title: 'Reports',
            subtitle:
                'View clinic analytics & reports',
            color: Colors.purple,
            route: Routes.reportsView,
          ),
          _MenuItem(
            icon: Icons.people_outline_rounded,
            title: 'Pet Owners',
            subtitle: 'Manage pet owner accounts',
            color: Colors.indigo,
            route: Routes.petOwnerListView,
          ),
          _MenuItem(
            icon: Icons.folder_outlined,
            title: 'Documents',
            subtitle: 'Upload and manage documents',
            color: Colors.brown,
            route: Routes.documentListView,
          ),
        ];
      case UserRole.veterinarian:
        return const [];
    }
  }
}

// ====================================================
// Header
// ====================================================

class _Header extends StatelessWidget {
  const _Header({required this.role});

  final UserRole role;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        10,
      ),
      child: Text(
        role == UserRole.clinicAdmin
            ? 'Management'
            : 'More',
        style: GoogleFonts.manrope(
          fontSize: 24,
          fontWeight: FontWeight.w800,
          color: kcDarkGreyColor,
        ),
      ),
    );
  }
}

// ====================================================
// Menu item data
// ====================================================

class _MenuItem {
  const _MenuItem({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.route,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final String route;
}

// ====================================================
// Menu tile
// ====================================================

class _MenuTile extends StatelessWidget {
  const _MenuTile({
    required this.icon,
    required this.title,
    required this.subtitle,
    required this.color,
    required this.onTap,
  });

  final IconData icon;
  final String title;
  final String subtitle;
  final Color color;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.all(16),
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
            Container(
              padding: const EdgeInsets.all(10),
              decoration: BoxDecoration(
                color: color.withValues(
                  alpha: 0.1,
                ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                icon,
                color: color,
                size: 22,
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 15,
                      fontWeight: FontWeight.w800,
                      color: kcDarkGreyColor,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    subtitle,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w500,
                      color: kcMediumGrey,
                    ),
                  ),
                ],
              ),
            ),
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

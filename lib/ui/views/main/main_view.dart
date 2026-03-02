import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/core/enums/user_role.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/doctor_profile/doctor_profile_view.dart';
import 'package:partner/ui/views/home/home_view.dart';
import 'package:partner/ui/views/main/main_viewmodel.dart';
import 'package:partner/ui/views/more_menu/more_menu_view.dart';
import 'package:partner/ui/views/patient_registry/patient_registry_view.dart';
import 'package:partner/ui/views/schedule/schedule_view.dart';
import 'package:stacked/stacked.dart';

/// Root container that holds all bottom-nav tabs
/// using an [IndexedStack] so that each tab preserves
/// its state (scroll position, loaded data, etc.).
class MainView extends StackedView<MainViewModel> {
  /// Creates the main view.
  const MainView({super.key});

  @override
  Widget builder(
    BuildContext context,
    MainViewModel viewModel,
    Widget? child,
  ) {
    final pages = _pagesForRole(viewModel.currentRole);
    final tabs = _tabsForRole(viewModel.currentRole);

    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: IndexedStack(
        index: viewModel.currentIndex,
        children: pages,
      ),
      bottomNavigationBar: _BottomNav(
        currentIndex: viewModel.currentIndex,
        tabs: tabs,
        onTap: viewModel.setIndex,
      ),
    );
  }

  @override
  MainViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      MainViewModel();

  // --------------------------------------------------
  // Pages per role
  // --------------------------------------------------

  List<Widget> _pagesForRole(UserRole role) {
    switch (role) {
      case UserRole.veterinarian:
        return const [
          HomeView(),
          PatientRegistryView(),
          ScheduleView(),
          DoctorProfileView(),
        ];
      case UserRole.staff:
        return const [
          HomeView(),
          PatientRegistryView(),
          ScheduleView(),
          MoreMenuView(),
          DoctorProfileView(),
        ];
      case UserRole.clinicAdmin:
        return const [
          HomeView(),
          PatientRegistryView(),
          ScheduleView(),
          MoreMenuView(),
          DoctorProfileView(),
        ];
    }
  }

  // --------------------------------------------------
  // Tab definitions per role
  // --------------------------------------------------

  List<_TabItem> _tabsForRole(UserRole role) {
    switch (role) {
      case UserRole.veterinarian:
        return const [
          _TabItem(
            icon: Icons.grid_view_rounded,
            label: 'Home',
          ),
          _TabItem(
            icon: Icons.pets_rounded,
            label: 'Patients',
          ),
          _TabItem(
            icon: Icons.calendar_month_rounded,
            label: 'Schedule',
          ),
          _TabItem(
            icon: Icons.person_rounded,
            label: 'Profile',
          ),
        ];
      case UserRole.staff:
        return const [
          _TabItem(
            icon: Icons.grid_view_rounded,
            label: 'Home',
          ),
          _TabItem(
            icon: Icons.pets_rounded,
            label: 'Patients',
          ),
          _TabItem(
            icon: Icons.calendar_month_rounded,
            label: 'Schedule',
          ),
          _TabItem(
            icon: Icons.menu_rounded,
            label: 'More',
          ),
          _TabItem(
            icon: Icons.person_rounded,
            label: 'Profile',
          ),
        ];
      case UserRole.clinicAdmin:
        return const [
          _TabItem(
            icon: Icons.grid_view_rounded,
            label: 'Home',
          ),
          _TabItem(
            icon: Icons.pets_rounded,
            label: 'Patients',
          ),
          _TabItem(
            icon: Icons.calendar_month_rounded,
            label: 'Schedule',
          ),
          _TabItem(
            icon: Icons.dashboard_rounded,
            label: 'Manage',
          ),
          _TabItem(
            icon: Icons.person_rounded,
            label: 'Profile',
          ),
        ];
    }
  }
}

// ----------------------------------------------------
// Tab item data class
// ----------------------------------------------------

class _TabItem {
  const _TabItem({
    required this.icon,
    required this.label,
  });

  final IconData icon;
  final String label;
}

// ----------------------------------------------------
// Bottom navigation bar
// ----------------------------------------------------

class _BottomNav extends StatelessWidget {
  const _BottomNav({
    required this.currentIndex,
    required this.tabs,
    required this.onTap,
  });

  final int currentIndex;
  final List<_TabItem> tabs;
  final ValueChanged<int> onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          top: BorderSide(
            color: kcVeryLightGrey,
            width: 0.5,
          ),
        ),
      ),
      child: SafeArea(
        child: SizedBox(
          height: 64,
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceAround,
            children: List.generate(tabs.length, (i) {
              final tab = tabs[i];
              final isActive = i == currentIndex;

              return _NavItem(
                icon: tab.icon,
                label: tab.label,
                isActive: isActive,
                onTap: () => onTap(i),
              );
            }),
          ),
        ),
      ),
    );
  }
}

// ----------------------------------------------------
// Single nav item
// ----------------------------------------------------

class _NavItem extends StatelessWidget {
  const _NavItem({
    required this.icon,
    required this.label,
    required this.isActive,
    required this.onTap,
  });

  final IconData icon;
  final String label;
  final bool isActive;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      behavior: HitTestBehavior.opaque,
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(
              horizontal: 16,
              vertical: 4,
            ),
            decoration: BoxDecoration(
              color: isActive
                  ? kcPrimaryColor.withValues(
                      alpha: 0.2,
                    )
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isActive
                  ? kcPrimaryColorDark
                  : kcLightGrey,
              size: 26,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: isActive
                  ? FontWeight.w800
                  : FontWeight.w600,
              color: isActive
                  ? kcPrimaryColorDark
                  : kcLightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

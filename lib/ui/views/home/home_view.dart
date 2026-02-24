import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'home_viewmodel.dart';

class HomeView extends StackedView<HomeViewModel> {
  const HomeView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    HomeViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      bottomNavigationBar: _DashboardBottomNav(viewModel: viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kcPrimaryColor,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: kcNeutral900, size: 32),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Column(
          children: [
            const _DashboardHeader(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(horizontal: 20),
                children: [
                  const SizedBox(height: 10),
                  const _SummaryStatsGrid(),
                  const _SearchBar(),
                  const SizedBox(height: 24),
                  _AppointmentsSectionHeader(viewModel: viewModel),
                  const SizedBox(height: 16),
                  _AppointmentsList(viewModel: viewModel),
                  const SizedBox(height: 40),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  HomeViewModel viewModelBuilder(BuildContext context) => HomeViewModel();
}

class _DashboardHeader extends StatelessWidget {
  const _DashboardHeader();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(20),
      child: Row(
        children: [
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kcPrimaryColor, width: 2),
                ),
                padding: const EdgeInsets.all(2),
                child: const CircleAvatar(
                  radius: 24,
                  backgroundImage: NetworkImage(
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuDZw0fxqVSMpmJRdqJMLQGYmOVcVjbL1nIx_zlefzpBXaYPsLmuGlbj7zDKAjlWzvu4SsFwP6mnPlIZ9rdl4g2Ne9guBp2D9sPHFUh2rRkdprMDms600_J5ghMrnMOcKtOHURlh1CykiK_NLAmJ_l57Xs-7jQ8sbNFRfMvYeRwyNtjxFMDIIPaTPJStcaQrultw0AN8oGpces9ZhbvV2pT4264vbcjiCl733TPfsDFkQFAD5tBBlrjM2M8o6xWfvhIzgMc8XWShLE4"),
                ),
              ),
              Positioned(
                right: 2,
                bottom: 2,
                child: Container(
                  width: 12,
                  height: 12,
                  decoration: BoxDecoration(
                    color: kcPrimaryColor,
                    shape: BoxShape.circle,
                    border: Border.all(color: kcBackgroundColor, width: 2),
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(width: 12),
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Good Morning,",
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: kcMediumGrey,
                ),
              ),
              Text(
                "Dr. Alex",
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: kcDarkGreyColor,
                ),
              ),
            ],
          ),
          const Spacer(),
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(16),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withOpacity(0.05),
                  blurRadius: 10,
                )
              ],
            ),
            child: Stack(
              children: [
                const Icon(Icons.notifications_outlined,
                    color: kcDarkGreyColor),
                Positioned(
                  right: 2,
                  top: 2,
                  child: Container(
                    width: 8,
                    height: 8,
                    decoration: const BoxDecoration(
                      color: Colors.red,
                      shape: BoxShape.circle,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _SummaryStatsGrid extends StatelessWidget {
  const _SummaryStatsGrid();

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        _statCard("12", "TOTAL", false),
        const SizedBox(width: 12),
        _statCard("8", "PENDING", true),
        const SizedBox(width: 12),
        _statCard("4", "DONE", false, isDone: true),
      ],
    );
  }

  Widget _statCard(String value, String label, bool isPrimary,
      {bool isDone = false}) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 20),
        decoration: BoxDecoration(
          color: isPrimary ? kcPrimaryColor.withOpacity(0.1) : Colors.white,
          borderRadius: BorderRadius.circular(24),
          border: isPrimary
              ? Border.all(color: kcPrimaryColor.withOpacity(0.2))
              : Border.all(color: kcVeryLightGrey.withOpacity(0.5)),
        ),
        child: Column(
          children: [
            Text(
              value,
              style: GoogleFonts.manrope(
                fontSize: 28,
                fontWeight: FontWeight.w800,
                color: isDone
                    ? kcLightGrey
                    : (isPrimary ? kcPrimaryColorDark : kcDarkGreyColor),
              ),
            ),
            const SizedBox(height: 4),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w700,
                letterSpacing: 0.5,
                color: isDone
                    ? kcLightGrey
                    : (isPrimary ? kcPrimaryColorDark : kcMediumGrey),
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _SearchBar extends StatelessWidget {
  const _SearchBar();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 16),
      height: 56,
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [
          const Icon(Icons.search, color: kcLightGrey),
          const SizedBox(width: 12),
          Text(
            "Search for a patient...",
            style: GoogleFonts.manrope(
              color: kcLightGrey,
              fontWeight: FontWeight.w500,
            ),
          ),
        ],
      ),
    );
  }
}

class _AppointmentsSectionHeader extends StatelessWidget {
  final HomeViewModel viewModel;
  const _AppointmentsSectionHeader({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              "Today's Appointments",
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kcDarkGreyColor,
              ),
            ),
            const SizedBox(height: 2),
            Text(
              "Oct 24, 2023",
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: kcPrimaryColorDark,
              ),
            ),
          ],
        ),
        GestureDetector(
          onTap: viewModel.navigateToScheduleView,
          child: Row(
            children: [
              Text(
                "Calendar",
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w700,
                  color: kcPrimaryColorDark,
                ),
              ),
              const Icon(Icons.chevron_right,
                  color: kcPrimaryColorDark, size: 20),
            ],
          ),
        ),
      ],
    );
  }
}

class _AppointmentsList extends StatelessWidget {
  final HomeViewModel viewModel;
  const _AppointmentsList({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _appointmentCard(
          viewModel: viewModel,
          time: "09:00",
          ampm: "AM",
          name: "Bella",
          breed: "Golden Retriever • 4 yrs",
          status: "IN PROGRESS",
          isActive: true,
          imageUrl:
              "https://lh3.googleusercontent.com/aida-public/AB6AXuBTdPsYzFku1P5F8K8_43MB6V9L8ood6s88wr6DPdGJvGpEhympZXmVcEOfBqgGXSqFIJlXwKFwUDx97Crma6sZd6Qyt1LxqAQspdNo7-YbPS02Tsn3yu493D1w3XLqTW-zx-_P87heidVdDT9rlvovPQTCWOKMihg4WWeSAQquWDg9E8e9ZFq94kod0YZDN_Jv82tDdhA3so3CZCcJWav69WnjsIvH7YTkAH6v2c4pPZW3EhBXN-UMtkxU9naZmC4NqbNjkjWHNFI",
        ),
        const SizedBox(height: 16),
        _appointmentCard(
          viewModel: viewModel,
          time: "10:30",
          ampm: "AM",
          name: "Max",
          breed: "Siamese Cat • 2 yrs",
          status: "PENDING",
          imageUrl:
              "https://lh3.googleusercontent.com/aida-public/AB6AXuAKZcaEmL3K4gncXUV_bVhqOC4iMWEORebLw1SPOrLSlzmjJkNkWSv18JBVUOnDskQckePEq_e7sy5PDvYHe_lLyJofy3MVuP1nVa4-d8sMvCNMpo8p0vLt8zjvCdNV2lvW8AbM0wLoq7BN1-PplgTnHa-4bKNfqaLrpf1SGNoM1FlI4mvISWzzGAnER_bi1niMBRscEAGl6cVV0sPJlev-Iedwt2B3ydyGszfaYURoR8Fc5wY8m1LcdMRJ-2v-_zSRlnElAX_2Umc",
        ),
        const SizedBox(height: 16),
        _appointmentCard(
          viewModel: viewModel,
          time: "11:15",
          ampm: "AM",
          name: "Charlie",
          breed: "Beagle • 5 yrs",
          status: "CHECK-IN",
          imageUrl:
              "https://lh3.googleusercontent.com/aida-public/AB6AXuCCa6p9jp5iRSNme63pzGdh0J2e1PEGyHL1ArgEQ3TyTI1bKSymeNOWcG2lD0DoNYTGPEdjxodWqlQ1T9yl_BHW8mPUt7fdBoNve5cbsweEp_fao9jFhuFmzsg54zoHkq5aLfpWRisrCX3yZC15g3N7tphdWb4IrQc4yvZAPkkIUeOL7NkRyrJXVulZDXoY9xwNo8tEntt2uozO_fsbDCRCVKHM-zrpBfNzhmtFSc2zw8dzOsvYReZvj3M4s9s9TwYge2DTF_yRw14",
        ),
        const SizedBox(height: 16),
        _appointmentCard(
          viewModel: viewModel,
          time: "01:45",
          ampm: "PM",
          name: "Rio",
          breed: "Macaw • 7 yrs",
          status: "PENDING",
          imageUrl:
              "https://lh3.googleusercontent.com/aida-public/AB6AXuANhLtfQamUsIy1EwL6o6cV9nqo9d58u2OP5JJJVu-Kp-sKXyvR_8OjypHOQnaH2i76Wivb7AV2e4vhyq8lw24OcQ4Z8A12eJdZKptxkBfGrdOyz8-ubWpWChz_2nNPcsFhj-4qTKbe3NpSlG95miBawBP7sagVHlbNGpVlBUSDrz802m8XITeUFN1WlOVHSEdKYcKKJg7OmHVN03cN5dutIMJ4BQt3apJn9_v-4XD3y97r2ky2U-d_jj_3rJRpK9eOOBZ3BNk94ek",
        ),
        const SizedBox(height: 16),
        _appointmentCard(
          viewModel: viewModel,
          time: "08:15",
          ampm: "AM",
          name: "Rocky",
          breed: "German Shepherd • 1 yr",
          status: "DONE",
          isDone: true,
          imageUrl:
              "https://lh3.googleusercontent.com/aida-public/AB6AXuB4O1L_duzHktRprv-EGGQBnnLWNQbj0Dke4Wjaa-ApM3hx-GtexZblbgDRo-sjOI8linLE_4bX5FUtf93qrOqLZv9Fv47zKNmq2bOxm33BUhR7-qzi2PtarNMF4MXHt7je3_FiDmmPDDmVW6SC01r5ybQ1PHUdmi3tgr3plqoiKoB6ck17ngFBZeyavKbBQRbRKiqKcfz5R2tF22yPu0dlSXgqCgG_2sANYuBsY3E6rYvYj2amEg2rb9BPNzwmLdA6c0QEfcLiDU0",
        ),
      ],
    );
  }

  Widget _appointmentCard({
    required HomeViewModel viewModel,
    required String time,
    required String ampm,
    required String name,
    required String breed,
    required String status,
    required String imageUrl,
    bool isActive = false,
    bool isDone = false,
  }) {
    Color statusColor;
    switch (status) {
      case "PENDING":
        statusColor = Colors.orange;
        break;
      case "CHECK-IN":
        statusColor = Colors.blue;
        break;
      case "DONE":
        statusColor = kcStatusDone;
        break;
      case "IN PROGRESS":
        statusColor = kcPrimaryColor;
        break;
      default:
        statusColor = kcMediumGrey;
    }

    return Container(
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(isActive ? 0.08 : 0.03),
            blurRadius: 15,
            offset: const Offset(0, 5),
          )
        ],
        border: isActive
            ? const Border(left: BorderSide(color: kcPrimaryColor, width: 4))
            : null,
      ),
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                Column(
                  children: [
                    Text(
                      time,
                      style: GoogleFonts.manrope(
                        fontSize: 16,
                        fontWeight: FontWeight.w800,
                        color: isDone ? kcLightGrey : kcDarkGreyColor,
                        decoration: isDone ? TextDecoration.lineThrough : null,
                      ),
                    ),
                    Text(
                      ampm,
                      style: GoogleFonts.manrope(
                        fontSize: 12,
                        fontWeight: FontWeight.w600,
                        color: kcLightGrey,
                      ),
                    ),
                  ],
                ),
                const SizedBox(width: 16),
                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(14),
                    image: DecorationImage(
                      image: NetworkImage(imageUrl),
                      fit: BoxFit.cover,
                      colorFilter: isDone
                          ? const ColorFilter.mode(
                              Colors.grey, BlendMode.saturation)
                          : null,
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight: FontWeight.w800,
                          color: isDone ? kcLightGrey : kcDarkGreyColor,
                        ),
                      ),
                      Text(
                        breed,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: isDone ? kcLightGrey : kcPrimaryColorDark,
                        ),
                      ),
                    ],
                  ),
                ),
                if (!isActive)
                  _statusBadge(status, statusColor, isDone)
                else
                  const Icon(Icons.chevron_right, color: kcLightGrey),
              ],
            ),
          ),
          if (isActive) ...[
            Padding(
              padding: const EdgeInsets.fromLTRB(16, 0, 16, 16),
              child: Row(
                children: [
                  Expanded(
                    child: GestureDetector(
                      onTap: viewModel.navigateToAppointmentDetail,
                      child: Container(
                        height: 44,
                        decoration: BoxDecoration(
                          color: kcPrimaryColor,
                          borderRadius: BorderRadius.circular(12),
                          boxShadow: [
                            BoxShadow(
                              color: kcPrimaryColor.withOpacity(0.3),
                              blurRadius: 10,
                              offset: const Offset(0, 4),
                            )
                          ],
                        ),
                        child: Center(
                          child: Text(
                            "Continue Consult",
                            style: GoogleFonts.manrope(
                              fontWeight: FontWeight.w800,
                              color: kcNeutral900,
                              fontSize: 14,
                            ),
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: kcNeutral100,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: const Icon(Icons.description_outlined,
                        color: kcDarkGreyColor, size: 20),
                  ),
                ],
              ),
            ),
            Positioned(
              right: 0,
              top: 0,
              child: Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: const BoxDecoration(
                  color: kcPrimaryColor,
                  borderRadius: BorderRadius.only(
                    bottomLeft: Radius.circular(16),
                    topRight: Radius.circular(20),
                  ),
                ),
                child: Text(
                  "IN PROGRESS",
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w900,
                    color: kcDarkGreyColor,
                  ),
                ),
              ),
            ),
          ],
        ],
      ),
    );
  }

  Widget _statusBadge(String text, Color color, bool isDone) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
      decoration: BoxDecoration(
        color: isDone ? kcBackgroundColor : color.withOpacity(0.1),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          if (isDone) ...[
            Container(
              width: 6,
              height: 6,
              decoration: const BoxDecoration(
                color: kcLightGrey,
                shape: BoxShape.circle,
              ),
            ),
            const SizedBox(width: 6),
          ],
          Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w800,
              color: color,
            ),
          ),
        ],
      ),
    );
  }
}

class _DashboardBottomNav extends StatelessWidget {
  final HomeViewModel viewModel;
  const _DashboardBottomNav({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 10,
      padding: EdgeInsets.zero,
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(horizontal: 20),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            _navItem(Icons.grid_view_rounded, "Home", true, onTap: () {}),
            _navItem(Icons.pets_rounded, "Patients", false,
                onTap: viewModel.navigateToPatientRegistryView),
            const SizedBox(width: 40),
            _navItem(Icons.calendar_month_rounded, "Calendar", false,
                onTap: viewModel.navigateToScheduleView),
            _navItem(Icons.person_rounded, "Profile", false,
                onTap: viewModel.navigateToDoctorProfileView),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive,
      {required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
            decoration: BoxDecoration(
              color: isActive
                  ? kcPrimaryColor.withOpacity(0.2)
                  : Colors.transparent,
              borderRadius: BorderRadius.circular(12),
            ),
            child: Icon(
              icon,
              color: isActive ? kcPrimaryColorDark : kcLightGrey,
              size: 26,
            ),
          ),
          const SizedBox(height: 2),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? kcPrimaryColorDark : kcLightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

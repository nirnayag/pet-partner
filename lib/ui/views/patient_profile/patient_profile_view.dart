import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'package:partner/ui/widgets/patient_profile_widgets.dart';
import 'patient_profile_viewmodel.dart';

class PatientProfileView extends StackedView<PatientProfileViewModel> {
  const PatientProfileView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    PatientProfileViewModel viewModel,
    Widget? child,
  ) {
    return DefaultTabController(
      length: 5,
      child: Scaffold(
        backgroundColor: kcBackgroundColor,
        bottomNavigationBar: const _BottomNav(),
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
              _ProfileHeader(viewModel: viewModel),
              const Expanded(
                child: TabBarView(
                  children: [
                    _OverviewTab(),
                    VisitHistoryTab(),
                    VaccinationTab(),
                    MedicationsTab(),
                    LabsTab(),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  PatientProfileViewModel viewModelBuilder(BuildContext context) =>
      PatientProfileViewModel();
}

class _ProfileHeader extends StatelessWidget {
  final PatientProfileViewModel viewModel;
  const _ProfileHeader({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kcVeryLightGrey, width: 0.5)),
      ),
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              IconButton(
                onPressed: viewModel.goBack,
                icon:
                    const Icon(Icons.arrow_back_rounded, color: kcPrimaryColor),
                padding: EdgeInsets.zero,
                constraints: const BoxConstraints(),
              ),
              Text(
                "Patient Profile",
                style: GoogleFonts.manrope(
                  fontSize: 16,
                  fontWeight: FontWeight.w800,
                  color: kcDarkGreyColor,
                ),
              ),
              const Icon(Icons.more_vert_rounded, color: kcPrimaryColor),
            ],
          ),
          const SizedBox(height: 24),
          Stack(
            children: [
              Container(
                width: 96,
                height: 96,
                padding: const EdgeInsets.all(4),
                decoration: const BoxDecoration(
                  color: Colors.white,
                  shape: BoxShape.circle,
                ),
                child: ClipRRect(
                  borderRadius: BorderRadius.circular(44),
                  child: Image.network(
                    "https://lh3.googleusercontent.com/aida-public/AB6AXuBTdPsYzFku1P5F8K8_43MB6V9L8ood6s88wr6DPdGJvGpEhympZXmVcEOfBqgGXSqFIJlXwKFwUDx97Crma6sZd6Qyt1LxqAQspdNo7-YbPS02Tsn3yu493D1w3XLqTW-zx-_P87heidVdDT9rlvovPQTCWOKMihg4WWeSAQquWDg9E8e9ZFq94kod0YZDN_Jv82tDdhA3so3CZCcJWav69WnjsIvH7YTkAH6v2c4pPZW3EhBXN-UMtkxU9naZmC4NqbNjkjWHNFI",
                    fit: BoxFit.cover,
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
                  child: const Icon(Icons.pets_rounded,
                      size: 14, color: Colors.white),
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            "Bella",
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w900,
              color: kcDarkGreyColor,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            "Golden Retriever • 4 yrs • 28kg",
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w600,
              color: kcPrimaryColor,
            ),
          ),
          const SizedBox(height: 20),
          Container(
            padding: const EdgeInsets.all(12),
            decoration: BoxDecoration(
              color: const Color(0xFFFFEBEE),
              borderRadius: BorderRadius.circular(16),
              border: Border.all(color: const Color(0xFFFFCDD2)),
            ),
            child: Row(
              children: [
                const Icon(Icons.warning_rounded, color: Colors.red, size: 20),
                const SizedBox(width: 12),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "Allergy Alert",
                        style: GoogleFonts.manrope(
                          fontSize: 13,
                          fontWeight: FontWeight.w800,
                          color: Colors.red,
                        ),
                      ),
                      Text(
                        "Severe reaction to Penicillin. Monitor closely.",
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w500,
                          color: Colors.red.withOpacity(0.8),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 24),
          const TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            indicatorSize: TabBarIndicatorSize.label,
            labelPadding: EdgeInsets.only(right: 24),
            indicatorColor: kcPrimaryColor,
            labelColor: kcPrimaryColor,
            unselectedLabelColor: kcMediumGrey,
            labelStyle: TextStyle(fontSize: 14, fontWeight: FontWeight.w800),
            unselectedLabelStyle:
                TextStyle(fontSize: 14, fontWeight: FontWeight.w600),
            dividerColor: Colors.transparent,
            tabs: [
              Tab(text: "Overview"),
              Tab(text: "History"),
              Tab(text: "Vaccinations"),
              Tab(text: "Meds"),
              Tab(text: "Labs"),
            ],
          ),
        ],
      ),
    );
  }
}

class _OverviewTab extends StatelessWidget {
  const _OverviewTab();

  @override
  Widget build(BuildContext context) {
    return const SingleChildScrollView(
      padding: EdgeInsets.fromLTRB(20, 20, 20, 100),
      child: Column(
        children: [
          _InfoGrid(),
          SizedBox(height: 24),
          _OwnerSection(),
          SizedBox(height: 24),
          _QuickNotes(),
        ],
      ),
    );
  }
}

class _InfoGrid extends StatelessWidget {
  const _InfoGrid();

  @override
  Widget build(BuildContext context) {
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 16,
      crossAxisSpacing: 16,
      childAspectRatio: 1.4,
      children: const [
        _InfoCard(
            icon: Icons.cake_rounded,
            title: "DOB",
            value: "Oct 12, 2019",
            subtitle: "4 years old"),
        _InfoCard(
            icon: Icons.female_rounded,
            title: "SEX",
            value: "Female",
            subtitle: "Intact"),
        _InfoCard(
            icon: Icons.medical_services_rounded,
            title: "NEUTERED",
            value: "No",
            subtitle: "Scheduled: Nov 24"),
        _InfoCard(
            icon: Icons.qr_code_rounded,
            title: "MICROCHIP",
            value: "9851 1234 5678",
            subtitle: "Verified"),
      ],
    );
  }
}

class _InfoCard extends StatelessWidget {
  final IconData icon;
  final String title;
  final String value;
  final String subtitle;

  const _InfoCard({
    required this.icon,
    required this.title,
    required this.value,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border.all(color: kcVeryLightGrey.withOpacity(0.5)),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Row(
            children: [
              Icon(icon, size: 18, color: kcMediumGrey),
              const SizedBox(width: 8),
              Text(
                title,
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: kcMediumGrey,
                  letterSpacing: 0.5,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Text(
            value,
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
    );
  }
}

class _OwnerSection extends StatelessWidget {
  const _OwnerSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Owner Details",
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kcDarkGreyColor,
              ),
            ),
            Text(
              "Edit",
              style: GoogleFonts.manrope(
                fontSize: 14,
                fontWeight: FontWeight.w700,
                color: kcPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: kcVeryLightGrey.withOpacity(0.5)),
          ),
          child: Column(
            children: [
              Row(
                children: [
                  Container(
                    width: 56,
                    height: 56,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      image: const DecorationImage(
                        image: NetworkImage(
                            "https://lh3.googleusercontent.com/aida-public/AB6AXuDZw0fxqVSMpmJRdqJMLQGYmOVcVjbL1nIx_zlefzpBXaYPsLmuGlbj7zDKAjlWzvu4SsFwP6mnPlIZ9rdl4g2Ne9guBp2D9sPHFUh2rRkdprMDms600_J5ghMrnMOcKtOHURlh1CykiK_NLAmJ_l57Xs-7jQ8sbNFRfMvYeRwyNtjxFMDIIPaTPJStcaQrultw0AN8oGpces9ZhbvV2pT4264vbcjiCl733TPfsDFkQFAD5tBBlrjM2M8o6xWfvhIzgMc8XWShLE4"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  const SizedBox(width: 16),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          "Sarah Jenkins",
                          style: GoogleFonts.manrope(
                            fontSize: 18,
                            fontWeight: FontWeight.w800,
                            color: kcDarkGreyColor,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            const Icon(Icons.location_on_rounded,
                                size: 14, color: kcPrimaryColor),
                            const SizedBox(width: 4),
                            Text(
                              "42 Maple Ave, Springfield",
                              style: GoogleFonts.manrope(
                                fontSize: 12,
                                fontWeight: FontWeight.w500,
                                color: kcMediumGrey,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 24),
              Row(
                children: [
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.call_rounded,
                      label: "Call",
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: _ActionButton(
                      icon: Icons.mail_rounded,
                      label: "Email",
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _ActionButton extends StatelessWidget {
  final IconData icon;
  final String label;

  const _ActionButton({required this.icon, required this.label});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 48,
      decoration: BoxDecoration(
        color: kcPrimaryColor.withOpacity(0.05),
        borderRadius: BorderRadius.circular(14),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(icon, size: 18, color: kcPrimaryColor),
          const SizedBox(width: 8),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: FontWeight.w700,
              color: kcDarkGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _QuickNotes extends StatelessWidget {
  const _QuickNotes();

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          "Quick Notes",
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 16),
        Container(
          padding: const EdgeInsets.all(20),
          decoration: BoxDecoration(
            color: const Color(0xFFFFFDE7),
            borderRadius: BorderRadius.circular(24),
            border: Border.all(color: const Color(0xFFFFF9C4)),
          ),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              const Icon(Icons.sticky_note_2_rounded,
                  color: Color(0xFFFBC02D), size: 20),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Owner mentioned Bella has been scratching her left ear more often lately. Check for potential ear infection during next visit.",
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kcDarkGreyColor.withOpacity(0.8),
                        height: 1.5,
                      ),
                    ),
                    const SizedBox(height: 12),
                    Text(
                      "Added by Dr. Alex • Oct 20, 2023",
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: kcMediumGrey,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav();

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
            _navItem(Icons.grid_view_rounded, "Home", false),
            _navItem(Icons.pets_rounded, "Patients", true),
            const SizedBox(width: 40),
            _navItem(Icons.calendar_month_rounded, "Calendar", false),
            _navItem(Icons.person_rounded, "Profile", false),
          ],
        ),
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
          decoration: BoxDecoration(
            color:
                isActive ? kcPrimaryColor.withOpacity(0.2) : Colors.transparent,
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
    );
  }
}

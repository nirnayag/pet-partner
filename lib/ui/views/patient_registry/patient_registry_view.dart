import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/patient_registry/patient_registry_viewmodel.dart';
import 'package:stacked/stacked.dart';

class PatientRegistryView
    extends StackedView<PatientRegistryViewModel> {
  const PatientRegistryView({super.key});

  @override
  Widget builder(
    BuildContext context,
    PatientRegistryViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      bottomNavigationBar:
          _BottomNav(viewModel: viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kcPrimaryColor,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.add,
          color: kcNeutral900,
          size: 32,
        ),
      ),
      floatingActionButtonLocation:
          FloatingActionButtonLocation.centerDocked,
      body: SafeArea(
        child: Column(
          children: [
            const _Header(),
            Expanded(
              child: ListView(
                padding: const EdgeInsets.symmetric(
                  horizontal: 20,
                ),
                children: [
                  const SizedBox(height: 10),
                  const _RecordCount(),
                  const SizedBox(height: 16),
                  _PatientCard(
                    name: 'Bella',
                    breed: 'Golden Retriever',
                    age: '4 yrs',
                    weight: '28 kg',
                    owner: 'Sarah Jenkins',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuBTdPsYzFku1P5F8K8_43MB6V9L8ood6s88wr6DPdGJvGpEhympZXmVcEOfBqgGXSqFIJlXwKFwUDx97Crma6sZd6Qyt1LxqAQspdNo7-YbPS02Tsn3yu493D1w3XLqTW-zx-_P87heidVdDT9rlvovPQTCWOKMihg4WWeSAQquWDg9E8e9ZFq94kod0YZDN_Jv82tDdhA3so3CZCcJWav69WnjsIvH7YTkAH6v2c4pPZW3EhBXN-UMtkxU9naZmC4NqbNjkjWHNFI',
                    onTap: viewModel
                        .navigateToPatientProfileView,
                  ),
                  _PatientCard(
                    name: 'Max',
                    breed: 'Siamese Cat',
                    age: '2 yrs',
                    weight: '4.5 kg',
                    owner: 'Mike Ross',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuAKZcaEmL3K4gncXUV_bVhqOC4iMWEORebLw1SPOrLSlzmjJkNkWSv18JBVUOnDskQckePEq_e7sy5PDvYHe_lLyJofy3MVuP1nVa4-d8sMvCNMpo8p0vLt8zjvCdNV2lvW8AbM0wLoq7BN1-PplgTnHa-4bKNfqaLrpf1SGNoM1FlI4mvISWzzGAnER_bi1niMBRscEAGl6cVV0sPJlev-Iedwt2B3ydyGszfaYURoR8Fc5wY8m1LcdMRJ-2v-_zSRlnElAX_2Umc',
                    onTap: viewModel
                        .navigateToPatientProfileView,
                  ),
                  _PatientCard(
                    name: 'Charlie',
                    breed: 'Beagle',
                    age: '5 yrs',
                    weight: '11 kg',
                    owner: 'Emily Blunt',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuCCa6p9jp5iRSNme63pzGdh0J2e1PEGyHL1ArgEQ3TyTI1bKSymeNOWcG2lD0DoNYTGPEdjxodWqlQ1T9yl_BHW8mPUt7fdBoNve5cbsweEp_fao9jFhuFmzsg54zoHkq5aLfpWRisrCX3yZC15g3N7tphdWb4IrQc4yvZAPkkIUeOL7NkRyrJXVulZDXoY9xwNo8tEntt2uozO_fsbDCRCVKHM-zrpBfNzhmtFSc2zw8dzOsvYReZvj3M4s9s9TwYge2DTF_yRw14',
                    onTap: viewModel
                        .navigateToPatientProfileView,
                  ),
                  _PatientCard(
                    name: 'Rio',
                    breed: 'Macaw',
                    age: '7 yrs',
                    weight: '1.2 kg',
                    owner: 'Linda Cole',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuANhLtfQamUsIy1EwL6o6cV9nqo9d58u2OP5JJJVu-Kp-sKXyvR_8OjypHOQnaH2i76Wivb7AV2e4vhyq8lw24OcQ4Z8A12eJdZKptxkBfGrdOyz8-ubWpWChz_2nNPcsFhj-4qTKbe3NpSlG95miBawBP7sagVHlbNGpVlBUSDrz802m8XITeUFN1WlOVHSEdKYcKKJg7OmHVN03cN5dutIMJ4BQt3apJn9_v-4XD3y97r2ky2U-d_jj_3rJRpK9eOOBZ3BNk94ek',
                    onTap: viewModel
                        .navigateToPatientProfileView,
                  ),
                  _PatientCard(
                    name: 'Rocky',
                    breed: 'German Shepherd',
                    age: '1 yr',
                    weight: '32 kg',
                    owner: 'James Smith',
                    imageUrl:
                        'https://lh3.googleusercontent.com/aida-public/AB6AXuB4O1L_duzHktRprv-EGGQBnnLWNQbj0Dke4Wjaa-ApM3hx-GtexZblbgDRo-sjOI8linLE_4bX5FUtf93qrOqLZv9Fv47zKNmq2bOxm33BUhR7-qzi2PtarNMF4MXHt7je3_FiDmmPDDmVW6SC01r5ybQ1PHUdmi3tgr3plqoiKoB6ck17ngFBZeyavKbBQRbRKiqKcfz5R2tF22yPu0dlSXgqCgG_2sANYuBsY3E6rYvYj2amEg2rb9BPNzwmLdA6c0QEfcLiDU0',
                    onTap: viewModel
                        .navigateToPatientProfileView,
                  ),
                  const SizedBox(height: 100),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  PatientRegistryViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      PatientRegistryViewModel();
}

class _Header extends StatelessWidget {
  const _Header();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Column(
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                'Patient Registry',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w800,
                  color: kcDarkGreyColor,
                ),
              ),
              Stack(
                children: [
                  Container(
                    padding: const EdgeInsets.all(8),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius:
                          BorderRadius.circular(12),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black
                              .withValues(alpha: 0.05),
                          blurRadius: 10,
                          offset: const Offset(0, 4),
                        ),
                      ],
                    ),
                    child: const Icon(
                      Icons
                          .notifications_none_rounded,
                      color: kcDarkGreyColor,
                    ),
                  ),
                  Positioned(
                    top: 8,
                    right: 8,
                    child: Container(
                      width: 8,
                      height: 8,
                      decoration: BoxDecoration(
                        color: Colors.red,
                        shape: BoxShape.circle,
                        border: Border.all(
                          color: Colors.white,
                          width: 2,
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: Container(
                  padding:
                      const EdgeInsets.symmetric(
                    horizontal: 16,
                  ),
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius:
                        BorderRadius.circular(16),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black
                            .withValues(
                          alpha: 0.03,
                        ),
                        blurRadius: 10,
                        offset: const Offset(0, 4),
                      ),
                    ],
                  ),
                  child: Row(
                    children: [
                      const Icon(
                        Icons.search_rounded,
                        color: kcLightGrey,
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: TextField(
                          decoration:
                              InputDecoration(
                            hintText:
                                'Search name,'
                                ' owner...',
                            hintStyle:
                                GoogleFonts.manrope(
                              color: kcLightGrey,
                              fontSize: 14,
                              fontWeight:
                                  FontWeight.w500,
                            ),
                            border: InputBorder.none,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius:
                      BorderRadius.circular(16),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(
                        alpha: 0.03,
                      ),
                      blurRadius: 10,
                      offset: const Offset(0, 4),
                    ),
                  ],
                ),
                child: const Icon(
                  Icons.tune_rounded,
                  color: kcMediumGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          SizedBox(
            height: 36,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: const [
                _FilterChip(
                  label: 'All',
                  isActive: true,
                ),
                _FilterChip(label: 'Dogs'),
                _FilterChip(label: 'Cats'),
                _FilterChip(label: 'Birds'),
                _FilterChip(label: 'Small Pets'),
              ],
            ),
          ),
        ],
      ),
    );
  }
}

class _FilterChip extends StatelessWidget {
  const _FilterChip({
    required this.label,
    this.isActive = false,
  });

  final String label;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 8,
      ),
      decoration: BoxDecoration(
        color:
            isActive ? kcNeutral900 : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isActive
            ? null
            : [
                BoxShadow(
                  color: Colors.black
                      .withValues(alpha: 0.03),
                  blurRadius: 5,
                ),
              ],
      ),
      child: Center(
        child: Text(
          label,
          style: GoogleFonts.manrope(
            fontSize: 12,
            fontWeight: FontWeight.w700,
            color: isActive
                ? Colors.white
                : kcMediumGrey,
          ),
        ),
      ),
    );
  }
}

class _RecordCount extends StatelessWidget {
  const _RecordCount();

  @override
  Widget build(BuildContext context) {
    return Text(
      'Showing 42 patients',
      style: GoogleFonts.manrope(
        fontSize: 14,
        fontWeight: FontWeight.w600,
        color: kcPrimaryColor,
      ),
    );
  }
}

class _PatientCard extends StatelessWidget {
  const _PatientCard({
    required this.name,
    required this.breed,
    required this.age,
    required this.weight,
    required this.owner,
    required this.imageUrl,
    required this.onTap,
  });

  final String name;
  final String breed;
  final String age;
  final String weight;
  final String owner;
  final String imageUrl;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(24),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.03),
              blurRadius: 20,
              offset: const Offset(0, 10),
            ),
          ],
        ),
        child: Row(
          crossAxisAlignment:
              CrossAxisAlignment.start,
          children: [
            Container(
              width: 80,
              height: 80,
              decoration: BoxDecoration(
                borderRadius:
                    BorderRadius.circular(16),
                image: DecorationImage(
                  image: NetworkImage(imageUrl),
                  fit: BoxFit.cover,
                ),
              ),
            ),
            const SizedBox(width: 16),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment:
                        MainAxisAlignment
                            .spaceBetween,
                    children: [
                      Text(
                        name,
                        style: GoogleFonts.manrope(
                          fontSize: 18,
                          fontWeight:
                              FontWeight.w800,
                          color: kcDarkGreyColor,
                        ),
                      ),
                      const Icon(
                        Icons.more_vert_rounded,
                        color: kcLightGrey,
                        size: 20,
                      ),
                    ],
                  ),
                  Text(
                    breed.toUpperCase(),
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: kcPrimaryColor,
                      letterSpacing: 0.5,
                    ),
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons.cake_outlined,
                        size: 16,
                        color: kcLightGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        age,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                          color: kcMediumGrey,
                        ),
                      ),
                      const SizedBox(width: 16),
                      const Icon(
                        Icons
                            .monitor_weight_outlined,
                        size: 16,
                        color: kcLightGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        weight,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
                          color: kcMediumGrey,
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 8),
                  Row(
                    children: [
                      const Icon(
                        Icons
                            .person_outline_rounded,
                        size: 16,
                        color: kcLightGrey,
                      ),
                      const SizedBox(width: 4),
                      Text(
                        'Owner: $owner',
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight:
                              FontWeight.w600,
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
      ),
    );
  }
}

class _BottomNav extends StatelessWidget {
  const _BottomNav({required this.viewModel});

  final PatientRegistryViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return BottomAppBar(
      notchMargin: 10,
      padding: EdgeInsets.zero,
      shape: const CircularNotchedRectangle(),
      color: Colors.white,
      child: Container(
        height: 70,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        child: Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            _navItem(
              Icons.grid_view_rounded,
              'Home',
              isActive: false,
              onTap:
                  viewModel.navigateToHomeView,
            ),
            _navItem(
              Icons.pets_rounded,
              'Patients',
              isActive: true,
              onTap: viewModel
                  .navigateToPatientRegistryView,
            ),
            const SizedBox(width: 40),
            _navItem(
              Icons.calendar_month_rounded,
              'Calendar',
              isActive: false,
              onTap:
                  viewModel.navigateToScheduleView,
            ),
            _navItem(
              Icons.person_rounded,
              'Profile',
              isActive: false,
              onTap: () {},
            ),
          ],
        ),
      ),
    );
  }

  Widget _navItem(
    IconData icon,
    String label, {
    required bool isActive,
    required VoidCallback onTap,
  }) {
    return GestureDetector(
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
              borderRadius:
                  BorderRadius.circular(12),
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

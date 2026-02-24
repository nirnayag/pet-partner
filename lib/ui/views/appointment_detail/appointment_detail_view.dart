import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'appointment_detail_viewmodel.dart';

class AppointmentDetailView extends StackedView<AppointmentDetailViewModel> {
  const AppointmentDetailView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    AppointmentDetailViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Stack(
        children: [
          Column(
            children: [
              _AppointmentAppBar(onBack: viewModel.goBack),
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.only(bottom: 120),
                  child: Column(
                    children: [
                      const _PetProfileHeader(),
                      const SizedBox(height: 12),
                      _VisitInfoCard(
                          onViewMedicalRecord:
                              viewModel.showMedicalRecordSheet),
                      const SizedBox(height: 12),
                      const _ConsultationNotesCard(),
                      const SizedBox(height: 12),
                      const _CurrentVitalsCard(),
                    ],
                  ),
                ),
              ),
            ],
          ),
          const _BottomStickyActions(),
        ],
      ),
    );
  }

  @override
  AppointmentDetailViewModel viewModelBuilder(BuildContext context) =>
      AppointmentDetailViewModel();
}

class _AppointmentAppBar extends StatelessWidget {
  final VoidCallback onBack;
  const _AppointmentAppBar({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(16, 50, 16, 16),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(bottom: BorderSide(color: kcVeryLightGrey, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Icon(Icons.arrow_back_rounded, color: kcDarkGreyColor),
          ),
          Text(
            "Appointment Details",
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
          const Icon(Icons.more_vert_rounded, color: kcDarkGreyColor),
        ],
      ),
    );
  }
}

class _PetProfileHeader extends StatelessWidget {
  const _PetProfileHeader();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.white,
      padding: const EdgeInsets.all(20),
      child: Column(
        children: [
          Row(
            children: [
              Stack(
                children: [
                  Container(
                    width: 100,
                    height: 100,
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(24),
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black.withOpacity(0.1),
                          blurRadius: 15,
                          offset: const Offset(0, 5),
                        )
                      ],
                      image: const DecorationImage(
                        image: NetworkImage(
                            "https://lh3.googleusercontent.com/aida-public/AB6AXuB4bWNHkebQSAW_0qaIP_zMcEdckUaoLzXCkh2KRD6T0GBYNz-piheUcz6jXJY6JhjgvTS9qPL70Y1Y8h2EURRa2KhmZM-mlK22zwSktKwZojYL8B4FA_R1Y2QBPQYJQmLYrNcB1-UPz-nADQmYCxgZy7XETtRl6c20570FsqPhi5d4Er7xSXmKiAPStJx9bMHvQUsbyb3FckFUXYFAJoFBA61Ao_IZwrAVKNj6T_LZsa3-BzrvZ5fo34rhJCKDuBnQJmdf9ZVh5yc"),
                        fit: BoxFit.cover,
                      ),
                    ),
                  ),
                  Positioned(
                    right: -4,
                    bottom: -4,
                    child: Container(
                      padding: const EdgeInsets.all(8),
                      decoration: BoxDecoration(
                        color: Colors.blue.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                        border: Border.all(color: Colors.white, width: 2),
                      ),
                      child:
                          const Icon(Icons.pets, size: 20, color: Colors.blue),
                    ),
                  )
                ],
              ),
              const SizedBox(width: 20),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "Bella",
                      style: GoogleFonts.manrope(
                        fontSize: 28,
                        fontWeight: FontWeight.w900,
                        color: kcDarkGreyColor,
                      ),
                    ),
                    Text(
                      "Golden Retriever • 4 Years • Female",
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w600,
                        color: kcMediumGrey,
                      ),
                    ),
                    const SizedBox(height: 10),
                    Container(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 12, vertical: 6),
                      decoration: BoxDecoration(
                        color: Colors.green.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                        border:
                            Border.all(color: Colors.green.withOpacity(0.2)),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          const CircleAvatar(
                              radius: 4, backgroundColor: Colors.green),
                          const SizedBox(width: 8),
                          Text(
                            "Checked In",
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w800,
                              color: Colors.green[700],
                            ),
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 24),
          const _OwnerActionCard(),
        ],
      ),
    );
  }
}

class _OwnerActionCard extends StatelessWidget {
  const _OwnerActionCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: kcVeryLightGrey.withOpacity(0.2),
        borderRadius: BorderRadius.circular(20),
        border: Border.all(color: kcVeryLightGrey.withOpacity(0.5)),
      ),
      child: Row(
        children: [
          Container(
            width: 44,
            height: 44,
            decoration: const BoxDecoration(
              color: kcVeryLightGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(Icons.person, color: kcMediumGrey),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  "OWNER",
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: kcLightGrey,
                    letterSpacing: 1,
                  ),
                ),
                Text(
                  "John Doe",
                  style: GoogleFonts.manrope(
                    fontSize: 16,
                    fontWeight: FontWeight.w800,
                    color: kcDarkGreyColor,
                  ),
                ),
              ],
            ),
          ),
          Row(
            children: [
              _iconButton(
                  Icons.chat_bubble_rounded, Colors.white, Colors.green),
              const SizedBox(width: 10),
              _iconButton(Icons.call_rounded, kcPrimaryColor, kcNeutral900),
            ],
          ),
        ],
      ),
    );
  }

  Widget _iconButton(IconData icon, Color bg, Color iconColor) {
    return Container(
      width: 40,
      height: 40,
      decoration: BoxDecoration(
        color: bg,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.05),
            blurRadius: 10,
          )
        ],
      ),
      child: Icon(icon, color: iconColor, size: 20),
    );
  }
}

class _VisitInfoCard extends StatelessWidget {
  final VoidCallback onViewMedicalRecord;
  const _VisitInfoCard({required this.onViewMedicalRecord});

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "REASON FOR VISIT",
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w900,
                      color: kcLightGrey,
                      letterSpacing: 1,
                    ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    "Annual Checkup",
                    style: GoogleFonts.manrope(
                      fontSize: 20,
                      fontWeight: FontWeight.w800,
                      color: kcDarkGreyColor,
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: Colors.blue.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(10),
                ),
                child: Text(
                  "30 min",
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w800,
                    color: Colors.blue,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Wrap(
            spacing: 8,
            children: [
              _tag("Vaccination due"),
              _tag("Weight check"),
            ],
          ),
          const SizedBox(height: 24),
          GestureDetector(
            onTap: onViewMedicalRecord,
            child: Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(vertical: 16),
              decoration: BoxDecoration(
                color: const Color(0xFF0C141F),
                borderRadius: BorderRadius.circular(16),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  const Icon(Icons.history_edu_rounded,
                      color: Colors.white, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    "View Full Medical Record",
                    style: GoogleFonts.manrope(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                      color: Colors.white,
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _tag(String text) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: kcVeryLightGrey.withOpacity(0.4),
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        text,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: kcMediumGrey,
        ),
      ),
    );
  }
}

class _ConsultationNotesCard extends StatelessWidget {
  const _ConsultationNotesCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
      ),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  const Icon(Icons.edit_note_rounded,
                      color: kcPrimaryColor, size: 24),
                  const SizedBox(width: 8),
                  Text(
                    "Consultation Notes",
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w800,
                      color: kcDarkGreyColor,
                    ),
                  ),
                ],
              ),
              Text(
                "Saving...",
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kcLightGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Container(
            height: 140,
            width: double.infinity,
            padding: const EdgeInsets.all(16),
            decoration: BoxDecoration(
              color: kcVeryLightGrey.withOpacity(0.2),
              borderRadius: BorderRadius.circular(16),
            ),
            child: TextField(
              maxLines: null,
              style: GoogleFonts.manrope(fontSize: 14, color: kcDarkGreyColor),
              decoration: InputDecoration.collapsed(
                hintText:
                    "Enter clinical observations, diagnosis, and treatment plan...",
                hintStyle: GoogleFonts.manrope(
                  fontSize: 14,
                  color: kcLightGrey,
                  fontWeight: FontWeight.w500,
                ),
              ),
            ),
          ),
          const SizedBox(height: 16),
          SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: Row(
              children: [
                _addSnippet("+ Prescribe Meds"),
                _addSnippet("+ Add Vitals"),
                _addSnippet("+ Upload File"),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _addSnippet(String label) {
    return Container(
      margin: const EdgeInsets.only(right: 8),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(color: kcVeryLightGrey),
      ),
      child: Text(
        label,
        style: GoogleFonts.manrope(
          fontSize: 11,
          fontWeight: FontWeight.w700,
          color: kcMediumGrey,
        ),
      ),
    );
  }
}

class _CurrentVitalsCard extends StatelessWidget {
  const _CurrentVitalsCard();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 20),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            "CURRENT VITALS",
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: FontWeight.w900,
              color: kcLightGrey,
              letterSpacing: 1,
            ),
          ),
          const SizedBox(height: 12),
          Row(
            children: [
              _vitalItem("Weight", "28 kg", Colors.red),
              const SizedBox(width: 8),
              _vitalItem("Temp", "38.5°C", Colors.blue),
              const SizedBox(width: 8),
              _vitalItem("HR", "80 bpm", Colors.orange),
            ],
          ),
        ],
      ),
    );
  }

  Widget _vitalItem(String label, String value, Color color) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.symmetric(vertical: 12),
        decoration: BoxDecoration(
          color: color.withOpacity(0.05),
          borderRadius: BorderRadius.circular(14),
        ),
        child: Column(
          children: [
            Text(
              label.toUpperCase(),
              style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w800,
                  color: color.withOpacity(0.6)),
            ),
            const SizedBox(height: 4),
            Text(
              value,
              style: GoogleFonts.manrope(
                  fontSize: 14, fontWeight: FontWeight.w900, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

class _BottomStickyActions extends StatelessWidget {
  const _BottomStickyActions();

  @override
  Widget build(BuildContext context) {
    return Positioned(
      bottom: 0,
      left: 0,
      right: 0,
      child: Container(
        padding: const EdgeInsets.fromLTRB(20, 20, 20, 40),
        decoration: BoxDecoration(
          gradient: LinearGradient(
            begin: Alignment.topCenter,
            end: Alignment.bottomCenter,
            colors: [
              kcBackgroundColor.withOpacity(0),
              kcBackgroundColor,
              kcBackgroundColor,
            ],
          ),
        ),
        child: Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(24),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withOpacity(0.1),
                blurRadius: 30,
              )
            ],
          ),
          child: Row(
            children: [
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: kcPrimaryColor,
                    borderRadius: BorderRadius.circular(18),
                    boxShadow: [
                      BoxShadow(
                        color: kcPrimaryColor.withOpacity(0.3),
                        blurRadius: 12,
                      )
                    ],
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.play_arrow_rounded, color: kcNeutral900),
                      const SizedBox(width: 4),
                      Text(
                        "In-Progress",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: kcNeutral900,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Expanded(
                child: Container(
                  height: 56,
                  decoration: BoxDecoration(
                    color: kcVeryLightGrey.withOpacity(0.4),
                    borderRadius: BorderRadius.circular(18),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Icon(Icons.check_rounded, color: kcDarkGreyColor),
                      const SizedBox(width: 4),
                      Text(
                        "Complete",
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w900,
                          fontSize: 15,
                          color: kcDarkGreyColor,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(width: 8),
              Container(
                width: 56,
                height: 56,
                decoration: BoxDecoration(
                  color: kcVeryLightGrey.withOpacity(0.4),
                  borderRadius: BorderRadius.circular(18),
                ),
                child: const Icon(Icons.person_off_rounded, color: kcLightGrey),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

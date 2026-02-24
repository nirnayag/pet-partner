import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';

class VaccinationTab extends StatelessWidget {
  const VaccinationTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: const [
            _VaccineCard(
              title: "Rabies",
              subtitle: "Core Vaccine",
              status: "Up to Date",
              color: Colors.green,
              administered: "Nov 15, 2023",
              due: "Nov 15, 2026",
              batch: "RB-2023-992",
              doctor: "Dr. S. Jenkins",
            ),
            _VaccineCard(
              title: "DHPP",
              subtitle: "Distemper, Hepatitis...",
              status: "Due Soon",
              color: Colors.orange,
              administered: "Dec 10, 2020",
              due: "Dec 10, 2023",
              batch: "DH-991-A2",
              doctor: "Dr. M. Ross",
            ),
            _VaccineCard(
              title: "Bordetella",
              subtitle: "Kennel Cough",
              status: "Overdue",
              color: Colors.red,
              administered: "Sep 01, 2022",
              due: "Sep 01, 2023",
              batch: "BD-220-X1",
              doctor: "Dr. S. Jenkins",
              isOverdue: true,
            ),
            _VaccineCard(
              title: "Leptospirosis",
              subtitle: "Bacterial Infection",
              status: "Up to Date",
              color: Colors.green,
              administered: "Jun 15, 2023",
              due: "Jun 15, 2024",
              batch: "LP-772-K9",
              doctor: "Dr. A. Smith",
            ),
            SizedBox(height: 100),
          ],
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13EC13),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 4,
            ),
            onPressed: () {},
            icon: const Icon(Icons.add, size: 24),
            label: Text(
              "Add Vaccination",
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _VaccineCard extends StatelessWidget {
  final String title, subtitle, status, administered, due, batch, doctor;
  final Color color;
  final bool isOverdue;

  const _VaccineCard({
    required this.title,
    required this.subtitle,
    required this.status,
    required this.color,
    required this.administered,
    required this.due,
    required this.batch,
    required this.doctor,
    this.isOverdue = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: color.withOpacity(0.1),
                      shape: BoxShape.circle,
                    ),
                    child: Icon(
                      isOverdue
                          ? Icons.warning_rounded
                          : Icons.medical_services_rounded,
                      color: color,
                      size: 20,
                    ),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        title,
                        style: GoogleFonts.manrope(
                          fontSize: 16,
                          fontWeight: FontWeight.w800,
                          color: kcDarkGreyColor,
                        ),
                      ),
                      Text(
                        subtitle,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: kcPrimaryColor,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(20),
                ),
                child: Text(
                  status,
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: color,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "ADMINISTERED",
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: kcLightGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      administered,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: kcDarkGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "NEXT DUE",
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: kcLightGrey,
                        letterSpacing: 0.5,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      due,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: isOverdue ? Colors.red : kcDarkGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                "Batch #$batch • $doctor",
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w500,
                  color: kcMediumGrey,
                ),
              ),
              if (isOverdue)
                Text(
                  "Schedule Now",
                  style: GoogleFonts.manrope(
                    fontSize: 11,
                    fontWeight: FontWeight.w800,
                    color: const Color(0xFF13EC13),
                  ),
                ),
            ],
          ),
        ],
      ),
    );
  }
}

class VisitHistoryTab extends StatelessWidget {
  const VisitHistoryTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Past Visits",
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kcDarkGreyColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Row(
                children: [
                  const Icon(Icons.tune_rounded,
                      size: 16, color: Color(0xFF1B5E20)),
                  const SizedBox(width: 4),
                  Text(
                    "Filter",
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF1B5E20),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
        const SizedBox(height: 20),
        const _HistoryCard(
          type: "ANNUAL CHECKUP",
          date: "Oct 24, 2023",
          doctor: "Dr. Alex",
          isFirst: true,
          content: [
            "Subjective: Owner reports increased lethargy over the last 2 days. Appetite is normal.",
            "Objective: Weight: 28kg, Temp: 38.5°C, HR: 100bpm",
            "Assessment: Possible early-stage renal issues or mild infection.",
          ],
        ),
        const _HistoryCard(
          type: "VACCINATION",
          date: "Aug 15, 2023",
          doctor: "Dr. Sarah",
          content: [
            "Plan: Administered Rabies Booster (Batch #RB-2023-99). Next due in 1 year. No adverse reactions observed.",
          ],
        ),
        const _HistoryCard(
          type: "EMERGENCY",
          date: "Feb 02, 2023",
          doctor: "Dr. Alex",
          content: [
            "Subjective: Dog ingested chocolate approx 1 hour ago. Vomited once.",
            "Assessment: Theobromine toxicity risk. Currently stable.",
            "Plan: Activated charcoal administered. Observation for 4 hours.",
          ],
        ),
        const _HistoryCard(
          type: "ROUTINE",
          date: "Dec 10, 2022",
          doctor: "Dr. Patel",
          isLast: true,
          content: [
            "Subjective: Nail trim request. Healthy overall.",
          ],
        ),
        const SizedBox(height: 4),
        Padding(
          padding: const EdgeInsets.only(left: 32),
          child: Text(
            "Registration Date: Nov 15, 2022",
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontStyle: FontStyle.italic,
              color: kcMediumGrey,
            ),
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}

class _HistoryCard extends StatelessWidget {
  final String type, date, doctor;
  final List<String> content;
  final bool isFirst, isLast;

  const _HistoryCard({
    required this.type,
    required this.date,
    required this.doctor,
    required this.content,
    this.isFirst = false,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          SizedBox(
            width: 32,
            child: Column(
              children: [
                Container(
                  width: 12,
                  height: 12,
                  decoration: const BoxDecoration(
                    color: Color(0xFF13EC13),
                    shape: BoxShape.circle,
                  ),
                ),
                if (!isLast)
                  Expanded(
                    child: Container(
                      width: 2,
                      color: const Color(0xFFEEEEEE),
                    ),
                  ),
              ],
            ),
          ),
          Expanded(
            child: Container(
              margin: const EdgeInsets.only(bottom: 24),
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(20),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.02),
                    blurRadius: 10,
                    offset: const Offset(0, 4),
                  ),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 4),
                        decoration: BoxDecoration(
                          color: const Color(0xFFEDF2FF),
                          borderRadius: BorderRadius.circular(6),
                        ),
                        child: Text(
                          type,
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            color: const Color(0xFF3B5BDB),
                          ),
                        ),
                      ),
                      Row(
                        children: [
                          const Icon(Icons.person_outline_rounded,
                              size: 14, color: kcMediumGrey),
                          const SizedBox(width: 4),
                          Text(
                            doctor,
                            style: GoogleFonts.manrope(
                              fontSize: 12,
                              fontWeight: FontWeight.w600,
                              color: kcMediumGrey,
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                  const SizedBox(height: 10),
                  Text(
                    date,
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: kcDarkGreyColor,
                    ),
                  ),
                  const SizedBox(height: 12),
                  ...content.map((text) {
                    final parts = text.split(': ');
                    return Padding(
                      padding: const EdgeInsets.only(bottom: 6),
                      child: RichText(
                        text: TextSpan(
                          style: GoogleFonts.manrope(
                            fontSize: 13,
                            color: kcDarkGreyColor,
                            height: 1.4,
                          ),
                          children: [
                            TextSpan(
                              text: "${parts[0]}: ",
                              style:
                                  const TextStyle(fontWeight: FontWeight.w800),
                            ),
                            TextSpan(text: parts[1]),
                          ],
                        ),
                      ),
                    );
                  }),
                  const SizedBox(height: 12),
                  OutlinedButton(
                    onPressed: () {},
                    style: OutlinedButton.styleFrom(
                      side: BorderSide(color: kcPrimaryColor.withOpacity(0.3)),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          "View Full Note",
                          style: GoogleFonts.manrope(
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: kcDarkGreyColor,
                          ),
                        ),
                        const SizedBox(width: 8),
                        const Icon(Icons.arrow_forward_rounded,
                            size: 16, color: kcDarkGreyColor),
                      ],
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
}

class MedicationsTab extends StatelessWidget {
  const MedicationsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text(
              "Active Medications",
              style: GoogleFonts.manrope(
                fontSize: 18,
                fontWeight: FontWeight.w800,
                color: kcDarkGreyColor,
              ),
            ),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
              decoration: BoxDecoration(
                color: const Color(0xFFE8F5E9),
                borderRadius: BorderRadius.circular(12),
              ),
              child: Text(
                "2 Active",
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w800,
                  color: const Color(0xFF2E7D32),
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 16),
        const _MedCard(
          name: "Apoquel",
          variant: "16mg Tablet",
          dosage: "1 tablet / day",
          started: "Oct 15, 2023",
          tag: "Daily",
          color: Colors.green,
          refillsLeft: 2,
        ),
        const _MedCard(
          name: "Carprofen",
          variant: "75mg Chewable",
          dosage: "1/2 tablet as needed",
          started: "Nov 02, 2023",
          tag: "PRN",
          color: Colors.orange,
          refillsLeft: 1,
          progress: 0.3,
        ),
        const SizedBox(height: 24),
        Text(
          "Past History",
          style: GoogleFonts.manrope(
            fontSize: 18,
            fontWeight: FontWeight.w800,
            color: kcDarkGreyColor,
          ),
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(20),
          ),
          child: Column(
            children: const [
              _PastMedTile(
                name: "Amoxicillin",
                details: "250mg • 2x daily for 7 days",
                dates: "Sep 10 - Sep 17, 2023",
              ),
              Divider(height: 1, indent: 64),
              _PastMedTile(
                name: "Prednisone",
                details: "5mg • Tapering dose",
                dates: "Jun 12 - Jun 25, 2023",
              ),
              Divider(height: 1, indent: 64),
              _PastMedTile(
                name: "Metronidazole",
                details: "250mg • 2x daily",
                dates: "Feb 05 - Feb 12, 2023",
                isLast: true,
              ),
            ],
          ),
        ),
        const SizedBox(height: 100),
      ],
    );
  }
}

class _MedCard extends StatelessWidget {
  final String name, variant, dosage, started, tag;
  final Color color;
  final int refillsLeft;
  final double progress;

  const _MedCard({
    required this.name,
    required this.variant,
    required this.dosage,
    required this.started,
    required this.tag,
    required this.color,
    required this.refillsLeft,
    this.progress = 0.5,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 18),
      padding: const EdgeInsets.all(18),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        border: Border(left: BorderSide(color: color, width: 4)),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
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
                    name,
                    style: GoogleFonts.manrope(
                      fontSize: 18,
                      fontWeight: FontWeight.w800,
                      color: kcDarkGreyColor,
                    ),
                  ),
                  Text(
                    variant,
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: const Color(0xFF13EC13),
                    ),
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: color.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    Icon(Icons.refresh_rounded, size: 14, color: color),
                    const SizedBox(width: 4),
                    Text(
                      tag,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color: color,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "DOSAGE",
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: kcLightGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      dosage,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: kcDarkGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      "STARTED",
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight: FontWeight.w700,
                        color: kcLightGrey,
                      ),
                    ),
                    const SizedBox(height: 4),
                    Text(
                      started,
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight: FontWeight.w700,
                        color: kcDarkGreyColor,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          ClipRRect(
            borderRadius: BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: const Color(0xFFE8F5E9),
              valueColor:
                  const AlwaysStoppedAnimation<Color>(Color(0xFF13EC13)),
              minHeight: 8,
            ),
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Text(
                "$refillsLeft refills left",
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kcMediumGrey,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Expanded(
                child: ElevatedButton.icon(
                  onPressed: () {},
                  style: ElevatedButton.styleFrom(
                    backgroundColor: const Color(0xFF13EC13),
                    foregroundColor: Colors.black,
                    elevation: 0,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.symmetric(vertical: 16),
                  ),
                  icon: const Icon(Icons.shopping_cart_outlined, size: 18),
                  label: Text(
                    "Refill",
                    style: const TextStyle(
                      fontSize: 14,
                      fontWeight: FontWeight.w800,
                    ),
                  ),
                ),
              ),
              const SizedBox(width: 12),
              Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  border: Border.all(color: kcLightGrey.withOpacity(0.3)),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: const Icon(Icons.description_outlined,
                    color: kcDarkGreyColor),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _PastMedTile extends StatelessWidget {
  final String name, details, dates;
  final bool isLast;

  const _PastMedTile({
    required this.name,
    required this.details,
    required this.dates,
    this.isLast = false,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        children: [
          Container(
            padding: const EdgeInsets.all(10),
            decoration: BoxDecoration(
              color: const Color(0xFFE8F5E9),
              borderRadius: BorderRadius.circular(12),
            ),
            child: const Icon(Icons.medication_liquid_rounded,
                color: Color(0xFF4CAF50), size: 24),
          ),
          const SizedBox(width: 16),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  name,
                  style: GoogleFonts.manrope(
                    fontSize: 15,
                    fontWeight: FontWeight.w800,
                    color: kcDarkGreyColor,
                  ),
                ),
                Text(
                  details,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: const Color(0xFF13EC13),
                  ),
                ),
                const SizedBox(height: 4),
                Row(
                  children: [
                    const Icon(Icons.calendar_today_rounded,
                        size: 12, color: kcLightGrey),
                    const SizedBox(width: 4),
                    Text(
                      dates,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w500,
                        color: kcMediumGrey,
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
          TextButton(
            onPressed: () {},
            child: Text(
              "View",
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w800,
                color: const Color(0xFF13EC13),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class LabsTab extends StatelessWidget {
  const LabsTab({super.key});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 20),
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  "Recent Lab Results",
                  style: GoogleFonts.manrope(
                    fontSize: 18,
                    fontWeight: FontWeight.w800,
                    color: kcDarkGreyColor,
                  ),
                ),
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 8),
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(12),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.04),
                        blurRadius: 10,
                      ),
                    ],
                  ),
                  child: const Icon(Icons.tune_rounded,
                      size: 20, color: kcMediumGrey),
                ),
              ],
            ),
            const SizedBox(height: 20),
            const _LabResultCard(
              title: "Comprehensive Blood Panel",
              lab: "Idexx Laboratories",
              date: "Oct 24, 2023",
              doctor: "Dr. Alex",
              status: "Final Result",
              icon: Icons.science_rounded,
              iconColor: Color(0xFF3B5BDB),
            ),
            const _LabResultCard(
              title: "Urinalysis",
              lab: "In-House Lab",
              date: "Oct 20, 2023",
              doctor: "Dr. Sarah",
              status: "Final Result",
              icon: Icons.water_drop_rounded,
              iconColor: Colors.orange,
            ),
            const _LabResultCard(
              title: "Fecal Analysis (O&P)",
              lab: "Antech Diagnostics",
              date: "Nov 01, 2023",
              eta: "2 Days",
              status: "Pending",
              icon: Icons.biotech_rounded,
              iconColor: Colors.purple,
              isPending: true,
            ),
            const _LabResultCard(
              title: "Pre-Anesthetic Panel",
              lab: "Idexx Laboratories",
              date: "Jan 15, 2023",
              doctor: "Dr. Alex",
              status: "Final Result",
              icon: Icons.science_rounded,
              iconColor: Color(0xFF3B5BDB),
            ),
            const SizedBox(height: 100),
          ],
        ),
        Positioned(
          bottom: 20,
          left: 20,
          right: 20,
          child: ElevatedButton.icon(
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color(0xFF13EC13),
              foregroundColor: Colors.black,
              minimumSize: const Size(double.infinity, 56),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(28),
              ),
              elevation: 4,
            ),
            onPressed: () {},
            icon: const Icon(Icons.add, size: 24),
            label: Text(
              "Request New Test",
              style: GoogleFonts.manrope(
                fontSize: 16,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
        ),
      ],
    );
  }
}

class _LabResultCard extends StatelessWidget {
  final String title, lab, date, status;
  final String? doctor, eta;
  final IconData icon;
  final Color iconColor;
  final bool isPending;

  const _LabResultCard({
    required this.title,
    required this.lab,
    required this.date,
    required this.status,
    required this.icon,
    required this.iconColor,
    this.doctor,
    this.eta,
    this.isPending = false,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(24),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: iconColor.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(12),
                    ),
                    child: Icon(icon, color: iconColor, size: 20),
                  ),
                  const SizedBox(width: 12),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      SizedBox(
                        width: MediaQuery.of(context).size.width * 0.45,
                        child: Text(
                          title,
                          style: GoogleFonts.manrope(
                            fontSize: 15,
                            fontWeight: FontWeight.w800,
                            color: kcDarkGreyColor,
                          ),
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),
                      Text(
                        lab,
                        style: GoogleFonts.manrope(
                          fontSize: 12,
                          fontWeight: FontWeight.w600,
                          color: const Color(0xFF13EC13),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                decoration: BoxDecoration(
                  color: isPending
                      ? Colors.orange.withOpacity(0.1)
                      : const Color(0xFFE8F5E9),
                  borderRadius: BorderRadius.circular(12),
                ),
                child: Row(
                  children: [
                    if (isPending)
                      const Padding(
                        padding: EdgeInsets.only(right: 4),
                        child:
                            Icon(Icons.circle, size: 8, color: Colors.orange),
                      ),
                    Text(
                      status,
                      style: GoogleFonts.manrope(
                        fontSize: 11,
                        fontWeight: FontWeight.w800,
                        color:
                            isPending ? Colors.orange : const Color(0xFF2E7D32),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          Row(
            children: [
              Row(
                children: [
                  const Icon(Icons.calendar_today_rounded,
                      size: 14, color: kcLightGrey),
                  const SizedBox(width: 6),
                  Text(
                    date,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kcMediumGrey,
                    ),
                  ),
                ],
              ),
              const SizedBox(width: 20),
              Row(
                children: [
                  Icon(
                      isPending
                          ? Icons.timer_outlined
                          : Icons.person_outline_rounded,
                      size: 14,
                      color: kcLightGrey),
                  const SizedBox(width: 6),
                  Text(
                    isPending ? "ETA: $eta" : doctor!,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kcMediumGrey,
                    ),
                  ),
                ],
              ),
            ],
          ),
          const SizedBox(height: 16),
          const Divider(height: 1),
          const SizedBox(height: 16),
          SizedBox(
            width: double.infinity,
            height: 52,
            child: OutlinedButton(
              onPressed: () {},
              style: OutlinedButton.styleFrom(
                backgroundColor: isPending
                    ? const Color(0xFFE8F5E9).withOpacity(0.5)
                    : Colors.white,
                side: BorderSide(
                    color: isPending
                        ? Colors.transparent
                        : kcLightGrey.withOpacity(0.3)),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12),
                ),
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isPending
                        ? Icons.hourglass_empty_rounded
                        : Icons.picture_as_pdf_outlined,
                    size: 18,
                    color: isPending ? kcMediumGrey : Colors.red,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    isPending ? "Awaiting Results" : "View PDF Report",
                    style: GoogleFonts.manrope(
                      fontSize: 13,
                      fontWeight: FontWeight.w700,
                      color: isPending ? kcMediumGrey : kcDarkGreyColor,
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
}

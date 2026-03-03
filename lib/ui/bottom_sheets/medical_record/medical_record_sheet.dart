import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:stacked_services/stacked_services.dart';

class MedicalRecordSheet extends StatelessWidget {
  const MedicalRecordSheet({
    required this.request,
    super.key,
    this.completer,
  });

  final void Function(SheetResponse<dynamic>)? completer;
  final SheetRequest<dynamic> request;

  Map<String, dynamic> get _petData =>
      request.data is Map<String, dynamic>
          ? request.data as Map<String, dynamic>
          : <String, dynamic>{};

  @override
  Widget build(BuildContext context) {
    return Container(
      height: MediaQuery.of(context).size.height *
          0.92,
      decoration: const BoxDecoration(
        color: kcBackgroundColor,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(32),
          topRight: Radius.circular(32),
        ),
      ),
      child: Column(
        children: [
          const _DragHandle(),
          _SheetHeader(
            onClose: () => completer?.call(
              SheetResponse(),
            ),
            petName: _petData['petName']
                    as String? ??
                'Unknown',
            petAge:
                _petData['petAge'] as String?,
          ),
          Expanded(
            child: ListView(
              padding: const EdgeInsets.symmetric(
                horizontal: 20,
              ),
              children: const [
                _PastVisitsSection(),
                SizedBox(height: 24),
                _VaccinationSection(),
                SizedBox(height: 24),
                _LabReportsSection(),
                SizedBox(height: 24),
                _MedicationSection(),
                SizedBox(height: 120),
              ],
            ),
          ),
          _BottomAction(onPrint: () {}),
        ],
      ),
    );
  }
}

class _DragHandle extends StatelessWidget {
  const _DragHandle();

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.only(
        top: 12,
        bottom: 8,
      ),
      width: 48,
      height: 5,
      decoration: BoxDecoration(
        color: kcVeryLightGrey,
        borderRadius: BorderRadius.circular(10),
      ),
    );
  }
}

class _SheetHeader extends StatelessWidget {
  const _SheetHeader({
    required this.onClose,
    required this.petName,
    this.petAge,
  });

  final VoidCallback onClose;
  final String petName;
  final String? petAge;

  @override
  Widget build(BuildContext context) {
    final subtitle = petAge != null
        ? '$petName \u2022 $petAge'
        : petName;
    return Padding(
      padding:
          const EdgeInsets.fromLTRB(20, 12, 20, 20),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                'Medical Record',
                style: GoogleFonts.manrope(
                  fontSize: 24,
                  fontWeight: FontWeight.w900,
                  color: kcDarkGreyColor,
                ),
              ),
              Text(
                subtitle,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kcMediumGrey,
                ),
              ),
            ],
          ),
          GestureDetector(
            onTap: onClose,
            child: Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: kcVeryLightGrey.withValues(
                  alpha: 0.3,
                ),
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.close_rounded,
                size: 20,
                color: kcDarkGreyColor,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _PastVisitsSection extends StatelessWidget {
  const _PastVisitsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment:
              MainAxisAlignment.spaceBetween,
          children: [
            const _SectionTitle(
              title: 'PAST VISITS',
              icon: Icons.calendar_month_rounded,
            ),
            Text(
              'View All',
              style: GoogleFonts.manrope(
                fontSize: 12,
                fontWeight: FontWeight.w800,
                color: kcPrimaryColor,
              ),
            ),
          ],
        ),
        const SizedBox(height: 12),
        const _VisitCard(
          date: 'Oct 12, 2023',
          tag: 'Routine',
          tagColor: Colors.green,
          title: 'Annual Wellness Exam',
          description:
              'Physical exam normal. Teeth scaling '
              'recommended. Weight is stable. '
              'Administered annual boosters.',
        ),
        const SizedBox(height: 12),
        const _VisitCard(
          date: 'May 05, 2023',
          tag: 'Checkup',
          tagColor: Colors.orange,
          title: 'Ear Infection (Right)',
          description:
              'Client reported scratching. Otoscopy '
              'confirmed yeast infection. '
              'Prescribed drops.',
        ),
      ],
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({
    required this.title,
    required this.icon,
  });

  final String title;
  final IconData icon;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(
          icon,
          size: 18,
          color: kcPrimaryColor,
        ),
        const SizedBox(width: 8),
        Text(
          title,
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: kcDarkGreyColor,
            letterSpacing: 1,
          ),
        ),
      ],
    );
  }
}

class _VisitCard extends StatelessWidget {
  const _VisitCard({
    required this.date,
    required this.tag,
    required this.tagColor,
    required this.title,
    required this.description,
  });

  final String date;
  final String tag;
  final Color tagColor;
  final String title;
  final String description;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(20),
        border: Border.all(
          color:
              kcVeryLightGrey.withValues(alpha: 0.3),
        ),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment:
                MainAxisAlignment.spaceBetween,
            children: [
              Text(
                date,
                style: GoogleFonts.manrope(
                  fontSize: 11,
                  fontWeight: FontWeight.w700,
                  color: kcLightGrey,
                ),
              ),
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 10,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: tagColor.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius:
                      BorderRadius.circular(8),
                  border: Border.all(
                    color: tagColor.withValues(
                      alpha: 0.2,
                    ),
                  ),
                ),
                child: Text(
                  tag,
                  style: GoogleFonts.manrope(
                    fontSize: 10,
                    fontWeight: FontWeight.w800,
                    color: tagColor,
                  ),
                ),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Text(
            title,
            style: GoogleFonts.manrope(
              fontSize: 15,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
          const SizedBox(height: 6),
          Text(
            description,
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w500,
              color: kcMediumGrey,
            ),
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
        ],
      ),
    );
  }
}

class _VaccinationSection extends StatelessWidget {
  const _VaccinationSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionTitle(
          title: 'VACCINATIONS',
          icon: Icons.vaccines_rounded,
        ),
        const SizedBox(height: 12),
        Container(
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(20),
            border: Border.all(
              color: kcVeryLightGrey.withValues(
                alpha: 0.3,
              ),
            ),
          ),
          child: const Column(
            children: [
              _VaccineTile(
                name: 'Rabies (3 Year)',
                given: 'Oct 12, 2023',
                due: 'Oct 12, 2026',
                status: 'Up to date',
                statusColor: Colors.green,
              ),
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              _VaccineTile(
                name: 'DHPP Booster',
                given: 'Oct 12, 2023',
                due: 'Oct 12, 2024',
                status: 'Up to date',
                statusColor: Colors.green,
              ),
              Divider(
                height: 1,
                indent: 16,
                endIndent: 16,
              ),
              _VaccineTile(
                name: 'Bordetella',
                given: 'Jan 15, 2023',
                due: 'Jan 15, 2024',
                status: 'Overdue',
                statusColor: Colors.red,
                isOverdue: true,
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _VaccineTile extends StatelessWidget {
  const _VaccineTile({
    required this.name,
    required this.given,
    required this.due,
    required this.status,
    required this.statusColor,
    this.isOverdue = false,
  });

  final String name;
  final String given;
  final String due;
  final String status;
  final Color statusColor;
  final bool isOverdue;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              Text(
                name,
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: kcDarkGreyColor,
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Given: $given',
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kcMediumGrey,
                ),
              ),
            ],
          ),
          Column(
            crossAxisAlignment:
                CrossAxisAlignment.end,
            children: [
              Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 8,
                  vertical: 4,
                ),
                decoration: BoxDecoration(
                  color: statusColor.withValues(
                    alpha: 0.1,
                  ),
                  borderRadius:
                      BorderRadius.circular(8),
                ),
                child: Row(
                  children: [
                    Icon(
                      isOverdue
                          ? Icons.warning_rounded
                          : Icons
                              .check_circle_rounded,
                      size: 10,
                      color: statusColor,
                    ),
                    const SizedBox(width: 4),
                    Text(
                      status,
                      style: GoogleFonts.manrope(
                        fontSize: 10,
                        fontWeight:
                            FontWeight.w800,
                        color: statusColor,
                      ),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 4),
              Text(
                'Due: $due',
                style: GoogleFonts.manrope(
                  fontSize: 10,
                  fontWeight: FontWeight.w600,
                  color: isOverdue
                      ? Colors.red
                      : kcLightGrey,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _LabReportsSection extends StatelessWidget {
  const _LabReportsSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionTitle(
          title: 'LAB REPORTS',
          icon: Icons.science_rounded,
        ),
        const SizedBox(height: 12),
        Row(
          children: [
            _reportButton(
              'Blood Panel - Full CBC',
              'Oct 12, 2023',
            ),
            const SizedBox(width: 12),
            _reportButton(
              'Fecal Analysis',
              'May 05, 2023',
            ),
          ],
        ),
      ],
    );
  }

  Widget _reportButton(
    String title,
    String date,
  ) {
    return Expanded(
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          border: Border.all(
            color: kcVeryLightGrey.withValues(
              alpha: 0.3,
            ),
          ),
        ),
        child: Row(
          children: [
            Container(
              padding: const EdgeInsets.all(8),
              decoration: BoxDecoration(
                color: Colors.red.withValues(
                  alpha: 0.1,
                ),
                borderRadius:
                    BorderRadius.circular(10),
              ),
              child: const Icon(
                Icons.picture_as_pdf_rounded,
                color: Colors.red,
                size: 18,
              ),
            ),
            const SizedBox(width: 10),
            Expanded(
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  Text(
                    title,
                    style: GoogleFonts.manrope(
                      fontSize: 11,
                      fontWeight: FontWeight.w800,
                      color: kcDarkGreyColor,
                    ),
                    maxLines: 2,
                    overflow:
                        TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 2),
                  Text(
                    date,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: kcLightGrey,
                    ),
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

class _MedicationSection extends StatelessWidget {
  const _MedicationSection();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        const _SectionTitle(
          title: 'MEDICATIONS',
          icon: Icons.medication_rounded,
        ),
        const SizedBox(height: 12),
        Container(
          padding: const EdgeInsets.all(8),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius:
                BorderRadius.circular(24),
            border: Border.all(
              color: kcVeryLightGrey.withValues(
                alpha: 0.3,
              ),
            ),
          ),
          child: const Column(
            children: [
              _MedItem(
                name: 'Heartgard Plus',
                info: '1 Chewable \u2022 Monthly',
                meta: 'Refills remaining: 4',
                status: 'Active',
                isActive: true,
              ),
              SizedBox(height: 8),
              _MedItem(
                name: 'Posatex Otic',
                info:
                    '7 drops in right ear '
                    '\u2022 Twice daily',
                meta: 'Ended: May 20, 2023',
                status: 'Completed',
              ),
            ],
          ),
        ),
      ],
    );
  }
}

class _MedItem extends StatelessWidget {
  const _MedItem({
    required this.name,
    required this.info,
    required this.meta,
    required this.status,
    this.isActive = false,
  });

  final String name;
  final String info;
  final String meta;
  final String status;
  final bool isActive;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: isActive
            ? kcVeryLightGrey.withValues(
                alpha: 0.2,
              )
            : Colors.transparent,
        borderRadius: BorderRadius.circular(16),
      ),
      child: Opacity(
        opacity: isActive ? 1 : 0.6,
        child: Row(
          children: [
            Container(
              width: 44,
              height: 44,
              decoration: BoxDecoration(
                color: isActive
                    ? Colors.blue.withValues(
                        alpha: 0.1,
                      )
                    : kcVeryLightGrey.withValues(
                        alpha: 0.3,
                      ),
                shape: BoxShape.circle,
              ),
              child: Icon(
                isActive
                    ? Icons.medication_rounded
                    : Icons
                        .medication_liquid_rounded,
                color: isActive
                    ? Colors.blue
                    : kcLightGrey,
                size: 22,
              ),
            ),
            const SizedBox(width: 12),
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
                        style:
                            GoogleFonts.manrope(
                          fontSize: 14,
                          fontWeight:
                              FontWeight.w800,
                          color: kcDarkGreyColor,
                        ),
                      ),
                      Container(
                        padding: const EdgeInsets
                            .symmetric(
                          horizontal: 6,
                          vertical: 2,
                        ),
                        decoration: BoxDecoration(
                          color: isActive
                              ? Colors.blue
                                  .withValues(
                                  alpha: 0.1,
                                )
                              : kcVeryLightGrey
                                  .withValues(
                                  alpha: 0.3,
                                ),
                          borderRadius:
                              BorderRadius
                                  .circular(4),
                        ),
                        child: Text(
                          status,
                          style: GoogleFonts
                              .manrope(
                            fontSize: 9,
                            fontWeight:
                                FontWeight.w900,
                            color: isActive
                                ? Colors.blue
                                : kcMediumGrey,
                          ),
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 2),
                  Text(
                    info,
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w600,
                      color: kcMediumGrey,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    meta,
                    style: GoogleFonts.manrope(
                      fontSize: 10,
                      fontWeight: FontWeight.w600,
                      color: kcLightGrey,
                    ),
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

class _BottomAction extends StatelessWidget {
  const _BottomAction({required this.onPrint});

  final VoidCallback onPrint;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        16,
        20,
        40,
      ),
      color: Colors.white,
      child: GestureDetector(
        onTap: onPrint,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: kcPrimaryColor,
            borderRadius:
                BorderRadius.circular(16),
            boxShadow: [
              BoxShadow(
                color:
                    kcPrimaryColor.withValues(
                  alpha: 0.3,
                ),
                blurRadius: 15,
                offset: const Offset(0, 5),
              ),
            ],
          ),
          child: Row(
            mainAxisAlignment:
                MainAxisAlignment.center,
            children: [
              const Icon(
                Icons.print_rounded,
                color: kcNeutral900,
                size: 20,
              ),
              const SizedBox(width: 8),
              Text(
                'Print Full Record',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w800,
                  color: kcNeutral900,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

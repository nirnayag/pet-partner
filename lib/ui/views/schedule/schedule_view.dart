import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:stacked/stacked.dart';

import 'schedule_viewmodel.dart';

class ScheduleView extends StackedView<ScheduleViewModel> {
  const ScheduleView({Key? key}) : super(key: key);

  @override
  Widget builder(
    BuildContext context,
    ScheduleViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      bottomNavigationBar: _BottomNav(viewModel: viewModel),
      floatingActionButton: FloatingActionButton(
        onPressed: () {},
        backgroundColor: kcPrimaryColor,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: kcNeutral900, size: 32),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _ScheduleHeader(onBack: viewModel.goBack),
            const _SegmentedControl(),
            const _DateSelector(),
            const Divider(height: 1, color: kcVeryLightGrey),
            Expanded(child: _TimelineList(viewModel: viewModel)),
          ],
        ),
      ),
    );
  }

  @override
  ScheduleViewModel viewModelBuilder(BuildContext context) =>
      ScheduleViewModel();
}

class _ScheduleHeader extends StatelessWidget {
  final VoidCallback onBack;
  const _ScheduleHeader({required this.onBack});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(20, 20, 20, 10),
      child: Row(
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Icon(Icons.arrow_back_ios_new_rounded, size: 20),
          ),
          const SizedBox(width: 16),
          Stack(
            children: [
              Container(
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  border: Border.all(color: kcPrimaryColor, width: 2),
                ),
                padding: const EdgeInsets.all(2),
                child: const CircleAvatar(
                  radius: 20,
                  backgroundImage: NetworkImage(
                      "https://lh3.googleusercontent.com/aida-public/AB6AXuBJd8ONcjJZ57-hDQHBX_0G9ISuwNe-N2X_tSEUErAIBg-jTp0ZknKKNkdwFoNLKhbFs5Qrbw0-MOLQyGaVQNeMP320mph_Rhrkxd5_MfZqSFFB9vEgxh_fXpA7cQiYCkflyyX_cb-JZPVRh4xOPsT6AQrbqqV1ekAGLxK8GuH_DpeNDIi-DBHluOaCgp2O0pYRbvRJ5F26y8xlJPNnyR_VBkWB7hWmNzLVeeVHUwDISzC-xUWzYG4v9m3ohD1v8gFcPZu6JMbUNL4"),
                ),
              ),
              Positioned(
                right: 0,
                bottom: 0,
                child: Container(
                  width: 10,
                  height: 10,
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
                "Dr. Sarah",
                style: GoogleFonts.manrope(
                  fontSize: 18,
                  fontWeight: FontWeight.w800,
                  color: kcDarkGreyColor,
                ),
              ),
              Text(
                "Vet Clinic",
                style: GoogleFonts.manrope(
                  fontSize: 12,
                  fontWeight: FontWeight.w600,
                  color: kcMediumGrey,
                ),
              ),
            ],
          ),
          const Spacer(),
          Stack(
            children: [
              const Icon(Icons.notifications_none_rounded,
                  color: kcDarkGreyColor, size: 28),
              Positioned(
                right: 4,
                top: 4,
                child: Container(
                  width: 8,
                  height: 8,
                  decoration: const BoxDecoration(
                    color: kcPrimaryColor,
                    shape: BoxShape.circle,
                  ),
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}

class _SegmentedControl extends StatelessWidget {
  const _SegmentedControl();

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 16),
      child: Container(
        height: 50,
        decoration: BoxDecoration(
          color: kcVeryLightGrey.withOpacity(0.3),
          borderRadius: BorderRadius.circular(16),
        ),
        child: Row(
          children: [
            _segmentItem("Day", true),
            _segmentItem("Week", false),
            _segmentItem("Month", false),
          ],
        ),
      ),
    );
  }

  Widget _segmentItem(String text, bool isActive) {
    return Expanded(
      child: Container(
        margin: const EdgeInsets.all(4),
        decoration: BoxDecoration(
          color: isActive ? Colors.white : Colors.transparent,
          borderRadius: BorderRadius.circular(12),
          boxShadow: isActive
              ? [
                  BoxShadow(
                    color: Colors.black.withOpacity(0.05),
                    blurRadius: 5,
                  )
                ]
              : null,
        ),
        child: Center(
          child: Text(
            text,
            style: GoogleFonts.manrope(
              fontSize: 14,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? kcDarkGreyColor : kcMediumGrey,
            ),
          ),
        ),
      ),
    );
  }
}

class _DateSelector extends StatelessWidget {
  const _DateSelector();

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 20),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              const Icon(Icons.chevron_left, color: kcLightGrey),
              Text(
                "October 2023",
                style: GoogleFonts.manrope(
                  fontSize: 20,
                  fontWeight: FontWeight.w800,
                  color: kcDarkGreyColor,
                ),
              ),
              const Icon(Icons.chevron_right, color: kcLightGrey),
            ],
          ),
        ),
        const SizedBox(height: 16),
        SizedBox(
          height: 90,
          child: ListView(
            scrollDirection: Axis.horizontal,
            padding: const EdgeInsets.symmetric(horizontal: 20),
            children: [
              _dayCard("Tue", "23", false),
              _dayCard("Wed", "24", true),
              _dayCard("Thu", "25", false),
              _dayCard("Fri", "26", false),
              _dayCard("Sat", "27", false),
            ],
          ),
        ),
        const SizedBox(height: 16),
      ],
    );
  }

  Widget _dayCard(String day, String date, bool isActive) {
    return Container(
      width: 65,
      margin: const EdgeInsets.only(right: 12),
      decoration: BoxDecoration(
        color: isActive ? kcPrimaryColor : Colors.white,
        borderRadius: BorderRadius.circular(20),
        boxShadow: isActive
            ? [
                BoxShadow(
                  color: kcPrimaryColor.withOpacity(0.3),
                  blurRadius: 10,
                  offset: const Offset(0, 4),
                )
              ]
            : [
                BoxShadow(
                  color: Colors.black.withOpacity(0.02),
                  blurRadius: 5,
                )
              ],
        border: !isActive
            ? Border.all(color: kcVeryLightGrey.withOpacity(0.5))
            : null,
      ),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Text(
            day,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? kcNeutral900 : kcLightGrey,
            ),
          ),
          const SizedBox(height: 4),
          Text(
            date,
            style: GoogleFonts.manrope(
              fontSize: 20,
              fontWeight: FontWeight.w800,
              color: isActive ? kcNeutral900 : kcDarkGreyColor,
            ),
          ),
        ],
      ),
    );
  }
}

class _TimelineList extends StatelessWidget {
  final ScheduleViewModel viewModel;
  const _TimelineList({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        ListView(
          padding: const EdgeInsets.only(top: 20, bottom: 40),
          children: [
            _timeSlot("08:00", isEmpty: true),
            _timeSlot("09:00",
                appointment: _Appointment(
                  name: "Bella",
                  breed: "Golden Retriever",
                  type: "ANNUAL CHECKUP",
                  owner: "John Doe",
                  color: Colors.blue,
                  icon: Icons.pets,
                )),
            _timeSlot("10:00",
                appointment: _Appointment(
                  name: "Max",
                  breed: "Siamese Cat",
                  type: "DENTAL",
                  time: "10:30 - 11:30",
                  color: kcPrimaryColor,
                  icon: Icons.cruelty_free,
                )),
            _timeSlot("11:00", isEmpty: true),
            _timeSlot("12:00",
                appointment: _Appointment(
                  name: "Rocky",
                  breed: "Bulldog",
                  type: "SURGERY",
                  color: Colors.orange,
                  icon: Icons.medical_services,
                  isHalfWidth: true,
                )),
            _timeSlot("01:00", isBreak: true),
            _timeSlot("02:00",
                appointment: _Appointment(
                  name: "Luna",
                  breed: "Rabbit",
                  type: "NAIL TRIM",
                  time: "2:15 PM",
                  color: Colors.pink,
                  icon: Icons.content_cut,
                )),
            _timeSlot("03:00", isEmpty: true),
          ],
        ),
        // Current Time Indicator
        Positioned(
          top: 245, // Adjusted to match 10:45 position manually for now
          left: 0,
          right: 0,
          child: Row(
            children: [
              Container(
                width: 60,
                padding: const EdgeInsets.only(right: 8),
                child: Text(
                  "10:45",
                  textAlign: TextAlign.right,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w900,
                    color: kcPrimaryColor,
                  ),
                ),
              ),
              Expanded(
                child: Stack(
                  alignment: Alignment.centerLeft,
                  children: [
                    Container(height: 2, color: kcPrimaryColor),
                    Container(
                      width: 10,
                      height: 10,
                      decoration: const BoxDecoration(
                        color: kcPrimaryColor,
                        shape: BoxShape.circle,
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

  Widget _timeSlot(String time,
      {bool isEmpty = false, bool isBreak = false, _Appointment? appointment}) {
    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Container(
            width: 60,
            padding: const EdgeInsets.only(right: 12, top: 2),
            child: Text(
              time,
              textAlign: TextAlign.right,
              style: GoogleFonts.manrope(
                fontSize: 13,
                fontWeight: FontWeight.w700,
                color: kcLightGrey,
              ),
            ),
          ),
          Expanded(
            child: Container(
              decoration: BoxDecoration(
                border: Border(
                  left: BorderSide(color: kcVeryLightGrey.withOpacity(0.5)),
                  bottom: BorderSide(color: kcVeryLightGrey.withOpacity(0.2)),
                ),
                color: isBreak ? kcVeryLightGrey.withOpacity(0.1) : null,
              ),
              child: isBreak
                  ? Center(
                      child: Container(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white.withOpacity(0.5),
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Text(
                          "LUNCH BREAK",
                          style: GoogleFonts.manrope(
                            fontSize: 10,
                            fontWeight: FontWeight.w800,
                            letterSpacing: 1.5,
                            color: kcLightGrey,
                          ),
                        ),
                      ),
                    )
                  : (isEmpty
                      ? Align(
                          alignment: Alignment.centerLeft,
                          child: Padding(
                            padding: const EdgeInsets.only(left: 16),
                            child: Text(
                              "Available",
                              style: GoogleFonts.manrope(
                                fontStyle: FontStyle.italic,
                                fontSize: 12,
                                color: kcVeryLightGrey,
                              ),
                            ),
                          ),
                        )
                      : (appointment != null
                          ? _appointmentCard(appointment, viewModel)
                          : const SizedBox(height: 100))),
            ),
          ),
        ],
      ),
    );
  }

  Widget _appointmentCard(_Appointment data, ScheduleViewModel viewModel) {
    return GestureDetector(
      onTap: viewModel.navigateToAppointmentDetail,
      child: Container(
        margin: EdgeInsets.fromLTRB(8, 8, data.isHalfWidth ? 100 : 8, 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: data.color.withOpacity(0.1),
          borderRadius: BorderRadius.circular(16),
          border: Border(left: BorderSide(color: data.color, width: 4)),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        data.name,
                        style: GoogleFonts.manrope(
                          fontWeight: FontWeight.w800,
                          fontSize: 15,
                          color: kcDarkGreyColor,
                        ),
                      ),
                      Text(
                        data.breed,
                        style: GoogleFonts.manrope(
                          fontSize: 11,
                          fontWeight: FontWeight.w600,
                          color: kcMediumGrey,
                        ),
                      ),
                    ],
                  ),
                ),
                Container(
                  padding: const EdgeInsets.all(6),
                  decoration: BoxDecoration(
                    color: Colors.white.withOpacity(0.5),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Icon(data.icon, color: data.color, size: 16),
                ),
              ],
            ),
            const Spacer(),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Container(
                  padding:
                      const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                  decoration: BoxDecoration(
                    color: data.color,
                    borderRadius: BorderRadius.circular(6),
                  ),
                  child: Text(
                    data.type,
                    style: GoogleFonts.manrope(
                      fontSize: 9,
                      fontWeight: FontWeight.w900,
                      color: data.color == kcPrimaryColor
                          ? kcNeutral900
                          : Colors.white,
                    ),
                  ),
                ),
                if (data.owner != null || data.time != null)
                  Row(
                    children: [
                      Icon(data.owner != null ? Icons.person : Icons.schedule,
                          size: 12, color: kcLightGrey),
                      const SizedBox(width: 4),
                      Text(
                        data.owner ?? data.time!,
                        style: GoogleFonts.manrope(
                          fontSize: 10,
                          fontWeight: FontWeight.w600,
                          color: kcMediumGrey,
                        ),
                      ),
                    ],
                  ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

class _Appointment {
  final String name;
  final String breed;
  final String type;
  final String? owner;
  final String? time;
  final Color color;
  final IconData icon;
  final bool isHalfWidth;

  _Appointment({
    required this.name,
    required this.breed,
    required this.type,
    this.owner,
    this.time,
    required this.color,
    required this.icon,
    this.isHalfWidth = false,
  });
}

class _BottomNav extends StatelessWidget {
  final ScheduleViewModel viewModel;
  const _BottomNav({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 80,
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(top: BorderSide(color: kcVeryLightGrey, width: 0.5)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceAround,
        children: [
          _navItem(Icons.grid_view_rounded, "Home", false,
              onTap: viewModel.navigateToHomeView),
          _navItem(Icons.pets_rounded, "Patients", false,
              onTap: viewModel.navigateToPatientRegistryView),
          _navItem(Icons.calendar_month_rounded, "Calendar", true,
              onTap: () {}),
          _navItem(Icons.person_outline_rounded, "Profile", false,
              onTap: () {}),
        ],
      ),
    );
  }

  Widget _navItem(IconData icon, String label, bool isActive,
      {bool hasBadge = false, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Stack(
            children: [
              Icon(
                icon,
                color: isActive ? kcPrimaryColor : kcLightGrey,
                size: 26,
              ),
              if (hasBadge)
                Positioned(
                  right: 0,
                  top: 0,
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
          const SizedBox(height: 4),
          Text(
            label,
            style: GoogleFonts.manrope(
              fontSize: 10,
              fontWeight: isActive ? FontWeight.w800 : FontWeight.w600,
              color: isActive ? kcPrimaryColor : kcLightGrey,
            ),
          ),
        ],
      ),
    );
  }
}

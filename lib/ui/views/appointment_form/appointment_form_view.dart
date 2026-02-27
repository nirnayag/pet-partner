import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/ui/common/app_colors.dart';
// ignore: lines_longer_than_80_chars, long generated path
import 'package:partner/ui/views/appointment_form/appointment_form_viewmodel.dart';
import 'package:stacked/stacked.dart';

/// Form view for creating or editing an
/// appointment.
class AppointmentFormView
    extends StackedView<AppointmentFormViewmodel> {
  /// Creates an [AppointmentFormView].
  const AppointmentFormView({
    this.appointment,
    super.key,
  });

  /// The appointment to edit, or `null` for
  /// create mode.
  final Appointment? appointment;

  @override
  AppointmentFormViewmodel viewModelBuilder(
    BuildContext context,
  ) =>
      AppointmentFormViewmodel(
        appointment: appointment,
      );

  @override
  Widget builder(
    BuildContext context,
    AppointmentFormViewmodel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Column(
        children: [
          _FormAppBar(
            isEditMode: viewModel.isEditMode,
          ),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                120,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (viewModel.errorMessage !=
                      null)
                    _ErrorBanner(
                      message:
                          viewModel.errorMessage!,
                    ),

                  // --- Owner section ---
                  const _SectionTitle(
                    title: 'PET OWNER',
                  ),
                  const SizedBox(height: 8),
                  _OwnerSearchSection(
                    viewModel: viewModel,
                  ),
                  const SizedBox(height: 20),

                  // --- Pet selection ---
                  if (viewModel
                      .ownerPets.isNotEmpty) ...[
                    const _SectionTitle(title: 'PET'),
                    const SizedBox(height: 8),
                    _PetSelector(
                      pets: viewModel.ownerPets,
                      selected:
                          viewModel.selectedPet,
                      onSelect:
                          viewModel.selectPet,
                    ),
                    const SizedBox(height: 20),
                  ],

                  // --- Title ---
                  const _SectionTitle(
                    title: 'TITLE *',
                  ),
                  const SizedBox(height: 8),
                  _InputField(
                    controller:
                        viewModel.titleController,
                    hint:
                        'e.g. Annual checkup',
                  ),
                  const SizedBox(height: 20),

                  // --- Type ---
                  const _SectionTitle(
                    title: 'TYPE',
                  ),
                  const SizedBox(height: 8),
                  _TypeDropdown(
                    value: viewModel.selectedType,
                    onChanged: viewModel.setType,
                  ),
                  const SizedBox(height: 20),

                  // --- Date & Time ---
                  Row(
                    children: [
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const _SectionTitle(
                              title: 'DATE *',
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            _DateField(
                              date: viewModel
                                  .selectedDate,
                              onTap: () =>
                                  _pickDate(
                                context,
                                viewModel,
                              ),
                            ),
                          ],
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: Column(
                          crossAxisAlignment:
                              CrossAxisAlignment
                                  .start,
                          children: [
                            const _SectionTitle(
                              title: 'TIME *',
                            ),
                            const SizedBox(
                              height: 8,
                            ),
                            _TimeField(
                              time: viewModel
                                  .selectedTime,
                              onTap: () =>
                                  _pickTime(
                                context,
                                viewModel,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                  const SizedBox(height: 20),

                  // --- Duration ---
                  const _SectionTitle(
                    title: 'DURATION',
                  ),
                  const SizedBox(height: 8),
                  _DurationSelector(
                    selected:
                        viewModel.durationMinutes,
                    onChanged:
                        viewModel.setDuration,
                  ),
                  const SizedBox(height: 20),

                  // --- Room number ---
                  const _SectionTitle(
                    title: 'ROOM NUMBER',
                  ),
                  const SizedBox(height: 8),
                  _InputField(
                    controller: viewModel
                        .roomNumberController,
                    hint: 'Optional',
                  ),
                  const SizedBox(height: 20),

                  // --- Pre-appointment notes ---
                  const _SectionTitle(
                    title:
                        'PRE-APPOINTMENT NOTES',
                  ),
                  const SizedBox(height: 8),
                  _InputField(
                    controller: viewModel
                        .preAppointmentNotesController,
                    hint: 'Instructions for '
                        'the pet owner...',
                    maxLines: 4,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _SubmitButton(
        isBusy: viewModel.isBusy,
        isEditMode: viewModel.isEditMode,
        onTap: viewModel.saveAppointment,
      ),
    );
  }

  Future<void> _pickDate(
    BuildContext context,
    AppointmentFormViewmodel viewModel,
  ) async {
    final now = DateTime.now();
    final picked = await showDatePicker(
      context: context,
      initialDate:
          viewModel.selectedDate ?? now,
      firstDate: now,
      lastDate: now.add(
        const Duration(days: 365),
      ),
    );
    if (picked != null) {
      viewModel.setDate(picked);
    }
  }

  Future<void> _pickTime(
    BuildContext context,
    AppointmentFormViewmodel viewModel,
  ) async {
    final picked = await showTimePicker(
      context: context,
      initialTime:
          viewModel.selectedTime ??
          const TimeOfDay(hour: 9, minute: 0),
    );
    if (picked != null) {
      viewModel.setTime(picked);
    }
  }
}

// ---- Private Widgets ----

class _FormAppBar extends StatelessWidget {
  const _FormAppBar({required this.isEditMode});

  final bool isEditMode;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        50,
        16,
        16,
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
          GestureDetector(
            onTap: () =>
                Navigator.of(context).pop(),
            child: const Icon(
              Icons.arrow_back_rounded,
              color: kcDarkGreyColor,
            ),
          ),
          Text(
            isEditMode
                ? 'Edit Appointment'
                : 'New Appointment',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  const _SectionTitle({required this.title});

  final String title;

  @override
  Widget build(BuildContext context) {
    return Text(
      title,
      style: GoogleFonts.manrope(
        fontSize: 11,
        fontWeight: FontWeight.w900,
        color: kcLightGrey,
        letterSpacing: 1,
      ),
    );
  }
}

class _InputField extends StatelessWidget {
  const _InputField({
    required this.controller,
    required this.hint,
    this.maxLines = 1,
  });

  final TextEditingController controller;
  final String hint;
  final int maxLines;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: TextField(
        controller: controller,
        maxLines: maxLines,
        style: GoogleFonts.manrope(
          fontSize: 14,
          color: kcDarkGreyColor,
        ),
        decoration: InputDecoration(
          hintText: hint,
          hintStyle: GoogleFonts.manrope(
            color: kcLightGrey,
            fontSize: 14,
            fontWeight: FontWeight.w500,
          ),
          border: InputBorder.none,
          contentPadding:
              const EdgeInsets.symmetric(
            vertical: 16,
          ),
        ),
      ),
    );
  }
}

class _OwnerSearchSection extends StatelessWidget {
  const _OwnerSearchSection({
    required this.viewModel,
  });

  final AppointmentFormViewmodel viewModel;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Expanded(
              child: Container(
                padding:
                    const EdgeInsets.symmetric(
                  horizontal: 16,
                ),
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
                      offset:
                          const Offset(0, 4),
                    ),
                  ],
                ),
                child: TextField(
                  controller: viewModel
                      .phoneSearchController,
                  keyboardType:
                      TextInputType.phone,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    color: kcDarkGreyColor,
                  ),
                  decoration: InputDecoration(
                    hintText: 'Phone number',
                    hintStyle:
                        GoogleFonts.manrope(
                      color: kcLightGrey,
                      fontSize: 14,
                      fontWeight: FontWeight.w500,
                    ),
                    border: InputBorder.none,
                    contentPadding:
                        const EdgeInsets
                            .symmetric(
                      vertical: 16,
                    ),
                  ),
                ),
              ),
            ),
            const SizedBox(width: 12),
            GestureDetector(
              onTap: viewModel.isSearchingOwner
                  ? null
                  : viewModel.searchOwnerByPhone,
              child: Container(
                height: 52,
                width: 52,
                decoration: BoxDecoration(
                  color: kcPrimaryColor,
                  borderRadius:
                      BorderRadius.circular(16),
                ),
                child: viewModel.isSearchingOwner
                    ? const Padding(
                        padding:
                            EdgeInsets.all(14),
                        child:
                            CircularProgressIndicator(
                          strokeWidth: 2.5,
                          color: kcNeutral900,
                        ),
                      )
                    : const Icon(
                        Icons.search_rounded,
                        color: kcNeutral900,
                      ),
              ),
            ),
          ],
        ),
        if (viewModel.ownerSearchError !=
            null) ...[
          const SizedBox(height: 8),
          Text(
            viewModel.ownerSearchError!,
            style: GoogleFonts.manrope(
              fontSize: 12,
              fontWeight: FontWeight.w600,
              color: Colors.red[600],
            ),
          ),
        ],
        if (viewModel.selectedOwner != null) ...[
          const SizedBox(height: 12),
          _OwnerCard(
            owner: viewModel.selectedOwner,
          ),
        ],
      ],
    );
  }
}

class _OwnerCard extends StatelessWidget {
  const _OwnerCard({required this.owner});

  final dynamic owner;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        border: Border.all(
          color: kcPrimaryColor.withValues(
            alpha: 0.3,
          ),
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 40,
            height: 40,
            decoration: const BoxDecoration(
              color: kcVeryLightGrey,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.person_rounded,
              color: kcMediumGrey,
              size: 20,
            ),
          ),
          const SizedBox(width: 12),
          Expanded(
            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,
              children: [
                // ignore: avoid_dynamic_calls, owner is dynamic until PetOwner model is typed
                Text(
                  // ignore: avoid_dynamic_calls, owner is dynamic until PetOwner model is typed
                  owner.fullName as String,
                  style: GoogleFonts.manrope(
                    fontSize: 14,
                    fontWeight: FontWeight.w800,
                    color: kcDarkGreyColor,
                  ),
                ),
                Text(
                  // ignore: avoid_dynamic_calls, owner is dynamic until PetOwner model is typed
                  owner.phone as String,
                  style: GoogleFonts.manrope(
                    fontSize: 12,
                    fontWeight: FontWeight.w600,
                    color: kcMediumGrey,
                  ),
                ),
              ],
            ),
          ),
          const Icon(
            Icons.check_circle_rounded,
            color: kcPrimaryColor,
            size: 24,
          ),
        ],
      ),
    );
  }
}

class _PetSelector extends StatelessWidget {
  const _PetSelector({
    required this.pets,
    required this.selected,
    required this.onSelect,
  });

  final List<Pet> pets;
  final Pet? selected;
  final ValueChanged<Pet> onSelect;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 48,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: pets.length,
        separatorBuilder: (_, __) =>
            const SizedBox(width: 8),
        itemBuilder: (_, index) {
          final pet = pets[index];
          final isSelected =
              selected?.id == pet.id;
          return GestureDetector(
            onTap: () => onSelect(pet),
            child: Container(
              padding:
                  const EdgeInsets.symmetric(
                horizontal: 16,
                vertical: 12,
              ),
              decoration: BoxDecoration(
                color: isSelected
                    ? kcNeutral900
                    : Colors.white,
                borderRadius:
                    BorderRadius.circular(14),
                boxShadow: isSelected
                    ? null
                    : [
                        BoxShadow(
                          color: Colors.black
                              .withValues(
                            alpha: 0.03,
                          ),
                          blurRadius: 5,
                        ),
                      ],
              ),
              child: Text(
                pet.name,
                style: GoogleFonts.manrope(
                  fontSize: 13,
                  fontWeight: FontWeight.w700,
                  color: isSelected
                      ? Colors.white
                      : kcMediumGrey,
                ),
              ),
            ),
          );
        },
      ),
    );
  }
}

class _TypeDropdown extends StatelessWidget {
  const _TypeDropdown({
    required this.value,
    required this.onChanged,
  });

  final String value;
  final ValueChanged<String> onChanged;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.03),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: DropdownButtonHideUnderline(
        child: DropdownButton<String>(
          value: value,
          isExpanded: true,
          icon: const Icon(
            Icons.keyboard_arrow_down_rounded,
            color: kcMediumGrey,
          ),
          style: GoogleFonts.manrope(
            fontSize: 14,
            color: kcDarkGreyColor,
          ),
          items: AppointmentFormViewmodel
              .typeOptions
              .map(
                (e) => DropdownMenuItem<String>(
                  value: e,
                  child: Text(
                    _formatType(e),
                  ),
                ),
              )
              .toList(),
          onChanged: (v) {
            if (v != null) onChanged(v);
          },
        ),
      ),
    );
  }

  String _formatType(String type) {
    return '${type[0].toUpperCase()}'
        '${type.substring(1)}';
  }
}

class _DateField extends StatelessWidget {
  const _DateField({
    required this.date,
    required this.onTap,
  });

  final DateTime? date;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = date != null
        ? DateFormat('dd MMM yyyy')
            .format(date!)
        : 'Select date';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.calendar_today_rounded,
              size: 16,
              color: kcMediumGrey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: date != null
                    ? kcDarkGreyColor
                    : kcLightGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _TimeField extends StatelessWidget {
  const _TimeField({
    required this.time,
    required this.onTap,
  });

  final TimeOfDay? time;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    final label = time != null
        ? time!.format(context)
        : 'Select time';

    return GestureDetector(
      onTap: onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 16,
          vertical: 16,
        ),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius:
              BorderRadius.circular(16),
          boxShadow: [
            BoxShadow(
              color: Colors.black
                  .withValues(alpha: 0.03),
              blurRadius: 10,
              offset: const Offset(0, 4),
            ),
          ],
        ),
        child: Row(
          children: [
            const Icon(
              Icons.access_time_rounded,
              size: 16,
              color: kcMediumGrey,
            ),
            const SizedBox(width: 8),
            Text(
              label,
              style: GoogleFonts.manrope(
                fontSize: 14,
                color: time != null
                    ? kcDarkGreyColor
                    : kcLightGrey,
                fontWeight: FontWeight.w500,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _DurationSelector extends StatelessWidget {
  const _DurationSelector({
    required this.selected,
    required this.onChanged,
  });

  final int selected;
  final ValueChanged<int> onChanged;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: AppointmentFormViewmodel
          .durationOptions
          .map(
            (mins) => Expanded(
              child: GestureDetector(
                onTap: () => onChanged(mins),
                child: Container(
                  margin:
                      const EdgeInsets.symmetric(
                    horizontal: 4,
                  ),
                  padding:
                      const EdgeInsets.symmetric(
                    vertical: 14,
                  ),
                  decoration: BoxDecoration(
                    color: selected == mins
                        ? kcNeutral900
                        : Colors.white,
                    borderRadius:
                        BorderRadius.circular(14),
                    boxShadow:
                        selected == mins
                            ? null
                            : [
                                BoxShadow(
                                  color: Colors
                                      .black
                                      .withValues(
                                    alpha: 0.03,
                                  ),
                                  blurRadius: 5,
                                ),
                              ],
                  ),
                  child: Center(
                    child: Text(
                      '${mins}m',
                      style: GoogleFonts.manrope(
                        fontSize: 13,
                        fontWeight:
                            FontWeight.w700,
                        color: selected == mins
                            ? Colors.white
                            : kcMediumGrey,
                      ),
                    ),
                  ),
                ),
              ),
            ),
          )
          .toList(),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        message,
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.red[700],
        ),
      ),
    );
  }
}

class _SubmitButton extends StatelessWidget {
  const _SubmitButton({
    required this.isBusy,
    required this.isEditMode,
    required this.onTap,
  });

  final bool isBusy;
  final bool isEditMode;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        40,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black
                .withValues(alpha: 0.05),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: isBusy ? null : onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isBusy
                ? kcLightGrey
                : kcPrimaryColor,
            borderRadius:
                BorderRadius.circular(18),
            boxShadow: isBusy
                ? null
                : [
                    BoxShadow(
                      color: kcPrimaryColor
                          .withValues(
                        alpha: 0.3,
                      ),
                      blurRadius: 12,
                    ),
                  ],
          ),
          child: Center(
            child: isBusy
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    isEditMode
                        ? 'Update Appointment'
                        : 'Book Appointment',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight: FontWeight.w900,
                      color: kcNeutral900,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

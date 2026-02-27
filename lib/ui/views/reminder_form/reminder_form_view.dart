import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:intl/intl.dart';
import 'package:partner/core/models/reminder/reminder.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/reminder_form/reminder_form_viewmodel.dart';
import 'package:partner/ui/views/reminder_form/widgets/channel_selector.dart';
import 'package:partner/ui/views/reminder_form/widgets/reminder_form_fields.dart';
import 'package:partner/ui/views/staff_form/widgets/staff_form_fields.dart';
import 'package:stacked/stacked.dart';

/// Form view for creating or editing a reminder.
class ReminderFormView
    extends StackedView<ReminderFormViewModel> {
  /// Creates a [ReminderFormView].
  const ReminderFormView({
    this.reminder,
    this.petId,
    this.ownerId,
    super.key,
  });

  /// The reminder to edit, or `null` for create.
  final Reminder? reminder;

  /// Pre-filled pet ID.
  final String? petId;

  /// Pre-filled owner ID.
  final String? ownerId;

  @override
  ReminderFormViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReminderFormViewModel(
        reminder: reminder,
        petId: petId,
        ownerId: ownerId,
      );

  @override
  void onViewModelReady(
    ReminderFormViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    ReminderFormViewModel viewModel,
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
                      message: viewModel
                          .errorMessage!,
                    ),
                  StaffFormField(
                    controller: viewModel
                        .titleController,
                    label: 'Title *',
                    hint:
                        'e.g. Vaccination Due',
                  ),
                  const SizedBox(height: 16),
                  ReminderTypeDropdown(
                    value:
                        viewModel.selectedType,
                    onChanged: viewModel.setType,
                  ),
                  const SizedBox(height: 16),
                  StaffFormField(
                    controller: viewModel
                        .messageController,
                    label: 'Message',
                    hint: 'Reminder details...',
                    maxLines: 3,
                  ),
                  const SizedBox(height: 16),
                  _SchedulePicker(
                    scheduledFor:
                        viewModel.scheduledFor,
                    onPick: () => _pickDateTime(
                      context,
                      viewModel,
                    ),
                  ),
                  const SizedBox(height: 16),
                  ChannelSelector(
                    selected: viewModel
                        .selectedChannels,
                    onToggle:
                        viewModel.toggleChannel,
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
        onTap: viewModel.save,
      ),
    );
  }

  Future<void> _pickDateTime(
    BuildContext context,
    ReminderFormViewModel viewModel,
  ) async {
    final now = DateTime.now();
    final date = await showDatePicker(
      context: context,
      initialDate:
          viewModel.scheduledFor ?? now,
      firstDate: now,
      lastDate: now.add(
        const Duration(days: 365),
      ),
    );
    if (date == null || !context.mounted) return;

    final time = await showTimePicker(
      context: context,
      initialTime:
          viewModel.scheduledFor != null
              ? TimeOfDay.fromDateTime(
                  viewModel.scheduledFor!,
                )
              : const TimeOfDay(
                  hour: 9,
                  minute: 0,
                ),
    );
    if (time == null) return;

    viewModel.setScheduledFor(
      DateTime(
        date.year,
        date.month,
        date.day,
        time.hour,
        time.minute,
      ),
    );
  }
}

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
                ? 'Edit Reminder'
                : 'New Reminder',
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

class _SchedulePicker extends StatelessWidget {
  const _SchedulePicker({
    required this.scheduledFor,
    required this.onPick,
  });

  final DateTime? scheduledFor;
  final VoidCallback onPick;

  @override
  Widget build(BuildContext context) {
    final label = scheduledFor != null
        ? DateFormat('MMM dd, yyyy HH:mm')
            .format(scheduledFor!)
        : 'Select date & time';

    return Column(
      crossAxisAlignment:
          CrossAxisAlignment.start,
      children: [
        Text(
          'SCHEDULED FOR *',
          style: GoogleFonts.manrope(
            fontSize: 11,
            fontWeight: FontWeight.w900,
            color: kcLightGrey,
            letterSpacing: 1,
          ),
        ),
        const SizedBox(height: 8),
        GestureDetector(
          onTap: onPick,
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
                    color: scheduledFor != null
                        ? kcDarkGreyColor
                        : kcLightGrey,
                    fontWeight: FontWeight.w500,
                  ),
                ),
              ],
            ),
          ),
        ),
      ],
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
        color:
            Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color: Colors.red
              .withValues(alpha: 0.3),
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
                        ? 'Update Reminder'
                        : 'Create Reminder',
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

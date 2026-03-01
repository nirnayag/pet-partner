import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/enums/reminder_type.dart';
import 'package:partner/core/models/reminder/reminder.dart';
import 'package:partner/services/reminder_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for creating or editing a reminder.
class ReminderFormViewModel
    extends BaseViewModel
    with ErrorHandlingMixin {
  /// Creates a [ReminderFormViewModel].
  ///
  /// When [reminder] is provided the form opens
  /// in edit mode. [petId] and [ownerId] can
  /// pre-fill associations.
  ReminderFormViewModel({
    this.reminder,
    this.petId,
    this.ownerId,
  });

  /// The reminder being edited, or `null`.
  final Reminder? reminder;

  /// Pre-filled pet ID.
  final String? petId;

  /// Pre-filled owner ID.
  final String? ownerId;

  final _reminderService =
      locator<ReminderService>();
  final _navigationService =
      locator<NavigationService>();

  // ---- Controllers ----

  /// Title field controller.
  final titleController = TextEditingController();

  /// Message field controller.
  final messageController =
      TextEditingController();

  // ---- State ----

  ReminderType _selectedType =
      ReminderType.appointment;

  /// The selected reminder type.
  ReminderType get selectedType => _selectedType;

  DateTime? _scheduledFor;

  /// The selected scheduled date/time.
  DateTime? get scheduledFor => _scheduledFor;

  final Set<String> _selectedChannels = {
    'push',
  };

  /// The selected delivery channels.
  Set<String> get selectedChannels =>
      _selectedChannels;

  /// Whether the form is in edit mode.
  bool get isEditMode => reminder != null;

  // errorMessage and hasError provided by
  // ErrorHandlingMixin.

  /// Available channel options.
  static const channelOptions = <String>[
    'sms',
    'email',
    'push',
  ];

  // ---- Lifecycle ----

  /// Initialises form fields.
  void initialise() {
    if (reminder != null) {
      titleController.text = reminder!.title;
      messageController.text =
          reminder!.message ?? '';
      _selectedType = reminder!.reminderType;
      _scheduledFor = reminder!.scheduledFor;
      _selectedChannels
        ..clear()
        ..addAll(reminder!.channels);
      notifyListeners();
    }
  }

  // ---- Setters ----

  /// Sets the reminder type.
  void setType(ReminderType type) {
    _selectedType = type;
    notifyListeners();
  }

  /// Sets the scheduled date/time.
  void setScheduledFor(DateTime dateTime) {
    _scheduledFor = dateTime;
    notifyListeners();
  }

  /// Toggles a channel selection.
  void toggleChannel(String channel) {
    if (_selectedChannels.contains(channel)) {
      _selectedChannels.remove(channel);
    } else {
      _selectedChannels.add(channel);
    }
    notifyListeners();
  }

  // ---- Save ----

  /// Validates and saves the reminder.
  Future<void> save() async {
    clearError();

    final title = titleController.text.trim();
    if (title.isEmpty) {
      setError('Title is required.');
      return;
    }

    if (_scheduledFor == null) {
      setError('Schedule date is required.');
      return;
    }

    if (_selectedChannels.isEmpty) {
      setError('Select at least one channel.');
      return;
    }

    final data = <String, dynamic>{
      'title': title,
      'reminderType': _selectedType.value,
      'scheduledFor':
          _scheduledFor!.toIso8601String(),
      'channels': _selectedChannels.toList(),
    };

    final message =
        messageController.text.trim();
    if (message.isNotEmpty) {
      data['message'] = message;
    }

    final effectivePetId =
        petId ?? reminder?.petId;
    if (effectivePetId != null) {
      data['petId'] = effectivePetId;
    }

    final effectiveOwnerId =
        ownerId ?? reminder?.ownerId;
    if (effectiveOwnerId != null) {
      data['ownerId'] = effectiveOwnerId;
    }

    setBusy(true);
    final result = await runSafe(
      () async {
        if (isEditMode) {
          await _reminderService.updateReminder(
            reminder!.id,
            data,
          );
        } else {
          await _reminderService.createReminder(
            data,
          );
        }
      },
    );
    setBusy(false);
    if (result != null) {
      _navigationService.back();
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    messageController.dispose();
    super.dispose();
  }
}

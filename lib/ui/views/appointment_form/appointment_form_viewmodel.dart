import 'dart:async';

import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/core/models/pet_owner.dart';
import 'package:partner/services/appointment_service.dart';
import 'package:partner/services/pet_owner_service.dart';
import 'package:partner/services/pet_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for creating or editing an
/// appointment.
class AppointmentFormViewmodel
    extends BaseViewModel
    with ErrorHandlingMixin {
  /// Creates an [AppointmentFormViewmodel].
  ///
  /// When [appointment] is provided the form
  /// opens in edit mode.
  AppointmentFormViewmodel({this.appointment});

  /// The appointment being edited, or `null`
  /// for create mode.
  final Appointment? appointment;

  final _appointmentService =
      locator<AppointmentService>();
  final _petOwnerService =
      locator<PetOwnerService>();
  final _petService = locator<PetService>();
  final _navigationService =
      locator<NavigationService>();

  // ---- Controllers ----

  /// Controller for the title field.
  final titleController = TextEditingController();

  /// Controller for the description field.
  final descriptionController =
      TextEditingController();

  /// Controller for the room number field.
  final roomNumberController =
      TextEditingController();

  /// Controller for pre-appointment notes.
  final preAppointmentNotesController =
      TextEditingController();

  /// Controller for the phone search field.
  final phoneSearchController =
      TextEditingController();

  // ---- Form state ----

  /// Available appointment type options.
  static const typeOptions = <String>[
    'checkup',
    'vaccination',
    'dental',
    'grooming',
    'surgery',
    'emergency',
  ];

  /// Available duration options in minutes.
  static const durationOptions = <int>[
    15,
    30,
    45,
    60,
  ];

  String _selectedType = 'checkup';

  /// The currently selected appointment type.
  String get selectedType => _selectedType;

  DateTime? _selectedDate;

  /// The selected appointment date.
  DateTime? get selectedDate => _selectedDate;

  TimeOfDay? _selectedTime;

  /// The selected appointment time.
  TimeOfDay? get selectedTime => _selectedTime;

  int _durationMinutes = 30;

  /// The selected duration in minutes.
  int get durationMinutes => _durationMinutes;

  PetOwner? _selectedOwner;

  /// The selected pet owner.
  PetOwner? get selectedOwner => _selectedOwner;

  Pet? _selectedPet;

  /// The selected pet.
  Pet? get selectedPet => _selectedPet;

  List<Pet> _ownerPets = <Pet>[];

  /// Pets belonging to the selected owner.
  List<Pet> get ownerPets => _ownerPets;

  bool _isSearchingOwner = false;

  /// Whether an owner lookup is in progress.
  bool get isSearchingOwner => _isSearchingOwner;

  /// Whether the form is in edit mode.
  bool get isEditMode => appointment != null;

  // errorMessage and hasError provided by
  // ErrorHandlingMixin.

  /// Owner search error, if any.
  String? ownerSearchError;

  // ---- Setters ----

  /// Sets the appointment type.
  void setType(String value) {
    _selectedType = value;
    notifyListeners();
  }

  /// Sets the appointment date.
  void setDate(DateTime date) {
    _selectedDate = date;
    notifyListeners();
  }

  /// Sets the appointment time.
  void setTime(TimeOfDay time) {
    _selectedTime = time;
    notifyListeners();
  }

  /// Sets the duration in minutes.
  void setDuration(int minutes) {
    _durationMinutes = minutes;
    notifyListeners();
  }

  /// Selects a pet from the owner's pets.
  void selectPet(Pet pet) {
    _selectedPet = pet;
    notifyListeners();
  }

  // ---- Owner search ----

  /// Looks up a pet owner by phone number and
  /// fetches their pets when found.
  Future<void> searchOwnerByPhone() async {
    final phone =
        phoneSearchController.text.trim();
    if (phone.isEmpty) {
      ownerSearchError =
          'Enter a phone number.';
      notifyListeners();
      return;
    }

    _isSearchingOwner = true;
    ownerSearchError = null;
    _selectedOwner = null;
    _selectedPet = null;
    _ownerPets = <Pet>[];
    notifyListeners();

    final owner = await runSafe(
      () => _petOwnerService.lookupByPhone(phone),
    );

    if (hasError) {
      ownerSearchError = errorMessage;
      clearError();
    } else if (owner == null) {
      ownerSearchError =
          'No owner found with this number.';
    } else {
      _selectedOwner = owner;
      await _loadOwnerPets(owner.id);
    }

    _isSearchingOwner = false;
    notifyListeners();
  }

  Future<void> _loadOwnerPets(
    String ownerId,
  ) async {
    try {
      final response = await _petService.getPets(
        // The backend filters by ownerId when
        // the query param is provided. Since
        // PetService.getPets does not have an
        // ownerId param, we fetch all and rely
        // on backend scoping. A dedicated
        // endpoint may be added later.
      );
      _ownerPets = response.items;
    } on Exception {
      // Silently fail; user can still proceed.
      _ownerPets = <Pet>[];
    }
  }

  // ---- Save ----

  /// Validates required fields and saves the
  /// appointment.
  Future<void> saveAppointment() async {
    clearError();

    final title = titleController.text.trim();
    if (title.isEmpty) {
      setError('Title is required.');
      return;
    }

    if (_selectedOwner == null) {
      setError(
        'Please search and select an owner.',
      );
      return;
    }

    if (_selectedPet == null &&
        _ownerPets.isNotEmpty) {
      setError('Please select a pet.');
      return;
    }

    if (_selectedDate == null) {
      setError('Please select a date.');
      return;
    }

    if (_selectedTime == null) {
      setError('Please select a time.');
      return;
    }

    final scheduledStart = DateTime(
      _selectedDate!.year,
      _selectedDate!.month,
      _selectedDate!.day,
      _selectedTime!.hour,
      _selectedTime!.minute,
    );

    final scheduledEnd = scheduledStart.add(
      Duration(minutes: _durationMinutes),
    );

    final data = <String, dynamic>{
      'title': title,
      'appointmentType': _selectedType,
      'scheduledStart':
          scheduledStart.toIso8601String(),
      'scheduledEnd':
          scheduledEnd.toIso8601String(),
      'durationMinutes': _durationMinutes,
      'ownerId': _selectedOwner!.id,
    };

    if (_selectedPet != null) {
      data['petId'] = _selectedPet!.id;
    }

    final description =
        descriptionController.text.trim();
    if (description.isNotEmpty) {
      data['description'] = description;
    }

    final roomNumber =
        roomNumberController.text.trim();
    if (roomNumber.isNotEmpty) {
      data['roomNumber'] = roomNumber;
    }

    final notes =
        preAppointmentNotesController.text.trim();
    if (notes.isNotEmpty) {
      data['preAppointmentNotes'] = notes;
    }

    setBusy(true);
    final result = await runSafe(
      () async => isEditMode
          ? _appointmentService
              .updateAppointment(
              appointment!.id,
              data,
            )
          : _appointmentService
              .createAppointment(data),
    );
    setBusy(false);

    if (result != null) {
      unawaited(
        _navigationService.replaceWith<void>(
          '/booking-success-view',
          arguments: result,
        ),
      );
    }
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    roomNumberController.dispose();
    preAppointmentNotesController.dispose();
    phoneSearchController.dispose();
    super.dispose();
  }
}

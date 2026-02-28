import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/medical/prescription.dart';
import 'package:partner/services/prescription_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for creating or editing a
/// prescription.
class PrescriptionFormViewModel
    extends BaseViewModel
    with ErrorHandlingMixin {
  /// Creates a [PrescriptionFormViewModel].
  PrescriptionFormViewModel({
    this.prescription,
    this.petId,
    this.medicalRecordId,
  });

  /// The prescription to edit, or `null`.
  final Prescription? prescription;

  /// Pre-selected pet ID.
  final String? petId;

  /// Pre-selected medical record ID.
  final String? medicalRecordId;

  final _prescriptionService =
      locator<PrescriptionService>();
  final _navigationService =
      locator<NavigationService>();

  // ---- Controllers ----

  /// Controller for medication name.
  final medicationNameController =
      TextEditingController();

  /// Controller for dosage.
  final dosageController =
      TextEditingController();

  /// Controller for frequency.
  final frequencyController =
      TextEditingController();

  /// Controller for duration.
  final durationController =
      TextEditingController();

  /// Controller for instructions.
  final instructionsController =
      TextEditingController();

  // ---- State ----

  DateTime _startDate = DateTime.now();

  /// The selected start date.
  DateTime get startDate => _startDate;

  DateTime? _endDate;

  /// The selected end date.
  DateTime? get endDate => _endDate;

  bool _isActive = true;

  /// Whether the prescription is active.
  bool get isActive => _isActive;

  /// Whether this is edit mode.
  bool get isEditMode => prescription != null;

  // errorMessage and hasError provided by
  // ErrorHandlingMixin.

  // ---- Lifecycle ----

  /// Initialises the form fields.
  void initialise() {
    if (isEditMode) {
      _populateFromPrescription();
    }
  }

  void _populateFromPrescription() {
    final p = prescription!;
    medicationNameController.text =
        p.medicationName;
    dosageController.text = p.dosage;
    frequencyController.text = p.frequency;
    durationController.text =
        p.duration ?? '';
    instructionsController.text =
        p.instructions ?? '';
    _startDate = p.startDate;
    _endDate = p.endDate;
    _isActive = p.isActive;
    notifyListeners();
  }

  // ---- Setters ----

  /// Sets the start date.
  void setStartDate(DateTime date) {
    _startDate = date;
    notifyListeners();
  }

  /// Sets the end date.
  void setEndDate(DateTime? date) {
    _endDate = date;
    notifyListeners();
  }

  /// Toggles active status.
  void toggleActive() {
    _isActive = !_isActive;
    notifyListeners();
  }

  // ---- Save ----

  /// Validates and saves the prescription.
  Future<void> savePrescription() async {
    clearError();

    final name =
        medicationNameController.text.trim();
    final dosage =
        dosageController.text.trim();
    final frequency =
        frequencyController.text.trim();

    if (name.isEmpty) {
      setError('Medication name is required.');
      return;
    }
    if (dosage.isEmpty) {
      setError('Dosage is required.');
      return;
    }
    if (frequency.isEmpty) {
      setError('Frequency is required.');
      return;
    }

    final data = <String, dynamic>{
      'medicationName': name,
      'dosage': dosage,
      'frequency': frequency,
      'startDate':
          _startDate.toIso8601String(),
      'isActive': _isActive,
    };

    if (petId != null) {
      data['petId'] = petId;
    }
    if (medicalRecordId != null) {
      data['medicalRecordId'] =
          medicalRecordId;
    }

    final duration =
        durationController.text.trim();
    if (duration.isNotEmpty) {
      data['duration'] = duration;
    }

    final instructions =
        instructionsController.text.trim();
    if (instructions.isNotEmpty) {
      data['instructions'] = instructions;
    }

    if (_endDate != null) {
      data['endDate'] =
          _endDate!.toIso8601String();
    }

    setBusy(true);
    final result = await runSafe(
      () async {
        if (isEditMode) {
          await _prescriptionService
              .updatePrescription(
            prescription!.id,
            data,
          );
        } else {
          await _prescriptionService
              .createPrescription(data);
        }
      },
    );
    setBusy(false);
    if (result != null) {
      _navigationService.back<void>();
    }
  }

  @override
  void dispose() {
    medicationNameController.dispose();
    dosageController.dispose();
    frequencyController.dispose();
    durationController.dispose();
    instructionsController.dispose();
    super.dispose();
  }
}

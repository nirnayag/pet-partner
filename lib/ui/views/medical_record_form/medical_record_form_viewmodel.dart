import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/medical/medical_record.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/services/medical_record_service.dart';
import 'package:partner/services/pet_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for creating or editing a
/// medical record.
class MedicalRecordFormViewModel
    extends BaseViewModel
    with ErrorHandlingMixin {
  /// Creates a [MedicalRecordFormViewModel].
  MedicalRecordFormViewModel({
    this.record,
    this.petId,
    this.appointmentId,
  });

  /// The record to edit, or `null` for create.
  final MedicalRecord? record;

  /// Pre-selected pet ID.
  final String? petId;

  /// Pre-selected appointment ID.
  final String? appointmentId;

  final _medicalRecordService =
      locator<MedicalRecordService>();
  final _petService = locator<PetService>();
  final _navigationService =
      locator<NavigationService>();
  final _dialogService =
      locator<DialogService>();

  // ---- Controllers ----

  /// Controller for visit reason.
  final visitReasonController =
      TextEditingController();

  /// Controller for diagnosis.
  final diagnosisController =
      TextEditingController();

  /// Controller for treatment.
  final treatmentController =
      TextEditingController();

  /// Controller for notes.
  final notesController =
      TextEditingController();

  /// Controller for weight.
  final weightController =
      TextEditingController();

  /// Controller for temperature.
  final temperatureController =
      TextEditingController();

  // ---- State ----

  DateTime _visitDate = DateTime.now();

  /// The selected visit date.
  DateTime get visitDate => _visitDate;

  String _weightUnit = 'kg';

  /// The selected weight unit.
  String get weightUnit => _weightUnit;

  String _temperatureUnit = 'F';

  /// The selected temperature unit.
  String get temperatureUnit => _temperatureUnit;

  /// Whether this is edit mode.
  bool get isEditMode => record != null;

  // errorMessage and hasError provided by
  // ErrorHandlingMixin.

  Pet? _pet;

  /// The pet associated with this record.
  Pet? get pet => _pet;

  /// Available weight unit options.
  static const weightUnitOptions = <String>[
    'kg',
    'lbs',
  ];

  /// Available temperature unit options.
  static const temperatureUnitOptions = <String>[
    'F',
    'C',
  ];

  // ---- Lifecycle ----

  /// Initialises the form fields.
  Future<void> initialise() async {
    if (isEditMode) {
      _populateFromRecord();
    }
    await _loadPet();
  }

  void _populateFromRecord() {
    final r = record!;
    _visitDate = r.visitDate;
    visitReasonController.text =
        r.visitReason ?? '';
    diagnosisController.text =
        r.diagnosis ?? '';
    treatmentController.text =
        r.treatment ?? '';
    notesController.text = r.notes ?? '';
    if (r.weightAtVisit != null) {
      weightController.text =
          r.weightAtVisit!.toString();
    }
    _weightUnit = r.weightUnit ?? 'kg';
    if (r.temperatureAtVisit != null) {
      temperatureController.text =
          r.temperatureAtVisit!.toString();
    }
    _temperatureUnit =
        r.temperatureUnit ?? 'F';
    notifyListeners();
  }

  Future<void> _loadPet() async {
    final id = petId ?? record?.petId;
    if (id == null) return;
    _pet = await runSafe(
      () => _petService.getPetById(id),
    );
    // Non-critical — clear any error.
    clearError();
    notifyListeners();
  }

  // ---- Setters ----

  /// Sets the visit date.
  void setVisitDate(DateTime date) {
    _visitDate = date;
    notifyListeners();
  }

  /// Sets the weight unit.
  void setWeightUnit(String value) {
    _weightUnit = value;
    notifyListeners();
  }

  /// Sets the temperature unit.
  void setTemperatureUnit(String value) {
    _temperatureUnit = value;
    notifyListeners();
  }

  // ---- Save ----

  /// Validates and saves the medical record.
  Future<void> saveRecord() async {
    clearError();

    final visitReason =
        visitReasonController.text.trim();
    if (visitReason.isEmpty) {
      setError('Visit reason is required.');
      return;
    }

    final data = <String, dynamic>{
      'visitDate':
          _visitDate.toIso8601String(),
      'visitReason': visitReason,
    };

    if (petId != null) data['petId'] = petId;
    if (appointmentId != null) {
      data['appointmentId'] = appointmentId;
    }

    final diagnosis =
        diagnosisController.text.trim();
    if (diagnosis.isNotEmpty) {
      data['diagnosis'] = diagnosis;
    }

    final treatment =
        treatmentController.text.trim();
    if (treatment.isNotEmpty) {
      data['treatment'] = treatment;
    }

    final notes =
        notesController.text.trim();
    if (notes.isNotEmpty) {
      data['notes'] = notes;
    }

    final weightText =
        weightController.text.trim();
    if (weightText.isNotEmpty) {
      final weight =
          double.tryParse(weightText);
      if (weight != null) {
        data['weightAtVisit'] = weight;
        data['weightUnit'] = _weightUnit;
      }
    }

    final tempText =
        temperatureController.text.trim();
    if (tempText.isNotEmpty) {
      final temp = double.tryParse(tempText);
      if (temp != null) {
        data['temperatureAtVisit'] = temp;
        data['temperatureUnit'] =
            _temperatureUnit;
      }
    }

    setBusy(true);
    final result = await runSafe(
      () async {
        if (isEditMode) {
          await _medicalRecordService
              .updateMedicalRecord(
            record!.id,
            data,
          );
        } else {
          await _medicalRecordService
              .createMedicalRecord(data);
        }
      },
    );
    setBusy(false);
    if (result != null) {
      _navigationService.back<void>();
    }
  }

  /// Deletes the current record after
  /// confirmation.
  Future<void> deleteRecord() async {
    if (!isEditMode) return;

    final response = await _dialogService
        .showConfirmationDialog(
      title: 'Delete Record',
      description:
          'Are you sure you want to delete '
          'this medical record? '
          'This cannot be undone.',
      confirmationTitle: 'Delete',
    );

    if (response?.confirmed != true) return;

    setBusy(true);
    await runSafe<void>(
      () => _medicalRecordService
          .deleteMedicalRecord(record!.id),
    );
    setBusy(false);
    if (!hasError) {
      _navigationService.back<void>();
    }
  }

  @override
  void dispose() {
    visitReasonController.dispose();
    diagnosisController.dispose();
    treatmentController.dispose();
    notesController.dispose();
    weightController.dispose();
    temperatureController.dispose();
    super.dispose();
  }
}

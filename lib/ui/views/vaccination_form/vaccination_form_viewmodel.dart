import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/medical/vaccination.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/vaccination_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for creating or editing a
/// vaccination record.
class VaccinationFormViewModel
    extends BaseViewModel {
  /// Creates a [VaccinationFormViewModel].
  VaccinationFormViewModel({
    this.vaccination,
    this.petId,
  });

  /// The vaccination to edit, or `null`.
  final Vaccination? vaccination;

  /// Pre-selected pet ID.
  final String? petId;

  final _vaccinationService =
      locator<VaccinationService>();
  final _navigationService =
      locator<NavigationService>();

  // ---- Controllers ----

  /// Controller for vaccine name.
  final vaccineNameController =
      TextEditingController();

  /// Controller for batch number.
  final batchNumberController =
      TextEditingController();

  /// Controller for manufacturer.
  final manufacturerController =
      TextEditingController();

  /// Controller for notes.
  final notesController =
      TextEditingController();

  // ---- State ----

  DateTime _dateAdministered = DateTime.now();

  /// The selected administration date.
  DateTime get dateAdministered =>
      _dateAdministered;

  DateTime? _nextDueDate;

  /// The selected next due date.
  DateTime? get nextDueDate => _nextDueDate;

  /// Whether this is edit mode.
  bool get isEditMode => vaccination != null;

  String? _errorMessage;

  /// Error message from the last operation.
  String? get errorMessage => _errorMessage;

  // ---- Lifecycle ----

  /// Initialises the form fields.
  void initialise() {
    if (isEditMode) {
      _populateFromVaccination();
    }
  }

  void _populateFromVaccination() {
    final v = vaccination!;
    vaccineNameController.text =
        v.vaccineName;
    batchNumberController.text =
        v.batchNumber ?? '';
    manufacturerController.text =
        v.manufacturer ?? '';
    notesController.text = v.notes ?? '';
    _dateAdministered = v.dateAdministered;
    _nextDueDate = v.nextDueDate;
    notifyListeners();
  }

  // ---- Setters ----

  /// Sets the administration date.
  void setDateAdministered(DateTime date) {
    _dateAdministered = date;
    notifyListeners();
  }

  /// Sets the next due date.
  void setNextDueDate(DateTime? date) {
    _nextDueDate = date;
    notifyListeners();
  }

  // ---- Save ----

  /// Validates and saves the vaccination.
  Future<void> saveVaccination() async {
    _errorMessage = null;

    final name =
        vaccineNameController.text.trim();
    if (name.isEmpty) {
      _errorMessage =
          'Vaccine name is required.';
      notifyListeners();
      return;
    }

    final data = <String, dynamic>{
      'vaccineName': name,
      'dateAdministered':
          _dateAdministered.toIso8601String(),
    };

    if (petId != null) {
      data['petId'] = petId;
    }

    final batch =
        batchNumberController.text.trim();
    if (batch.isNotEmpty) {
      data['batchNumber'] = batch;
    }

    final manufacturer =
        manufacturerController.text.trim();
    if (manufacturer.isNotEmpty) {
      data['manufacturer'] = manufacturer;
    }

    final notes =
        notesController.text.trim();
    if (notes.isNotEmpty) {
      data['notes'] = notes;
    }

    if (_nextDueDate != null) {
      data['nextDueDate'] =
          _nextDueDate!.toIso8601String();
    }

    setBusy(true);
    try {
      if (isEditMode) {
        await _vaccinationService
            .updateVaccination(
          vaccination!.id,
          data,
        );
      } else {
        await _vaccinationService
            .createVaccination(data);
      }
      _navigationService.back<void>();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    }
    setBusy(false);
  }

  @override
  void dispose() {
    vaccineNameController.dispose();
    batchNumberController.dispose();
    manufacturerController.dispose();
    notesController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/services/pet_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for creating or editing a pet.
class PetFormViewmodel extends BaseViewModel {
  /// Creates a [PetFormViewmodel].
  ///
  /// When [pet] is provided the form opens in edit
  /// mode and fields are pre-populated.
  PetFormViewmodel({this.pet, this.ownerId});

  /// The pet being edited, or `null` for create mode.
  final Pet? pet;

  /// The owner ID to associate with the new pet.
  final String? ownerId;

  final _petService = locator<PetService>();
  final _navigationService =
      locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  // ---- Controllers ----

  /// Controller for the pet name field.
  final nameController = TextEditingController();

  /// Controller for the breed field.
  final breedController = TextEditingController();

  /// Controller for the colour field.
  final colorController = TextEditingController();

  /// Controller for the weight field.
  final weightController = TextEditingController();

  /// Controller for the allergies field.
  final allergiesController =
      TextEditingController();

  /// Controller for the chronic conditions field.
  final chronicConditionsController =
      TextEditingController();

  /// Controller for the notes field.
  final notesController = TextEditingController();

  // ---- Form state ----

  /// Available species options.
  static const speciesOptions = <String>[
    'Dog',
    'Cat',
    'Bird',
    'Rabbit',
    'Other',
  ];

  /// Available gender options.
  static const genderOptions = <String>[
    'Male',
    'Female',
    'Unknown',
  ];

  /// Available weight unit options.
  static const weightUnitOptions = <String>[
    'kg',
    'lbs',
  ];

  String _selectedSpecies = 'Dog';

  /// The currently selected species.
  String get selectedSpecies => _selectedSpecies;

  String _selectedGender = 'Male';

  /// The currently selected gender.
  String get selectedGender => _selectedGender;

  String _weightUnit = 'kg';

  /// The currently selected weight unit.
  String get weightUnit => _weightUnit;

  DateTime? _dateOfBirth;

  /// The selected date of birth.
  DateTime? get dateOfBirth => _dateOfBirth;

  bool _isDeceased = false;

  /// Whether the pet is marked as deceased.
  bool get isDeceased => _isDeceased;

  bool _isActive = true;

  /// Whether the pet record is active.
  bool get isActive => _isActive;

  /// Whether the form is in edit mode.
  bool get isEditMode => pet != null;

  /// Validation error message, if any.
  String? errorMessage;

  // ---- Lifecycle ----

  /// Initialises the form. When editing, fields are
  /// pre-populated from [pet].
  void initialise() {
    if (pet == null) return;

    nameController.text = pet!.name;
    breedController.text = pet!.breed ?? '';
    colorController.text = pet!.color ?? '';
    if (pet!.weight != null) {
      weightController.text =
          pet!.weight!.toString();
    }
    allergiesController.text =
        pet!.allergies.join(', ');
    chronicConditionsController.text =
        pet!.chronicConditions.join(', ');
    notesController.text = pet!.notes ?? '';

    _selectedSpecies =
        _capitalise(pet!.species);
    _selectedGender =
        _capitalise(pet!.gender ?? 'Unknown');
    _weightUnit = pet!.weightUnit ?? 'kg';
    _dateOfBirth = pet!.dateOfBirth;
    _isDeceased = pet!.isDeceased;
    _isActive = pet!.isActive;
    notifyListeners();
  }

  // ---- Setters ----

  /// Sets the selected species.
  void setSpecies(String value) {
    _selectedSpecies = value;
    notifyListeners();
  }

  /// Sets the selected gender.
  void setGender(String value) {
    _selectedGender = value;
    notifyListeners();
  }

  /// Sets the weight unit.
  void setWeightUnit(String value) {
    _weightUnit = value;
    notifyListeners();
  }

  /// Sets the date of birth.
  void setDateOfBirth(DateTime date) {
    _dateOfBirth = date;
    notifyListeners();
  }

  /// Toggles the active flag.
  Future<void> toggleActive() async {
    if (!isEditMode) return;

    _isActive = !_isActive;
    notifyListeners();

    try {
      await _petService.updatePet(
        pet!.id,
        <String, dynamic>{
          'isActive': _isActive,
        },
      );
    } on Exception catch (e) {
      _isActive = !_isActive;
      errorMessage = e.toString();
      notifyListeners();
    }
  }

  /// Marks the pet as deceased after confirmation.
  Future<void> markAsDeceased() async {
    if (!isEditMode) return;

    final response =
        await _dialogService.showConfirmationDialog(
      title: 'Mark as Deceased',
      description:
          'Are you sure you want to mark '
          '${pet!.name} as deceased? '
          'This cannot be undone.',
      confirmationTitle: 'Confirm',
    );

    if (response?.confirmed != true) return;

    setBusy(true);
    try {
      await _petService.updatePet(
        pet!.id,
        <String, dynamic>{'isDeceased': true},
      );
      _navigationService.back<void>();
    } on Exception catch (e) {
      errorMessage = e.toString();
    } finally {
      setBusy(false);
    }
  }

  // ---- Save ----

  /// Validates required fields and saves the pet.
  Future<void> savePet() async {
    errorMessage = null;

    final name = nameController.text.trim();
    if (name.isEmpty) {
      errorMessage = 'Pet name is required.';
      notifyListeners();
      return;
    }

    final data = <String, dynamic>{
      'name': name,
      'species': _selectedSpecies.toLowerCase(),
      'gender': _selectedGender.toLowerCase(),
      'weightUnit': _weightUnit,
      'isActive': _isActive,
      'isDeceased': _isDeceased,
    };

    final breed = breedController.text.trim();
    if (breed.isNotEmpty) data['breed'] = breed;

    final color = colorController.text.trim();
    if (color.isNotEmpty) data['color'] = color;

    final weightText =
        weightController.text.trim();
    if (weightText.isNotEmpty) {
      final weight = double.tryParse(weightText);
      if (weight != null) data['weight'] = weight;
    }

    if (_dateOfBirth != null) {
      data['dateOfBirth'] =
          _dateOfBirth!.toIso8601String();
    }

    final allergies =
        allergiesController.text.trim();
    if (allergies.isNotEmpty) {
      data['allergies'] = allergies
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    final chronic =
        chronicConditionsController.text.trim();
    if (chronic.isNotEmpty) {
      data['chronicConditions'] = chronic
          .split(',')
          .map((e) => e.trim())
          .where((e) => e.isNotEmpty)
          .toList();
    }

    final notes = notesController.text.trim();
    if (notes.isNotEmpty) data['notes'] = notes;

    if (ownerId != null) {
      data['ownerId'] = ownerId;
    }

    setBusy(true);
    try {
      if (isEditMode) {
        await _petService.updatePet(
          pet!.id,
          data,
        );
      } else {
        await _petService.createPet(data);
      }
      _navigationService.back<void>();
    } on Exception catch (e) {
      errorMessage = e.toString();
    } finally {
      setBusy(false);
    }
  }

  // ---- Helpers ----

  String _capitalise(String value) {
    if (value.isEmpty) return value;
    return '${value[0].toUpperCase()}'
        '${value.substring(1).toLowerCase()}';
  }

  @override
  void dispose() {
    nameController.dispose();
    breedController.dispose();
    colorController.dispose();
    weightController.dispose();
    allergiesController.dispose();
    chronicConditionsController.dispose();
    notesController.dispose();
    super.dispose();
  }
}

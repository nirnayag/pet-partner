import 'package:partner/core/models/auth/user.dart';
import 'package:partner/core/models/pet/pet.dart';

/// A vaccination record for a pet.
class Vaccination {
  /// Creates a [Vaccination].
  const Vaccination({
    required this.id,
    required this.petId,
    required this.vaccineName,
    required this.dateAdministered,
    required this.createdAt,
    this.veterinarianId,
    this.clinicId,
    this.nextDueDate,
    this.batchNumber,
    this.manufacturer,
    this.notes,
    this.pet,
    this.veterinarian,
    this.updatedAt,
  });

  /// Parses a [Vaccination] from JSON.
  factory Vaccination.fromJson(
    Map<String, dynamic> json,
  ) {
    return Vaccination(
      id: json['id'] as String,
      petId: json['petId'] as String,
      vaccineName:
          json['vaccineName'] as String,
      dateAdministered: DateTime.parse(
        json['dateAdministered'] as String,
      ),
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      veterinarianId:
          json['veterinarianId'] as String?,
      clinicId: json['clinicId'] as String?,
      nextDueDate: json['nextDueDate'] != null
          ? DateTime.parse(
              json['nextDueDate'] as String,
            )
          : null,
      batchNumber:
          json['batchNumber'] as String?,
      manufacturer:
          json['manufacturer'] as String?,
      notes: json['notes'] as String?,
      pet: json['pet'] != null
          ? Pet.fromJson(
              json['pet']
                  as Map<String, dynamic>,
            )
          : null,
      veterinarian: json['veterinarian'] != null
          ? User.fromJson(
              json['veterinarian']
                  as Map<String, dynamic>,
            )
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(
              json['updatedAt'] as String,
            )
          : null,
    );
  }

  /// Unique identifier.
  final String id;

  /// The pet that received the vaccination.
  final String petId;

  /// The veterinarian who administered it.
  final String? veterinarianId;

  /// The clinic where it was administered.
  final String? clinicId;

  /// Name of the vaccine.
  final String vaccineName;

  /// Date the vaccine was administered.
  final DateTime dateAdministered;

  /// Next due date for a booster dose.
  final DateTime? nextDueDate;

  /// Vaccine batch or lot number.
  final String? batchNumber;

  /// Vaccine manufacturer.
  final String? manufacturer;

  /// Additional notes.
  final String? notes;

  /// Nested pet object (if included).
  final Pet? pet;

  /// Nested veterinarian object (if included).
  final User? veterinarian;

  /// Timestamp when the record was created.
  final DateTime createdAt;

  /// Timestamp when last updated.
  final DateTime? updatedAt;

  /// Computed vaccination status.
  ///
  /// Returns `'up_to_date'` when there is no next
  /// due date or it is in the future (>30 days),
  /// `'due_soon'` when within 30 days, and
  /// `'overdue'` when past.
  String get status {
    if (nextDueDate == null) return 'up_to_date';
    final now = DateTime.now();
    if (nextDueDate!.isBefore(now)) {
      return 'overdue';
    }
    final daysUntilDue =
        nextDueDate!.difference(now).inDays;
    if (daysUntilDue <= 30) return 'due_soon';
    return 'up_to_date';
  }

  /// Serialises this vaccination to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'petId': petId,
      'vaccineName': vaccineName,
      'dateAdministered':
          dateAdministered.toIso8601String(),
      'createdAt':
          createdAt.toIso8601String(),
      if (veterinarianId != null)
        'veterinarianId': veterinarianId,
      if (clinicId != null)
        'clinicId': clinicId,
      if (nextDueDate != null)
        'nextDueDate':
            nextDueDate!.toIso8601String(),
      if (batchNumber != null)
        'batchNumber': batchNumber,
      if (manufacturer != null)
        'manufacturer': manufacturer,
      if (notes != null) 'notes': notes,
      if (updatedAt != null)
        'updatedAt':
            updatedAt!.toIso8601String(),
    };
  }
}

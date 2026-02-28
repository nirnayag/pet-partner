import 'package:partner/core/models/auth/user.dart';
import 'package:partner/core/models/pet/pet.dart';

/// A prescription issued for a pet.
class Prescription {
  /// Creates a [Prescription].
  const Prescription({
    required this.id,
    required this.petId,
    required this.medicationName,
    required this.dosage,
    required this.frequency,
    required this.startDate,
    required this.isActive,
    required this.createdAt,
    this.medicalRecordId,
    this.veterinarianId,
    this.clinicId,
    this.duration,
    this.instructions,
    this.endDate,
    this.pet,
    this.veterinarian,
    this.updatedAt,
  });

  /// Parses a [Prescription] from JSON.
  factory Prescription.fromJson(
    Map<String, dynamic> json,
  ) {
    return Prescription(
      id: json['id'] as String,
      petId: json['petId'] as String,
      medicationName:
          json['medicationName'] as String,
      dosage: json['dosage'] as String,
      frequency: json['frequency'] as String,
      startDate: DateTime.parse(
        json['startDate'] as String,
      ),
      isActive:
          json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      medicalRecordId:
          json['medicalRecordId'] as String?,
      veterinarianId:
          json['veterinarianId'] as String?,
      clinicId: json['clinicId'] as String?,
      duration: json['duration'] as String?,
      instructions:
          json['instructions'] as String?,
      endDate: json['endDate'] != null
          ? DateTime.parse(
              json['endDate'] as String,
            )
          : null,
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

  /// The pet this prescription is for.
  final String petId;

  /// Associated medical record (if any).
  final String? medicalRecordId;

  /// The prescribing veterinarian's ID.
  final String? veterinarianId;

  /// The clinic that issued this prescription.
  final String? clinicId;

  /// Name of the medication.
  final String medicationName;

  /// Dosage amount and unit (e.g. "10 mg").
  final String dosage;

  /// How often the medication should be given.
  final String frequency;

  /// Duration of the course (e.g. "7 days").
  final String? duration;

  /// Additional instructions for administration.
  final String? instructions;

  /// Whether this prescription is currently active.
  final bool isActive;

  /// Date when the medication course starts.
  final DateTime startDate;

  /// Date when the medication course ends.
  final DateTime? endDate;

  /// Nested pet object (if included).
  final Pet? pet;

  /// Nested veterinarian object (if included).
  final User? veterinarian;

  /// Timestamp when the prescription was created.
  final DateTime createdAt;

  /// Timestamp when last updated.
  final DateTime? updatedAt;

  /// Serialises this prescription to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'petId': petId,
      'medicationName': medicationName,
      'dosage': dosage,
      'frequency': frequency,
      'startDate':
          startDate.toIso8601String(),
      'isActive': isActive,
      'createdAt':
          createdAt.toIso8601String(),
      if (medicalRecordId != null)
        'medicalRecordId': medicalRecordId,
      if (veterinarianId != null)
        'veterinarianId': veterinarianId,
      if (clinicId != null)
        'clinicId': clinicId,
      if (duration != null)
        'duration': duration,
      if (instructions != null)
        'instructions': instructions,
      if (endDate != null)
        'endDate':
            endDate!.toIso8601String(),
      if (updatedAt != null)
        'updatedAt':
            updatedAt!.toIso8601String(),
    };
  }
}

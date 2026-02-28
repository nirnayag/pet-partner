import 'package:partner/core/models/auth/user.dart';
import 'package:partner/core/models/pet/pet.dart';

/// A medical record for a pet visit.
class MedicalRecord {
  /// Creates a [MedicalRecord].
  const MedicalRecord({
    required this.id,
    required this.petId,
    required this.veterinarianId,
    required this.visitDate,
    this.appointmentId,
    this.visitReason,
    this.diagnosis,
    this.treatment,
    this.notes,
    this.weightAtVisit,
    this.weightUnit,
    this.temperatureAtVisit,
    this.temperatureUnit,
    this.pet,
    this.veterinarian,
    this.petName,
    this.petPhotoUrl,
    this.veterinarianName,
    this.clinicId,
    this.clinicName,
    this.hasPrescriptions,
    this.hasDocuments,
    this.createdAt,
    this.updatedAt,
  });

  /// Parses a [MedicalRecord] from JSON.
  factory MedicalRecord.fromJson(
    Map<String, dynamic> json,
  ) {
    return MedicalRecord(
      id: json['id'] as String,
      petId: json['petId'] as String,
      veterinarianId:
          json['veterinarianId'] as String,
      visitDate: DateTime.parse(
        json['visitDate'] as String,
      ),
      appointmentId:
          json['appointmentId'] as String?,
      visitReason:
          json['visitReason'] as String?,
      diagnosis: json['diagnosis'] as String?,
      treatment: json['treatment'] as String?,
      notes: json['notes'] as String?,
      weightAtVisit:
          (json['weightAtVisit'] as num?)
              ?.toDouble(),
      weightUnit:
          json['weightUnit'] as String?,
      temperatureAtVisit:
          (json['temperatureAtVisit'] as num?)
              ?.toDouble(),
      temperatureUnit:
          json['temperatureUnit'] as String?,
      pet: json['pet'] != null
          ? Pet.fromJson(
              json['pet'] as Map<String, dynamic>,
            )
          : null,
      veterinarian: json['veterinarian'] != null
          ? User.fromJson(
              json['veterinarian']
                  as Map<String, dynamic>,
            )
          : null,
      petName: json['petName'] as String?,
      petPhotoUrl:
          json['petPhotoUrl'] as String?,
      veterinarianName:
          json['veterinarianName'] as String?,
      clinicId: json['clinicId'] as String?,
      clinicName: json['clinicName'] as String?,
      hasPrescriptions:
          json['hasPrescriptions'] as bool?,
      hasDocuments:
          json['hasDocuments'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(
              json['createdAt'] as String,
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

  /// The pet this record belongs to.
  final String petId;

  /// The attending veterinarian's ID.
  final String veterinarianId;

  /// Associated appointment ID (if any).
  final String? appointmentId;

  /// Date of the visit.
  final DateTime visitDate;

  /// Reason for the visit.
  final String? visitReason;

  /// Diagnosis made during the visit.
  final String? diagnosis;

  /// Treatment administered.
  final String? treatment;

  /// Additional notes.
  final String? notes;

  /// Pet's weight at time of visit.
  final double? weightAtVisit;

  /// Unit for [weightAtVisit] ("kg" or "lbs").
  final String? weightUnit;

  /// Pet's temperature at time of visit.
  final double? temperatureAtVisit;

  /// Unit for [temperatureAtVisit] ("C" / "F").
  final String? temperatureUnit;

  /// Nested pet object (if included).
  final Pet? pet;

  /// Nested veterinarian object (if included).
  final User? veterinarian;

  /// Pet's name (denormalised for list views).
  final String? petName;

  /// Pet's photo URL (denormalised).
  final String? petPhotoUrl;

  /// Veterinarian's name (denormalised).
  final String? veterinarianName;

  /// ID of the clinic where the visit occurred.
  final String? clinicId;

  /// Name of the clinic.
  final String? clinicName;

  /// Whether prescriptions exist for this record.
  final bool? hasPrescriptions;

  /// Whether documents are attached.
  final bool? hasDocuments;

  /// Timestamp when the record was created.
  final DateTime? createdAt;

  /// Timestamp when the record was last updated.
  final DateTime? updatedAt;

  /// Serialises this medical record to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'petId': petId,
      'veterinarianId': veterinarianId,
      'visitDate':
          visitDate.toIso8601String(),
      if (appointmentId != null)
        'appointmentId': appointmentId,
      if (visitReason != null)
        'visitReason': visitReason,
      if (diagnosis != null)
        'diagnosis': diagnosis,
      if (treatment != null)
        'treatment': treatment,
      if (notes != null) 'notes': notes,
      if (weightAtVisit != null)
        'weightAtVisit': weightAtVisit,
      if (weightUnit != null)
        'weightUnit': weightUnit,
      if (temperatureAtVisit != null)
        'temperatureAtVisit': temperatureAtVisit,
      if (temperatureUnit != null)
        'temperatureUnit': temperatureUnit,
      if (petName != null) 'petName': petName,
      if (petPhotoUrl != null)
        'petPhotoUrl': petPhotoUrl,
      if (veterinarianName != null)
        'veterinarianName': veterinarianName,
      if (clinicId != null)
        'clinicId': clinicId,
      if (clinicName != null)
        'clinicName': clinicName,
      if (hasPrescriptions != null)
        'hasPrescriptions': hasPrescriptions,
      if (hasDocuments != null)
        'hasDocuments': hasDocuments,
      if (createdAt != null)
        'createdAt':
            createdAt!.toIso8601String(),
      if (updatedAt != null)
        'updatedAt':
            updatedAt!.toIso8601String(),
    };
  }
}

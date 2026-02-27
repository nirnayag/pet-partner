/// A medical record for a pet visit.
class MedicalRecord {
  /// Creates a [MedicalRecord].
  const MedicalRecord({
    required this.id,
    required this.petId,
    required this.visitDate,
    this.petName,
    this.petPhotoUrl,
    this.visitReason,
    this.diagnosis,
    this.treatment,
    this.notes,
    this.veterinarianId,
    this.veterinarianName,
    this.clinicId,
    this.clinicName,
    this.weightAtVisit,
    this.weightUnit,
    this.temperatureAtVisit,
    this.temperatureUnit,
    this.hasPrescriptions,
    this.hasDocuments,
    this.createdAt,
  });

  /// Parses a [MedicalRecord] from JSON.
  factory MedicalRecord.fromJson(
    Map<String, dynamic> json,
  ) {
    return MedicalRecord(
      id: json['id'] as String,
      petId: json['petId'] as String,
      visitDate: DateTime.parse(
        json['visitDate'] as String,
      ),
      petName: json['petName'] as String?,
      petPhotoUrl: json['petPhotoUrl'] as String?,
      visitReason: json['visitReason'] as String?,
      diagnosis: json['diagnosis'] as String?,
      treatment: json['treatment'] as String?,
      notes: json['notes'] as String?,
      veterinarianId:
          json['veterinarianId'] as String?,
      veterinarianName:
          json['veterinarianName'] as String?,
      clinicId: json['clinicId'] as String?,
      clinicName: json['clinicName'] as String?,
      weightAtVisit:
          (json['weightAtVisit'] as num?)?.toDouble(),
      weightUnit: json['weightUnit'] as String?,
      temperatureAtVisit:
          (json['temperatureAtVisit'] as num?)
              ?.toDouble(),
      temperatureUnit:
          json['temperatureUnit'] as String?,
      hasPrescriptions:
          json['hasPrescriptions'] as bool?,
      hasDocuments: json['hasDocuments'] as bool?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(
              json['createdAt'] as String,
            )
          : null,
    );
  }

  /// Unique identifier.
  final String id;

  /// The pet this record belongs to.
  final String petId;

  /// Pet's name (denormalised for list views).
  final String? petName;

  /// Pet's photo URL (denormalised for list views).
  final String? petPhotoUrl;

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

  /// ID of the attending veterinarian.
  final String? veterinarianId;

  /// Name of the attending veterinarian.
  final String? veterinarianName;

  /// ID of the clinic where the visit occurred.
  final String? clinicId;

  /// Name of the clinic.
  final String? clinicName;

  /// Pet's weight at time of visit.
  final double? weightAtVisit;

  /// Unit for [weightAtVisit] ("kg" or "lbs").
  final String? weightUnit;

  /// Pet's temperature at time of visit.
  final double? temperatureAtVisit;

  /// Unit for [temperatureAtVisit] ("C" or "F").
  final String? temperatureUnit;

  /// Whether prescriptions exist for this record.
  final bool? hasPrescriptions;

  /// Whether documents are attached to this record.
  final bool? hasDocuments;

  /// Timestamp when the record was created.
  final DateTime? createdAt;

  /// Serialises this medical record back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'petId': petId,
      'visitDate': visitDate.toIso8601String(),
      if (petName != null) 'petName': petName,
      if (petPhotoUrl != null)
        'petPhotoUrl': petPhotoUrl,
      if (visitReason != null)
        'visitReason': visitReason,
      if (diagnosis != null) 'diagnosis': diagnosis,
      if (treatment != null) 'treatment': treatment,
      if (notes != null) 'notes': notes,
      if (veterinarianId != null)
        'veterinarianId': veterinarianId,
      if (veterinarianName != null)
        'veterinarianName': veterinarianName,
      if (clinicId != null) 'clinicId': clinicId,
      if (clinicName != null) 'clinicName': clinicName,
      if (weightAtVisit != null)
        'weightAtVisit': weightAtVisit,
      if (weightUnit != null) 'weightUnit': weightUnit,
      if (temperatureAtVisit != null)
        'temperatureAtVisit': temperatureAtVisit,
      if (temperatureUnit != null)
        'temperatureUnit': temperatureUnit,
      if (hasPrescriptions != null)
        'hasPrescriptions': hasPrescriptions,
      if (hasDocuments != null)
        'hasDocuments': hasDocuments,
      if (createdAt != null)
        'createdAt': createdAt!.toIso8601String(),
    };
  }
}

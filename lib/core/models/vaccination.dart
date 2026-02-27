/// A vaccination record for a pet.
class Vaccination {
  /// Creates a [Vaccination].
  const Vaccination({
    required this.id,
    required this.petId,
    required this.clinicId,
    required this.vaccineName,
    required this.dateAdministered,
    required this.createdAt,
    this.veterinarianId,
    this.nextDueDate,
    this.batchNumber,
    this.manufacturer,
    this.notes,
  });

  /// Parses a [Vaccination] from JSON.
  factory Vaccination.fromJson(
    Map<String, dynamic> json,
  ) {
    return Vaccination(
      id: json['id'] as String,
      petId: json['petId'] as String,
      clinicId: json['clinicId'] as String,
      vaccineName: json['vaccineName'] as String,
      dateAdministered: DateTime.parse(
        json['dateAdministered'] as String,
      ),
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      veterinarianId:
          json['veterinarianId'] as String?,
      nextDueDate: json['nextDueDate'] != null
          ? DateTime.parse(
              json['nextDueDate'] as String,
            )
          : null,
      batchNumber: json['batchNumber'] as String?,
      manufacturer: json['manufacturer'] as String?,
      notes: json['notes'] as String?,
    );
  }

  /// Unique identifier.
  final String id;

  /// The pet that received the vaccination.
  final String petId;

  /// The veterinarian who administered it.
  final String? veterinarianId;

  /// The clinic where it was administered.
  final String clinicId;

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

  /// Timestamp when the record was created.
  final DateTime createdAt;

  /// Serialises this vaccination back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'petId': petId,
      'clinicId': clinicId,
      'vaccineName': vaccineName,
      'dateAdministered':
          dateAdministered.toIso8601String(),
      'createdAt': createdAt.toIso8601String(),
      if (veterinarianId != null)
        'veterinarianId': veterinarianId,
      if (nextDueDate != null)
        'nextDueDate':
            nextDueDate!.toIso8601String(),
      if (batchNumber != null)
        'batchNumber': batchNumber,
      if (manufacturer != null)
        'manufacturer': manufacturer,
      if (notes != null) 'notes': notes,
    };
  }
}

/// A pet registered at the clinic.
class Pet {
  /// Creates a [Pet].
  const Pet({
    required this.id,
    required this.name,
    required this.species,
    required this.isActive,
    required this.isDeceased,
    required this.createdAt,
    required this.updatedAt,
    this.breed,
    this.gender,
    this.color,
    this.dateOfBirth,
    this.weight,
    this.weightUnit,
    this.photoUrl,
    this.microchipNumber,
    this.allergies = const <String>[],
    this.chronicConditions = const <String>[],
    this.currentMedications = const <String>[],
    this.notes,
  });

  /// Parses a [Pet] from JSON.
  factory Pet.fromJson(Map<String, dynamic> json) {
    return Pet(
      id: json['id'] as String,
      name: json['name'] as String,
      species: json['species'] as String,
      isActive: json['isActive'] as bool? ?? true,
      isDeceased: json['isDeceased'] as bool? ?? false,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),
      breed: json['breed'] as String?,
      gender: json['gender'] as String?,
      color: json['color'] as String?,
      dateOfBirth: json['dateOfBirth'] != null
          ? DateTime.parse(
              json['dateOfBirth'] as String,
            )
          : null,
      weight: (json['weight'] as num?)?.toDouble(),
      weightUnit: json['weightUnit'] as String?,
      photoUrl: json['photoUrl'] as String?,
      microchipNumber:
          json['microchipNumber'] as String?,
      allergies: _parseStringList(json['allergies']),
      chronicConditions:
          _parseStringList(json['chronicConditions']),
      currentMedications:
          _parseStringList(json['currentMedications']),
      notes: json['notes'] as String?,
    );
  }

  /// Unique identifier.
  final String id;

  /// Pet's name.
  final String name;

  /// Species (e.g. "dog", "cat").
  final String species;

  /// Breed (e.g. "Labrador Retriever").
  final String? breed;

  /// Gender: male, female, or unknown.
  final String? gender;

  /// Coat or body colour.
  final String? color;

  /// Date of birth.
  final DateTime? dateOfBirth;

  /// Body weight.
  final double? weight;

  /// Weight unit: "kg" or "lbs".
  final String? weightUnit;

  /// URL to the pet's photo.
  final String? photoUrl;

  /// Whether the pet record is active.
  final bool isActive;

  /// Whether the pet is deceased.
  final bool isDeceased;

  /// Microchip identification number.
  final String? microchipNumber;

  /// Known allergies.
  final List<String> allergies;

  /// Known chronic conditions.
  final List<String> chronicConditions;

  /// Current medications.
  final List<String> currentMedications;

  /// Freeform notes.
  final String? notes;

  /// Timestamp when the record was created.
  final DateTime createdAt;

  /// Timestamp when the record was last updated.
  final DateTime updatedAt;

  /// Serialises this pet back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'species': species,
      'isActive': isActive,
      'isDeceased': isDeceased,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (breed != null) 'breed': breed,
      if (gender != null) 'gender': gender,
      if (color != null) 'color': color,
      if (dateOfBirth != null)
        'dateOfBirth': dateOfBirth!.toIso8601String(),
      if (weight != null) 'weight': weight,
      if (weightUnit != null) 'weightUnit': weightUnit,
      if (photoUrl != null) 'photoUrl': photoUrl,
      if (microchipNumber != null)
        'microchipNumber': microchipNumber,
      if (allergies.isNotEmpty) 'allergies': allergies,
      if (chronicConditions.isNotEmpty)
        'chronicConditions': chronicConditions,
      if (currentMedications.isNotEmpty)
        'currentMedications': currentMedications,
      if (notes != null) 'notes': notes,
    };
  }

  static List<String> _parseStringList(dynamic value) {
    if (value == null) return <String>[];
    if (value is List) {
      return value.map((e) => e as String).toList();
    }
    return <String>[];
  }
}

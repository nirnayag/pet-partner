/// A pet owner linked to the clinic.
class PetOwner {
  /// Creates a [PetOwner].
  const PetOwner({
    required this.id,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.phone,
    required this.createdAt,
    this.email,
    this.avatarUrl,
    this.petCount,
  });

  /// Parses a [PetOwner] from JSON.
  factory PetOwner.fromJson(Map<String, dynamic> json) {
    return PetOwner(
      id: json['id'] as String,
      userId: json['userId'] as String,
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      phone: json['phone'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      email: json['email'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      petCount: json['petCount'] as int?,
    );
  }

  /// Unique identifier for this pet-owner record.
  final String id;

  /// The user account ID associated with the owner.
  final String userId;

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Phone number.
  final String phone;

  /// Email address.
  final String? email;

  /// URL to the owner's avatar image.
  final String? avatarUrl;

  /// Number of pets registered under this owner.
  final int? petCount;

  /// Timestamp when the record was created.
  final DateTime createdAt;

  /// The owner's full name.
  String get fullName => '$firstName $lastName';

  /// Serialises this pet owner back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'userId': userId,
      'firstName': firstName,
      'lastName': lastName,
      'phone': phone,
      'createdAt': createdAt.toIso8601String(),
      if (email != null) 'email': email,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (petCount != null) 'petCount': petCount,
    };
  }
}

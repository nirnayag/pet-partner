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
  ///
  /// Handles both flat responses (pet-owners list) and
  /// nested responses (inside appointments where user
  /// details are in an `owner.user` sub-object).
  factory PetOwner.fromJson(Map<String, dynamic> json) {
    final user =
        json['user'] as Map<String, dynamic>? ?? {};
    return PetOwner(
      id: json['id'] as String,
      userId: (json['userId'] ?? user['id'] ?? '')
          as String,
      firstName: (json['firstName'] ??
          user['firstName'] ??
          '') as String,
      lastName: (json['lastName'] ??
          user['lastName'] ??
          '') as String,
      phone: (json['phone'] ??
          user['phone'] ??
          '') as String,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(json['createdAt'] as String)
          : DateTime.now(),
      email: (json['email'] ?? user['email'])
          as String?,
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

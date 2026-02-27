import 'dart:convert';

import 'package:partner/core/enums/user_role.dart';

/// A clinic-side user (admin, veterinarian, or staff).
class User {
  /// Creates a [User].
  const User({
    required this.id,
    required this.role,
    required this.roles,
    required this.firstName,
    required this.lastName,
    required this.isActive,
    this.clinicId,
    this.email,
    this.phone,
    this.avatarUrl,
    this.specialization,
    this.bio,
    this.createdAt,
  });

  /// Deserialises from a stored JSON string.
  factory User.fromJsonString(String source) {
    final json =
        jsonDecode(source) as Map<String, dynamic>;
    return User.fromJson(json);
  }

  /// Parses a [User] from JSON.
  factory User.fromJson(Map<String, dynamic> json) {
    return User(
      id: json['id'] as String,
      role: json['role'] as String,
      roles: (json['roles'] as List<dynamic>?)
              ?.map((e) => e as String)
              .toList() ??
          <String>[json['role'] as String],
      firstName: json['firstName'] as String,
      lastName: json['lastName'] as String,
      isActive: json['isActive'] as bool? ?? true,
      clinicId: json['clinicId'] as String?,
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      avatarUrl: json['avatarUrl'] as String?,
      specialization:
          json['specialization'] as String?,
      bio: json['bio'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(
              json['createdAt'] as String,
            )
          : null,
    );
  }

  /// Unique identifier.
  final String id;

  /// The currently active role as an API string.
  final String role;

  /// All roles assigned to this user.
  final List<String> roles;

  /// The clinic this user belongs to.
  /// `null` for super-admin accounts.
  final String? clinicId;

  /// First name.
  final String firstName;

  /// Last name.
  final String lastName;

  /// Email address.
  final String? email;

  /// Phone number.
  final String? phone;

  /// URL to the user's avatar image.
  final String? avatarUrl;

  /// Veterinarian specialization (e.g. "Surgery").
  final String? specialization;

  /// Short biography for veterinarians.
  final String? bio;

  /// Whether the account is active.
  final bool isActive;

  /// Timestamp when the user was created.
  final DateTime? createdAt;

  // -- Computed getters ------------------------------------

  /// The user's full name.
  String get fullName => '$firstName $lastName';

  /// The currently active [UserRole].
  UserRole get activeRole => UserRole.fromString(role);

  /// All [UserRole]s available to this user.
  List<UserRole> get availableRoles =>
      roles.map(UserRole.fromString).toList();

  /// Whether the user can switch between roles.
  bool get hasMultipleRoles => roles.length > 1;

  /// Serialises this user back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'role': role,
      'roles': roles,
      'firstName': firstName,
      'lastName': lastName,
      'isActive': isActive,
      if (clinicId != null) 'clinicId': clinicId,
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (avatarUrl != null) 'avatarUrl': avatarUrl,
      if (specialization != null)
        'specialization': specialization,
      if (bio != null) 'bio': bio,
      if (createdAt != null)
        'createdAt': createdAt!.toIso8601String(),
    };
  }

  /// Serialises to a JSON string for storage.
  String toJsonString() => jsonEncode(toJson());
}

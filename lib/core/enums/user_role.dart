/// Enum representing clinic-side user roles.
enum UserRole {
  /// Clinic administrator with full management access.
  clinicAdmin('clinic_admin'),

  /// Veterinarian with medical record access.
  veterinarian('veterinarian'),

  /// Staff member with appointment and patient access.
  staff('staff');

  const UserRole(this.value);

  /// The API string value for this role.
  final String value;

  /// Parses a role string from the API into a [UserRole].
  ///
  static UserRole fromString(String role) {
    return UserRole.values.firstWhere(
      (e) => e.value == role,
      orElse: () => throw ArgumentError(
        'Unknown role: $role',
      ),
    );
  }

  /// Human-readable label for display in the UI.
  String get displayName {
    switch (this) {
      case UserRole.clinicAdmin:
        return 'Clinic Admin';
      case UserRole.veterinarian:
        return 'Veterinarian';
      case UserRole.staff:
        return 'Staff';
    }
  }
}

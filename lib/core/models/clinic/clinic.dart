import 'package:partner/core/models/clinic/clinic_address.dart';
import 'package:partner/core/models/clinic/clinic_branding.dart';

/// A veterinary clinic.
class Clinic {
  /// Creates a [Clinic].
  const Clinic({
    required this.id,
    required this.name,
    required this.createdAt,
    required this.updatedAt,
    this.email,
    this.phone,
    this.address,
    this.branding,
  });

  /// Parses a [Clinic] from JSON.
  factory Clinic.fromJson(
    Map<String, dynamic> json,
  ) {
    return Clinic(
      id: json['id'] as String,
      name: json['name'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),
      email: json['email'] as String?,
      phone: json['phone'] as String?,
      address: json['address'] != null
          ? ClinicAddress.fromJson(
              json['address']
                  as Map<String, dynamic>,
            )
          : null,
      branding: json['branding'] != null
          ? ClinicBranding.fromJson(
              json['branding']
                  as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Unique identifier.
  final String id;

  /// Display name of the clinic.
  final String name;

  /// Contact email address.
  final String? email;

  /// Contact phone number.
  final String? phone;

  /// Physical address of the clinic.
  final ClinicAddress? address;

  /// Branding configuration (logo, colour).
  final ClinicBranding? branding;

  /// Timestamp when the clinic was created.
  final DateTime createdAt;

  /// Timestamp when the clinic was last
  /// updated.
  final DateTime updatedAt;

  /// Serialises this clinic back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (email != null) 'email': email,
      if (phone != null) 'phone': phone,
      if (address != null)
        'address': address!.toJson(),
      if (branding != null)
        'branding': branding!.toJson(),
    };
  }
}

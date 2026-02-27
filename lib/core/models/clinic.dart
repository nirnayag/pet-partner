/// A veterinary clinic.
class Clinic {
  /// Creates a [Clinic].
  const Clinic({
    required this.id,
    required this.name,
    required this.slug,
    required this.isActive,
    required this.createdAt,
    this.phone,
    this.email,
    this.address,
    this.branding,
    this.subscriptionStatus,
    this.subscriptionPlan,
  });

  /// Parses a [Clinic] from JSON.
  factory Clinic.fromJson(Map<String, dynamic> json) {
    return Clinic(
      id: json['id'] as String,
      name: json['name'] as String,
      slug: json['slug'] as String,
      isActive: json['isActive'] as bool? ?? true,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      phone: json['phone'] as String?,
      email: json['email'] as String?,
      address: json['address'] != null
          ? ClinicAddress.fromJson(
              json['address'] as Map<String, dynamic>,
            )
          : null,
      branding: json['branding'] != null
          ? ClinicBranding.fromJson(
              json['branding'] as Map<String, dynamic>,
            )
          : null,
      subscriptionStatus:
          json['subscriptionStatus'] as String?,
      subscriptionPlan:
          json['subscriptionPlan'] as String?,
    );
  }

  /// Unique identifier.
  final String id;

  /// Display name of the clinic.
  final String name;

  /// URL-friendly slug.
  final String slug;

  /// Contact phone number.
  final String? phone;

  /// Contact email address.
  final String? email;

  /// Physical address of the clinic.
  final ClinicAddress? address;

  /// Branding configuration (logo, colour).
  final ClinicBranding? branding;

  /// Whether the clinic account is active.
  final bool isActive;

  /// Current subscription status.
  final String? subscriptionStatus;

  /// Current subscription plan identifier.
  final String? subscriptionPlan;

  /// Timestamp when the clinic was created.
  final DateTime createdAt;

  /// Serialises this clinic back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'name': name,
      'slug': slug,
      'isActive': isActive,
      'createdAt': createdAt.toIso8601String(),
      if (phone != null) 'phone': phone,
      if (email != null) 'email': email,
      if (address != null) 'address': address!.toJson(),
      if (branding != null)
        'branding': branding!.toJson(),
      if (subscriptionStatus != null)
        'subscriptionStatus': subscriptionStatus,
      if (subscriptionPlan != null)
        'subscriptionPlan': subscriptionPlan,
    };
  }
}

/// Physical address of a clinic.
class ClinicAddress {
  /// Creates a [ClinicAddress].
  const ClinicAddress({
    this.street,
    this.city,
    this.state,
    this.zipCode,
    this.country,
  });

  /// Parses a [ClinicAddress] from JSON.
  factory ClinicAddress.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClinicAddress(
      street: json['street'] as String?,
      city: json['city'] as String?,
      state: json['state'] as String?,
      zipCode: json['zipCode'] as String?,
      country: json['country'] as String?,
    );
  }

  /// Street line.
  final String? street;

  /// City name.
  final String? city;

  /// State or province.
  final String? state;

  /// Postal / ZIP code.
  final String? zipCode;

  /// Country name or ISO code.
  final String? country;

  /// Serialises this address back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (street != null) 'street': street,
      if (city != null) 'city': city,
      if (state != null) 'state': state,
      if (zipCode != null) 'zipCode': zipCode,
      if (country != null) 'country': country,
    };
  }
}

/// Branding configuration for a clinic.
class ClinicBranding {
  /// Creates a [ClinicBranding].
  const ClinicBranding({
    this.primaryColor,
    this.logoUrl,
  });

  /// Parses a [ClinicBranding] from JSON.
  factory ClinicBranding.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClinicBranding(
      primaryColor: json['primaryColor'] as String?,
      logoUrl: json['logoUrl'] as String?,
    );
  }

  /// Hex colour string for the clinic's primary brand
  /// colour.
  final String? primaryColor;

  /// URL to the clinic's logo image.
  final String? logoUrl;

  /// Serialises this branding back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (primaryColor != null)
        'primaryColor': primaryColor,
      if (logoUrl != null) 'logoUrl': logoUrl,
    };
  }
}

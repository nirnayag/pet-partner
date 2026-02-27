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

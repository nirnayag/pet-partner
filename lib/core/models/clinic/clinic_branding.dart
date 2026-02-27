/// Branding configuration for a clinic.
class ClinicBranding {
  /// Creates a [ClinicBranding].
  const ClinicBranding({
    this.logoUrl,
    this.primaryColor,
    this.createdAt,
    this.updatedAt,
  });

  /// Parses a [ClinicBranding] from JSON.
  factory ClinicBranding.fromJson(
    Map<String, dynamic> json,
  ) {
    return ClinicBranding(
      logoUrl: json['logoUrl'] as String?,
      primaryColor:
          json['primaryColor'] as String?,
      createdAt: json['createdAt'] != null
          ? DateTime.parse(
              json['createdAt'] as String,
            )
          : null,
      updatedAt: json['updatedAt'] != null
          ? DateTime.parse(
              json['updatedAt'] as String,
            )
          : null,
    );
  }

  /// URL to the clinic's logo image.
  final String? logoUrl;

  /// Hex colour string for the clinic's
  /// primary brand colour.
  final String? primaryColor;

  /// Timestamp when the branding was created.
  final DateTime? createdAt;

  /// Timestamp when the branding was last
  /// updated.
  final DateTime? updatedAt;

  /// Serialises this branding back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      if (logoUrl != null) 'logoUrl': logoUrl,
      if (primaryColor != null)
        'primaryColor': primaryColor,
      if (createdAt != null)
        'createdAt': createdAt!.toIso8601String(),
      if (updatedAt != null)
        'updatedAt': updatedAt!.toIso8601String(),
    };
  }
}

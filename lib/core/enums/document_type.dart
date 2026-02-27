/// Enum representing the type of a medical document.
enum DocumentType {
  /// Laboratory test result.
  labResult('lab_result'),

  /// X-ray or radiograph image.
  xray('xray'),

  /// Patient intake form.
  intakeForm('intake_form'),

  /// Referral letter to/from another provider.
  referralLetter('referral_letter'),

  /// Other document type not covered above.
  other('other');

  const DocumentType(this.value);

  /// The API string value for this document type.
  final String value;

  /// Parses a type string from the API into a
  /// [DocumentType].
  ///
  /// Throws [ArgumentError] if [type] does not match any
  /// known value.
  static DocumentType fromString(String type) {
    return DocumentType.values.firstWhere(
      (e) => e.value == type,
      orElse: () => throw ArgumentError(
        'Unknown document type: $type',
      ),
    );
  }

  /// Human-readable label for display in the UI.
  String get displayName {
    switch (this) {
      case DocumentType.labResult:
        return 'Lab Result';
      case DocumentType.xray:
        return 'X-Ray';
      case DocumentType.intakeForm:
        return 'Intake Form';
      case DocumentType.referralLetter:
        return 'Referral Letter';
      case DocumentType.other:
        return 'Other';
    }
  }
}

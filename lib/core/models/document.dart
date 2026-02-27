/// A document attached to a pet's medical record.
class Document {
  /// Creates a [Document].
  const Document({
    required this.id,
    required this.petId,
    required this.name,
    required this.fileUrl,
    required this.fileType,
    required this.uploadedAt,
    this.petName,
    this.medicalRecordId,
    this.fileSizeBytes,
    this.documentType,
    this.tags,
    this.uploadedBy,
  });

  /// Parses a [Document] from JSON.
  factory Document.fromJson(
    Map<String, dynamic> json,
  ) {
    return Document(
      id: json['id'] as String,
      petId: json['petId'] as String,
      name: json['name'] as String,
      fileUrl: json['fileUrl'] as String,
      fileType: json['fileType'] as String,
      uploadedAt: DateTime.parse(
        json['uploadedAt'] as String,
      ),
      petName: json['petName'] as String?,
      medicalRecordId:
          json['medicalRecordId'] as String?,
      fileSizeBytes: json['fileSizeBytes'] as int?,
      documentType: json['documentType'] as String?,
      tags: (json['tags'] as List<dynamic>?)
          ?.map((e) => e as String)
          .toList(),
      uploadedBy: json['uploadedBy'] as String?,
    );
  }

  /// Unique identifier.
  final String id;

  /// The pet this document belongs to.
  final String petId;

  /// Pet's name (denormalised for list views).
  final String? petName;

  /// Associated medical record (if any).
  final String? medicalRecordId;

  /// Display name of the document.
  final String name;

  /// URL to download or view the file.
  final String fileUrl;

  /// MIME type or file extension.
  final String fileType;

  /// File size in bytes.
  final int? fileSizeBytes;

  /// Categorisation of the document (e.g. "lab_result").
  final String? documentType;

  /// Searchable tags.
  final List<String>? tags;

  /// Timestamp when the document was uploaded.
  final DateTime uploadedAt;

  /// User ID of whoever uploaded the document.
  final String? uploadedBy;

  /// Serialises this document back to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'petId': petId,
      'name': name,
      'fileUrl': fileUrl,
      'fileType': fileType,
      'uploadedAt': uploadedAt.toIso8601String(),
      if (petName != null) 'petName': petName,
      if (medicalRecordId != null)
        'medicalRecordId': medicalRecordId,
      if (fileSizeBytes != null)
        'fileSizeBytes': fileSizeBytes,
      if (documentType != null)
        'documentType': documentType,
      if (tags != null) 'tags': tags,
      if (uploadedBy != null) 'uploadedBy': uploadedBy,
    };
  }
}

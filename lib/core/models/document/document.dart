import 'package:partner/core/models/pet/pet.dart';

/// A document attached to a pet record.
class Document {
  /// Creates a [Document].
  const Document({
    required this.id,
    required this.petId,
    required this.title,
    required this.documentType,
    required this.fileName,
    required this.createdAt,
    required this.updatedAt,
    this.medicalRecordId,
    this.description,
    this.fileSize,
    this.mimeType,
    this.uploadedBy,
    this.tags = const <String>[],
    this.pet,
  });

  /// Parses a [Document] from JSON.
  factory Document.fromJson(
    Map<String, dynamic> json,
  ) {
    return Document(
      id: json['id'] as String,
      petId: json['petId'] as String,
      title: json['title'] as String,
      documentType:
          json['documentType'] as String,
      fileName: json['fileName'] as String,
      createdAt: DateTime.parse(
        json['createdAt'] as String,
      ),
      updatedAt: DateTime.parse(
        json['updatedAt'] as String,
      ),
      medicalRecordId:
          json['medicalRecordId'] as String?,
      description:
          json['description'] as String?,
      fileSize: json['fileSize'] as int?,
      mimeType: json['mimeType'] as String?,
      uploadedBy:
          json['uploadedBy'] as String?,
      tags: _parseStringList(json['tags']),
      pet: json['pet'] != null
          ? Pet.fromJson(
              json['pet']
                  as Map<String, dynamic>,
            )
          : null,
    );
  }

  /// Unique identifier.
  final String id;

  /// The pet this document belongs to.
  final String petId;

  /// Associated medical record, if any.
  final String? medicalRecordId;

  /// Display title.
  final String title;

  /// Optional description.
  final String? description;

  /// Category of the document.
  ///
  /// One of: `lab_result`, `xray`,
  /// `intake_form`, `referral_letter`, `other`.
  final String documentType;

  /// Original file name on disk.
  final String fileName;

  /// File size in bytes.
  final int? fileSize;

  /// MIME type (e.g. `application/pdf`).
  final String? mimeType;

  /// User ID of the uploader.
  final String? uploadedBy;

  /// Searchable tags.
  final List<String> tags;

  /// Timestamp when the record was created.
  final DateTime createdAt;

  /// Timestamp when the record was updated.
  final DateTime updatedAt;

  /// Nested pet details (optional).
  final Pet? pet;

  /// Serialises this document to JSON.
  Map<String, dynamic> toJson() {
    return <String, dynamic>{
      'id': id,
      'petId': petId,
      'title': title,
      'documentType': documentType,
      'fileName': fileName,
      'createdAt': createdAt.toIso8601String(),
      'updatedAt': updatedAt.toIso8601String(),
      if (medicalRecordId != null)
        'medicalRecordId': medicalRecordId,
      if (description != null)
        'description': description,
      if (fileSize != null) 'fileSize': fileSize,
      if (mimeType != null)
        'mimeType': mimeType,
      if (uploadedBy != null)
        'uploadedBy': uploadedBy,
      if (tags.isNotEmpty) 'tags': tags,
      if (pet != null) 'pet': pet!.toJson(),
    };
  }

  static List<String> _parseStringList(
    dynamic value,
  ) {
    if (value == null) return <String>[];
    if (value is List) {
      return value
          .map((e) => e as String)
          .toList();
    }
    return <String>[];
  }
}

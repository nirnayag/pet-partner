import 'dart:io';

import 'package:dio/dio.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/core/models/document/document.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/services/api_client.dart';

/// Handles document-related API calls.
class DocumentService {
  final _apiClient = locator<ApiClient>();

  /// Fetches a paginated list of documents.
  ///
  /// Optionally filter by [petId],
  /// [medicalRecordId], or [documentType].
  Future<PaginatedResponse<Document>> getDocuments({
    int page = 1,
    int limit = 20,
    String? petId,
    String? medicalRecordId,
    String? documentType,
  }) async {
    final queryParams = <String, dynamic>{
      'page': page,
      'limit': limit,
      if (petId != null) 'petId': petId,
      if (medicalRecordId != null)
        'medicalRecordId': medicalRecordId,
      if (documentType != null)
        'documentType': documentType,
    };

    final body = await _apiClient.get(
      ApiConfig.documentsEndpoint,
      queryParameters: queryParams,
    ) as Map<String, dynamic>;

    return PaginatedResponse<Document>.fromJson(
      body['data'] as Map<String, dynamic>,
      Document.fromJson,
    );
  }

  /// Fetches a single document by [documentId].
  Future<Document> getDocumentById(
    String documentId,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.documentByIdEndpoint(documentId),
    ) as Map<String, dynamic>;

    return Document.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Uploads a document with a multipart file.
  Future<Document> uploadDocument({
    required File file,
    required String petId,
    required String documentType,
    required String title,
    String? description,
    String? medicalRecordId,
    List<String>? tags,
  }) async {
    final formData = FormData.fromMap({
      'file': await MultipartFile.fromFile(
        file.path,
        filename: file.path.split('/').last,
      ),
      'petId': petId,
      'documentType': documentType,
      'title': title,
      if (description != null)
        'description': description,
      if (medicalRecordId != null)
        'medicalRecordId': medicalRecordId,
      if (tags != null) 'tags': tags,
    });

    final body = await _apiClient.post(
      ApiConfig.documentsUploadEndpoint,
      data: formData,
    ) as Map<String, dynamic>;

    return Document.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Updates document metadata by [documentId].
  Future<Document> updateDocument(
    String documentId,
    Map<String, dynamic> data,
  ) async {
    final body = await _apiClient.patch(
      ApiConfig.documentByIdEndpoint(documentId),
      data: data,
    ) as Map<String, dynamic>;

    return Document.fromJson(
      body['data'] as Map<String, dynamic>,
    );
  }

  /// Deletes a document by [documentId].
  Future<void> deleteDocument(
    String documentId,
  ) async {
    await _apiClient.delete(
      ApiConfig.documentByIdEndpoint(documentId),
    );
  }

  /// Returns the download URL for a document.
  Future<String> downloadDocument(
    String documentId,
  ) async {
    final body = await _apiClient.get(
      ApiConfig.documentDownloadEndpoint(
        documentId,
      ),
    ) as Map<String, dynamic>;

    return body['data'] as String;
  }
}

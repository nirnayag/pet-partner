import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/core/models/document/document.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/document_service.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late DocumentService service;
  late MockApiClient mockApiClient;

  final testDate =
      DateTime(2024, 1, 15).toIso8601String();

  final documentJson = <String, dynamic>{
    'id': 'doc-1',
    'petId': 'pet-1',
    'title': 'Blood Work',
    'documentType': 'lab_result',
    'fileName': 'blood_work.pdf',
    'createdAt': testDate,
    'updatedAt': testDate,
    'description': 'Annual blood test',
    'fileSize': 1024,
    'mimeType': 'application/pdf',
    'uploadedBy': 'user-1',
    'tags': <String>['routine', 'annual'],
  };

  final paginatedJson = <String, dynamic>{
    'data': <String, dynamic>{
      'items': <Map<String, dynamic>>[
        documentJson,
      ],
      'pagination': <String, dynamic>{
        'page': 1,
        'limit': 20,
        'total': 1,
        'totalPages': 1,
        'hasNext': false,
        'hasPrev': false,
      },
    },
  };

  setUp(() {
    registerServices();
    mockApiClient = locator<ApiClient>()
        as MockApiClient;
    service = DocumentService();
  });

  tearDown(locator.reset);

  group('DocumentService -', () {
    group('getDocuments -', () {
      test(
        'calls GET on documents endpoint '
        'and returns paginated response',
        () async {
          when(
            mockApiClient.get(
              ApiConfig.documentsEndpoint,
              queryParameters: anyNamed(
                'queryParameters',
              ),
            ),
          ).thenAnswer(
            (_) async => paginatedJson,
          );

          final result =
              await service.getDocuments();

          expect(result.items.length, 1);
          expect(
            result.items.first.title,
            'Blood Work',
          );
          expect(result.pagination.total, 1);
        },
      );

      test(
        'passes optional filters '
        'as query parameters',
        () async {
          when(
            mockApiClient.get(
              ApiConfig.documentsEndpoint,
              queryParameters: anyNamed(
                'queryParameters',
              ),
            ),
          ).thenAnswer(
            (_) async => paginatedJson,
          );

          await service.getDocuments(
            page: 2,
            limit: 10,
            petId: 'pet-1',
            documentType: 'lab_result',
          );

          verify(
            mockApiClient.get(
              ApiConfig.documentsEndpoint,
              queryParameters: {
                'page': 2,
                'limit': 10,
                'petId': 'pet-1',
                'documentType': 'lab_result',
              },
            ),
          ).called(1);
        },
      );
    });

    group('getDocumentById -', () {
      test(
        'calls GET on document-by-id '
        'endpoint and returns document',
        () async {
          when(
            mockApiClient.get(
              ApiConfig.documentByIdEndpoint(
                'doc-1',
              ),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': documentJson,
            },
          );

          final result =
              await service.getDocumentById(
            'doc-1',
          );

          expect(result.id, 'doc-1');
          expect(result.title, 'Blood Work');
        },
      );
    });

    group('updateDocument -', () {
      test(
        'calls PATCH on document-by-id '
        'endpoint and returns updated document',
        () async {
          when(
            mockApiClient.patch(
              ApiConfig.documentByIdEndpoint(
                'doc-1',
              ),
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': documentJson,
            },
          );

          final result =
              await service.updateDocument(
            'doc-1',
            <String, dynamic>{
              'title': 'Updated',
            },
          );

          expect(result.id, 'doc-1');
        },
      );
    });

    group('deleteDocument -', () {
      test(
        'calls DELETE on document-by-id '
        'endpoint',
        () async {
          when(
            mockApiClient.delete(
              ApiConfig.documentByIdEndpoint(
                'doc-1',
              ),
            ),
          ).thenAnswer((_) async => null);

          await service.deleteDocument('doc-1');

          verify(
            mockApiClient.delete(
              ApiConfig.documentByIdEndpoint(
                'doc-1',
              ),
            ),
          ).called(1);
        },
      );
    });

    group('downloadDocument -', () {
      test(
        'calls GET on download endpoint '
        'and returns URL string',
        () async {
          when(
            mockApiClient.get(
              ApiConfig
                  .documentDownloadEndpoint(
                'doc-1',
              ),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': 'https://example.com/dl',
            },
          );

          final url =
              await service.downloadDocument(
            'doc-1',
          );

          expect(
            url,
            'https://example.com/dl',
          );
        },
      );
    });
  });

  group('Document model -', () {
    test('fromJson parses all fields', () {
      final doc =
          Document.fromJson(documentJson);

      expect(doc.id, 'doc-1');
      expect(doc.petId, 'pet-1');
      expect(doc.title, 'Blood Work');
      expect(doc.documentType, 'lab_result');
      expect(doc.fileName, 'blood_work.pdf');
      expect(doc.fileSize, 1024);
      expect(
        doc.mimeType,
        'application/pdf',
      );
      expect(doc.uploadedBy, 'user-1');
      expect(doc.tags, ['routine', 'annual']);
      expect(
        doc.description,
        'Annual blood test',
      );
    });

    test('toJson serialises correctly', () {
      final doc =
          Document.fromJson(documentJson);
      final json = doc.toJson();

      expect(json['id'], 'doc-1');
      expect(json['title'], 'Blood Work');
      expect(
        json['documentType'],
        'lab_result',
      );
    });

    test(
      'fromJson handles null optional fields',
      () {
        final minimal = <String, dynamic>{
          'id': 'doc-2',
          'petId': 'pet-1',
          'title': 'Minimal',
          'documentType': 'other',
          'fileName': 'test.pdf',
          'createdAt': testDate,
          'updatedAt': testDate,
        };
        final doc = Document.fromJson(minimal);

        expect(doc.description, isNull);
        expect(doc.fileSize, isNull);
        expect(doc.mimeType, isNull);
        expect(doc.tags, isEmpty);
        expect(doc.pet, isNull);
      },
    );
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/document/document.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/document_service.dart';
import 'package:partner/ui/views/document_list/document_list_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late DocumentListViewModel model;
  late MockDocumentService mockDocService;

  final now = DateTime.now();

  final testDoc = Document(
    id: 'doc-1',
    petId: 'pet-1',
    title: 'Blood Work',
    documentType: 'lab_result',
    fileName: 'blood.pdf',
    createdAt: now,
    updatedAt: now,
  );

  final paginatedResponse =
      PaginatedResponse<Document>(
    items: [testDoc],
    pagination: const PaginationMeta(
      page: 1,
      limit: 20,
      total: 1,
      totalPages: 1,
      hasNext: false,
      hasPrev: false,
    ),
  );

  setUp(() {
    registerServices();
    mockDocService = locator<DocumentService>()
        as MockDocumentService;
  });

  tearDown(locator.reset);

  DocumentListViewModel getModel({
    String? petId,
  }) =>
      DocumentListViewModel(petId: petId);

  group('DocumentListViewModel -', () {
    group('initialise -', () {
      test(
        'loads documents and sets state',
        () async {
          when(
            mockDocService.getDocuments(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              medicalRecordId:
                  anyNamed('medicalRecordId'),
              documentType:
                  anyNamed('documentType'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          model = getModel();
          await model.initialise();

          expect(model.documents.length, 1);
          expect(
            model.documents.first.title,
            'Blood Work',
          );
          expect(model.totalCount, 1);
          expect(model.isBusy, false);
        },
      );

      test(
        'sets error on ApiException',
        () async {
          when(
            mockDocService.getDocuments(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              medicalRecordId:
                  anyNamed('medicalRecordId'),
              documentType:
                  anyNamed('documentType'),
            ),
          ).thenThrow(
            const ApiException(
              message: 'Server error',
            ),
          );

          model = getModel();
          await model.initialise();

          expect(
            model.errorMessage,
            'Server error',
          );
          expect(model.documents, isEmpty);
        },
      );
    });

    group('loadMoreDocuments -', () {
      test(
        'appends results from next page',
        () async {
          when(
            mockDocService.getDocuments(
              page: 1,
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              medicalRecordId:
                  anyNamed('medicalRecordId'),
              documentType:
                  anyNamed('documentType'),
            ),
          ).thenAnswer(
            (_) async =>
                PaginatedResponse<Document>(
              items: [testDoc],
              pagination: const PaginationMeta(
                page: 1,
                limit: 20,
                total: 2,
                totalPages: 2,
                hasNext: true,
                hasPrev: false,
              ),
            ),
          );

          final doc2 = Document(
            id: 'doc-2',
            petId: 'pet-1',
            title: 'X-Ray',
            documentType: 'xray',
            fileName: 'xray.jpg',
            createdAt: now,
            updatedAt: now,
          );

          when(
            mockDocService.getDocuments(
              page: 2,
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              medicalRecordId:
                  anyNamed('medicalRecordId'),
              documentType:
                  anyNamed('documentType'),
            ),
          ).thenAnswer(
            (_) async =>
                PaginatedResponse<Document>(
              items: [doc2],
              pagination: const PaginationMeta(
                page: 2,
                limit: 20,
                total: 2,
                totalPages: 2,
                hasNext: false,
                hasPrev: true,
              ),
            ),
          );

          model = getModel();
          await model.initialise();
          expect(model.documents.length, 1);

          await model.loadMoreDocuments();
          expect(model.documents.length, 2);
          expect(model.currentPage, 2);
        },
      );
    });

    group('onFilterChanged -', () {
      test(
        'updates filter and reloads',
        () async {
          when(
            mockDocService.getDocuments(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              medicalRecordId:
                  anyNamed('medicalRecordId'),
              documentType:
                  anyNamed('documentType'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          model = getModel();
          await model.initialise();

          model.onFilterChanged('Lab Results');

          expect(
            model.activeFilter,
            'Lab Results',
          );
        },
      );

      test(
        'does nothing when same filter selected',
        () async {
          when(
            mockDocService.getDocuments(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              medicalRecordId:
                  anyNamed('medicalRecordId'),
              documentType:
                  anyNamed('documentType'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          model = getModel();
          await model.initialise();

          // Default is 'All', select it again
          model.onFilterChanged('All');

          // Should have been called only once
          // during initialise
          verify(
            mockDocService.getDocuments(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              medicalRecordId:
                  anyNamed('medicalRecordId'),
              documentType:
                  anyNamed('documentType'),
            ),
          ).called(1);
        },
      );
    });

    group('refresh -', () {
      test(
        'reloads documents from first page',
        () async {
          when(
            mockDocService.getDocuments(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              medicalRecordId:
                  anyNamed('medicalRecordId'),
              documentType:
                  anyNamed('documentType'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          model = getModel();
          await model.refresh();

          expect(model.documents.length, 1);
          expect(model.errorMessage, isNull);
        },
      );
    });

    group('petId filtering -', () {
      test(
        'passes petId to service when provided',
        () async {
          when(
            mockDocService.getDocuments(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: 'pet-1',
              medicalRecordId:
                  anyNamed('medicalRecordId'),
              documentType:
                  anyNamed('documentType'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          model = getModel(petId: 'pet-1');
          await model.initialise();

          expect(model.documents.length, 1);
        },
      );
    });
  });
}

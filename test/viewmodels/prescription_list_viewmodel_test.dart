import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/medical/prescription.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/prescription_service.dart';
import 'package:partner/ui/views/prescription_list/prescription_list_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  group('PrescriptionListViewModel -', () {
    setUp(registerServices);
    tearDown(locator.reset);

    final samplePrescription =
        Prescription.fromJson(
      <String, dynamic>{
        'id': 'presc-1',
        'petId': 'pet-1',
        'medicationName': 'Amoxicillin',
        'dosage': '10 mg',
        'frequency': 'Twice daily',
        'startDate':
            '2025-01-15T00:00:00.000Z',
        'isActive': true,
        'createdAt':
            '2025-01-15T10:00:00.000Z',
      },
    );

    final sampleResponse =
        PaginatedResponse<Prescription>(
      items: <Prescription>[
        samplePrescription,
      ],
      pagination: const PaginationMeta(
        page: 1,
        limit: 20,
        total: 1,
        totalPages: 1,
        hasNext: false,
        hasPrev: false,
      ),
    );

    final responseWithMore =
        PaginatedResponse<Prescription>(
      items: <Prescription>[
        samplePrescription,
      ],
      pagination: const PaginationMeta(
        page: 1,
        limit: 20,
        total: 40,
        totalPages: 2,
        hasNext: true,
        hasPrev: false,
      ),
    );

    PrescriptionListViewModel _getModel({
      String? petId,
    }) {
      return PrescriptionListViewModel(
        petId: petId,
      );
    }

    group('initialise -', () {
      test(
        'Should load prescriptions on init',
        () async {
          final mockService =
              locator<PrescriptionService>()
                  as MockPrescriptionService;

          when(
            mockService.getPrescriptions(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => sampleResponse,
          );

          final model = _getModel();
          await model.initialise();

          expect(
            model.prescriptions.length,
            1,
          );
          expect(
            model.prescriptions.first.id,
            'presc-1',
          );
        },
      );

      test(
        'Should set error on ApiException',
        () async {
          final mockService =
              locator<PrescriptionService>()
                  as MockPrescriptionService;

          when(
            mockService.getPrescriptions(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).thenThrow(
            const ApiException(
              message: 'Network error',
            ),
          );

          final model = _getModel();
          await model.initialise();

          expect(
            model.errorMessage,
            'Network error',
          );
          expect(
            model.prescriptions.isEmpty,
            true,
          );
        },
      );
    });

    group('filter -', () {
      test(
        'Should update filter and reload',
        () async {
          final mockService =
              locator<PrescriptionService>()
                  as MockPrescriptionService;

          when(
            mockService.getPrescriptions(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => sampleResponse,
          );

          final model = _getModel();
          await model.initialise();

          await model.setFilter(
            PrescriptionFilter.active,
          );

          expect(
            model.filter,
            PrescriptionFilter.active,
          );

          // Verify called at least twice
          // (init + filter change).
          verify(
            mockService.getPrescriptions(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).called(2);
        },
      );

      test(
        'Should not reload for same filter',
        () async {
          final mockService =
              locator<PrescriptionService>()
                  as MockPrescriptionService;

          when(
            mockService.getPrescriptions(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => sampleResponse,
          );

          final model = _getModel();
          await model.initialise();

          await model.setFilter(
            PrescriptionFilter.all,
          );

          // Only called once (init).
          verify(
            mockService.getPrescriptions(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).called(1);
        },
      );
    });

    group('pagination -', () {
      test(
        'Should report hasMore correctly',
        () async {
          final mockService =
              locator<PrescriptionService>()
                  as MockPrescriptionService;

          when(
            mockService.getPrescriptions(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => responseWithMore,
          );

          final model = _getModel();
          await model.initialise();

          expect(model.hasMore, true);
        },
      );

      test(
        'Should load more items',
        () async {
          final mockService =
              locator<PrescriptionService>()
                  as MockPrescriptionService;

          when(
            mockService.getPrescriptions(
              page: 1,
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => responseWithMore,
          );

          when(
            mockService.getPrescriptions(
              page: 2,
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => sampleResponse,
          );

          final model = _getModel();
          await model.initialise();
          await model.loadMore();

          expect(
            model.prescriptions.length,
            2,
          );
          expect(model.currentPage, 2);
        },
      );

      test(
        'Should not load more when no '
        'more pages',
        () async {
          final mockService =
              locator<PrescriptionService>()
                  as MockPrescriptionService;

          when(
            mockService.getPrescriptions(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => sampleResponse,
          );

          final model = _getModel();
          await model.initialise();
          await model.loadMore();

          // Only called once (init only).
          verify(
            mockService.getPrescriptions(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).called(1);
        },
      );
    });

    group('refresh -', () {
      test(
        'Should reload prescriptions',
        () async {
          final mockService =
              locator<PrescriptionService>()
                  as MockPrescriptionService;

          when(
            mockService.getPrescriptions(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => sampleResponse,
          );

          final model = _getModel();
          await model.initialise();
          await model.refresh();

          verify(
            mockService.getPrescriptions(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
              isActive: anyNamed('isActive'),
            ),
          ).called(2);
        },
      );
    });
  });
}

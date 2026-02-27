import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/medical/vaccination.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/vaccination_service.dart';
import 'package:partner/ui/views/vaccination_list/vaccination_list_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  group('VaccinationListViewModel -', () {
    setUp(registerServices);
    tearDown(locator.reset);

    final sampleVaccination =
        Vaccination.fromJson(
      <String, dynamic>{
        'id': 'vac-1',
        'petId': 'pet-1',
        'vaccineName': 'Rabies',
        'dateAdministered':
            '2025-01-15T00:00:00.000Z',
        'createdAt':
            '2025-01-15T10:00:00.000Z',
      },
    );

    final sampleResponse =
        PaginatedResponse<Vaccination>(
      items: <Vaccination>[sampleVaccination],
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
        PaginatedResponse<Vaccination>(
      items: <Vaccination>[sampleVaccination],
      pagination: const PaginationMeta(
        page: 1,
        limit: 20,
        total: 40,
        totalPages: 2,
        hasNext: true,
        hasPrev: false,
      ),
    );

    VaccinationListViewModel _getModel({
      String? petId,
    }) {
      return VaccinationListViewModel(
        petId: petId,
      );
    }

    group('initialise -', () {
      test(
        'Should load vaccinations on init',
        () async {
          final mockService =
              locator<VaccinationService>()
                  as MockVaccinationService;

          when(
            mockService.getVaccinations(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
            ),
          ).thenAnswer(
            (_) async => sampleResponse,
          );

          final model = _getModel();
          await model.initialise();

          expect(
            model.vaccinations.length,
            1,
          );
          expect(
            model.vaccinations.first.id,
            'vac-1',
          );
        },
      );

      test(
        'Should set error on ApiException',
        () async {
          final mockService =
              locator<VaccinationService>()
                  as MockVaccinationService;

          when(
            mockService.getVaccinations(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
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
            model.vaccinations.isEmpty,
            true,
          );
        },
      );
    });

    group('pagination -', () {
      test(
        'Should report hasMore correctly',
        () async {
          final mockService =
              locator<VaccinationService>()
                  as MockVaccinationService;

          when(
            mockService.getVaccinations(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
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
              locator<VaccinationService>()
                  as MockVaccinationService;

          when(
            mockService.getVaccinations(
              page: 1,
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
            ),
          ).thenAnswer(
            (_) async => responseWithMore,
          );

          when(
            mockService.getVaccinations(
              page: 2,
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
            ),
          ).thenAnswer(
            (_) async => sampleResponse,
          );

          final model = _getModel();
          await model.initialise();
          await model.loadMore();

          expect(
            model.vaccinations.length,
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
              locator<VaccinationService>()
                  as MockVaccinationService;

          when(
            mockService.getVaccinations(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
            ),
          ).thenAnswer(
            (_) async => sampleResponse,
          );

          final model = _getModel();
          await model.initialise();
          await model.loadMore();

          // Only called once (init only).
          verify(
            mockService.getVaccinations(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
            ),
          ).called(1);
        },
      );
    });

    group('refresh -', () {
      test(
        'Should reload vaccinations',
        () async {
          final mockService =
              locator<VaccinationService>()
                  as MockVaccinationService;

          when(
            mockService.getVaccinations(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
            ),
          ).thenAnswer(
            (_) async => sampleResponse,
          );

          final model = _getModel();
          await model.initialise();
          await model.refresh();

          verify(
            mockService.getVaccinations(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              petId: anyNamed('petId'),
            ),
          ).called(2);
        },
      );
    });
  });
}

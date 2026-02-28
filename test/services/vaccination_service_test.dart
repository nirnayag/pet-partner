import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/vaccination_service.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late VaccinationService service;
  late MockApiClient mockApiClient;

  final sampleVaccinationJson =
      <String, dynamic>{
    'id': 'vac-1',
    'petId': 'pet-1',
    'vaccineName': 'Rabies',
    'dateAdministered':
        '2025-01-15T00:00:00.000Z',
    'createdAt': '2025-01-15T10:00:00.000Z',
    'batchNumber': 'LOT-123',
    'manufacturer': 'Zoetis',
  };

  final paginatedResponseJson =
      <String, dynamic>{
    'data': <String, dynamic>{
      'items': <dynamic>[
        sampleVaccinationJson,
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

  final singleResponseJson =
      <String, dynamic>{
    'data': sampleVaccinationJson,
  };

  final listResponseJson =
      <String, dynamic>{
    'data': <dynamic>[
      sampleVaccinationJson,
    ],
  };

  group('VaccinationService -', () {
    setUp(() {
      registerServices();
      mockApiClient =
          locator<ApiClient>() as MockApiClient;
      service = VaccinationService();
    });

    tearDown(locator.reset);

    group('getVaccinations -', () {
      test(
        'Should call GET with correct endpoint',
        () async {
          when(
            mockApiClient.get(
              ApiConfig.vaccinationsEndpoint,
              queryParameters:
                  anyNamed('queryParameters'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponseJson,
          );

          final result =
              await service.getVaccinations();

          expect(result.items.length, 1);
          expect(
            result.items.first.id,
            'vac-1',
          );
        },
      );

      test(
        'Should pass petId query parameter',
        () async {
          when(
            mockApiClient.get(
              ApiConfig.vaccinationsEndpoint,
              queryParameters:
                  anyNamed('queryParameters'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponseJson,
          );

          await service.getVaccinations(
            petId: 'pet-1',
          );

          verify(
            mockApiClient.get(
              ApiConfig.vaccinationsEndpoint,
              queryParameters: argThat(
                containsPair(
                  'petId',
                  'pet-1',
                ),
                named: 'queryParameters',
              ),
            ),
          ).called(1);
        },
      );
    });

    group('getVaccinationById -', () {
      test(
        'Should call GET with correct id',
        () async {
          when(
            mockApiClient.get(
              ApiConfig
                  .vaccinationByIdEndpoint(
                'vac-1',
              ),
            ),
          ).thenAnswer(
            (_) async => singleResponseJson,
          );

          final result =
              await service
                  .getVaccinationById(
            'vac-1',
          );

          expect(result.id, 'vac-1');
          expect(
            result.vaccineName,
            'Rabies',
          );
        },
      );
    });

    group('createVaccination -', () {
      test(
        'Should call POST with data',
        () async {
          when(
            mockApiClient.post(
              ApiConfig.vaccinationsEndpoint,
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => singleResponseJson,
          );

          final result =
              await service.createVaccination(
            <String, dynamic>{
              'petId': 'pet-1',
              'vaccineName': 'Rabies',
            },
          );

          expect(result.id, 'vac-1');
        },
      );
    });

    group('updateVaccination -', () {
      test(
        'Should call PATCH with data',
        () async {
          when(
            mockApiClient.patch(
              ApiConfig
                  .vaccinationByIdEndpoint(
                'vac-1',
              ),
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => singleResponseJson,
          );

          final result =
              await service
                  .updateVaccination(
            'vac-1',
            <String, dynamic>{
              'notes': 'Updated',
            },
          );

          expect(result.id, 'vac-1');
        },
      );
    });

    group('deleteVaccination -', () {
      test(
        'Should call DELETE with correct id',
        () async {
          when(
            mockApiClient.delete(
              ApiConfig
                  .vaccinationByIdEndpoint(
                'vac-1',
              ),
            ),
          ).thenAnswer((_) async => null);

          await service.deleteVaccination(
            'vac-1',
          );

          verify(
            mockApiClient.delete(
              ApiConfig
                  .vaccinationByIdEndpoint(
                'vac-1',
              ),
            ),
          ).called(1);
        },
      );
    });

    group('getPetVaccinations -', () {
      test(
        'Should call GET with pet endpoint',
        () async {
          when(
            mockApiClient.get(
              ApiConfig
                  .petVaccinationsEndpoint(
                'pet-1',
              ),
            ),
          ).thenAnswer(
            (_) async => listResponseJson,
          );

          final result =
              await service
                  .getPetVaccinations(
            'pet-1',
          );

          expect(result.length, 1);
          expect(
            result.first.petId,
            'pet-1',
          );
        },
      );
    });
  });
}

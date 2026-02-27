import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/prescription_service.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late PrescriptionService service;
  late MockApiClient mockApiClient;

  final samplePrescriptionJson =
      <String, dynamic>{
    'id': 'presc-1',
    'petId': 'pet-1',
    'medicationName': 'Amoxicillin',
    'dosage': '10 mg',
    'frequency': 'Twice daily',
    'startDate': '2025-01-15T00:00:00.000Z',
    'isActive': true,
    'createdAt': '2025-01-15T10:00:00.000Z',
  };

  final paginatedResponseJson =
      <String, dynamic>{
    'data': <String, dynamic>{
      'items': <dynamic>[
        samplePrescriptionJson,
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
    'data': samplePrescriptionJson,
  };

  final listResponseJson =
      <String, dynamic>{
    'data': <dynamic>[
      samplePrescriptionJson,
    ],
  };

  group('PrescriptionService -', () {
    setUp(() {
      registerServices();
      mockApiClient =
          locator<ApiClient>() as MockApiClient;
      service = PrescriptionService();
    });

    tearDown(locator.reset);

    group('getPrescriptions -', () {
      test(
        'Should call GET with correct endpoint',
        () async {
          when(
            mockApiClient.get(
              ApiConfig.prescriptionsEndpoint,
              queryParameters:
                  anyNamed('queryParameters'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponseJson,
          );

          final result =
              await service.getPrescriptions();

          expect(result.items.length, 1);
          expect(
            result.items.first.id,
            'presc-1',
          );
        },
      );

      test(
        'Should pass isActive filter',
        () async {
          when(
            mockApiClient.get(
              ApiConfig.prescriptionsEndpoint,
              queryParameters:
                  anyNamed('queryParameters'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponseJson,
          );

          await service.getPrescriptions(
            isActive: true,
          );

          verify(
            mockApiClient.get(
              ApiConfig.prescriptionsEndpoint,
              queryParameters: argThat(
                containsPair(
                  'isActive',
                  true,
                ),
                named: 'queryParameters',
              ),
            ),
          ).called(1);
        },
      );
    });

    group('getPrescriptionById -', () {
      test(
        'Should call GET with correct id',
        () async {
          when(
            mockApiClient.get(
              ApiConfig
                  .prescriptionByIdEndpoint(
                'presc-1',
              ),
            ),
          ).thenAnswer(
            (_) async => singleResponseJson,
          );

          final result =
              await service
                  .getPrescriptionById(
            'presc-1',
          );

          expect(result.id, 'presc-1');
          expect(
            result.medicationName,
            'Amoxicillin',
          );
        },
      );
    });

    group('createPrescription -', () {
      test(
        'Should call POST with data',
        () async {
          when(
            mockApiClient.post(
              ApiConfig.prescriptionsEndpoint,
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => singleResponseJson,
          );

          final result =
              await service
                  .createPrescription(
            <String, dynamic>{
              'petId': 'pet-1',
              'medicationName': 'Amoxicillin',
            },
          );

          expect(result.id, 'presc-1');
        },
      );
    });

    group('updatePrescription -', () {
      test(
        'Should call PATCH with data',
        () async {
          when(
            mockApiClient.patch(
              ApiConfig
                  .prescriptionByIdEndpoint(
                'presc-1',
              ),
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => singleResponseJson,
          );

          final result =
              await service
                  .updatePrescription(
            'presc-1',
            <String, dynamic>{
              'isActive': false,
            },
          );

          expect(result.id, 'presc-1');
        },
      );
    });

    group('deletePrescription -', () {
      test(
        'Should call DELETE with correct id',
        () async {
          when(
            mockApiClient.delete(
              ApiConfig
                  .prescriptionByIdEndpoint(
                'presc-1',
              ),
            ),
          ).thenAnswer((_) async => null);

          await service.deletePrescription(
            'presc-1',
          );

          verify(
            mockApiClient.delete(
              ApiConfig
                  .prescriptionByIdEndpoint(
                'presc-1',
              ),
            ),
          ).called(1);
        },
      );
    });

    group('getPetPrescriptions -', () {
      test(
        'Should call GET with pet endpoint',
        () async {
          when(
            mockApiClient.get(
              ApiConfig
                  .petPrescriptionsEndpoint(
                'pet-1',
              ),
            ),
          ).thenAnswer(
            (_) async => listResponseJson,
          );

          final result =
              await service
                  .getPetPrescriptions(
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

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/medical_record_service.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MedicalRecordService service;
  late MockApiClient mockApiClient;

  final sampleRecordJson =
      <String, dynamic>{
    'id': 'rec-1',
    'petId': 'pet-1',
    'veterinarianId': 'vet-1',
    'visitDate': '2025-01-15T10:00:00.000Z',
    'visitReason': 'Checkup',
    'diagnosis': 'Healthy',
    'treatment': 'None',
    'createdAt': '2025-01-15T10:00:00.000Z',
  };

  final paginatedResponseJson =
      <String, dynamic>{
    'data': <String, dynamic>{
      'items': <dynamic>[sampleRecordJson],
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
    'data': sampleRecordJson,
  };

  final listResponseJson =
      <String, dynamic>{
    'data': <dynamic>[sampleRecordJson],
  };

  group('MedicalRecordService -', () {
    setUp(() {
      registerServices();
      mockApiClient =
          locator<ApiClient>() as MockApiClient;
      service = MedicalRecordService();
    });

    tearDown(locator.reset);

    group('getMedicalRecords -', () {
      test(
        'Should call GET with correct endpoint',
        () async {
          when(
            mockApiClient.get(
              ApiConfig.medicalRecordsEndpoint,
              queryParameters:
                  anyNamed('queryParameters'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponseJson,
          );

          final result =
              await service.getMedicalRecords();

          expect(result.items.length, 1);
          expect(
            result.items.first.id,
            'rec-1',
          );
          verify(
            mockApiClient.get(
              ApiConfig.medicalRecordsEndpoint,
              queryParameters:
                  anyNamed('queryParameters'),
            ),
          ).called(1);
        },
      );

      test(
        'Should pass petId query parameter',
        () async {
          when(
            mockApiClient.get(
              ApiConfig.medicalRecordsEndpoint,
              queryParameters:
                  anyNamed('queryParameters'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponseJson,
          );

          await service.getMedicalRecords(
            petId: 'pet-1',
          );

          verify(
            mockApiClient.get(
              ApiConfig.medicalRecordsEndpoint,
              queryParameters: argThat(
                containsPair('petId', 'pet-1'),
                named: 'queryParameters',
              ),
            ),
          ).called(1);
        },
      );
    });

    group('getMedicalRecordById -', () {
      test(
        'Should call GET with correct id',
        () async {
          when(
            mockApiClient.get(
              ApiConfig
                  .medicalRecordByIdEndpoint(
                'rec-1',
              ),
            ),
          ).thenAnswer(
            (_) async => singleResponseJson,
          );

          final result =
              await service
                  .getMedicalRecordById(
            'rec-1',
          );

          expect(result.id, 'rec-1');
          expect(
            result.visitReason,
            'Checkup',
          );
        },
      );
    });

    group('createMedicalRecord -', () {
      test(
        'Should call POST with data',
        () async {
          final data = <String, dynamic>{
            'petId': 'pet-1',
            'visitDate':
                '2025-01-15T10:00:00.000Z',
            'visitReason': 'Checkup',
          };

          when(
            mockApiClient.post(
              ApiConfig.medicalRecordsEndpoint,
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => singleResponseJson,
          );

          final result =
              await service
                  .createMedicalRecord(data);

          expect(result.id, 'rec-1');
          verify(
            mockApiClient.post(
              ApiConfig.medicalRecordsEndpoint,
              data: anyNamed('data'),
            ),
          ).called(1);
        },
      );
    });

    group('updateMedicalRecord -', () {
      test(
        'Should call PATCH with data',
        () async {
          final data = <String, dynamic>{
            'diagnosis': 'Updated',
          };

          when(
            mockApiClient.patch(
              ApiConfig
                  .medicalRecordByIdEndpoint(
                'rec-1',
              ),
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => singleResponseJson,
          );

          final result =
              await service
                  .updateMedicalRecord(
            'rec-1',
            data,
          );

          expect(result.id, 'rec-1');
          verify(
            mockApiClient.patch(
              ApiConfig
                  .medicalRecordByIdEndpoint(
                'rec-1',
              ),
              data: anyNamed('data'),
            ),
          ).called(1);
        },
      );
    });

    group('deleteMedicalRecord -', () {
      test(
        'Should call DELETE with correct id',
        () async {
          when(
            mockApiClient.delete(
              ApiConfig
                  .medicalRecordByIdEndpoint(
                'rec-1',
              ),
            ),
          ).thenAnswer((_) async => null);

          await service.deleteMedicalRecord(
            'rec-1',
          );

          verify(
            mockApiClient.delete(
              ApiConfig
                  .medicalRecordByIdEndpoint(
                'rec-1',
              ),
            ),
          ).called(1);
        },
      );
    });

    group('getPetMedicalRecords -', () {
      test(
        'Should call GET with pet endpoint',
        () async {
          when(
            mockApiClient.get(
              ApiConfig
                  .petMedicalRecordsEndpoint(
                'pet-1',
              ),
            ),
          ).thenAnswer(
            (_) async => listResponseJson,
          );

          final result =
              await service
                  .getPetMedicalRecords(
            'pet-1',
          );

          expect(result.length, 1);
          expect(result.first.petId, 'pet-1');
        },
      );
    });
  });
}

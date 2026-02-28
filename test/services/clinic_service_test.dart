import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/services/clinic_service.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockApiClient apiClient;

  group('ClinicService -', () {
    setUp(() {
      registerServices();
      apiClient = locator<MockApiClient>();
    });
    tearDown(locator.reset);

    final clinicJson = <String, dynamic>{
      'id': 'c1',
      'name': 'Test Clinic',
      'createdAt': '2024-01-01T00:00:00.000Z',
      'updatedAt': '2024-01-01T00:00:00.000Z',
    };

    final brandingJson = <String, dynamic>{
      'primaryColor': '#FF0000',
      'logoUrl': 'https://example.com/logo.png',
    };

    final settingsJson = <String, dynamic>{
      'slotDuration': 30,
      'smsEnabled': true,
    };

    group('getClinicInfo -', () {
      test(
        'Should call GET on clinic endpoint',
        () async {
          when(
            apiClient.get(
              ApiConfig.clinicEndpoint,
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': clinicJson,
            },
          );

          final service = ClinicService();
          final result =
              await service.getClinicInfo();

          expect(result.name, 'Test Clinic');
          verify(
            apiClient.get(
              ApiConfig.clinicEndpoint,
            ),
          ).called(1);
        },
      );
    });

    group('updateClinicInfo -', () {
      test(
        'Should call PATCH on clinic endpoint',
        () async {
          when(
            apiClient.patch(
              ApiConfig.clinicEndpoint,
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': clinicJson,
            },
          );

          final service = ClinicService();
          final result =
              await service.updateClinicInfo(
            <String, dynamic>{
              'name': 'Updated',
            },
          );

          expect(result.id, 'c1');
        },
      );
    });

    group('getClinicSettings -', () {
      test(
        'Should call GET on settings endpoint',
        () async {
          when(
            apiClient.get(
              ApiConfig.settingsEndpoint,
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': settingsJson,
            },
          );

          final service = ClinicService();
          final result =
              await service.getClinicSettings();

          expect(result['slotDuration'], 30);
        },
      );
    });

    group('updateClinicSettings -', () {
      test(
        'Should call PATCH on settings',
        () async {
          when(
            apiClient.patch(
              ApiConfig.settingsEndpoint,
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': settingsJson,
            },
          );

          final service = ClinicService();
          final result =
              await service.updateClinicSettings(
            <String, dynamic>{
              'slotDuration': 45,
            },
          );

          expect(result['slotDuration'], 30);
        },
      );
    });

    group('getClinicBranding -', () {
      test(
        'Should call GET on branding endpoint',
        () async {
          when(
            apiClient.get(
              ApiConfig.brandingEndpoint,
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': brandingJson,
            },
          );

          final service = ClinicService();
          final result =
              await service.getClinicBranding();

          expect(
            result.primaryColor,
            '#FF0000',
          );
        },
      );
    });

    group('updateClinicBranding -', () {
      test(
        'Should call PATCH on branding',
        () async {
          when(
            apiClient.patch(
              ApiConfig.brandingEndpoint,
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': brandingJson,
            },
          );

          final service = ClinicService();
          final result =
              await service.updateClinicBranding(
            <String, dynamic>{
              'primaryColor': '#00FF00',
            },
          );

          expect(
            result.primaryColor,
            '#FF0000',
          );
        },
      );
    });
  });
}

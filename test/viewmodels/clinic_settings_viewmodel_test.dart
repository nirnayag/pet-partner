import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/clinic/clinic.dart';
import 'package:partner/services/clinic_service.dart';
import 'package:partner/ui/views/clinic_settings/clinic_settings_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockClinicService clinicService;

  final testClinic = Clinic.fromJson(
    const <String, dynamic>{
      'id': 'c1',
      'name': 'Test Clinic',
      'email': 'test@clinic.com',
      'createdAt': '2024-01-01T00:00:00.000Z',
      'updatedAt': '2024-01-01T00:00:00.000Z',
    },
  );

  final testSettings = <String, dynamic>{
    'slotDuration': 30,
    'smsEnabled': true,
  };

  group('ClinicSettingsViewModel -', () {
    setUp(() {
      registerServices();
      clinicService = locator<ClinicService>()
          as MockClinicService;
    });
    tearDown(locator.reset);

    group('initialise -', () {
      test(
        'Should load clinic info and settings',
        () async {
          when(
            clinicService.getClinicInfo(),
          ).thenAnswer(
            (_) async => testClinic,
          );
          when(
            clinicService.getClinicSettings(),
          ).thenAnswer(
            (_) async => testSettings,
          );

          final model =
              ClinicSettingsViewModel();
          await model.initialise();

          expect(model.clinic, isNotNull);
          expect(
            model.clinic!.name,
            'Test Clinic',
          );
          expect(
            model.settings['slotDuration'],
            30,
          );
          expect(
            model.nameController.text,
            'Test Clinic',
          );
          expect(
            model.emailController.text,
            'test@clinic.com',
          );
          expect(model.errorMessage, isNull);
        },
      );
    });

    group('saveClinicInfo -', () {
      test(
        'Should call updateClinicInfo',
        () async {
          when(
            clinicService.getClinicInfo(),
          ).thenAnswer(
            (_) async => testClinic,
          );
          when(
            clinicService.getClinicSettings(),
          ).thenAnswer(
            (_) async => testSettings,
          );
          when(
            clinicService.updateClinicInfo(any),
          ).thenAnswer(
            (_) async => testClinic,
          );

          final model =
              ClinicSettingsViewModel();
          await model.initialise();
          await model.saveClinicInfo();

          verify(
            clinicService.updateClinicInfo(any),
          ).called(1);
          expect(
            model.successMessage,
            'Clinic info saved.',
          );
        },
      );
    });

    group('saveSettings -', () {
      test(
        'Should call updateClinicSettings',
        () async {
          when(
            clinicService.getClinicInfo(),
          ).thenAnswer(
            (_) async => testClinic,
          );
          when(
            clinicService.getClinicSettings(),
          ).thenAnswer(
            (_) async => testSettings,
          );
          when(
            clinicService.updateClinicSettings(
              any,
            ),
          ).thenAnswer(
            (_) async => testSettings,
          );

          final model =
              ClinicSettingsViewModel();
          await model.initialise();
          await model.saveSettings(
            <String, dynamic>{
              'slotDuration': 45,
            },
          );

          verify(
            clinicService.updateClinicSettings(
              any,
            ),
          ).called(1);
          expect(
            model.successMessage,
            'Settings saved.',
          );
        },
      );
    });

    group('initial state -', () {
      test(
        'Should have correct defaults',
        () {
          final model =
              ClinicSettingsViewModel();
          expect(model.clinic, isNull);
          expect(model.settings, isEmpty);
          expect(model.errorMessage, isNull);
          expect(model.isSaving, false);
          expect(
            model.successMessage,
            isNull,
          );
        },
      );
    });
  });
}

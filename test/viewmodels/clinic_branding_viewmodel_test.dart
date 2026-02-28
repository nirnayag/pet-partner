import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/clinic/clinic_branding.dart';
import 'package:partner/services/clinic_service.dart';
import 'package:partner/ui/views/clinic_branding/clinic_branding_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockClinicService clinicService;

  const testBranding = ClinicBranding(
    logoUrl: 'https://example.com/logo.png',
    primaryColor: '#FF0000',
  );

  group('ClinicBrandingViewModel -', () {
    setUp(() {
      registerServices();
      clinicService = locator<ClinicService>()
          as MockClinicService;
    });
    tearDown(locator.reset);

    group('initialise -', () {
      test(
        'Should load branding info',
        () async {
          when(
            clinicService.getClinicBranding(),
          ).thenAnswer(
            (_) async => testBranding,
          );

          final model =
              ClinicBrandingViewModel();
          await model.initialise();

          expect(model.branding, isNotNull);
          expect(
            model.logoUrl,
            'https://example.com/logo.png',
          );
          expect(
            model.primaryColor,
            '#FF0000',
          );
          expect(model.errorMessage, isNull);
        },
      );
    });

    group('setPrimaryColor -', () {
      test(
        'Should update primary color',
        () {
          final model =
              ClinicBrandingViewModel();
          model.setPrimaryColor('#00FF00');

          expect(
            model.primaryColor,
            '#00FF00',
          );
        },
      );
    });

    group('parsedColor -', () {
      test(
        'Should return correct Color',
        () {
          final model =
              ClinicBrandingViewModel();
          model.setPrimaryColor('#FF0000');

          expect(
            model.parsedColor,
            const Color(0xFFFF0000),
          );
        },
      );

      test(
        'Should return default for invalid hex',
        () {
          final model =
              ClinicBrandingViewModel();
          model.setPrimaryColor('invalid');

          expect(
            model.parsedColor,
            const Color(0xFF13EC13),
          );
        },
      );
    });

    group('save -', () {
      test(
        'Should call updateClinicBranding',
        () async {
          when(
            clinicService.getClinicBranding(),
          ).thenAnswer(
            (_) async => testBranding,
          );
          when(
            clinicService.updateClinicBranding(
              any,
            ),
          ).thenAnswer(
            (_) async => testBranding,
          );

          final model =
              ClinicBrandingViewModel();
          await model.initialise();
          await model.save();

          verify(
            clinicService.updateClinicBranding(
              any,
            ),
          ).called(1);
          expect(
            model.successMessage,
            'Branding saved.',
          );
        },
      );
    });

    group('initial state -', () {
      test(
        'Should have correct defaults',
        () {
          final model =
              ClinicBrandingViewModel();
          expect(model.branding, isNull);
          expect(model.logoUrl, isNull);
          expect(
            model.primaryColor,
            '#13EC13',
          );
          expect(model.isSaving, false);
        },
      );
    });
  });
}

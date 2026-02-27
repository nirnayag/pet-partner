import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/medical/vaccination.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/vaccination_service.dart';
import 'package:partner/ui/views/vaccination_form/vaccination_form_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  group('VaccinationFormViewModel -', () {
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
        'batchNumber': 'LOT-123',
        'manufacturer': 'Zoetis',
        'notes': 'Annual booster',
        'nextDueDate':
            '2026-01-15T00:00:00.000Z',
      },
    );

    VaccinationFormViewModel _getModel({
      Vaccination? vaccination,
      String? petId,
    }) {
      return VaccinationFormViewModel(
        vaccination: vaccination,
        petId: petId,
      );
    }

    group('create mode -', () {
      test(
        'Should default to not edit mode',
        () {
          final model = _getModel();
          expect(model.isEditMode, false);
          expect(model.errorMessage, isNull);
        },
      );
    });

    group('edit mode -', () {
      test(
        'Should populate from vaccination',
        () {
          final model = _getModel(
            vaccination: sampleVaccination,
          );
          model.initialise();

          expect(model.isEditMode, true);
          expect(
            model.vaccineNameController.text,
            'Rabies',
          );
          expect(
            model.batchNumberController.text,
            'LOT-123',
          );
          expect(
            model.manufacturerController.text,
            'Zoetis',
          );
          expect(
            model.notesController.text,
            'Annual booster',
          );
          expect(
            model.nextDueDate,
            isNotNull,
          );
        },
      );
    });

    group('saveVaccination -', () {
      test(
        'Should show error when vaccine '
        'name is empty',
        () async {
          final model = _getModel(
            petId: 'pet-1',
          );

          await model.saveVaccination();

          expect(
            model.errorMessage,
            'Vaccine name is required.',
          );
        },
      );

      test(
        'Should call createVaccination '
        'in create mode',
        () async {
          final mockService =
              locator<VaccinationService>()
                  as MockVaccinationService;

          when(
            mockService.createVaccination(
              any,
            ),
          ).thenAnswer(
            (_) async => sampleVaccination,
          );

          final model = _getModel(
            petId: 'pet-1',
          );
          model.vaccineNameController.text =
              'Rabies';

          await model.saveVaccination();

          verify(
            mockService.createVaccination(
              any,
            ),
          ).called(1);
        },
      );

      test(
        'Should call updateVaccination '
        'in edit mode',
        () async {
          final mockService =
              locator<VaccinationService>()
                  as MockVaccinationService;

          when(
            mockService.updateVaccination(
              any,
              any,
            ),
          ).thenAnswer(
            (_) async => sampleVaccination,
          );

          final model = _getModel(
            vaccination: sampleVaccination,
          );
          model.initialise();

          await model.saveVaccination();

          verify(
            mockService.updateVaccination(
              'vac-1',
              any,
            ),
          ).called(1);
        },
      );

      test(
        'Should set error on ApiException',
        () async {
          final mockService =
              locator<VaccinationService>()
                  as MockVaccinationService;

          when(
            mockService.createVaccination(
              any,
            ),
          ).thenThrow(
            const ApiException(
              message: 'Server error',
            ),
          );

          final model = _getModel(
            petId: 'pet-1',
          );
          model.vaccineNameController.text =
              'Rabies';

          await model.saveVaccination();

          expect(
            model.errorMessage,
            'Server error',
          );
        },
      );
    });

    group('setters -', () {
      test(
        'Should update dateAdministered',
        () {
          final model = _getModel();
          final date = DateTime(2025, 6, 1);
          model.setDateAdministered(date);
          expect(
            model.dateAdministered,
            date,
          );
        },
      );

      test(
        'Should update nextDueDate',
        () {
          final model = _getModel();
          final date = DateTime(2026, 6, 1);
          model.setNextDueDate(date);
          expect(model.nextDueDate, date);
        },
      );
    });
  });
}

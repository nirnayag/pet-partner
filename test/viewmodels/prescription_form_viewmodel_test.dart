import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/medical/prescription.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/prescription_service.dart';
import 'package:partner/ui/views/prescription_form/prescription_form_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  group('PrescriptionFormViewModel -', () {
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
        'duration': '7 days',
        'instructions': 'With food',
      },
    );

    PrescriptionFormViewModel _getModel({
      Prescription? prescription,
      String? petId,
      String? medicalRecordId,
    }) {
      return PrescriptionFormViewModel(
        prescription: prescription,
        petId: petId,
        medicalRecordId: medicalRecordId,
      );
    }

    group('create mode -', () {
      test(
        'Should default to not edit mode',
        () {
          final model = _getModel();
          expect(model.isEditMode, false);
          expect(model.isActive, true);
        },
      );
    });

    group('edit mode -', () {
      test(
        'Should populate from prescription',
        () {
          final model = _getModel(
            prescription: samplePrescription,
          );
          model.initialise();

          expect(model.isEditMode, true);
          expect(
            model.medicationNameController.text,
            'Amoxicillin',
          );
          expect(
            model.dosageController.text,
            '10 mg',
          );
          expect(
            model.frequencyController.text,
            'Twice daily',
          );
          expect(
            model.durationController.text,
            '7 days',
          );
          expect(
            model.instructionsController.text,
            'With food',
          );
          expect(model.isActive, true);
        },
      );
    });

    group('savePrescription -', () {
      test(
        'Should show error when medication '
        'name is empty',
        () async {
          final model = _getModel(
            petId: 'pet-1',
          );

          await model.savePrescription();

          expect(
            model.errorMessage,
            'Medication name is required.',
          );
        },
      );

      test(
        'Should show error when dosage '
        'is empty',
        () async {
          final model = _getModel(
            petId: 'pet-1',
          );
          model.medicationNameController.text =
              'Test';

          await model.savePrescription();

          expect(
            model.errorMessage,
            'Dosage is required.',
          );
        },
      );

      test(
        'Should show error when frequency '
        'is empty',
        () async {
          final model = _getModel(
            petId: 'pet-1',
          );
          model.medicationNameController.text =
              'Test';
          model.dosageController.text =
              '10 mg';

          await model.savePrescription();

          expect(
            model.errorMessage,
            'Frequency is required.',
          );
        },
      );

      test(
        'Should call createPrescription '
        'in create mode',
        () async {
          final mockService = locator<
                  PrescriptionService>()
              as MockPrescriptionService;

          when(
            mockService.createPrescription(
              any,
            ),
          ).thenAnswer(
            (_) async => samplePrescription,
          );

          final model = _getModel(
            petId: 'pet-1',
          );
          model.medicationNameController.text =
              'Amoxicillin';
          model.dosageController.text =
              '10 mg';
          model.frequencyController.text =
              'Twice daily';

          await model.savePrescription();

          verify(
            mockService.createPrescription(
              any,
            ),
          ).called(1);
        },
      );

      test(
        'Should call updatePrescription '
        'in edit mode',
        () async {
          final mockService = locator<
                  PrescriptionService>()
              as MockPrescriptionService;

          when(
            mockService.updatePrescription(
              any,
              any,
            ),
          ).thenAnswer(
            (_) async => samplePrescription,
          );

          final model = _getModel(
            prescription: samplePrescription,
          );
          model.initialise();

          await model.savePrescription();

          verify(
            mockService.updatePrescription(
              'presc-1',
              any,
            ),
          ).called(1);
        },
      );

      test(
        'Should set error on ApiException',
        () async {
          final mockService = locator<
                  PrescriptionService>()
              as MockPrescriptionService;

          when(
            mockService.createPrescription(
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
          model.medicationNameController.text =
              'Test';
          model.dosageController.text =
              '10 mg';
          model.frequencyController.text =
              'Daily';

          await model.savePrescription();

          expect(
            model.errorMessage,
            'Server error',
          );
        },
      );
    });

    group('setters -', () {
      test(
        'Should update startDate',
        () {
          final model = _getModel();
          final date = DateTime(2025, 6, 1);
          model.setStartDate(date);
          expect(model.startDate, date);
        },
      );

      test(
        'Should update endDate',
        () {
          final model = _getModel();
          final date = DateTime(2025, 7, 1);
          model.setEndDate(date);
          expect(model.endDate, date);
        },
      );

      test(
        'Should toggle active',
        () {
          final model = _getModel();
          expect(model.isActive, true);
          model.toggleActive();
          expect(model.isActive, false);
          model.toggleActive();
          expect(model.isActive, true);
        },
      );
    });
  });
}

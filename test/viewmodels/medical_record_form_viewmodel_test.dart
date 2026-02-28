import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/medical/medical_record.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/medical_record_service.dart';
import 'package:partner/ui/views/medical_record_form/medical_record_form_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  group('MedicalRecordFormViewModel -', () {
    setUp(registerServices);
    tearDown(locator.reset);

    MedicalRecordFormViewModel _getModel({
      MedicalRecord? record,
      String? petId,
      String? appointmentId,
    }) {
      return MedicalRecordFormViewModel(
        record: record,
        petId: petId,
        appointmentId: appointmentId,
      );
    }

    final sampleRecord = MedicalRecord.fromJson(
      <String, dynamic>{
        'id': 'rec-1',
        'petId': 'pet-1',
        'veterinarianId': 'vet-1',
        'visitDate':
            '2025-01-15T10:00:00.000Z',
        'visitReason': 'Checkup',
        'diagnosis': 'Healthy',
        'treatment': 'None',
        'notes': 'All good',
        'weightAtVisit': 10.5,
        'weightUnit': 'kg',
        'temperatureAtVisit': 101.5,
        'temperatureUnit': 'F',
        'createdAt':
            '2025-01-15T10:00:00.000Z',
      },
    );

    group('create mode -', () {
      test(
        'Should default to not edit mode',
        () {
          final model = _getModel();
          expect(model.isEditMode, false);
          expect(model.errorMessage, isNull);
        },
      );

      test(
        'Should store petId and '
        'appointmentId',
        () {
          final model = _getModel(
            petId: 'pet-1',
            appointmentId: 'appt-1',
          );
          expect(model.petId, 'pet-1');
          expect(
            model.appointmentId,
            'appt-1',
          );
        },
      );
    });

    group('edit mode -', () {
      test(
        'Should populate controllers '
        'from record',
        () {
          final model = _getModel(
            record: sampleRecord,
          );
          model.initialise();

          expect(model.isEditMode, true);
          expect(
            model.visitReasonController.text,
            'Checkup',
          );
          expect(
            model.diagnosisController.text,
            'Healthy',
          );
          expect(
            model.treatmentController.text,
            'None',
          );
          expect(
            model.notesController.text,
            'All good',
          );
          expect(
            model.weightController.text,
            '10.5',
          );
          expect(model.weightUnit, 'kg');
          expect(
            model.temperatureController.text,
            '101.5',
          );
          expect(
            model.temperatureUnit,
            'F',
          );
        },
      );
    });

    group('saveRecord -', () {
      test(
        'Should show error when visit reason '
        'is empty',
        () async {
          final model = _getModel(
            petId: 'pet-1',
          );

          await model.saveRecord();

          expect(
            model.errorMessage,
            'Visit reason is required.',
          );
        },
      );

      test(
        'Should call createMedicalRecord '
        'in create mode',
        () async {
          final mockService = locator<
                  MedicalRecordService>()
              as MockMedicalRecordService;

          when(
            mockService.createMedicalRecord(
              any,
            ),
          ).thenAnswer(
            (_) async => sampleRecord,
          );

          final model = _getModel(
            petId: 'pet-1',
          );
          model.visitReasonController.text =
              'Checkup';

          await model.saveRecord();

          verify(
            mockService.createMedicalRecord(
              any,
            ),
          ).called(1);
        },
      );

      test(
        'Should call updateMedicalRecord '
        'in edit mode',
        () async {
          final mockService = locator<
                  MedicalRecordService>()
              as MockMedicalRecordService;

          when(
            mockService.updateMedicalRecord(
              any,
              any,
            ),
          ).thenAnswer(
            (_) async => sampleRecord,
          );

          final model = _getModel(
            record: sampleRecord,
          );
          model.initialise();
          model.visitReasonController.text =
              'Updated';

          await model.saveRecord();

          verify(
            mockService.updateMedicalRecord(
              'rec-1',
              any,
            ),
          ).called(1);
        },
      );

      test(
        'Should set error on ApiException',
        () async {
          final mockService = locator<
                  MedicalRecordService>()
              as MockMedicalRecordService;

          when(
            mockService.createMedicalRecord(
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
          model.visitReasonController.text =
              'Checkup';

          await model.saveRecord();

          expect(
            model.errorMessage,
            'Server error',
          );
        },
      );
    });

    group('deleteRecord -', () {
      test(
        'Should not delete if not in '
        'edit mode',
        () async {
          final model = _getModel();
          await model.deleteRecord();

          verifyNever(
            (locator<MedicalRecordService>()
                    as MockMedicalRecordService)
                .deleteMedicalRecord(any),
          );
        },
      );

      test(
        'Should delete when confirmed',
        () async {
          final mockService = locator<
                  MedicalRecordService>()
              as MockMedicalRecordService;
          final mockDialog =
              locator<DialogService>()
                  as MockDialogService;

          when(
            mockDialog
                .showConfirmationDialog(
              title: anyNamed('title'),
              description:
                  anyNamed('description'),
              confirmationTitle: anyNamed(
                'confirmationTitle',
              ),
            ),
          ).thenAnswer(
            (_) async =>
                DialogResponse<dynamic>(
              confirmed: true,
            ),
          );

          when(
            mockService.deleteMedicalRecord(
              any,
            ),
          ).thenAnswer((_) async {});

          final model = _getModel(
            record: sampleRecord,
          );
          await model.deleteRecord();

          verify(
            mockService.deleteMedicalRecord(
              'rec-1',
            ),
          ).called(1);
        },
      );
    });

    group('setters -', () {
      test(
        'Should update visitDate',
        () {
          final model = _getModel();
          final date = DateTime(2025, 6, 1);
          model.setVisitDate(date);
          expect(model.visitDate, date);
        },
      );

      test(
        'Should update weightUnit',
        () {
          final model = _getModel();
          model.setWeightUnit('lbs');
          expect(model.weightUnit, 'lbs');
        },
      );

      test(
        'Should update temperatureUnit',
        () {
          final model = _getModel();
          model.setTemperatureUnit('C');
          expect(
            model.temperatureUnit,
            'C',
          );
        },
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/enums/reminder_type.dart';
import 'package:partner/core/models/reminder/reminder.dart';
import 'package:partner/services/reminder_service.dart';
import 'package:partner/ui/views/reminder_form/reminder_form_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockReminderService reminderService;

  final testReminder = Reminder.fromJson(
    const <String, dynamic>{
      'id': 'r1',
      'reminderType': 'vaccination',
      'title': 'Vaccine Due',
      'message': 'Please schedule',
      'scheduledFor':
          '2024-06-01T09:00:00.000Z',
      'status': 'pending',
      'channels': ['sms', 'email'],
      'createdAt':
          '2024-01-01T00:00:00.000Z',
      'updatedAt':
          '2024-01-01T00:00:00.000Z',
    },
  );

  group('ReminderFormViewModel -', () {
    setUp(() {
      registerServices();
      reminderService =
          locator<ReminderService>()
              as MockReminderService;
    });
    tearDown(locator.reset);

    group('create mode -', () {
      test(
        'Should not be in edit mode',
        () {
          final model = ReminderFormViewModel();
          expect(model.isEditMode, false);
        },
      );

      test(
        'Should default to appointment type',
        () {
          final model = ReminderFormViewModel();
          expect(
            model.selectedType,
            ReminderType.appointment,
          );
        },
      );

      test(
        'Should default to push channel',
        () {
          final model = ReminderFormViewModel();
          expect(
            model.selectedChannels,
            contains('push'),
          );
        },
      );
    });

    group('edit mode -', () {
      test(
        'Should populate fields from reminder',
        () {
          final model = ReminderFormViewModel(
            reminder: testReminder,
          );
          model.initialise();

          expect(model.isEditMode, true);
          expect(
            model.titleController.text,
            'Vaccine Due',
          );
          expect(
            model.messageController.text,
            'Please schedule',
          );
          expect(
            model.selectedType,
            ReminderType.vaccination,
          );
          expect(
            model.selectedChannels,
            containsAll(['sms', 'email']),
          );
        },
      );
    });

    group('toggleChannel -', () {
      test(
        'Should add and remove channels',
        () {
          final model = ReminderFormViewModel();
          expect(
            model.selectedChannels
                .contains('sms'),
            false,
          );

          model.toggleChannel('sms');
          expect(
            model.selectedChannels
                .contains('sms'),
            true,
          );

          model.toggleChannel('sms');
          expect(
            model.selectedChannels
                .contains('sms'),
            false,
          );
        },
      );
    });

    group('save -', () {
      test(
        'Should show error when title is empty',
        () async {
          final model = ReminderFormViewModel();
          await model.save();

          expect(
            model.errorMessage,
            'Title is required.',
          );
        },
      );

      test(
        'Should show error when schedule '
        'is not set',
        () async {
          final model = ReminderFormViewModel();
          model.titleController.text = 'Test';
          await model.save();

          expect(
            model.errorMessage,
            'Schedule date is required.',
          );
        },
      );

      test(
        'Should show error when no channels '
        'selected',
        () async {
          final model = ReminderFormViewModel();
          model.titleController.text = 'Test';
          model.setScheduledFor(
            DateTime(2024, 6, 1, 9),
          );
          // Remove default push channel
          model.toggleChannel('push');
          await model.save();

          expect(
            model.errorMessage,
            'Select at least one channel.',
          );
        },
      );

      test(
        'Should call createReminder in '
        'create mode',
        () async {
          when(
            reminderService.createReminder(any),
          ).thenAnswer(
            (_) async => testReminder,
          );

          final model = ReminderFormViewModel();
          model.titleController.text = 'Test';
          model.setScheduledFor(
            DateTime(2024, 6, 1, 9),
          );
          await model.save();

          verify(
            reminderService.createReminder(any),
          ).called(1);
        },
      );

      test(
        'Should call updateReminder in '
        'edit mode',
        () async {
          when(
            reminderService.updateReminder(
              any,
              any,
            ),
          ).thenAnswer(
            (_) async => testReminder,
          );

          final model = ReminderFormViewModel(
            reminder: testReminder,
          );
          model.initialise();
          await model.save();

          verify(
            reminderService.updateReminder(
              'r1',
              any,
            ),
          ).called(1);
        },
      );
    });
  });
}

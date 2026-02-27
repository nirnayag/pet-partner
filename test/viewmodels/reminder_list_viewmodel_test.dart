import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/clinic/send_result.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/core/models/reminder/reminder.dart';
import 'package:partner/services/reminder_service.dart';
import 'package:partner/ui/views/reminder_list/reminder_list_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockReminderService reminderService;

  ReminderListViewModel getModel() =>
      ReminderListViewModel();

  final testReminder = Reminder.fromJson(
    const <String, dynamic>{
      'id': 'r1',
      'reminderType': 'appointment',
      'title': 'Checkup reminder',
      'scheduledFor':
          '2024-06-01T09:00:00.000Z',
      'status': 'pending',
      'channels': ['push'],
      'createdAt':
          '2024-01-01T00:00:00.000Z',
      'updatedAt':
          '2024-01-01T00:00:00.000Z',
    },
  );

  final paginatedResponse =
      PaginatedResponse<Reminder>(
    items: [testReminder],
    pagination: const PaginationMeta(
      page: 1,
      limit: 20,
      total: 1,
      totalPages: 1,
      hasNext: false,
    ),
  );

  group('ReminderListViewModel -', () {
    setUp(() {
      registerServices();
      reminderService =
          locator<ReminderService>()
              as MockReminderService;
    });
    tearDown(locator.reset);

    group('initialise -', () {
      test(
        'Should load reminders',
        () async {
          when(
            reminderService.getReminders(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              status: anyNamed('status'),
              reminderType:
                  anyNamed('reminderType'),
              petId: anyNamed('petId'),
              ownerId: anyNamed('ownerId'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          final model = getModel();
          await model.initialise();

          expect(model.reminders.length, 1);
          expect(model.totalCount, 1);
        },
      );
    });

    group('filters -', () {
      test(
        'Should update status filter',
        () async {
          when(
            reminderService.getReminders(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              status: anyNamed('status'),
              reminderType:
                  anyNamed('reminderType'),
              petId: anyNamed('petId'),
              ownerId: anyNamed('ownerId'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          final model = getModel();
          model.onStatusFilterChanged('Pending');

          expect(
            model.statusFilter,
            'Pending',
          );
        },
      );
    });

    group('sendPendingReminders -', () {
      test(
        'Should call sendPendingReminders',
        () async {
          when(
            reminderService.getReminders(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              status: anyNamed('status'),
              reminderType:
                  anyNamed('reminderType'),
              petId: anyNamed('petId'),
              ownerId: anyNamed('ownerId'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );
          when(
            reminderService
                .sendPendingReminders(),
          ).thenAnswer(
            (_) async => const SendResult(
              total: 5,
              sent: 4,
              failed: 1,
              errors: ['timeout'],
            ),
          );

          final model = getModel();
          await model.sendPendingReminders();

          expect(
            model.lastSendResult,
            isNotNull,
          );
          expect(
            model.lastSendResult!.sent,
            4,
          );
        },
      );
    });

    group('deleteReminder -', () {
      test(
        'Should remove from list after delete',
        () async {
          when(
            reminderService.getReminders(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              status: anyNamed('status'),
              reminderType:
                  anyNamed('reminderType'),
              petId: anyNamed('petId'),
              ownerId: anyNamed('ownerId'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );
          when(
            reminderService.deleteReminder(
              'r1',
            ),
          ).thenAnswer((_) async {});

          final model = getModel();
          await model.initialise();
          expect(model.reminders.length, 1);

          await model.deleteReminder(
            testReminder,
          );
          expect(model.reminders.length, 0);
        },
      );
    });

    group('initial state -', () {
      test(
        'Should have correct defaults',
        () {
          final model = getModel();
          expect(model.reminders, isEmpty);
          expect(model.statusFilter, 'All');
          expect(model.totalCount, 0);
          expect(model.isSending, false);
          expect(
            model.lastSendResult,
            isNull,
          );
        },
      );
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/services/reminder_service.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockApiClient apiClient;

  group('ReminderService -', () {
    setUp(() {
      registerServices();
      apiClient = locator<MockApiClient>();
    });
    tearDown(locator.reset);

    final reminderJson = <String, dynamic>{
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
    };

    final paginatedBody = <String, dynamic>{
      'data': <String, dynamic>{
        'items': [reminderJson],
        'pagination': <String, dynamic>{
          'page': 1,
          'limit': 20,
          'total': 1,
          'totalPages': 1,
        },
      },
    };

    group('getReminders -', () {
      test(
        'Should call GET on reminders endpoint',
        () async {
          when(
            apiClient.get(
              ApiConfig.remindersEndpoint,
              queryParameters:
                  anyNamed('queryParameters'),
            ),
          ).thenAnswer(
            (_) async => paginatedBody,
          );

          final service = ReminderService();
          final result =
              await service.getReminders();

          expect(result.items.length, 1);
          expect(
            result.items.first.title,
            'Checkup reminder',
          );
        },
      );

      test(
        'Should pass status filter',
        () async {
          when(
            apiClient.get(
              ApiConfig.remindersEndpoint,
              queryParameters:
                  anyNamed('queryParameters'),
            ),
          ).thenAnswer(
            (_) async => paginatedBody,
          );

          final service = ReminderService();
          await service.getReminders(
            status: 'pending',
          );

          final captured = verify(
            apiClient.get(
              ApiConfig.remindersEndpoint,
              queryParameters: captureAnyNamed(
                'queryParameters',
              ),
            ),
          ).captured.single
              as Map<String, dynamic>;

          expect(
            captured['status'],
            'pending',
          );
        },
      );
    });

    group('getReminderById -', () {
      test(
        'Should call GET on reminder by id',
        () async {
          when(
            apiClient.get(
              ApiConfig.reminderByIdEndpoint(
                'r1',
              ),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': reminderJson,
            },
          );

          final service = ReminderService();
          final result =
              await service.getReminderById(
            'r1',
          );

          expect(result.id, 'r1');
        },
      );
    });

    group('createReminder -', () {
      test(
        'Should call POST on reminders',
        () async {
          when(
            apiClient.post(
              ApiConfig.remindersEndpoint,
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': reminderJson,
            },
          );

          final service = ReminderService();
          final result =
              await service.createReminder(
            <String, dynamic>{
              'title': 'Test',
            },
          );

          expect(
            result.title,
            'Checkup reminder',
          );
        },
      );
    });

    group('updateReminder -', () {
      test(
        'Should call PATCH on reminder by id',
        () async {
          when(
            apiClient.patch(
              ApiConfig.reminderByIdEndpoint(
                'r1',
              ),
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': reminderJson,
            },
          );

          final service = ReminderService();
          final result =
              await service.updateReminder(
            'r1',
            <String, dynamic>{
              'title': 'Updated',
            },
          );

          expect(result.id, 'r1');
        },
      );
    });

    group('deleteReminder -', () {
      test(
        'Should call DELETE on reminder by id',
        () async {
          when(
            apiClient.delete(
              ApiConfig.reminderByIdEndpoint(
                'r1',
              ),
            ),
          ).thenAnswer((_) async => null);

          final service = ReminderService();
          await service.deleteReminder('r1');

          verify(
            apiClient.delete(
              ApiConfig.reminderByIdEndpoint(
                'r1',
              ),
            ),
          ).called(1);
        },
      );
    });

    group('sendPendingReminders -', () {
      test(
        'Should call POST on send endpoint',
        () async {
          when(
            apiClient.post(
              ApiConfig.remindersSendEndpoint,
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': <String, dynamic>{
                'total': 5,
                'sent': 4,
                'failed': 1,
                'errors': ['timeout'],
              },
            },
          );

          final service = ReminderService();
          final result =
              await service
                  .sendPendingReminders();

          expect(result.total, 5);
          expect(result.sent, 4);
          expect(result.failed, 1);
        },
      );
    });
  });
}

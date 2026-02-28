import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/config/api_config.dart';
import 'package:partner/services/user_service.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockApiClient apiClient;

  group('UserService -', () {
    setUp(() {
      registerServices();
      apiClient = locator<MockApiClient>();
    });
    tearDown(locator.reset);

    final userJson = <String, dynamic>{
      'id': 'u1',
      'role': 'veterinarian',
      'roles': ['veterinarian'],
      'firstName': 'Jane',
      'lastName': 'Doe',
      'isActive': true,
    };

    final paginatedBody = <String, dynamic>{
      'data': <String, dynamic>{
        'items': [userJson],
        'pagination': <String, dynamic>{
          'page': 1,
          'limit': 20,
          'total': 1,
          'totalPages': 1,
        },
      },
    };

    group('getUsers -', () {
      test(
        'Should call GET on users endpoint',
        () async {
          when(
            apiClient.get(
              ApiConfig.usersEndpoint,
              queryParameters:
                  anyNamed('queryParameters'),
            ),
          ).thenAnswer(
            (_) async => paginatedBody,
          );

          final service = UserService();
          final result =
              await service.getUsers();

          expect(result.items.length, 1);
          expect(
            result.items.first.firstName,
            'Jane',
          );
          verify(
            apiClient.get(
              ApiConfig.usersEndpoint,
              queryParameters:
                  anyNamed('queryParameters'),
            ),
          ).called(1);
        },
      );

      test(
        'Should pass role filter',
        () async {
          when(
            apiClient.get(
              ApiConfig.usersEndpoint,
              queryParameters:
                  anyNamed('queryParameters'),
            ),
          ).thenAnswer(
            (_) async => paginatedBody,
          );

          final service = UserService();
          await service.getUsers(
            role: 'veterinarian',
          );

          final captured = verify(
            apiClient.get(
              ApiConfig.usersEndpoint,
              queryParameters: captureAnyNamed(
                'queryParameters',
              ),
            ),
          ).captured.single
              as Map<String, dynamic>;

          expect(
            captured['role'],
            'veterinarian',
          );
        },
      );
    });

    group('getUserById -', () {
      test(
        'Should call GET on user by id',
        () async {
          when(
            apiClient.get(
              ApiConfig.userByIdEndpoint('u1'),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': userJson,
            },
          );

          final service = UserService();
          final result =
              await service.getUserById('u1');

          expect(result.id, 'u1');
          expect(result.firstName, 'Jane');
        },
      );
    });

    group('createUser -', () {
      test(
        'Should call POST on users endpoint',
        () async {
          when(
            apiClient.post(
              ApiConfig.usersEndpoint,
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': userJson,
            },
          );

          final service = UserService();
          final result =
              await service.createUser(
            <String, dynamic>{
              'firstName': 'Jane',
            },
          );

          expect(result.firstName, 'Jane');
        },
      );
    });

    group('updateUser -', () {
      test(
        'Should call PATCH on user by id',
        () async {
          when(
            apiClient.patch(
              ApiConfig.userByIdEndpoint('u1'),
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': userJson,
            },
          );

          final service = UserService();
          final result =
              await service.updateUser(
            'u1',
            <String, dynamic>{
              'firstName': 'Jane',
            },
          );

          expect(result.id, 'u1');
        },
      );
    });

    group('deactivateUser -', () {
      test(
        'Should call PATCH with isActive false',
        () async {
          when(
            apiClient.patch(
              ApiConfig.userByIdEndpoint('u1'),
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': userJson,
            },
          );

          final service = UserService();
          await service.deactivateUser('u1');

          final captured = verify(
            apiClient.patch(
              ApiConfig.userByIdEndpoint('u1'),
              data: captureAnyNamed('data'),
            ),
          ).captured.single
              as Map<String, dynamic>;

          expect(captured['isActive'], false);
        },
      );
    });

    group('bulkCreateUsers -', () {
      test(
        'Should call POST on bulk endpoint',
        () async {
          when(
            apiClient.post(
              ApiConfig.usersBulkEndpoint,
              data: anyNamed('data'),
            ),
          ).thenAnswer(
            (_) async => <String, dynamic>{
              'data': <String, dynamic>{
                'total': 2,
                'successful': 2,
                'failed': 0,
                'results': <dynamic>[],
              },
            },
          );

          final service = UserService();
          final result =
              await service.bulkCreateUsers(
            [
              <String, dynamic>{
                'firstName': 'A',
              },
            ],
          );

          expect(result.total, 2);
          expect(result.successful, 2);
        },
      );
    });
  });
}

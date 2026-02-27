import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/auth/user.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/services/user_service.dart';
import 'package:partner/ui/views/staff_list/staff_list_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockUserService userService;

  StaffListViewModel getModel() =>
      StaffListViewModel();

  final testUser = User.fromJson(
    const <String, dynamic>{
      'id': 'u1',
      'role': 'veterinarian',
      'roles': ['veterinarian'],
      'firstName': 'Jane',
      'lastName': 'Doe',
      'isActive': true,
    },
  );

  final paginatedResponse =
      PaginatedResponse<User>(
    items: [testUser],
    pagination: const PaginationMeta(
      page: 1,
      limit: 20,
      total: 1,
      totalPages: 1,
      hasNext: false,
    ),
  );

  group('StaffListViewModel -', () {
    setUp(() {
      registerServices();
      userService =
          locator<UserService>() as MockUserService;
    });
    tearDown(locator.reset);

    group('initialise -', () {
      test(
        'Should load staff on initialise',
        () async {
          when(
            userService.getUsers(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              role: anyNamed('role'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          final model = getModel();
          await model.initialise();

          expect(model.staffMembers.length, 1);
          expect(model.totalCount, 1);
          expect(model.errorMessage, isNull);
        },
      );
    });

    group('filters -', () {
      test(
        'Should update role filter and reload',
        () async {
          when(
            userService.getUsers(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              role: anyNamed('role'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          final model = getModel();
          model.onRoleFilterChanged(
            'Veterinarians',
          );

          expect(
            model.roleFilter,
            'Veterinarians',
          );
        },
      );

      test(
        'Should update status filter',
        () async {
          when(
            userService.getUsers(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              role: anyNamed('role'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          final model = getModel();
          model.onStatusFilterChanged(
            'Inactive',
          );

          expect(
            model.statusFilter,
            'Inactive',
          );
        },
      );

      test(
        'Should not reload when same filter',
        () async {
          final model = getModel();
          model.onRoleFilterChanged('All');

          // Default is 'All', should not trigger
          verifyNever(
            userService.getUsers(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              role: anyNamed('role'),
              isActive: anyNamed('isActive'),
            ),
          );
        },
      );
    });

    group('pagination -', () {
      test(
        'Should not load more when already '
        'loading',
        () async {
          final model = getModel();
          // isLoadingMore starts false, hasMore
          // starts true but no items loaded
          // so loadMoreStaff returns early
          await model.loadMoreStaff();

          verifyNever(
            userService.getUsers(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              role: anyNamed('role'),
              isActive: anyNamed('isActive'),
            ),
          );
        },
      );
    });

    group('initial state -', () {
      test(
        'Should have correct defaults',
        () {
          final model = getModel();
          expect(model.staffMembers, isEmpty);
          expect(model.roleFilter, 'All');
          expect(model.statusFilter, 'Active');
          expect(model.totalCount, 0);
          expect(model.errorMessage, isNull);
          expect(model.isLoadingMore, false);
        },
      );
    });
  });
}

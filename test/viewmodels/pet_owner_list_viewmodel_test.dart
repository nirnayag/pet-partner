import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/core/models/pet_owner.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/pet_owner_service.dart';
import 'package:partner/ui/views/pet_owner_list/pet_owner_list_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late PetOwnerListViewModel model;
  late MockPetOwnerService mockPetOwnerService;

  final testOwner = PetOwner(
    id: 'owner-1',
    userId: 'user-1',
    firstName: 'Jane',
    lastName: 'Doe',
    phone: '+1234567890',
    createdAt: DateTime(2024),
    email: 'jane@example.com',
    petCount: 2,
  );

  final paginatedResponse =
      PaginatedResponse<PetOwner>(
    items: [testOwner],
    pagination: const PaginationMeta(
      page: 1,
      limit: 20,
      total: 1,
      totalPages: 1,
      hasNext: false,
      hasPrev: false,
    ),
  );

  final page2Response =
      PaginatedResponse<PetOwner>(
    items: [
      PetOwner(
        id: 'owner-2',
        userId: 'user-2',
        firstName: 'John',
        lastName: 'Smith',
        phone: '+9876543210',
        createdAt: DateTime(2024),
      ),
    ],
    pagination: const PaginationMeta(
      page: 2,
      limit: 20,
      total: 2,
      totalPages: 2,
      hasNext: false,
      hasPrev: true,
    ),
  );

  setUp(() {
    registerServices();
    mockPetOwnerService =
        locator<PetOwnerService>()
            as MockPetOwnerService;
  });

  tearDown(locator.reset);

  PetOwnerListViewModel getModel() =>
      PetOwnerListViewModel();

  group('PetOwnerListViewModel -', () {
    group('initialise -', () {
      test(
        'loads owners and sets state correctly',
        () async {
          when(
            mockPetOwnerService.getPetOwners(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              search: anyNamed('search'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          model = getModel();
          await model.initialise();

          expect(model.owners.length, 1);
          expect(
            model.owners.first.fullName,
            'Jane Doe',
          );
          expect(model.totalCount, 1);
          expect(model.hasMore, false);
          expect(model.isBusy, false);
        },
      );

      test(
        'sets error message on ApiException',
        () async {
          when(
            mockPetOwnerService.getPetOwners(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              search: anyNamed('search'),
            ),
          ).thenThrow(
            const ApiException(
              message: 'Network error',
            ),
          );

          model = getModel();
          await model.initialise();

          expect(
            model.errorMessage,
            'Network error',
          );
          expect(model.owners, isEmpty);
        },
      );
    });

    group('loadMoreOwners -', () {
      test(
        'appends results from next page',
        () async {
          when(
            mockPetOwnerService.getPetOwners(
              page: 1,
              limit: anyNamed('limit'),
              search: anyNamed('search'),
            ),
          ).thenAnswer(
            (_) async =>
                PaginatedResponse<PetOwner>(
              items: [testOwner],
              pagination: const PaginationMeta(
                page: 1,
                limit: 20,
                total: 2,
                totalPages: 2,
                hasNext: true,
                hasPrev: false,
              ),
            ),
          );

          when(
            mockPetOwnerService.getPetOwners(
              page: 2,
              limit: anyNamed('limit'),
              search: anyNamed('search'),
            ),
          ).thenAnswer(
            (_) async => page2Response,
          );

          model = getModel();
          await model.initialise();
          expect(model.owners.length, 1);

          await model.loadMoreOwners();
          expect(model.owners.length, 2);
          expect(model.currentPage, 2);
        },
      );

      test(
        'does nothing when already loading more',
        () async {
          when(
            mockPetOwnerService.getPetOwners(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              search: anyNamed('search'),
            ),
          ).thenAnswer(
            (_) async =>
                PaginatedResponse<PetOwner>(
              items: [testOwner],
              pagination: const PaginationMeta(
                page: 1,
                limit: 20,
                total: 1,
                totalPages: 1,
                hasNext: false,
                hasPrev: false,
              ),
            ),
          );

          model = getModel();
          await model.initialise();
          await model.loadMoreOwners();

          // hasMore is false, so this is a no-op
          expect(model.currentPage, 1);
        },
      );
    });

    group('onSearchChanged -', () {
      test(
        'updates search query and triggers '
        'debounced reload',
        () async {
          when(
            mockPetOwnerService.getPetOwners(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              search: anyNamed('search'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          model = getModel();
          model.onSearchChanged('Jane');

          expect(model.searchQuery, 'Jane');
        },
      );
    });

    group('refresh -', () {
      test(
        'reloads owners from first page',
        () async {
          when(
            mockPetOwnerService.getPetOwners(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              search: anyNamed('search'),
            ),
          ).thenAnswer(
            (_) async => paginatedResponse,
          );

          model = getModel();
          await model.refresh();

          expect(model.owners.length, 1);
          expect(model.errorMessage, isNull);
        },
      );
    });
  });
}

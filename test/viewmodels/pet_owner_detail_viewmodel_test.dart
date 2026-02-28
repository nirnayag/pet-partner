import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/core/models/pet_owner.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/pet_owner_service.dart';
import 'package:partner/services/pet_service.dart';
import 'package:partner/ui/views/pet_owner_detail/pet_owner_detail_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late PetOwnerDetailViewModel model;
  late MockPetOwnerService mockPetOwnerService;
  late MockPetService mockPetService;
  late MockNavigationService mockNavService;

  final testOwner = PetOwner(
    id: 'owner-1',
    userId: 'user-1',
    firstName: 'Jane',
    lastName: 'Doe',
    phone: '+1234567890',
    createdAt: DateTime(2024),
    email: 'jane@example.com',
  );

  final now = DateTime.now();

  final testPet = Pet(
    id: 'pet-1',
    name: 'Buddy',
    species: 'dog',
    isActive: true,
    isDeceased: false,
    createdAt: now,
    updatedAt: now,
  );

  final petResponse = PaginatedResponse<Pet>(
    items: [testPet],
    pagination: const PaginationMeta(
      page: 1,
      limit: 20,
      total: 1,
      totalPages: 1,
    ),
  );

  setUp(() {
    registerServices();
    mockPetOwnerService =
        locator<PetOwnerService>()
            as MockPetOwnerService;
    mockPetService = locator<PetService>()
        as MockPetService;
    mockNavService =
        locator<NavigationService>()
            as MockNavigationService;
  });

  tearDown(locator.reset);

  PetOwnerDetailViewModel getModel() =>
      PetOwnerDetailViewModel(
        ownerId: 'owner-1',
      );

  group('PetOwnerDetailViewModel -', () {
    group('initialise -', () {
      test(
        'loads owner and pets successfully',
        () async {
          when(
            mockPetOwnerService
                .getPetOwnerById('owner-1'),
          ).thenAnswer(
            (_) async => testOwner,
          );
          when(
            mockPetService.getPets(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              species: anyNamed('species'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => petResponse,
          );

          model = getModel();
          await model.initialise();

          expect(model.owner, isNotNull);
          expect(
            model.owner!.fullName,
            'Jane Doe',
          );
          expect(model.pets.length, 1);
          expect(model.pets.first.name, 'Buddy');
          expect(model.isBusy, false);
          expect(model.errorMessage, isNull);
        },
      );

      test(
        'sets error on ApiException',
        () async {
          when(
            mockPetOwnerService
                .getPetOwnerById('owner-1'),
          ).thenThrow(
            const ApiException(
              message: 'Not found',
              statusCode: 404,
            ),
          );

          model = getModel();
          await model.initialise();

          expect(
            model.errorMessage,
            'Not found',
          );
          expect(model.owner, isNull);
        },
      );
    });

    group('navigation -', () {
      test(
        'onBackTapped calls navigation back',
        () async {
          when(
            mockPetOwnerService
                .getPetOwnerById('owner-1'),
          ).thenAnswer(
            (_) async => testOwner,
          );
          when(
            mockPetService.getPets(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              species: anyNamed('species'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => petResponse,
          );

          model = getModel();
          await model.initialise();
          model.onBackTapped();

          verify(
            mockNavService.back<void>(),
          ).called(1);
        },
      );

      test(
        'onPetTapped navigates to profile',
        () async {
          when(
            mockPetOwnerService
                .getPetOwnerById('owner-1'),
          ).thenAnswer(
            (_) async => testOwner,
          );
          when(
            mockPetService.getPets(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              species: anyNamed('species'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => petResponse,
          );

          model = getModel();
          await model.initialise();
          model.onPetTapped(testPet);

          verify(
            mockNavService
                .navigateToPatientProfileView(
              petId: 'pet-1',
            ),
          ).called(1);
        },
      );
    });

    group('refresh -', () {
      test(
        'reloads owner and pets',
        () async {
          when(
            mockPetOwnerService
                .getPetOwnerById('owner-1'),
          ).thenAnswer(
            (_) async => testOwner,
          );
          when(
            mockPetService.getPets(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              species: anyNamed('species'),
              isActive: anyNamed('isActive'),
            ),
          ).thenAnswer(
            (_) async => petResponse,
          );

          model = getModel();
          await model.refresh();

          expect(model.owner, isNotNull);
          expect(model.errorMessage, isNull);
        },
      );
    });
  });
}

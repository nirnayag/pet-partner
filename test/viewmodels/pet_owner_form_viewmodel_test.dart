import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/pet_owner.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/pet_owner_service.dart';
import 'package:partner/ui/views/pet_owner_form/pet_owner_form_viewmodel.dart';
import 'package:stacked_services/stacked_services.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockPetOwnerService mockPetOwnerService;
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

  setUp(() {
    registerServices();
    mockPetOwnerService =
        locator<PetOwnerService>()
            as MockPetOwnerService;
    mockNavService =
        locator<NavigationService>()
            as MockNavigationService;
  });

  tearDown(locator.reset);

  PetOwnerFormViewModel getModel({
    PetOwner? owner,
  }) =>
      PetOwnerFormViewModel(owner: owner);

  group('PetOwnerFormViewModel -', () {
    group('initialise -', () {
      test(
        'creates in create mode when no '
        'owner provided',
        () {
          final model = getModel();
          model.initialise();

          expect(model.isEditMode, false);
          expect(
            model.firstNameController.text,
            isEmpty,
          );
        },
      );

      test(
        'pre-populates fields in edit mode',
        () {
          final model = getModel(
            owner: testOwner,
          );
          model.initialise();

          expect(model.isEditMode, true);
          expect(
            model.firstNameController.text,
            'Jane',
          );
          expect(
            model.lastNameController.text,
            'Doe',
          );
          expect(
            model.phoneController.text,
            '+1234567890',
          );
          expect(
            model.emailController.text,
            'jane@example.com',
          );
        },
      );
    });

    group('lookupByPhone -', () {
      test(
        'sets lookupResult when owner found',
        () async {
          when(
            mockPetOwnerService.lookupByPhone(
              any,
            ),
          ).thenAnswer(
            (_) async => testOwner,
          );

          final model = getModel();
          model.phoneController.text =
              '+1234567890';
          await model.lookupByPhone();

          expect(
            model.lookupResult,
            isNotNull,
          );
          expect(
            model.lookupResult!.fullName,
            'Jane Doe',
          );
          expect(model.isLookingUp, false);
        },
      );

      test(
        'sets null lookupResult when '
        'owner not found',
        () async {
          when(
            mockPetOwnerService.lookupByPhone(
              any,
            ),
          ).thenAnswer((_) async => null);

          final model = getModel();
          model.phoneController.text =
              '+9999999999';
          await model.lookupByPhone();

          expect(
            model.lookupResult,
            isNull,
          );
        },
      );

      test(
        'does nothing when phone is empty',
        () async {
          final model = getModel();
          model.phoneController.text = '';
          await model.lookupByPhone();

          verifyNever(
            mockPetOwnerService.lookupByPhone(
              any,
            ),
          );
        },
      );
    });

    group('save -', () {
      test(
        'shows error when first name empty',
        () async {
          final model = getModel();
          model.lastNameController.text = 'Doe';
          model.phoneController.text = '123';

          await model.save();

          expect(
            model.errorMessage,
            'First name is required.',
          );
        },
      );

      test(
        'shows error when last name empty',
        () async {
          final model = getModel();
          model.firstNameController.text = 'Jane';
          model.phoneController.text = '123';

          await model.save();

          expect(
            model.errorMessage,
            'Last name is required.',
          );
        },
      );

      test(
        'shows error when phone empty',
        () async {
          final model = getModel();
          model.firstNameController.text = 'Jane';
          model.lastNameController.text = 'Doe';

          await model.save();

          expect(
            model.errorMessage,
            'Phone number is required.',
          );
        },
      );

      test(
        'calls createPetOwner in create mode',
        () async {
          when(
            mockPetOwnerService.createPetOwner(
              any,
            ),
          ).thenAnswer(
            (_) async => testOwner,
          );

          final model = getModel();
          model.firstNameController.text = 'Jane';
          model.lastNameController.text = 'Doe';
          model.phoneController.text = '123';

          await model.save();

          verify(
            mockPetOwnerService.createPetOwner(
              argThat(
                containsPair(
                  'firstName',
                  'Jane',
                ),
              ),
            ),
          ).called(1);
          verify(
            mockNavService.back<void>(),
          ).called(1);
        },
      );

      test(
        'calls updatePetOwner in edit mode',
        () async {
          when(
            mockPetOwnerService.updatePetOwner(
              any,
              any,
            ),
          ).thenAnswer(
            (_) async => testOwner,
          );

          final model = getModel(
            owner: testOwner,
          );
          model.initialise();
          model.firstNameController.text =
              'Updated';

          await model.save();

          verify(
            mockPetOwnerService.updatePetOwner(
              'owner-1',
              argThat(
                containsPair(
                  'firstName',
                  'Updated',
                ),
              ),
            ),
          ).called(1);
        },
      );

      test(
        'sets error on ApiException',
        () async {
          when(
            mockPetOwnerService.createPetOwner(
              any,
            ),
          ).thenThrow(
            const ApiException(
              message: 'Duplicate phone',
            ),
          );

          final model = getModel();
          model.firstNameController.text = 'Jane';
          model.lastNameController.text = 'Doe';
          model.phoneController.text = '123';

          await model.save();

          expect(
            model.errorMessage,
            'Duplicate phone',
          );
        },
      );
    });

    group('onBackTapped -', () {
      test(
        'navigates back',
        () {
          final model = getModel();
          model.onBackTapped();

          verify(
            mockNavService.back<void>(),
          ).called(1);
        },
      );
    });
  });
}

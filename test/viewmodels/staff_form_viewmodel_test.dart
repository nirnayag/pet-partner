import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/enums/user_role.dart';
import 'package:partner/core/models/auth/user.dart';
import 'package:partner/services/user_service.dart';
import 'package:partner/ui/views/staff_form/staff_form_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockUserService userService;

  final testUser = User.fromJson(
    const <String, dynamic>{
      'id': 'u1',
      'role': 'veterinarian',
      'roles': ['veterinarian'],
      'firstName': 'Jane',
      'lastName': 'Doe',
      'isActive': true,
      'email': 'jane@clinic.com',
      'specialization': 'Surgery',
    },
  );

  group('StaffFormViewModel -', () {
    setUp(() {
      registerServices();
      userService =
          locator<UserService>() as MockUserService;
    });
    tearDown(locator.reset);

    group('create mode -', () {
      test(
        'Should not be in edit mode',
        () {
          final model = StaffFormViewModel();
          expect(model.isEditMode, false);
        },
      );

      test(
        'Should default to staff role',
        () {
          final model = StaffFormViewModel();
          expect(
            model.selectedRole,
            UserRole.staff,
          );
        },
      );

      test(
        'Should not show vet fields by default',
        () {
          final model = StaffFormViewModel();
          expect(model.showVetFields, false);
        },
      );
    });

    group('edit mode -', () {
      test(
        'Should populate fields from user',
        () {
          final model = StaffFormViewModel(
            user: testUser,
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
            model.emailController.text,
            'jane@clinic.com',
          );
          expect(
            model.selectedRole,
            UserRole.veterinarian,
          );
          expect(
            model.specializationController.text,
            'Surgery',
          );
        },
      );
    });

    group('setRole -', () {
      test(
        'Should update role and show vet fields',
        () {
          final model = StaffFormViewModel();
          model.setRole(UserRole.veterinarian);

          expect(
            model.selectedRole,
            UserRole.veterinarian,
          );
          expect(model.showVetFields, true);
        },
      );
    });

    group('save -', () {
      test(
        'Should show error when first name '
        'is empty',
        () async {
          final model = StaffFormViewModel();
          await model.save();

          expect(
            model.errorMessage,
            'First name is required.',
          );
        },
      );

      test(
        'Should show error when last name '
        'is empty',
        () async {
          final model = StaffFormViewModel();
          model.firstNameController.text = 'Jane';
          await model.save();

          expect(
            model.errorMessage,
            'Last name is required.',
          );
        },
      );

      test(
        'Should show error when email is empty',
        () async {
          final model = StaffFormViewModel();
          model.firstNameController.text = 'Jane';
          model.lastNameController.text = 'Doe';
          await model.save();

          expect(
            model.errorMessage,
            'Email is required.',
          );
        },
      );

      test(
        'Should show error when password is '
        'empty in create mode',
        () async {
          final model = StaffFormViewModel();
          model.firstNameController.text = 'Jane';
          model.lastNameController.text = 'Doe';
          model.emailController.text =
              'j@test.com';
          await model.save();

          expect(
            model.errorMessage,
            'Password is required.',
          );
        },
      );

      test(
        'Should call createUser in create mode',
        () async {
          when(
            userService.createUser(any),
          ).thenAnswer(
            (_) async => testUser,
          );

          final model = StaffFormViewModel();
          model.firstNameController.text = 'Jane';
          model.lastNameController.text = 'Doe';
          model.emailController.text =
              'j@test.com';
          model.passwordController.text =
              'password123';

          await model.save();

          verify(
            userService.createUser(any),
          ).called(1);
        },
      );

      test(
        'Should call updateUser in edit mode',
        () async {
          when(
            userService.updateUser(
              any,
              any,
            ),
          ).thenAnswer(
            (_) async => testUser,
          );

          final model = StaffFormViewModel(
            user: testUser,
          );
          model.initialise();
          await model.save();

          verify(
            userService.updateUser('u1', any),
          ).called(1);
        },
      );
    });
  });
}

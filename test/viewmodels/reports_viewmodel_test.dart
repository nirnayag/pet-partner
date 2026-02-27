import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:partner/core/models/auth/user.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/core/models/pet_owner.dart';
import 'package:partner/services/appointment_service.dart';
import 'package:partner/services/pet_owner_service.dart';
import 'package:partner/services/pet_service.dart';
import 'package:partner/services/user_service.dart';
import 'package:partner/ui/views/reports/reports_viewmodel.dart';

import '../helpers/test_helpers.dart';
import '../helpers/test_helpers.mocks.dart';

void main() {
  late MockPetService petService;
  late MockPetOwnerService petOwnerService;
  late MockUserService userService;
  late MockAppointmentService
      appointmentService;

  ReportsViewModel getModel() =>
      ReportsViewModel();

  PaginatedResponse<T> _emptyPage<T>(
    int total,
  ) {
    return PaginatedResponse<T>(
      items: <T>[],
      pagination: PaginationMeta(
        page: 1,
        limit: 1,
        total: total,
        totalPages: 1,
      ),
    );
  }

  group('ReportsViewModel -', () {
    setUp(() {
      registerServices();
      petService =
          locator<PetService>() as MockPetService;
      petOwnerService =
          locator<PetOwnerService>()
              as MockPetOwnerService;
      userService =
          locator<UserService>() as MockUserService;
      appointmentService =
          locator<AppointmentService>()
              as MockAppointmentService;
    });
    tearDown(locator.reset);

    void stubServices({
      int pets = 10,
      int owners = 5,
      int staff = 3,
      int appointments = 20,
    }) {
      when(
        petService.getPets(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
          species: anyNamed('species'),
          isActive: anyNamed('isActive'),
        ),
      ).thenAnswer(
        (_) async => _emptyPage<Pet>(pets),
      );
      when(
        petOwnerService.getPetOwners(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
          search: anyNamed('search'),
        ),
      ).thenAnswer(
        (_) async =>
            _emptyPage<PetOwner>(owners),
      );
      when(
        userService.getUsers(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
          role: anyNamed('role'),
          isActive: anyNamed('isActive'),
        ),
      ).thenAnswer(
        (_) async => _emptyPage<User>(staff),
      );
      when(
        appointmentService.getAppointments(
          page: anyNamed('page'),
          limit: anyNamed('limit'),
          status: anyNamed('status'),
          petId: anyNamed('petId'),
          veterinarianId:
              anyNamed('veterinarianId'),
          date: anyNamed('date'),
        ),
      ).thenAnswer(
        (_) async =>
            _emptyPage<Appointment>(
          appointments,
        ),
      );
    }

    group('initialise -', () {
      test(
        'Should load all stats',
        () async {
          stubServices();

          final model = getModel();
          await model.initialise();

          expect(model.activePets, 10);
          expect(model.petOwners, 5);
          expect(model.staffCount, 3);
          expect(model.appointments, 20);
          expect(model.errorMessage, isNull);
        },
      );
    });

    group('setPeriod -', () {
      test(
        'Should update selected period',
        () async {
          stubServices();

          final model = getModel();
          model.setPeriod('Week');

          expect(
            model.selectedPeriod,
            'Week',
          );
        },
      );

      test(
        'Should not reload when same period',
        () {
          final model = getModel();
          model.setPeriod('Month');

          // Default is 'Month', should not
          // trigger any calls
          verifyNever(
            petService.getPets(
              page: anyNamed('page'),
              limit: anyNamed('limit'),
              species: anyNamed('species'),
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
          expect(model.activePets, 0);
          expect(model.petOwners, 0);
          expect(model.staffCount, 0);
          expect(model.appointments, 0);
          expect(
            model.selectedPeriod,
            'Month',
          );
          expect(model.errorMessage, isNull);
        },
      );
    });
  });
}

// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedLocatorGenerator
// **************************************************************************

// ignore_for_file: public_member_api_docs, implementation_imports, depend_on_referenced_packages

import 'package:stacked_services/src/bottom_sheet/bottom_sheet_service.dart';
import 'package:stacked_services/src/dialog/dialog_service.dart';
import 'package:stacked_services/src/navigation/navigation_service.dart';
import 'package:stacked_shared/stacked_shared.dart';

import '../services/api_client.dart';
import '../services/appointment_service.dart';
import '../services/auth_service.dart';
import '../services/clinic_service.dart';
import '../services/document_service.dart';
import '../services/layout_service.dart';
import '../services/medical_record_service.dart';
import '../services/pet_owner_service.dart';
import '../services/pet_service.dart';
import '../services/prescription_service.dart';
import '../services/reminder_service.dart';
import '../services/secure_storage_service.dart';
import '../services/shared_preferences_service.dart';
import '../services/user_service.dart';
import '../services/vaccination_service.dart';

final locator = StackedLocator.instance;

Future<void> setupLocator({
  String? environment,
  EnvironmentFilter? environmentFilter,
}) async {
// Register environments
  locator.registerEnvironment(
      environment: environment, environmentFilter: environmentFilter);

// Register dependencies
  locator.registerLazySingleton(() => BottomSheetService());
  locator.registerLazySingleton(() => DialogService());
  locator.registerLazySingleton(() => NavigationService());
  locator.registerLazySingleton(() => SecureStorageService());
  locator.registerLazySingleton(() => SharedPreferencesService());
  locator.registerLazySingleton(() => ApiClient());
  locator.registerLazySingleton(() => AuthService());
  locator.registerLazySingleton(() => LayoutService());
  locator.registerLazySingleton(() => PetService());
  locator.registerLazySingleton(() => PetOwnerService());
  locator.registerLazySingleton(() => AppointmentService());
  locator.registerLazySingleton(() => MedicalRecordService());
  locator.registerLazySingleton(() => PrescriptionService());
  locator.registerLazySingleton(() => VaccinationService());
  locator.registerLazySingleton(() => DocumentService());
  locator.registerLazySingleton(() => UserService());
  locator.registerLazySingleton(() => ClinicService());
  locator.registerLazySingleton(() => ReminderService());
}

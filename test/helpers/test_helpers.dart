import 'package:mockito/annotations.dart';
import 'package:mockito/mockito.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/appointment_service.dart';
import 'package:partner/services/auth_service.dart';
import 'package:partner/services/clinic_service.dart';
import 'package:partner/services/connectivity_service.dart';
import 'package:partner/services/document_service.dart';
import 'package:partner/services/image_upload_service.dart';
import 'package:partner/services/medical_record_service.dart';
import 'package:partner/services/pet_owner_service.dart';
import 'package:partner/services/pet_service.dart';
import 'package:partner/services/prescription_service.dart';
import 'package:partner/services/reminder_service.dart';
import 'package:partner/services/user_service.dart';
import 'package:partner/services/vaccination_service.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

import 'test_helpers.mocks.dart';

@GenerateMocks(
  [],
  customMocks: [
    MockSpec<NavigationService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<BottomSheetService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<DialogService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<ApiClient>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<AuthService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<PetService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<PetOwnerService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<AppointmentService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    // Phase 3
    MockSpec<MedicalRecordService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<PrescriptionService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<VaccinationService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    // Phase 4
    MockSpec<DocumentService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    // Phase 5
    MockSpec<UserService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<ClinicService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<ReminderService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    // Phase 6
    MockSpec<ConnectivityService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    MockSpec<ImageUploadService>(
      onMissingStub: OnMissingStub.returnDefault,
    ),
    // @stacked-mock-spec
  ],
)
void registerServices() {
  getAndRegisterNavigationService();
  getAndRegisterBottomSheetService<dynamic>();
  getAndRegisterDialogService();
  getAndRegisterApiClient();
  getAndRegisterAuthService();
  getAndRegisterPetService();
  getAndRegisterPetOwnerService();
  getAndRegisterAppointmentService();
  getAndRegisterMedicalRecordService();
  getAndRegisterPrescriptionService();
  getAndRegisterVaccinationService();
  getAndRegisterDocumentService();
  getAndRegisterUserService();
  getAndRegisterClinicService();
  getAndRegisterReminderService();
  getAndRegisterConnectivityService();
  getAndRegisterImageUploadService();
  // @stacked-mock-register
}

MockNavigationService
    getAndRegisterNavigationService() {
  _removeRegistrationIfExists<
      NavigationService>();
  final service = MockNavigationService();
  locator
      .registerSingleton<NavigationService>(
    service,
  );
  return service;
}

MockBottomSheetService
    getAndRegisterBottomSheetService<T>({
  SheetResponse<T>? showCustomSheetResponse,
}) {
  _removeRegistrationIfExists<
      BottomSheetService>();
  final service = MockBottomSheetService();

  when(
    service.showCustomSheet<T, T>(
      enableDrag: anyNamed('enableDrag'),
      enterBottomSheetDuration:
          anyNamed('enterBottomSheetDuration'),
      exitBottomSheetDuration:
          anyNamed('exitBottomSheetDuration'),
      ignoreSafeArea:
          anyNamed('ignoreSafeArea'),
      isScrollControlled:
          anyNamed('isScrollControlled'),
      barrierDismissible:
          anyNamed('barrierDismissible'),
      additionalButtonTitle:
          anyNamed('additionalButtonTitle'),
      variant: anyNamed('variant'),
      title: anyNamed('title'),
      hasImage: anyNamed('hasImage'),
      imageUrl: anyNamed('imageUrl'),
      showIconInMainButton:
          anyNamed('showIconInMainButton'),
      mainButtonTitle:
          anyNamed('mainButtonTitle'),
      showIconInSecondaryButton:
          anyNamed('showIconInSecondaryButton'),
      secondaryButtonTitle:
          anyNamed('secondaryButtonTitle'),
      showIconInAdditionalButton: anyNamed(
        'showIconInAdditionalButton',
      ),
      takesInput: anyNamed('takesInput'),
      barrierColor: anyNamed('barrierColor'),
      barrierLabel: anyNamed('barrierLabel'),
      customData: anyNamed('customData'),
      data: anyNamed('data'),
      description: anyNamed('description'),
    ),
  ).thenAnswer(
    (realInvocation) => Future.value(
      showCustomSheetResponse ??
          SheetResponse<T>(),
    ),
  );

  locator
      .registerSingleton<BottomSheetService>(
    service,
  );
  return service;
}

MockDialogService
    getAndRegisterDialogService() {
  _removeRegistrationIfExists<DialogService>();
  final service = MockDialogService();
  locator.registerSingleton<DialogService>(
    service,
  );
  return service;
}

MockApiClient getAndRegisterApiClient() {
  _removeRegistrationIfExists<ApiClient>();
  final service = MockApiClient();
  locator.registerSingleton<ApiClient>(
    service,
  );
  return service;
}

MockAuthService getAndRegisterAuthService() {
  _removeRegistrationIfExists<AuthService>();
  final service = MockAuthService();
  locator.registerSingleton<AuthService>(
    service,
  );
  return service;
}

MockPetService getAndRegisterPetService() {
  _removeRegistrationIfExists<PetService>();
  final service = MockPetService();
  locator.registerSingleton<PetService>(
    service,
  );
  return service;
}

MockPetOwnerService
    getAndRegisterPetOwnerService() {
  _removeRegistrationIfExists<
      PetOwnerService>();
  final service = MockPetOwnerService();
  locator.registerSingleton<PetOwnerService>(
    service,
  );
  return service;
}

MockAppointmentService
    getAndRegisterAppointmentService() {
  _removeRegistrationIfExists<
      AppointmentService>();
  final service = MockAppointmentService();
  locator
      .registerSingleton<AppointmentService>(
    service,
  );
  return service;
}

MockMedicalRecordService
    getAndRegisterMedicalRecordService() {
  _removeRegistrationIfExists<
      MedicalRecordService>();
  final service = MockMedicalRecordService();
  locator
      .registerSingleton<MedicalRecordService>(
    service,
  );
  return service;
}

MockPrescriptionService
    getAndRegisterPrescriptionService() {
  _removeRegistrationIfExists<
      PrescriptionService>();
  final service = MockPrescriptionService();
  locator
      .registerSingleton<PrescriptionService>(
    service,
  );
  return service;
}

MockVaccinationService
    getAndRegisterVaccinationService() {
  _removeRegistrationIfExists<
      VaccinationService>();
  final service = MockVaccinationService();
  locator
      .registerSingleton<VaccinationService>(
    service,
  );
  return service;
}

MockDocumentService
    getAndRegisterDocumentService() {
  _removeRegistrationIfExists<
      DocumentService>();
  final service = MockDocumentService();
  locator.registerSingleton<DocumentService>(
    service,
  );
  return service;
}

MockUserService getAndRegisterUserService() {
  _removeRegistrationIfExists<UserService>();
  final service = MockUserService();
  locator.registerSingleton<UserService>(
    service,
  );
  return service;
}

MockClinicService
    getAndRegisterClinicService() {
  _removeRegistrationIfExists<ClinicService>();
  final service = MockClinicService();
  locator.registerSingleton<ClinicService>(
    service,
  );
  return service;
}

MockReminderService
    getAndRegisterReminderService() {
  _removeRegistrationIfExists<
      ReminderService>();
  final service = MockReminderService();
  locator.registerSingleton<ReminderService>(
    service,
  );
  return service;
}

MockConnectivityService
    getAndRegisterConnectivityService() {
  _removeRegistrationIfExists<
      ConnectivityService>();
  final service = MockConnectivityService();
  locator
      .registerSingleton<ConnectivityService>(
    service,
  );
  return service;
}

MockImageUploadService
    getAndRegisterImageUploadService() {
  _removeRegistrationIfExists<
      ImageUploadService>();
  final service = MockImageUploadService();
  locator
      .registerSingleton<ImageUploadService>(
    service,
  );
  return service;
}

// @stacked-mock-create

void _removeRegistrationIfExists<
    T extends Object>() {
  if (locator.isRegistered<T>()) {
    locator.unregister<T>();
  }
}

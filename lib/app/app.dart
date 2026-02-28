import 'package:partner/services/api_client.dart';
import 'package:partner/services/appointment_service.dart';
import 'package:partner/services/auth_service.dart';
import 'package:partner/services/clinic_service.dart';
import 'package:partner/services/document_service.dart';
import 'package:partner/services/layout_service.dart';
import 'package:partner/services/medical_record_service.dart';
import 'package:partner/services/pet_owner_service.dart';
import 'package:partner/services/pet_service.dart';
import 'package:partner/services/prescription_service.dart';
import 'package:partner/services/reminder_service.dart';
import 'package:partner/services/secure_storage_service.dart';
import 'package:partner/services/shared_preferences_service.dart';
import 'package:partner/services/user_service.dart';
import 'package:partner/services/vaccination_service.dart';
import 'package:partner/ui/bottom_sheets/medical_record/medical_record_sheet.dart';
import 'package:partner/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:partner/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:partner/ui/views/appointment_detail/appointment_detail_view.dart';
import 'package:partner/ui/views/appointment_form/appointment_form_view.dart';
import 'package:partner/ui/views/booking_success/booking_success_view.dart';
import 'package:partner/ui/views/clinic_branding/clinic_branding_view.dart';
import 'package:partner/ui/views/clinic_settings/clinic_settings_view.dart';
import 'package:partner/ui/views/doctor_profile/doctor_profile_view.dart';
import 'package:partner/ui/views/document_list/document_list_view.dart';
import 'package:partner/ui/views/document_upload/document_upload_view.dart';
import 'package:partner/ui/views/home/home_view.dart';
import 'package:partner/ui/views/login/login_view.dart';
import 'package:partner/ui/views/main/main_view.dart';
import 'package:partner/ui/views/medical_record_form/medical_record_form_view.dart';
import 'package:partner/ui/views/patient_profile/patient_profile_view.dart';
import 'package:partner/ui/views/patient_registry/patient_registry_view.dart';
import 'package:partner/ui/views/pending_appointments/pending_appointments_view.dart';
import 'package:partner/ui/views/pet_form/pet_form_view.dart';
import 'package:partner/ui/views/pet_owner_detail/pet_owner_detail_view.dart';
import 'package:partner/ui/views/pet_owner_form/pet_owner_form_view.dart';
import 'package:partner/ui/views/pet_owner_list/pet_owner_list_view.dart';
import 'package:partner/ui/views/prescription_form/prescription_form_view.dart';
import 'package:partner/ui/views/prescription_list/prescription_list_view.dart';
import 'package:partner/ui/views/register/register_view.dart';
import 'package:partner/ui/views/reminder_form/reminder_form_view.dart';
import 'package:partner/ui/views/reminder_list/reminder_list_view.dart';
import 'package:partner/ui/views/reports/reports_view.dart';
import 'package:partner/ui/views/schedule/schedule_view.dart';
import 'package:partner/ui/views/staff_form/staff_form_view.dart';
import 'package:partner/ui/views/staff_list/staff_list_view.dart';
import 'package:partner/ui/views/startup/startup_view.dart';
import 'package:partner/ui/views/vaccination_form/vaccination_form_view.dart';
import 'package:partner/ui/views/vaccination_list/vaccination_list_view.dart';
import 'package:partner/ui/views/verify_otp/verify_otp_view.dart';
import 'package:stacked/stacked_annotations.dart';
import 'package:stacked_services/stacked_services.dart';
// @stacked-import

@StackedApp(
  routes: [
    MaterialRoute(page: HomeView),
    MaterialRoute(page: StartupView),
    MaterialRoute(page: RegisterView),
    MaterialRoute(page: VerifyOtpView),
    MaterialRoute(page: LoginView),
    MaterialRoute(page: ScheduleView),
    MaterialRoute(page: AppointmentDetailView),
    MaterialRoute(page: PatientRegistryView),
    MaterialRoute(page: PatientProfileView),
    MaterialRoute(page: DoctorProfileView),
    MaterialRoute(page: MainView),
    MaterialRoute(page: PetFormView),
    MaterialRoute(page: AppointmentFormView),
    MaterialRoute(page: BookingSuccessView),
    MaterialRoute(page: PendingAppointmentsView),
    // Phase 3: Veterinarian
    MaterialRoute(page: MedicalRecordFormView),
    MaterialRoute(page: PrescriptionListView),
    MaterialRoute(page: PrescriptionFormView),
    MaterialRoute(page: VaccinationListView),
    MaterialRoute(page: VaccinationFormView),
    // Phase 4: Staff
    MaterialRoute(page: PetOwnerListView),
    MaterialRoute(page: PetOwnerDetailView),
    MaterialRoute(page: PetOwnerFormView),
    MaterialRoute(page: DocumentListView),
    MaterialRoute(page: DocumentUploadView),
    // Phase 5: Clinic Admin
    MaterialRoute(page: StaffListView),
    MaterialRoute(page: StaffFormView),
    MaterialRoute(page: ClinicSettingsView),
    MaterialRoute(page: ClinicBrandingView),
    MaterialRoute(page: ReminderListView),
    MaterialRoute(page: ReminderFormView),
    MaterialRoute(page: ReportsView),
// @stacked-route
  ],
  dependencies: [
    LazySingleton<BottomSheetService>(
      classType: BottomSheetService,
    ),
    LazySingleton<DialogService>(
      classType: DialogService,
    ),
    LazySingleton<NavigationService>(
      classType: NavigationService,
    ),
    LazySingleton<SecureStorageService>(
      classType: SecureStorageService,
    ),
    LazySingleton<SharedPreferencesService>(
      classType: SharedPreferencesService,
    ),
    LazySingleton<ApiClient>(
      classType: ApiClient,
    ),
    LazySingleton<AuthService>(
      classType: AuthService,
    ),
    LazySingleton<LayoutService>(
      classType: LayoutService,
    ),
    LazySingleton<PetService>(
      classType: PetService,
    ),
    LazySingleton<PetOwnerService>(
      classType: PetOwnerService,
    ),
    LazySingleton<AppointmentService>(
      classType: AppointmentService,
    ),
    // Phase 3: Veterinarian
    LazySingleton<MedicalRecordService>(
      classType: MedicalRecordService,
    ),
    LazySingleton<PrescriptionService>(
      classType: PrescriptionService,
    ),
    LazySingleton<VaccinationService>(
      classType: VaccinationService,
    ),
    // Phase 4: Staff
    LazySingleton<DocumentService>(
      classType: DocumentService,
    ),
    // Phase 5: Clinic Admin
    LazySingleton<UserService>(
      classType: UserService,
    ),
    LazySingleton<ClinicService>(
      classType: ClinicService,
    ),
    LazySingleton<ReminderService>(
      classType: ReminderService,
    ),
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    StackedBottomsheet(
      classType: MedicalRecordSheet,
    ),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}

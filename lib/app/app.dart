import 'package:partner/services/api_client.dart';
import 'package:partner/services/appointment_service.dart';
import 'package:partner/services/auth_service.dart';
import 'package:partner/services/layout_service.dart';
import 'package:partner/services/pet_owner_service.dart';
import 'package:partner/services/pet_service.dart';
import 'package:partner/services/secure_storage_service.dart';
import 'package:partner/services/shared_preferences_service.dart';
import 'package:partner/ui/bottom_sheets/medical_record/medical_record_sheet.dart';
import 'package:partner/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:partner/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:partner/ui/views/appointment_detail/appointment_detail_view.dart';
import 'package:partner/ui/views/appointment_form/appointment_form_view.dart';
import 'package:partner/ui/views/booking_success/booking_success_view.dart';
import 'package:partner/ui/views/doctor_profile/doctor_profile_view.dart';
import 'package:partner/ui/views/home/home_view.dart';
import 'package:partner/ui/views/login/login_view.dart';
import 'package:partner/ui/views/main/main_view.dart';
import 'package:partner/ui/views/patient_profile/patient_profile_view.dart';
import 'package:partner/ui/views/patient_registry/patient_registry_view.dart';
import 'package:partner/ui/views/pending_appointments/pending_appointments_view.dart';
import 'package:partner/ui/views/pet_form/pet_form_view.dart';
import 'package:partner/ui/views/register/register_view.dart';
import 'package:partner/ui/views/schedule/schedule_view.dart';
import 'package:partner/ui/views/startup/startup_view.dart';
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
    // @stacked-service
  ],
  bottomsheets: [
    StackedBottomsheet(classType: NoticeSheet),
    StackedBottomsheet(classType: MedicalRecordSheet),
    // @stacked-bottom-sheet
  ],
  dialogs: [
    StackedDialog(classType: InfoAlertDialog),
    // @stacked-dialog
  ],
)
class App {}

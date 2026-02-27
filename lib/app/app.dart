import 'package:partner/ui/bottom_sheets/medical_record/medical_record_sheet.dart';
import 'package:partner/ui/bottom_sheets/notice/notice_sheet.dart';
import 'package:partner/ui/dialogs/info_alert/info_alert_dialog.dart';
import 'package:partner/ui/views/appointment_detail/appointment_detail_view.dart';
import 'package:partner/ui/views/doctor_profile/doctor_profile_view.dart';
import 'package:partner/ui/views/home/home_view.dart';
import 'package:partner/ui/views/login/login_view.dart';
import 'package:partner/ui/views/patient_profile/patient_profile_view.dart';
import 'package:partner/ui/views/patient_registry/patient_registry_view.dart';
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

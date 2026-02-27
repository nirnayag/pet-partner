// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart';
import 'package:flutter/material.dart' as _i34;
import 'package:partner/core/models/appointment/appointment.dart' as _i36;
import 'package:partner/core/models/auth/user.dart' as _i41;
import 'package:partner/core/models/medical/medical_record.dart' as _i37;
import 'package:partner/core/models/medical/prescription.dart' as _i38;
import 'package:partner/core/models/medical/vaccination.dart' as _i39;
import 'package:partner/core/models/pet/pet.dart' as _i35;
import 'package:partner/core/models/pet_owner.dart' as _i40;
import 'package:partner/core/models/reminder/reminder.dart' as _i42;
import 'package:partner/ui/views/appointment_detail/appointment_detail_view.dart'
    as _i8;
import 'package:partner/ui/views/appointment_form/appointment_form_view.dart'
    as _i14;
import 'package:partner/ui/views/booking_success/booking_success_view.dart'
    as _i15;
import 'package:partner/ui/views/clinic_branding/clinic_branding_view.dart'
    as _i30;
import 'package:partner/ui/views/clinic_settings/clinic_settings_view.dart'
    as _i29;
import 'package:partner/ui/views/doctor_profile/doctor_profile_view.dart'
    as _i11;
import 'package:partner/ui/views/document_list/document_list_view.dart' as _i25;
import 'package:partner/ui/views/document_upload/document_upload_view.dart'
    as _i26;
import 'package:partner/ui/views/home/home_view.dart' as _i2;
import 'package:partner/ui/views/login/login_view.dart' as _i6;
import 'package:partner/ui/views/main/main_view.dart' as _i12;
import 'package:partner/ui/views/medical_record_form/medical_record_form_view.dart'
    as _i17;
import 'package:partner/ui/views/patient_profile/patient_profile_view.dart'
    as _i10;
import 'package:partner/ui/views/patient_registry/patient_registry_view.dart'
    as _i9;
import 'package:partner/ui/views/pending_appointments/pending_appointments_view.dart'
    as _i16;
import 'package:partner/ui/views/pet_form/pet_form_view.dart' as _i13;
import 'package:partner/ui/views/pet_owner_detail/pet_owner_detail_view.dart'
    as _i23;
import 'package:partner/ui/views/pet_owner_form/pet_owner_form_view.dart'
    as _i24;
import 'package:partner/ui/views/pet_owner_list/pet_owner_list_view.dart'
    as _i22;
import 'package:partner/ui/views/prescription_form/prescription_form_view.dart'
    as _i19;
import 'package:partner/ui/views/prescription_list/prescription_list_view.dart'
    as _i18;
import 'package:partner/ui/views/register/register_view.dart' as _i4;
import 'package:partner/ui/views/reminder_form/reminder_form_view.dart' as _i32;
import 'package:partner/ui/views/reminder_list/reminder_list_view.dart' as _i31;
import 'package:partner/ui/views/reports/reports_view.dart' as _i33;
import 'package:partner/ui/views/schedule/schedule_view.dart' as _i7;
import 'package:partner/ui/views/staff_form/staff_form_view.dart' as _i28;
import 'package:partner/ui/views/staff_list/staff_list_view.dart' as _i27;
import 'package:partner/ui/views/startup/startup_view.dart' as _i3;
import 'package:partner/ui/views/vaccination_form/vaccination_form_view.dart'
    as _i21;
import 'package:partner/ui/views/vaccination_list/vaccination_list_view.dart'
    as _i20;
import 'package:partner/ui/views/verify_otp/verify_otp_view.dart' as _i5;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i43;

class Routes {
  static const homeView = '/home-view';

  static const startupView = '/startup-view';

  static const registerView = '/register-view';

  static const verifyOtpView = '/verify-otp-view';

  static const loginView = '/login-view';

  static const scheduleView = '/schedule-view';

  static const appointmentDetailView = '/appointment-detail-view';

  static const patientRegistryView = '/patient-registry-view';

  static const patientProfileView = '/patient-profile-view';

  static const doctorProfileView = '/doctor-profile-view';

  static const mainView = '/main-view';

  static const petFormView = '/pet-form-view';

  static const appointmentFormView = '/appointment-form-view';

  static const bookingSuccessView = '/booking-success-view';

  static const pendingAppointmentsView = '/pending-appointments-view';

  static const medicalRecordFormView = '/medical-record-form-view';

  static const prescriptionListView = '/prescription-list-view';

  static const prescriptionFormView = '/prescription-form-view';

  static const vaccinationListView = '/vaccination-list-view';

  static const vaccinationFormView = '/vaccination-form-view';

  static const petOwnerListView = '/pet-owner-list-view';

  static const petOwnerDetailView = '/pet-owner-detail-view';

  static const petOwnerFormView = '/pet-owner-form-view';

  static const documentListView = '/document-list-view';

  static const documentUploadView = '/document-upload-view';

  static const staffListView = '/staff-list-view';

  static const staffFormView = '/staff-form-view';

  static const clinicSettingsView = '/clinic-settings-view';

  static const clinicBrandingView = '/clinic-branding-view';

  static const reminderListView = '/reminder-list-view';

  static const reminderFormView = '/reminder-form-view';

  static const reportsView = '/reports-view';

  static const all = <String>{
    homeView,
    startupView,
    registerView,
    verifyOtpView,
    loginView,
    scheduleView,
    appointmentDetailView,
    patientRegistryView,
    patientProfileView,
    doctorProfileView,
    mainView,
    petFormView,
    appointmentFormView,
    bookingSuccessView,
    pendingAppointmentsView,
    medicalRecordFormView,
    prescriptionListView,
    prescriptionFormView,
    vaccinationListView,
    vaccinationFormView,
    petOwnerListView,
    petOwnerDetailView,
    petOwnerFormView,
    documentListView,
    documentUploadView,
    staffListView,
    staffFormView,
    clinicSettingsView,
    clinicBrandingView,
    reminderListView,
    reminderFormView,
    reportsView,
  };
}

class StackedRouter extends _i1.RouterBase {
  final _routes = <_i1.RouteDef>[
    _i1.RouteDef(Routes.homeView, page: _i2.HomeView),
    _i1.RouteDef(Routes.startupView, page: _i3.StartupView),
    _i1.RouteDef(Routes.registerView, page: _i4.RegisterView),
    _i1.RouteDef(Routes.verifyOtpView, page: _i5.VerifyOtpView),
    _i1.RouteDef(Routes.loginView, page: _i6.LoginView),
    _i1.RouteDef(Routes.scheduleView, page: _i7.ScheduleView),
    _i1.RouteDef(Routes.appointmentDetailView, page: _i8.AppointmentDetailView),
    _i1.RouteDef(Routes.patientRegistryView, page: _i9.PatientRegistryView),
    _i1.RouteDef(Routes.patientProfileView, page: _i10.PatientProfileView),
    _i1.RouteDef(Routes.doctorProfileView, page: _i11.DoctorProfileView),
    _i1.RouteDef(Routes.mainView, page: _i12.MainView),
    _i1.RouteDef(Routes.petFormView, page: _i13.PetFormView),
    _i1.RouteDef(Routes.appointmentFormView, page: _i14.AppointmentFormView),
    _i1.RouteDef(Routes.bookingSuccessView, page: _i15.BookingSuccessView),
    _i1.RouteDef(
      Routes.pendingAppointmentsView,
      page: _i16.PendingAppointmentsView,
    ),
    _i1.RouteDef(
      Routes.medicalRecordFormView,
      page: _i17.MedicalRecordFormView,
    ),
    _i1.RouteDef(Routes.prescriptionListView, page: _i18.PrescriptionListView),
    _i1.RouteDef(Routes.prescriptionFormView, page: _i19.PrescriptionFormView),
    _i1.RouteDef(Routes.vaccinationListView, page: _i20.VaccinationListView),
    _i1.RouteDef(Routes.vaccinationFormView, page: _i21.VaccinationFormView),
    _i1.RouteDef(Routes.petOwnerListView, page: _i22.PetOwnerListView),
    _i1.RouteDef(Routes.petOwnerDetailView, page: _i23.PetOwnerDetailView),
    _i1.RouteDef(Routes.petOwnerFormView, page: _i24.PetOwnerFormView),
    _i1.RouteDef(Routes.documentListView, page: _i25.DocumentListView),
    _i1.RouteDef(Routes.documentUploadView, page: _i26.DocumentUploadView),
    _i1.RouteDef(Routes.staffListView, page: _i27.StaffListView),
    _i1.RouteDef(Routes.staffFormView, page: _i28.StaffFormView),
    _i1.RouteDef(Routes.clinicSettingsView, page: _i29.ClinicSettingsView),
    _i1.RouteDef(Routes.clinicBrandingView, page: _i30.ClinicBrandingView),
    _i1.RouteDef(Routes.reminderListView, page: _i31.ReminderListView),
    _i1.RouteDef(Routes.reminderFormView, page: _i32.ReminderFormView),
    _i1.RouteDef(Routes.reportsView, page: _i33.ReportsView),
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      final args = data.getArgs<HomeViewArguments>(
        orElse: () => const HomeViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.HomeView(key: args.key),
        settings: data,
      );
    },
    _i3.StartupView: (data) {
      final args = data.getArgs<StartupViewArguments>(
        orElse: () => const StartupViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.StartupView(key: args.key),
        settings: data,
      );
    },
    _i4.RegisterView: (data) {
      final args = data.getArgs<RegisterViewArguments>(
        orElse: () => const RegisterViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.RegisterView(key: args.key),
        settings: data,
      );
    },
    _i5.VerifyOtpView: (data) {
      final args = data.getArgs<VerifyOtpViewArguments>(
        orElse: () => const VerifyOtpViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.VerifyOtpView(key: args.key),
        settings: data,
      );
    },
    _i6.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.LoginView(key: args.key),
        settings: data,
      );
    },
    _i7.ScheduleView: (data) {
      final args = data.getArgs<ScheduleViewArguments>(
        orElse: () => const ScheduleViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.ScheduleView(key: args.key),
        settings: data,
      );
    },
    _i8.AppointmentDetailView: (data) {
      final args = data.getArgs<AppointmentDetailViewArguments>(nullOk: false);
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i8.AppointmentDetailView(
          appointmentId: args.appointmentId,
          key: args.key,
        ),
        settings: data,
      );
    },
    _i9.PatientRegistryView: (data) {
      final args = data.getArgs<PatientRegistryViewArguments>(
        orElse: () => const PatientRegistryViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i9.PatientRegistryView(key: args.key),
        settings: data,
      );
    },
    _i10.PatientProfileView: (data) {
      final args = data.getArgs<PatientProfileViewArguments>(nullOk: false);
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i10.PatientProfileView(petId: args.petId, key: args.key),
        settings: data,
      );
    },
    _i11.DoctorProfileView: (data) {
      final args = data.getArgs<DoctorProfileViewArguments>(
        orElse: () => const DoctorProfileViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i11.DoctorProfileView(key: args.key),
        settings: data,
      );
    },
    _i12.MainView: (data) {
      final args = data.getArgs<MainViewArguments>(
        orElse: () => const MainViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.MainView(key: args.key),
        settings: data,
      );
    },
    _i13.PetFormView: (data) {
      final args = data.getArgs<PetFormViewArguments>(
        orElse: () => const PetFormViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i13.PetFormView(
          pet: args.pet,
          ownerId: args.ownerId,
          key: args.key,
        ),
        settings: data,
      );
    },
    _i14.AppointmentFormView: (data) {
      final args = data.getArgs<AppointmentFormViewArguments>(
        orElse: () => const AppointmentFormViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i14.AppointmentFormView(
          appointment: args.appointment,
          key: args.key,
        ),
        settings: data,
      );
    },
    _i15.BookingSuccessView: (data) {
      final args = data.getArgs<BookingSuccessViewArguments>(nullOk: false);
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i15.BookingSuccessView(
          appointment: args.appointment,
          key: args.key,
        ),
        settings: data,
      );
    },
    _i16.PendingAppointmentsView: (data) {
      final args = data.getArgs<PendingAppointmentsViewArguments>(
        orElse: () => const PendingAppointmentsViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i16.PendingAppointmentsView(key: args.key),
        settings: data,
      );
    },
    _i17.MedicalRecordFormView: (data) {
      final args = data.getArgs<MedicalRecordFormViewArguments>(
        orElse: () => const MedicalRecordFormViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i17.MedicalRecordFormView(
          record: args.record,
          petId: args.petId,
          appointmentId: args.appointmentId,
          key: args.key,
        ),
        settings: data,
      );
    },
    _i18.PrescriptionListView: (data) {
      final args = data.getArgs<PrescriptionListViewArguments>(
        orElse: () => const PrescriptionListViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i18.PrescriptionListView(petId: args.petId, key: args.key),
        settings: data,
      );
    },
    _i19.PrescriptionFormView: (data) {
      final args = data.getArgs<PrescriptionFormViewArguments>(
        orElse: () => const PrescriptionFormViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i19.PrescriptionFormView(
          prescription: args.prescription,
          petId: args.petId,
          medicalRecordId: args.medicalRecordId,
          key: args.key,
        ),
        settings: data,
      );
    },
    _i20.VaccinationListView: (data) {
      final args = data.getArgs<VaccinationListViewArguments>(
        orElse: () => const VaccinationListViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i20.VaccinationListView(petId: args.petId, key: args.key),
        settings: data,
      );
    },
    _i21.VaccinationFormView: (data) {
      final args = data.getArgs<VaccinationFormViewArguments>(
        orElse: () => const VaccinationFormViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i21.VaccinationFormView(
          vaccination: args.vaccination,
          petId: args.petId,
          key: args.key,
        ),
        settings: data,
      );
    },
    _i22.PetOwnerListView: (data) {
      final args = data.getArgs<PetOwnerListViewArguments>(
        orElse: () => const PetOwnerListViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i22.PetOwnerListView(key: args.key),
        settings: data,
      );
    },
    _i23.PetOwnerDetailView: (data) {
      final args = data.getArgs<PetOwnerDetailViewArguments>(nullOk: false);
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i23.PetOwnerDetailView(ownerId: args.ownerId, key: args.key),
        settings: data,
      );
    },
    _i24.PetOwnerFormView: (data) {
      final args = data.getArgs<PetOwnerFormViewArguments>(
        orElse: () => const PetOwnerFormViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i24.PetOwnerFormView(owner: args.owner, key: args.key),
        settings: data,
      );
    },
    _i25.DocumentListView: (data) {
      final args = data.getArgs<DocumentListViewArguments>(
        orElse: () => const DocumentListViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i25.DocumentListView(
          petId: args.petId,
          medicalRecordId: args.medicalRecordId,
          key: args.key,
        ),
        settings: data,
      );
    },
    _i26.DocumentUploadView: (data) {
      final args = data.getArgs<DocumentUploadViewArguments>(
        orElse: () => const DocumentUploadViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i26.DocumentUploadView(
          petId: args.petId,
          medicalRecordId: args.medicalRecordId,
          key: args.key,
        ),
        settings: data,
      );
    },
    _i27.StaffListView: (data) {
      final args = data.getArgs<StaffListViewArguments>(
        orElse: () => const StaffListViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i27.StaffListView(key: args.key),
        settings: data,
      );
    },
    _i28.StaffFormView: (data) {
      final args = data.getArgs<StaffFormViewArguments>(
        orElse: () => const StaffFormViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i28.StaffFormView(user: args.user, key: args.key),
        settings: data,
      );
    },
    _i29.ClinicSettingsView: (data) {
      final args = data.getArgs<ClinicSettingsViewArguments>(
        orElse: () => const ClinicSettingsViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i29.ClinicSettingsView(key: args.key),
        settings: data,
      );
    },
    _i30.ClinicBrandingView: (data) {
      final args = data.getArgs<ClinicBrandingViewArguments>(
        orElse: () => const ClinicBrandingViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i30.ClinicBrandingView(key: args.key),
        settings: data,
      );
    },
    _i31.ReminderListView: (data) {
      final args = data.getArgs<ReminderListViewArguments>(
        orElse: () => const ReminderListViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i31.ReminderListView(key: args.key),
        settings: data,
      );
    },
    _i32.ReminderFormView: (data) {
      final args = data.getArgs<ReminderFormViewArguments>(
        orElse: () => const ReminderFormViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i32.ReminderFormView(
          reminder: args.reminder,
          petId: args.petId,
          ownerId: args.ownerId,
          key: args.key,
        ),
        settings: data,
      );
    },
    _i33.ReportsView: (data) {
      final args = data.getArgs<ReportsViewArguments>(
        orElse: () => const ReportsViewArguments(),
      );
      return _i34.MaterialPageRoute<dynamic>(
        builder: (context) => _i33.ReportsView(key: args.key),
        settings: data,
      );
    },
  };

  @override
  List<_i1.RouteDef> get routes => _routes;

  @override
  Map<Type, _i1.StackedRouteFactory> get pagesMap => _pagesMap;
}

class HomeViewArguments {
  const HomeViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant HomeViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class StartupViewArguments {
  const StartupViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant StartupViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class RegisterViewArguments {
  const RegisterViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant RegisterViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class VerifyOtpViewArguments {
  const VerifyOtpViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant VerifyOtpViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class LoginViewArguments {
  const LoginViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant LoginViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ScheduleViewArguments {
  const ScheduleViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ScheduleViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class AppointmentDetailViewArguments {
  const AppointmentDetailViewArguments({required this.appointmentId, this.key});

  final String appointmentId;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"appointmentId": "$appointmentId", "key": "$key"}';
  }

  @override
  bool operator ==(covariant AppointmentDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.appointmentId == appointmentId && other.key == key;
  }

  @override
  int get hashCode {
    return appointmentId.hashCode ^ key.hashCode;
  }
}

class PatientRegistryViewArguments {
  const PatientRegistryViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant PatientRegistryViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class PatientProfileViewArguments {
  const PatientProfileViewArguments({required this.petId, this.key});

  final String petId;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"petId": "$petId", "key": "$key"}';
  }

  @override
  bool operator ==(covariant PatientProfileViewArguments other) {
    if (identical(this, other)) return true;
    return other.petId == petId && other.key == key;
  }

  @override
  int get hashCode {
    return petId.hashCode ^ key.hashCode;
  }
}

class DoctorProfileViewArguments {
  const DoctorProfileViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant DoctorProfileViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class MainViewArguments {
  const MainViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant MainViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class PetFormViewArguments {
  const PetFormViewArguments({this.pet, this.ownerId, this.key});

  final _i35.Pet? pet;

  final String? ownerId;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"pet": "$pet", "ownerId": "$ownerId", "key": "$key"}';
  }

  @override
  bool operator ==(covariant PetFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.pet == pet && other.ownerId == ownerId && other.key == key;
  }

  @override
  int get hashCode {
    return pet.hashCode ^ ownerId.hashCode ^ key.hashCode;
  }
}

class AppointmentFormViewArguments {
  const AppointmentFormViewArguments({this.appointment, this.key});

  final _i36.Appointment? appointment;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"appointment": "$appointment", "key": "$key"}';
  }

  @override
  bool operator ==(covariant AppointmentFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.appointment == appointment && other.key == key;
  }

  @override
  int get hashCode {
    return appointment.hashCode ^ key.hashCode;
  }
}

class BookingSuccessViewArguments {
  const BookingSuccessViewArguments({required this.appointment, this.key});

  final _i36.Appointment appointment;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"appointment": "$appointment", "key": "$key"}';
  }

  @override
  bool operator ==(covariant BookingSuccessViewArguments other) {
    if (identical(this, other)) return true;
    return other.appointment == appointment && other.key == key;
  }

  @override
  int get hashCode {
    return appointment.hashCode ^ key.hashCode;
  }
}

class PendingAppointmentsViewArguments {
  const PendingAppointmentsViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant PendingAppointmentsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class MedicalRecordFormViewArguments {
  const MedicalRecordFormViewArguments({
    this.record,
    this.petId,
    this.appointmentId,
    this.key,
  });

  final _i37.MedicalRecord? record;

  final String? petId;

  final String? appointmentId;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"record": "$record", "petId": "$petId", "appointmentId": "$appointmentId", "key": "$key"}';
  }

  @override
  bool operator ==(covariant MedicalRecordFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.record == record &&
        other.petId == petId &&
        other.appointmentId == appointmentId &&
        other.key == key;
  }

  @override
  int get hashCode {
    return record.hashCode ^
        petId.hashCode ^
        appointmentId.hashCode ^
        key.hashCode;
  }
}

class PrescriptionListViewArguments {
  const PrescriptionListViewArguments({this.petId, this.key});

  final String? petId;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"petId": "$petId", "key": "$key"}';
  }

  @override
  bool operator ==(covariant PrescriptionListViewArguments other) {
    if (identical(this, other)) return true;
    return other.petId == petId && other.key == key;
  }

  @override
  int get hashCode {
    return petId.hashCode ^ key.hashCode;
  }
}

class PrescriptionFormViewArguments {
  const PrescriptionFormViewArguments({
    this.prescription,
    this.petId,
    this.medicalRecordId,
    this.key,
  });

  final _i38.Prescription? prescription;

  final String? petId;

  final String? medicalRecordId;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"prescription": "$prescription", "petId": "$petId", "medicalRecordId": "$medicalRecordId", "key": "$key"}';
  }

  @override
  bool operator ==(covariant PrescriptionFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.prescription == prescription &&
        other.petId == petId &&
        other.medicalRecordId == medicalRecordId &&
        other.key == key;
  }

  @override
  int get hashCode {
    return prescription.hashCode ^
        petId.hashCode ^
        medicalRecordId.hashCode ^
        key.hashCode;
  }
}

class VaccinationListViewArguments {
  const VaccinationListViewArguments({this.petId, this.key});

  final String? petId;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"petId": "$petId", "key": "$key"}';
  }

  @override
  bool operator ==(covariant VaccinationListViewArguments other) {
    if (identical(this, other)) return true;
    return other.petId == petId && other.key == key;
  }

  @override
  int get hashCode {
    return petId.hashCode ^ key.hashCode;
  }
}

class VaccinationFormViewArguments {
  const VaccinationFormViewArguments({this.vaccination, this.petId, this.key});

  final _i39.Vaccination? vaccination;

  final String? petId;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"vaccination": "$vaccination", "petId": "$petId", "key": "$key"}';
  }

  @override
  bool operator ==(covariant VaccinationFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.vaccination == vaccination &&
        other.petId == petId &&
        other.key == key;
  }

  @override
  int get hashCode {
    return vaccination.hashCode ^ petId.hashCode ^ key.hashCode;
  }
}

class PetOwnerListViewArguments {
  const PetOwnerListViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant PetOwnerListViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class PetOwnerDetailViewArguments {
  const PetOwnerDetailViewArguments({required this.ownerId, this.key});

  final String ownerId;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"ownerId": "$ownerId", "key": "$key"}';
  }

  @override
  bool operator ==(covariant PetOwnerDetailViewArguments other) {
    if (identical(this, other)) return true;
    return other.ownerId == ownerId && other.key == key;
  }

  @override
  int get hashCode {
    return ownerId.hashCode ^ key.hashCode;
  }
}

class PetOwnerFormViewArguments {
  const PetOwnerFormViewArguments({this.owner, this.key});

  final _i40.PetOwner? owner;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"owner": "$owner", "key": "$key"}';
  }

  @override
  bool operator ==(covariant PetOwnerFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.owner == owner && other.key == key;
  }

  @override
  int get hashCode {
    return owner.hashCode ^ key.hashCode;
  }
}

class DocumentListViewArguments {
  const DocumentListViewArguments({this.petId, this.medicalRecordId, this.key});

  final String? petId;

  final String? medicalRecordId;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"petId": "$petId", "medicalRecordId": "$medicalRecordId", "key": "$key"}';
  }

  @override
  bool operator ==(covariant DocumentListViewArguments other) {
    if (identical(this, other)) return true;
    return other.petId == petId &&
        other.medicalRecordId == medicalRecordId &&
        other.key == key;
  }

  @override
  int get hashCode {
    return petId.hashCode ^ medicalRecordId.hashCode ^ key.hashCode;
  }
}

class DocumentUploadViewArguments {
  const DocumentUploadViewArguments({
    this.petId,
    this.medicalRecordId,
    this.key,
  });

  final String? petId;

  final String? medicalRecordId;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"petId": "$petId", "medicalRecordId": "$medicalRecordId", "key": "$key"}';
  }

  @override
  bool operator ==(covariant DocumentUploadViewArguments other) {
    if (identical(this, other)) return true;
    return other.petId == petId &&
        other.medicalRecordId == medicalRecordId &&
        other.key == key;
  }

  @override
  int get hashCode {
    return petId.hashCode ^ medicalRecordId.hashCode ^ key.hashCode;
  }
}

class StaffListViewArguments {
  const StaffListViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant StaffListViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class StaffFormViewArguments {
  const StaffFormViewArguments({this.user, this.key});

  final _i41.User? user;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"user": "$user", "key": "$key"}';
  }

  @override
  bool operator ==(covariant StaffFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.user == user && other.key == key;
  }

  @override
  int get hashCode {
    return user.hashCode ^ key.hashCode;
  }
}

class ClinicSettingsViewArguments {
  const ClinicSettingsViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ClinicSettingsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ClinicBrandingViewArguments {
  const ClinicBrandingViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ClinicBrandingViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ReminderListViewArguments {
  const ReminderListViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ReminderListViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

class ReminderFormViewArguments {
  const ReminderFormViewArguments({
    this.reminder,
    this.petId,
    this.ownerId,
    this.key,
  });

  final _i42.Reminder? reminder;

  final String? petId;

  final String? ownerId;

  final _i34.Key? key;

  @override
  String toString() {
    return '{"reminder": "$reminder", "petId": "$petId", "ownerId": "$ownerId", "key": "$key"}';
  }

  @override
  bool operator ==(covariant ReminderFormViewArguments other) {
    if (identical(this, other)) return true;
    return other.reminder == reminder &&
        other.petId == petId &&
        other.ownerId == ownerId &&
        other.key == key;
  }

  @override
  int get hashCode {
    return reminder.hashCode ^ petId.hashCode ^ ownerId.hashCode ^ key.hashCode;
  }
}

class ReportsViewArguments {
  const ReportsViewArguments({this.key});

  final _i34.Key? key;

  @override
  String toString() {
    return '{"key": "$key"}';
  }

  @override
  bool operator ==(covariant ReportsViewArguments other) {
    if (identical(this, other)) return true;
    return other.key == key;
  }

  @override
  int get hashCode {
    return key.hashCode;
  }
}

extension NavigatorStateExtension on _i43.NavigationService {
  Future<dynamic> navigateToHomeView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.homeView,
      arguments: HomeViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToStartupView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.startupView,
      arguments: StartupViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToRegisterView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.registerView,
      arguments: RegisterViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToVerifyOtpView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.verifyOtpView,
      arguments: VerifyOtpViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToLoginView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToScheduleView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.scheduleView,
      arguments: ScheduleViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAppointmentDetailView({
    required String appointmentId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.appointmentDetailView,
      arguments: AppointmentDetailViewArguments(
        appointmentId: appointmentId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPatientRegistryView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.patientRegistryView,
      arguments: PatientRegistryViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPatientProfileView({
    required String petId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.patientProfileView,
      arguments: PatientProfileViewArguments(petId: petId, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToDoctorProfileView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.doctorProfileView,
      arguments: DoctorProfileViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToMainView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.mainView,
      arguments: MainViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPetFormView({
    _i35.Pet? pet,
    String? ownerId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.petFormView,
      arguments: PetFormViewArguments(pet: pet, ownerId: ownerId, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToAppointmentFormView({
    _i36.Appointment? appointment,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.appointmentFormView,
      arguments: AppointmentFormViewArguments(
        appointment: appointment,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToBookingSuccessView({
    required _i36.Appointment appointment,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.bookingSuccessView,
      arguments: BookingSuccessViewArguments(
        appointment: appointment,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPendingAppointmentsView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.pendingAppointmentsView,
      arguments: PendingAppointmentsViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToMedicalRecordFormView({
    _i37.MedicalRecord? record,
    String? petId,
    String? appointmentId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.medicalRecordFormView,
      arguments: MedicalRecordFormViewArguments(
        record: record,
        petId: petId,
        appointmentId: appointmentId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPrescriptionListView({
    String? petId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.prescriptionListView,
      arguments: PrescriptionListViewArguments(petId: petId, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPrescriptionFormView({
    _i38.Prescription? prescription,
    String? petId,
    String? medicalRecordId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.prescriptionFormView,
      arguments: PrescriptionFormViewArguments(
        prescription: prescription,
        petId: petId,
        medicalRecordId: medicalRecordId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToVaccinationListView({
    String? petId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.vaccinationListView,
      arguments: VaccinationListViewArguments(petId: petId, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToVaccinationFormView({
    _i39.Vaccination? vaccination,
    String? petId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.vaccinationFormView,
      arguments: VaccinationFormViewArguments(
        vaccination: vaccination,
        petId: petId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPetOwnerListView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.petOwnerListView,
      arguments: PetOwnerListViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPetOwnerDetailView({
    required String ownerId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.petOwnerDetailView,
      arguments: PetOwnerDetailViewArguments(ownerId: ownerId, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToPetOwnerFormView({
    _i40.PetOwner? owner,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.petOwnerFormView,
      arguments: PetOwnerFormViewArguments(owner: owner, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToDocumentListView({
    String? petId,
    String? medicalRecordId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.documentListView,
      arguments: DocumentListViewArguments(
        petId: petId,
        medicalRecordId: medicalRecordId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToDocumentUploadView({
    String? petId,
    String? medicalRecordId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.documentUploadView,
      arguments: DocumentUploadViewArguments(
        petId: petId,
        medicalRecordId: medicalRecordId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToStaffListView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.staffListView,
      arguments: StaffListViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToStaffFormView({
    _i41.User? user,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.staffFormView,
      arguments: StaffFormViewArguments(user: user, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToClinicSettingsView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.clinicSettingsView,
      arguments: ClinicSettingsViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToClinicBrandingView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.clinicBrandingView,
      arguments: ClinicBrandingViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToReminderListView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.reminderListView,
      arguments: ReminderListViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToReminderFormView({
    _i42.Reminder? reminder,
    String? petId,
    String? ownerId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.reminderFormView,
      arguments: ReminderFormViewArguments(
        reminder: reminder,
        petId: petId,
        ownerId: ownerId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> navigateToReportsView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return navigateTo<dynamic>(
      Routes.reportsView,
      arguments: ReportsViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithHomeView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.homeView,
      arguments: HomeViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithStartupView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.startupView,
      arguments: StartupViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithRegisterView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.registerView,
      arguments: RegisterViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithVerifyOtpView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.verifyOtpView,
      arguments: VerifyOtpViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithLoginView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.loginView,
      arguments: LoginViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithScheduleView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.scheduleView,
      arguments: ScheduleViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAppointmentDetailView({
    required String appointmentId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.appointmentDetailView,
      arguments: AppointmentDetailViewArguments(
        appointmentId: appointmentId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithPatientRegistryView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.patientRegistryView,
      arguments: PatientRegistryViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithPatientProfileView({
    required String petId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.patientProfileView,
      arguments: PatientProfileViewArguments(petId: petId, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithDoctorProfileView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.doctorProfileView,
      arguments: DoctorProfileViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithMainView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.mainView,
      arguments: MainViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithPetFormView({
    _i35.Pet? pet,
    String? ownerId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.petFormView,
      arguments: PetFormViewArguments(pet: pet, ownerId: ownerId, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithAppointmentFormView({
    _i36.Appointment? appointment,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.appointmentFormView,
      arguments: AppointmentFormViewArguments(
        appointment: appointment,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithBookingSuccessView({
    required _i36.Appointment appointment,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.bookingSuccessView,
      arguments: BookingSuccessViewArguments(
        appointment: appointment,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithPendingAppointmentsView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.pendingAppointmentsView,
      arguments: PendingAppointmentsViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithMedicalRecordFormView({
    _i37.MedicalRecord? record,
    String? petId,
    String? appointmentId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.medicalRecordFormView,
      arguments: MedicalRecordFormViewArguments(
        record: record,
        petId: petId,
        appointmentId: appointmentId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithPrescriptionListView({
    String? petId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.prescriptionListView,
      arguments: PrescriptionListViewArguments(petId: petId, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithPrescriptionFormView({
    _i38.Prescription? prescription,
    String? petId,
    String? medicalRecordId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.prescriptionFormView,
      arguments: PrescriptionFormViewArguments(
        prescription: prescription,
        petId: petId,
        medicalRecordId: medicalRecordId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithVaccinationListView({
    String? petId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.vaccinationListView,
      arguments: VaccinationListViewArguments(petId: petId, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithVaccinationFormView({
    _i39.Vaccination? vaccination,
    String? petId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.vaccinationFormView,
      arguments: VaccinationFormViewArguments(
        vaccination: vaccination,
        petId: petId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithPetOwnerListView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.petOwnerListView,
      arguments: PetOwnerListViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithPetOwnerDetailView({
    required String ownerId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.petOwnerDetailView,
      arguments: PetOwnerDetailViewArguments(ownerId: ownerId, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithPetOwnerFormView({
    _i40.PetOwner? owner,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.petOwnerFormView,
      arguments: PetOwnerFormViewArguments(owner: owner, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithDocumentListView({
    String? petId,
    String? medicalRecordId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.documentListView,
      arguments: DocumentListViewArguments(
        petId: petId,
        medicalRecordId: medicalRecordId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithDocumentUploadView({
    String? petId,
    String? medicalRecordId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.documentUploadView,
      arguments: DocumentUploadViewArguments(
        petId: petId,
        medicalRecordId: medicalRecordId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithStaffListView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.staffListView,
      arguments: StaffListViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithStaffFormView({
    _i41.User? user,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.staffFormView,
      arguments: StaffFormViewArguments(user: user, key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithClinicSettingsView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.clinicSettingsView,
      arguments: ClinicSettingsViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithClinicBrandingView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.clinicBrandingView,
      arguments: ClinicBrandingViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithReminderListView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.reminderListView,
      arguments: ReminderListViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithReminderFormView({
    _i42.Reminder? reminder,
    String? petId,
    String? ownerId,
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.reminderFormView,
      arguments: ReminderFormViewArguments(
        reminder: reminder,
        petId: petId,
        ownerId: ownerId,
        key: key,
      ),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }

  Future<dynamic> replaceWithReportsView({
    _i34.Key? key,
    int? routerId,
    bool preventDuplicates = true,
    Map<String, String>? parameters,
    Widget Function(BuildContext, Animation<double>, Animation<double>, Widget)?
        transition,
  }) async {
    return replaceWith<dynamic>(
      Routes.reportsView,
      arguments: ReportsViewArguments(key: key),
      id: routerId,
      preventDuplicates: preventDuplicates,
      parameters: parameters,
      transition: transition,
    );
  }
}

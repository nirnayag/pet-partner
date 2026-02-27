// dart format width=80
// GENERATED CODE - DO NOT MODIFY BY HAND

// **************************************************************************
// StackedNavigatorGenerator
// **************************************************************************

// ignore_for_file: no_leading_underscores_for_library_prefixes
import 'package:flutter/material.dart' as _i17;
import 'package:flutter/material.dart';
import 'package:partner/core/models/appointment/appointment.dart' as _i19;
import 'package:partner/core/models/pet/pet.dart' as _i18;
import 'package:partner/ui/views/appointment_detail/appointment_detail_view.dart'
    as _i8;
import 'package:partner/ui/views/appointment_form/appointment_form_view.dart'
    as _i14;
import 'package:partner/ui/views/booking_success/booking_success_view.dart'
    as _i15;
import 'package:partner/ui/views/doctor_profile/doctor_profile_view.dart'
    as _i11;
import 'package:partner/ui/views/home/home_view.dart' as _i2;
import 'package:partner/ui/views/login/login_view.dart' as _i6;
import 'package:partner/ui/views/main/main_view.dart' as _i12;
import 'package:partner/ui/views/patient_profile/patient_profile_view.dart'
    as _i10;
import 'package:partner/ui/views/patient_registry/patient_registry_view.dart'
    as _i9;
import 'package:partner/ui/views/pending_appointments/pending_appointments_view.dart'
    as _i16;
import 'package:partner/ui/views/pet_form/pet_form_view.dart' as _i13;
import 'package:partner/ui/views/register/register_view.dart' as _i4;
import 'package:partner/ui/views/schedule/schedule_view.dart' as _i7;
import 'package:partner/ui/views/startup/startup_view.dart' as _i3;
import 'package:partner/ui/views/verify_otp/verify_otp_view.dart' as _i5;
import 'package:stacked/stacked.dart' as _i1;
import 'package:stacked_services/stacked_services.dart' as _i20;

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
  ];

  final _pagesMap = <Type, _i1.StackedRouteFactory>{
    _i2.HomeView: (data) {
      final args = data.getArgs<HomeViewArguments>(
        orElse: () => const HomeViewArguments(),
      );
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i2.HomeView(key: args.key),
        settings: data,
      );
    },
    _i3.StartupView: (data) {
      final args = data.getArgs<StartupViewArguments>(
        orElse: () => const StartupViewArguments(),
      );
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i3.StartupView(key: args.key),
        settings: data,
      );
    },
    _i4.RegisterView: (data) {
      final args = data.getArgs<RegisterViewArguments>(
        orElse: () => const RegisterViewArguments(),
      );
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i4.RegisterView(key: args.key),
        settings: data,
      );
    },
    _i5.VerifyOtpView: (data) {
      final args = data.getArgs<VerifyOtpViewArguments>(
        orElse: () => const VerifyOtpViewArguments(),
      );
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i5.VerifyOtpView(key: args.key),
        settings: data,
      );
    },
    _i6.LoginView: (data) {
      final args = data.getArgs<LoginViewArguments>(
        orElse: () => const LoginViewArguments(),
      );
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i6.LoginView(key: args.key),
        settings: data,
      );
    },
    _i7.ScheduleView: (data) {
      final args = data.getArgs<ScheduleViewArguments>(
        orElse: () => const ScheduleViewArguments(),
      );
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i7.ScheduleView(key: args.key),
        settings: data,
      );
    },
    _i8.AppointmentDetailView: (data) {
      final args = data.getArgs<AppointmentDetailViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
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
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i9.PatientRegistryView(key: args.key),
        settings: data,
      );
    },
    _i10.PatientProfileView: (data) {
      final args = data.getArgs<PatientProfileViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) =>
            _i10.PatientProfileView(petId: args.petId, key: args.key),
        settings: data,
      );
    },
    _i11.DoctorProfileView: (data) {
      final args = data.getArgs<DoctorProfileViewArguments>(
        orElse: () => const DoctorProfileViewArguments(),
      );
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i11.DoctorProfileView(key: args.key),
        settings: data,
      );
    },
    _i12.MainView: (data) {
      final args = data.getArgs<MainViewArguments>(
        orElse: () => const MainViewArguments(),
      );
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i12.MainView(key: args.key),
        settings: data,
      );
    },
    _i13.PetFormView: (data) {
      final args = data.getArgs<PetFormViewArguments>(
        orElse: () => const PetFormViewArguments(),
      );
      return _i17.MaterialPageRoute<dynamic>(
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
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i14.AppointmentFormView(
          appointment: args.appointment,
          key: args.key,
        ),
        settings: data,
      );
    },
    _i15.BookingSuccessView: (data) {
      final args = data.getArgs<BookingSuccessViewArguments>(nullOk: false);
      return _i17.MaterialPageRoute<dynamic>(
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
      return _i17.MaterialPageRoute<dynamic>(
        builder: (context) => _i16.PendingAppointmentsView(key: args.key),
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

  final _i17.Key? key;

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

  final _i17.Key? key;

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

  final _i17.Key? key;

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

  final _i17.Key? key;

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

  final _i17.Key? key;

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

  final _i17.Key? key;

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

  final _i17.Key? key;

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

  final _i17.Key? key;

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

  final _i17.Key? key;

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

  final _i17.Key? key;

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

  final _i17.Key? key;

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

  final _i18.Pet? pet;

  final String? ownerId;

  final _i17.Key? key;

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

  final _i19.Appointment? appointment;

  final _i17.Key? key;

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

  final _i19.Appointment appointment;

  final _i17.Key? key;

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

  final _i17.Key? key;

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

extension NavigatorStateExtension on _i20.NavigationService {
  Future<dynamic> navigateToHomeView({
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i18.Pet? pet,
    String? ownerId,
    _i17.Key? key,
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
    _i19.Appointment? appointment,
    _i17.Key? key,
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
    required _i19.Appointment appointment,
    _i17.Key? key,
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
    _i17.Key? key,
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

  Future<dynamic> replaceWithHomeView({
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i17.Key? key,
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
    _i18.Pet? pet,
    String? ownerId,
    _i17.Key? key,
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
    _i19.Appointment? appointment,
    _i17.Key? key,
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
    required _i19.Appointment appointment,
    _i17.Key? key,
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
    _i17.Key? key,
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
}

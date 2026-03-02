import 'package:intl/intl.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:partner/core/utils/permission_utils.dart';
import 'package:partner/services/appointment_service.dart';
import 'package:partner/services/auth_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the schedule / calendar screen.
///
/// Loads appointments for a selected date and
/// supports day navigation.
class ScheduleViewModel extends BaseViewModel
    with ErrorHandlingMixin {
  final _appointmentService =
      locator<AppointmentService>();
  final _authService = locator<AuthService>();
  final _navigationService =
      locator<NavigationService>();

  // --------------------------------------------------
  // State
  // --------------------------------------------------

  List<Appointment> _appointments =
      <Appointment>[];

  /// Appointments for the selected date.
  List<Appointment> get appointments =>
      _appointments;

  DateTime _selectedDate = DateTime.now();

  /// The currently selected date.
  DateTime get selectedDate => _selectedDate;

  /// The user's display name for the header.
  String get userName =>
      _authService.cachedUser?.fullName ??
      'Doctor';

  // --------------------------------------------------
  // Permissions
  // --------------------------------------------------

  /// Whether the current user can create
  /// appointments.
  bool get canCreateAppointment {
    final role = _authService.currentRole;
    if (role == null) return false;
    return PermissionUtils.hasPermission(
      role,
      'appointments:create',
    );
  }

  // --------------------------------------------------
  // Lifecycle
  // --------------------------------------------------

  /// Called once when the view is ready.
  Future<void> initialise() async {
    await loadAppointments();
  }

  // --------------------------------------------------
  // Data loading
  // --------------------------------------------------

  /// Fetches appointments for [_selectedDate].
  Future<void> loadAppointments() async {
    setBusy(true);
    await runSafe(() async {
      final dateStr = DateFormat('yyyy-MM-dd')
          .format(_selectedDate);
      final response =
          await _appointmentService.getAppointments(
        date: dateStr,
        limit: 50,
      );
      _appointments = response.items;
    });
    setBusy(false);
  }

  /// Called when the user picks a new date.
  void onDateSelected(DateTime date) {
    _selectedDate = date;
    notifyListeners();
    loadAppointments();
  }

  /// Moves the selected date forward or back by
  /// [days] (positive = forward, negative = back).
  void shiftDate(int days) {
    _selectedDate = _selectedDate.add(
      Duration(days: days),
    );
    notifyListeners();
    loadAppointments();
  }

  /// Pull-to-refresh.
  Future<void> refresh() async {
    await loadAppointments();
  }

  // --------------------------------------------------
  // Navigation
  // --------------------------------------------------

  /// Navigates to the detail screen for
  /// [appointment].
  void onAppointmentTapped(
    Appointment appointment,
  ) {
    _navigationService
        .navigateToAppointmentDetailView(
      appointmentId: appointment.id,
    );
  }

  /// Navigates to the new appointment form.
  void navigateToAddAppointment() {
    _navigationService
        .navigateToAppointmentFormView();
  }

  /// Pops back.
  void goBack() {
    _navigationService.back<dynamic>();
  }
}

import 'package:intl/intl.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:partner/services/appointment_service.dart';
import 'package:partner/services/auth_service.dart';
import 'package:partner/services/layout_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the home / dashboard screen.
///
/// Loads today's appointments and summary stats
/// from the API.
class HomeViewModel extends BaseViewModel
    with ErrorHandlingMixin {
  final _appointmentService =
      locator<AppointmentService>();
  final _authService = locator<AuthService>();
  final _navigationService =
      locator<NavigationService>();
  final _layoutService =
      locator<LayoutService>();

  // --------------------------------------------------
  // State
  // --------------------------------------------------

  List<Appointment> _todayAppointments =
      <Appointment>[];

  /// Today's appointments.
  List<Appointment> get todayAppointments =>
      _todayAppointments;

  int _totalCount = 0;

  /// Total number of appointments today.
  int get totalCount => _totalCount;

  int _pendingCount = 0;

  /// Number of pending appointments today.
  int get pendingCount => _pendingCount;

  int _completedCount = 0;

  /// Number of completed appointments today.
  int get completedCount => _completedCount;

  /// The greeting name from the logged-in user.
  String get userName =>
      _authService.cachedUser?.firstName ??
      'Doctor';

  /// Today's date formatted for display.
  String get todayFormatted =>
      DateFormat('MMM dd, yyyy')
          .format(DateTime.now());

  // --------------------------------------------------
  // Lifecycle
  // --------------------------------------------------

  /// Called once when the view is ready.
  Future<void> initialise() async {
    await loadDashboard();
  }

  // --------------------------------------------------
  // Data loading
  // --------------------------------------------------

  /// Loads today's appointments and computes
  /// summary stats.
  Future<void> loadDashboard() async {
    setBusy(true);
    await runSafe(() async {
      final dateStr = DateFormat('yyyy-MM-dd')
          .format(DateTime.now());
      final response =
          await _appointmentService
              .getAppointments(
        date: dateStr,
        limit: 50,
      );
      _todayAppointments = response.items;
      _totalCount = response.items.length;
      _pendingCount = response.items
          .where(
            (a) =>
                a.status.value == 'pending' ||
                a.status.value == 'scheduled' ||
                a.status.value == 'confirmed' ||
                a.status.value == 'checked_in' ||
                a.status.value == 'in_progress',
          )
          .length;
      _completedCount = response.items
          .where(
            (a) =>
                a.status.value == 'completed',
          )
          .length;
    });
    setBusy(false);
  }

  /// Pull-to-refresh.
  Future<void> refresh() async {
    await loadDashboard();
  }

  // --------------------------------------------------
  // Navigation
  // --------------------------------------------------

  /// Switches to the Schedule tab.
  void navigateToScheduleView() {
    _layoutService.setIndex(2);
  }

  /// Switches to the Patient Registry tab.
  void navigateToPatientRegistryView() {
    _layoutService.setIndex(1);
  }

  /// Navigates to appointment detail by pushing.
  void navigateToAppointmentDetail(
    Appointment appointment,
  ) {
    _navigationService
        .navigateToAppointmentDetailView(
      appointmentId: appointment.id,
    );
  }

  /// Switches to the Doctor Profile tab.
  void navigateToDoctorProfileView() {
    _layoutService.setIndex(3);
  }
}

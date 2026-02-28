import 'package:partner/app/app.bottomsheets.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/enums/appointment_status.dart';
import 'package:partner/core/enums/user_role.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:partner/core/utils/permission_utils.dart';
import 'package:partner/services/appointment_service.dart';
import 'package:partner/services/auth_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the appointment detail screen.
///
/// Fetches the appointment by ID and supports
/// status transitions and approval actions.
class AppointmentDetailViewModel
    extends BaseViewModel
    with ErrorHandlingMixin {
  /// Creates an [AppointmentDetailViewModel].
  ///
  /// Requires [appointmentId] to load the correct
  /// appointment.
  AppointmentDetailViewModel({
    required this.appointmentId,
  });

  /// The appointment ID to fetch.
  final String appointmentId;

  final _appointmentService =
      locator<AppointmentService>();
  final _authService = locator<AuthService>();
  final _navigationService =
      locator<NavigationService>();
  final _bottomSheetService =
      locator<BottomSheetService>();

  // --------------------------------------------------
  // State
  // --------------------------------------------------

  Appointment? _appointment;

  /// The loaded appointment, or `null`.
  Appointment? get appointment => _appointment;

  /// The active role of the current user.
  UserRole? get currentRole =>
      _authService.currentRole;

  /// The current user's full name.
  String get userName =>
      _authService.cachedUser?.fullName ?? '';

  // --------------------------------------------------
  // Permissions
  // --------------------------------------------------

  /// Whether the current user can manage
  /// appointments (approve, change status).
  bool get canManageAppointment {
    final role = _authService.currentRole;
    if (role == null) return false;
    return PermissionUtils.hasPermission(
      role,
      'appointments:manage',
    );
  }

  // Busy keys for action buttons.
  static const String kStatusBusyKey =
      'status_update';
  static const String kApproveBusyKey =
      'approve';

  // --------------------------------------------------
  // Lifecycle
  // --------------------------------------------------

  /// Called once when the view is ready.
  Future<void> initialise() async {
    await _loadAppointment();
  }

  // --------------------------------------------------
  // Data loading
  // --------------------------------------------------

  Future<void> _loadAppointment() async {
    setBusy(true);
    await runSafe(() async {
      _appointment = await _appointmentService
          .getAppointmentById(appointmentId);
    });
    setBusy(false);
  }

  /// Retry after error.
  Future<void> retry() async {
    await _loadAppointment();
  }

  // --------------------------------------------------
  // Actions
  // --------------------------------------------------

  /// Updates the appointment status to [newStatus].
  Future<void> updateStatus(
    AppointmentStatus newStatus,
  ) async {
    setBusyForObject(kStatusBusyKey, true);
    await runSafe(() async {
      _appointment = await _appointmentService
          .updateAppointmentStatus(
        appointmentId,
        newStatus.value,
      );
      notifyListeners();
    });
    setBusyForObject(kStatusBusyKey, false);
  }

  /// Approves a pending appointment.
  Future<void> approveAppointment() async {
    setBusyForObject(kApproveBusyKey, true);
    await runSafe(() async {
      _appointment = await _appointmentService
          .approveAppointment(appointmentId);
      notifyListeners();
    });
    setBusyForObject(kApproveBusyKey, false);
  }

  /// Shows the medical record bottom sheet.
  void showMedicalRecordSheet() {
    _bottomSheetService
        .showCustomSheet<void, void>(
      variant: BottomSheetType.medicalRecord,
    );
  }

  // --------------------------------------------------
  // Navigation
  // --------------------------------------------------

  /// Pops back.
  void goBack() {
    _navigationService.back<void>();
  }

  /// Navigates to the patient profile for the
  /// appointment's pet.
  void navigateToPatientProfile() {
    if (_appointment == null) return;
    _navigationService
        .navigateToPatientProfileView(
      petId: _appointment!.petId,
    );
  }
}

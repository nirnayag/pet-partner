import 'package:partner/app/app.locator.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/appointment_service.dart';
import 'package:partner/services/pet_owner_service.dart';
import 'package:partner/services/pet_service.dart';
import 'package:partner/services/user_service.dart';
import 'package:stacked/stacked.dart';

/// ViewModel for the reports / analytics
/// dashboard.
///
/// Computes overview stats from existing API
/// endpoints (no dedicated analytics endpoint).
class ReportsViewModel extends BaseViewModel {
  final _petService = locator<PetService>();
  final _petOwnerService =
      locator<PetOwnerService>();
  final _userService = locator<UserService>();
  final _appointmentService =
      locator<AppointmentService>();

  // ------------------------------------------------
  // State
  // ------------------------------------------------

  int _activePets = 0;

  /// Number of active pets.
  int get activePets => _activePets;

  int _petOwners = 0;

  /// Number of pet owners.
  int get petOwners => _petOwners;

  int _staffCount = 0;

  /// Number of staff members.
  int get staffCount => _staffCount;

  int _appointments = 0;

  /// Number of appointments.
  int get appointments => _appointments;

  int _pendingAppointments = 0;

  /// Number of pending appointments.
  int get pendingAppointments =>
      _pendingAppointments;

  int _completedAppointments = 0;

  /// Number of completed appointments.
  int get completedAppointments =>
      _completedAppointments;

  String _selectedPeriod = 'Month';

  /// The selected period label.
  String get selectedPeriod => _selectedPeriod;

  String? _errorMessage;

  /// Error message, or `null`.
  String? get errorMessage => _errorMessage;

  /// Available period options.
  static const periodOptions = <String>[
    'Week',
    'Month',
    'Year',
  ];

  // ------------------------------------------------
  // Lifecycle
  // ------------------------------------------------

  /// Loads all overview stats.
  Future<void> initialise() async {
    await loadStats();
  }

  // ------------------------------------------------
  // Data loading
  // ------------------------------------------------

  /// Loads stats from multiple API calls.
  Future<void> loadStats() async {
    setBusy(true);
    _errorMessage = null;
    try {
      final results = await Future.wait([
        _petService.getPets(limit: 1),
        _petOwnerService.getPetOwners(limit: 1),
        _userService.getUsers(limit: 1),
        _appointmentService.getAppointments(
          limit: 1,
        ),
      ]);

      _activePets = results[0].pagination.total;
      _petOwners = results[1].pagination.total;
      _staffCount = results[2].pagination.total;
      _appointments =
          results[3].pagination.total;

      // Load appointment breakdown
      await _loadAppointmentBreakdown();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    }
    setBusy(false);
  }

  Future<void> _loadAppointmentBreakdown() async {
    try {
      final pending = await _appointmentService
          .getAppointments(
        limit: 1,
        status: 'pending',
      );
      _pendingAppointments =
          pending.pagination.total;

      final completed = await _appointmentService
          .getAppointments(
        limit: 1,
        status: 'completed',
      );
      _completedAppointments =
          completed.pagination.total;
    } on ApiException {
      // Non-critical, silently ignore
    }
  }

  /// Changes the selected period and reloads.
  void setPeriod(String period) {
    if (_selectedPeriod == period) return;
    _selectedPeriod = period;
    notifyListeners();
    loadStats();
  }

  /// Pull-to-refresh handler.
  Future<void> refresh() async {
    _errorMessage = null;
    await loadStats();
  }
}

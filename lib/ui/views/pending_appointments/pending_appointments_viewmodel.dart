import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/models/appointment/appointment.dart';
import 'package:partner/services/appointment_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the pending appointments list.
class PendingAppointmentsViewmodel
    extends BaseViewModel {
  final _appointmentService =
      locator<AppointmentService>();
  final _navigationService =
      locator<NavigationService>();
  final _dialogService = locator<DialogService>();

  // ---- State ----

  /// The current list of pending appointments.
  List<Appointment> pendingAppointments =
      <Appointment>[];

  /// The current pagination page.
  int currentPage = 1;

  /// Whether more pages are available.
  bool hasMore = true;

  /// Error message from the last operation.
  String? errorMessage;

  static const _busyLoadMore = 'loadMore';
  static const _pageSize = 20;

  // ---- Lifecycle ----

  /// Loads the first page of pending
  /// appointments.
  Future<void> initialise() async {
    await _loadPage(1);
  }

  // ---- Loading ----

  Future<void> _loadPage(int page) async {
    setBusy(true);
    errorMessage = null;

    try {
      final response = await _appointmentService
          .getPendingAppointments(
        page: page,
      );

      if (page == 1) {
        pendingAppointments = response.items;
      } else {
        pendingAppointments = [
          ...pendingAppointments,
          ...response.items,
        ];
      }

      currentPage = page;
      hasMore =
          response.items.length >= _pageSize;
    } on Exception catch (e) {
      errorMessage = e.toString();
    } finally {
      setBusy(false);
    }
  }

  /// Loads the next page of results and appends
  /// them to the list.
  Future<void> loadMore() async {
    if (!hasMore) return;
    if (busy(_busyLoadMore)) return;

    setBusyForObject(_busyLoadMore, true);
    try {
      final nextPage = currentPage + 1;
      final response = await _appointmentService
          .getPendingAppointments(
        page: nextPage,
      );

      pendingAppointments = [
        ...pendingAppointments,
        ...response.items,
      ];
      currentPage = nextPage;
      hasMore =
          response.items.length >= _pageSize;
    } on Exception catch (e) {
      errorMessage = e.toString();
    } finally {
      setBusyForObject(_busyLoadMore, false);
    }
  }

  /// Whether a load-more operation is in
  /// progress.
  bool get isLoadingMore =>
      busy(_busyLoadMore);

  // ---- Actions ----

  /// Approves a pending appointment and removes
  /// it from the list.
  Future<void> approveAppointment(
    String id,
  ) async {
    setBusyForObject(id, true);
    try {
      await _appointmentService
          .approveAppointment(id);

      pendingAppointments.removeWhere(
        (a) => a.id == id,
      );
      notifyListeners();
    } on Exception catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    } finally {
      setBusyForObject(id, false);
    }
  }

  /// Shows a reason dialog, then rejects (cancels)
  /// the appointment and removes it from the
  /// list.
  Future<void> rejectAppointment(
    String id,
  ) async {
    final response = await _dialogService
        .showConfirmationDialog(
      title: 'Reject Appointment',
      description:
          'Are you sure you want to reject '
          'this appointment request?',
      confirmationTitle: 'Reject',
    );

    if (response?.confirmed != true) return;

    setBusyForObject(id, true);
    try {
      await _appointmentService
          .updateAppointmentStatus(
        id,
        'cancelled',
      );

      pendingAppointments.removeWhere(
        (a) => a.id == id,
      );
      notifyListeners();
    } on Exception catch (e) {
      errorMessage = e.toString();
      notifyListeners();
    } finally {
      setBusyForObject(id, false);
    }
  }

  /// Navigates to the appointment detail view.
  void viewDetails(Appointment apt) {
    _navigationService.navigateTo<void>(
      Routes.appointmentDetailView,
    );
  }

  /// Resets the list and reloads from the first
  /// page.
  Future<void> refresh() async {
    currentPage = 1;
    hasMore = true;
    pendingAppointments = <Appointment>[];
    await _loadPage(1);
  }
}

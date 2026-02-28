import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/models/clinic/send_result.dart';
import 'package:partner/core/models/reminder/reminder.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/reminder_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the reminder list screen.
///
/// Loads reminders with status filtering and
/// pagination.
class ReminderListViewModel
    extends BaseViewModel {
  final _reminderService =
      locator<ReminderService>();
  final _navigationService =
      locator<NavigationService>();

  // ------------------------------------------------
  // State
  // ------------------------------------------------

  List<Reminder> _reminders = <Reminder>[];

  /// The current list of reminders.
  List<Reminder> get reminders => _reminders;

  String _statusFilter = 'All';

  /// The active status filter label.
  String get statusFilter => _statusFilter;

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  /// Whether a load-more request is running.
  bool get isLoadingMore => _isLoadingMore;

  int _totalCount = 0;

  /// Total number of matching reminders.
  int get totalCount => _totalCount;

  String? _errorMessage;

  /// Error message, or `null`.
  String? get errorMessage => _errorMessage;

  SendResult? _lastSendResult;

  /// The result from the last send operation.
  SendResult? get lastSendResult =>
      _lastSendResult;

  bool _isSending = false;

  /// Whether a send operation is running.
  bool get isSending => _isSending;

  // ------------------------------------------------
  // Lifecycle
  // ------------------------------------------------

  /// Called once when the view is ready.
  Future<void> initialise() async {
    await loadReminders();
  }

  // ------------------------------------------------
  // Data loading
  // ------------------------------------------------

  /// Loads the first page of reminders.
  Future<void> loadReminders() async {
    setBusy(true);
    _errorMessage = null;
    try {
      _currentPage = 1;
      final response =
          await _reminderService.getReminders(
        status: _statusParam,
      );
      _reminders = response.items;
      _totalCount = response.pagination.total;
      _hasMore =
          response.pagination.hasNext ?? false;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    }
    setBusy(false);
  }

  /// Loads the next page and appends results.
  Future<void> loadMoreReminders() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final response =
          await _reminderService.getReminders(
        page: _currentPage + 1,
        status: _statusParam,
      );
      _reminders.addAll(response.items);
      _currentPage++;
      _totalCount = response.pagination.total;
      _hasMore =
          response.pagination.hasNext ?? false;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    }
    _isLoadingMore = false;
    notifyListeners();
  }

  /// Pull-to-refresh handler.
  Future<void> refresh() async {
    _errorMessage = null;
    _lastSendResult = null;
    await loadReminders();
  }

  // ------------------------------------------------
  // Filters
  // ------------------------------------------------

  /// Updates the status filter and reloads.
  void onStatusFilterChanged(String filter) {
    if (_statusFilter == filter) return;
    _statusFilter = filter;
    notifyListeners();
    loadReminders();
  }

  // ------------------------------------------------
  // Actions
  // ------------------------------------------------

  /// Sends all pending reminders.
  Future<void> sendPendingReminders() async {
    _isSending = true;
    _errorMessage = null;
    notifyListeners();
    try {
      _lastSendResult = await _reminderService
          .sendPendingReminders();
      await loadReminders();
    } on ApiException catch (e) {
      _errorMessage = e.message;
    }
    _isSending = false;
    notifyListeners();
  }

  /// Deletes a reminder and removes it from
  /// the list.
  Future<void> deleteReminder(
    Reminder reminder,
  ) async {
    try {
      await _reminderService.deleteReminder(
        reminder.id,
      );
      _reminders.removeWhere(
        (r) => r.id == reminder.id,
      );
      _totalCount--;
      notifyListeners();
    } on ApiException catch (e) {
      _errorMessage = e.message;
      notifyListeners();
    }
  }

  // ------------------------------------------------
  // Navigation
  // ------------------------------------------------

  /// Navigates to create a new reminder.
  void navigateToCreateReminder() {
    _navigationService
        .navigateToReminderFormView();
  }

  /// Navigates to edit an existing reminder.
  void navigateToEditReminder(
    Reminder reminder,
  ) {
    _navigationService.navigateToReminderFormView(
      reminder: reminder,
    );
  }

  // ------------------------------------------------
  // Helpers
  // ------------------------------------------------

  String? get _statusParam {
    switch (_statusFilter) {
      case 'Pending':
        return 'pending';
      case 'Sent':
        return 'sent';
      case 'Failed':
        return 'failed';
      default:
        return null;
    }
  }
}

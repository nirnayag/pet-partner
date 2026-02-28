import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/models/auth/user.dart';
import 'package:partner/services/user_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the staff list screen.
///
/// Loads clinic staff with role and status
/// filtering plus pagination.
class StaffListViewModel extends BaseViewModel
    with ErrorHandlingMixin {
  final _userService = locator<UserService>();
  final _navigationService =
      locator<NavigationService>();

  // ------------------------------------------------
  // State
  // ------------------------------------------------

  List<User> _staffMembers = <User>[];

  /// The current list of staff members.
  List<User> get staffMembers => _staffMembers;

  String _roleFilter = 'All';

  /// The active role filter label.
  String get roleFilter => _roleFilter;

  String _statusFilter = 'Active';

  /// The active status filter label.
  String get statusFilter => _statusFilter;

  int _currentPage = 1;
  bool _hasMore = true;
  bool _isLoadingMore = false;

  /// Whether a load-more request is running.
  bool get isLoadingMore => _isLoadingMore;

  int _totalCount = 0;

  /// Total number of matching staff members.
  int get totalCount => _totalCount;

  // ------------------------------------------------
  // Lifecycle
  // ------------------------------------------------

  /// Called once when the view is ready.
  Future<void> initialise() async {
    await loadStaff();
  }

  // ------------------------------------------------
  // Data loading
  // ------------------------------------------------

  /// Loads the first page of staff members.
  Future<void> loadStaff() async {
    setBusy(true);
    _currentPage = 1;
    await runSafe(() async {
      final response = await _userService.getUsers(
        role: _roleParam,
        isActive: _isActiveParam,
      );
      _staffMembers = response.items;
      _totalCount = response.pagination.total;
      _hasMore =
          response.pagination.hasNext ?? false;
    });
    setBusy(false);
  }

  /// Loads the next page and appends results.
  Future<void> loadMoreStaff() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();
    await runSafe(() async {
      final response = await _userService.getUsers(
        page: _currentPage + 1,
        role: _roleParam,
        isActive: _isActiveParam,
      );
      _staffMembers.addAll(response.items);
      _currentPage++;
      _totalCount = response.pagination.total;
      _hasMore =
          response.pagination.hasNext ?? false;
    });
    _isLoadingMore = false;
    notifyListeners();
  }

  /// Pull-to-refresh handler.
  Future<void> refresh() async {
    clearError();
    await loadStaff();
  }

  // ------------------------------------------------
  // Filters
  // ------------------------------------------------

  /// Updates the role filter and reloads.
  void onRoleFilterChanged(String filter) {
    if (_roleFilter == filter) return;
    _roleFilter = filter;
    notifyListeners();
    loadStaff();
  }

  /// Updates the status filter and reloads.
  void onStatusFilterChanged(String filter) {
    if (_statusFilter == filter) return;
    _statusFilter = filter;
    notifyListeners();
    loadStaff();
  }

  // ------------------------------------------------
  // Navigation
  // ------------------------------------------------

  /// Navigates to the add-staff form.
  void navigateToAddStaff() {
    _navigationService.navigateToStaffFormView();
  }

  /// Navigates to the edit-staff form.
  void navigateToEditStaff(User user) {
    _navigationService.navigateToStaffFormView(
      user: user,
    );
  }

  // ------------------------------------------------
  // Helpers
  // ------------------------------------------------

  String? get _roleParam {
    switch (_roleFilter) {
      case 'Veterinarians':
        return 'veterinarian';
      case 'Staff':
        return 'staff';
      default:
        return null;
    }
  }

  bool? get _isActiveParam {
    switch (_statusFilter) {
      case 'Active':
        return true;
      case 'Inactive':
        return false;
      default:
        return null;
    }
  }
}

import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/medical/prescription.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/services/prescription_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// Filter options for the prescription list.
enum PrescriptionFilter {
  /// Show all prescriptions.
  all,

  /// Show only active prescriptions.
  active,

  /// Show only inactive prescriptions.
  inactive,
}

/// ViewModel for the prescription list screen.
class PrescriptionListViewModel
    extends BaseViewModel
    with ErrorHandlingMixin {
  /// Creates a [PrescriptionListViewModel].
  PrescriptionListViewModel({this.petId});

  /// Optional pet ID to scope the list.
  final String? petId;

  final _prescriptionService =
      locator<PrescriptionService>();
  final _navigationService =
      locator<NavigationService>();

  // ---- State ----

  List<Prescription> _prescriptions =
      <Prescription>[];

  /// The loaded prescriptions.
  List<Prescription> get prescriptions =>
      _prescriptions;

  PaginationMeta? _pagination;

  /// The pagination metadata.
  PaginationMeta? get pagination => _pagination;

  PrescriptionFilter _filter =
      PrescriptionFilter.all;

  /// The current filter.
  PrescriptionFilter get filter => _filter;

  int _currentPage = 1;

  /// The current page number.
  int get currentPage => _currentPage;

  /// Whether more pages are available.
  bool get hasMore =>
      _pagination?.hasNext ?? false;

  // ---- Lifecycle ----

  /// Initialises the list.
  Future<void> initialise() async {
    await loadPrescriptions();
  }

  // ---- Data loading ----

  /// Loads prescriptions with the current filter.
  Future<void> loadPrescriptions() async {
    setBusy(true);
    _currentPage = 1;
    await runSafe(() async {
      final response = await _prescriptionService
          .getPrescriptions(
        petId: petId,
        isActive: _activeFilterValue,
      );
      _prescriptions = response.items;
      _pagination = response.pagination;
    });
    setBusy(false);
  }

  /// Loads the next page of results.
  Future<void> loadMore() async {
    if (!hasMore) return;
    if (busy(loadMoreKey)) return;

    setBusyForObject(loadMoreKey, true);
    _currentPage++;
    await runSafe(
      () async {
        final response =
            await _prescriptionService
                .getPrescriptions(
          page: _currentPage,
          petId: petId,
          isActive: _activeFilterValue,
        );
        _prescriptions.addAll(response.items);
        _pagination = response.pagination;
      },
      onError: () => _currentPage--,
    );
    setBusyForObject(loadMoreKey, false);
  }

  /// Pull-to-refresh.
  Future<void> refresh() async {
    await loadPrescriptions();
  }

  // ---- Filtering ----

  /// Sets the active filter and reloads.
  Future<void> setFilter(
    PrescriptionFilter value,
  ) async {
    if (_filter == value) return;
    _filter = value;
    notifyListeners();
    await loadPrescriptions();
  }

  bool? get _activeFilterValue {
    switch (_filter) {
      case PrescriptionFilter.all:
        return null;
      case PrescriptionFilter.active:
        return true;
      case PrescriptionFilter.inactive:
        return false;
    }
  }

  // ---- Navigation ----

  /// Navigates back.
  void goBack() {
    _navigationService.back<void>();
  }

  /// Key used for the load-more busy state.
  static const String loadMoreKey =
      'load-more';
}

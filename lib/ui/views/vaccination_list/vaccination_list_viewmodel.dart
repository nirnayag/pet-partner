import 'package:partner/app/app.locator.dart';
import 'package:partner/core/models/medical/vaccination.dart';
import 'package:partner/core/models/pagination.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/vaccination_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the vaccination list screen.
class VaccinationListViewModel
    extends BaseViewModel {
  /// Creates a [VaccinationListViewModel].
  VaccinationListViewModel({this.petId});

  /// Optional pet ID to scope the list.
  final String? petId;

  final _vaccinationService =
      locator<VaccinationService>();
  final _navigationService =
      locator<NavigationService>();

  // ---- State ----

  List<Vaccination> _vaccinations =
      <Vaccination>[];

  /// The loaded vaccinations.
  List<Vaccination> get vaccinations =>
      _vaccinations;

  PaginationMeta? _pagination;

  /// The pagination metadata.
  PaginationMeta? get pagination => _pagination;

  int _currentPage = 1;

  /// The current page number.
  int get currentPage => _currentPage;

  String? _errorMessage;

  /// Error message from the last operation.
  String? get errorMessage => _errorMessage;

  /// Whether more pages are available.
  bool get hasMore =>
      _pagination?.hasNext ?? false;

  // ---- Lifecycle ----

  /// Initialises the list.
  Future<void> initialise() async {
    await loadVaccinations();
  }

  // ---- Data loading ----

  /// Loads vaccinations.
  Future<void> loadVaccinations() async {
    setBusy(true);
    _errorMessage = null;
    _currentPage = 1;

    try {
      final response = await _vaccinationService
          .getVaccinations(petId: petId);
      _vaccinations = response.items;
      _pagination = response.pagination;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    }
    setBusy(false);
  }

  /// Loads the next page of results.
  Future<void> loadMore() async {
    if (!hasMore) return;
    if (busy(loadMoreKey)) return;

    setBusyForObject(loadMoreKey, true);
    _currentPage++;
    try {
      final response = await _vaccinationService
          .getVaccinations(
        page: _currentPage,
        petId: petId,
      );
      _vaccinations.addAll(response.items);
      _pagination = response.pagination;
    } on ApiException catch (e) {
      _currentPage--;
      _errorMessage = e.message;
    }
    setBusyForObject(loadMoreKey, false);
  }

  /// Pull-to-refresh.
  Future<void> refresh() async {
    await loadVaccinations();
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

import 'dart:async';

import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/config/app_constants.dart';
import 'package:partner/core/models/pet/pet.dart';
import 'package:partner/core/utils/permission_utils.dart';
import 'package:partner/services/auth_service.dart';
import 'package:partner/services/pet_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the patient registry (pet list)
/// screen. Loads pets from the API with search,
/// filtering, pagination, and pull-to-refresh.
class PatientRegistryViewModel extends BaseViewModel
    with ErrorHandlingMixin {
  final _petService = locator<PetService>();
  final _navigationService =
      locator<NavigationService>();
  final _authService = locator<AuthService>();

  // --------------------------------------------------
  // State
  // --------------------------------------------------

  List<Pet> _pets = <Pet>[];

  /// The current list of loaded pets.
  List<Pet> get pets => _pets;

  String _searchQuery = '';

  /// The current search query string.
  String get searchQuery => _searchQuery;

  int _currentPage = 1;

  /// The page number of the last fetched page.
  int get currentPage => _currentPage;

  bool _hasMore = true;

  /// Whether more pages are available.
  bool get hasMore => _hasMore;

  bool _isLoadingMore = false;

  /// Whether a "load more" request is in progress.
  bool get isLoadingMore => _isLoadingMore;

  String _activeFilter = 'All';

  /// The currently active species filter label.
  String get activeFilter => _activeFilter;

  int _totalCount = 0;

  /// Total number of pets matching the current query.
  int get totalCount => _totalCount;

  Timer? _debounce;

  // --------------------------------------------------
  // Permissions
  // --------------------------------------------------

  /// Whether the current user can create new pets.
  bool get canCreatePet {
    final role = _authService.currentRole;
    if (role == null) return false;
    return PermissionUtils.hasPermission(
      role,
      'pets:create',
    );
  }

  // --------------------------------------------------
  // Lifecycle
  // --------------------------------------------------

  /// Called once when the view is ready.
  Future<void> initialise() async {
    await loadPets();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // --------------------------------------------------
  // Data loading
  // --------------------------------------------------

  /// Loads the first page of pets, resetting state.
  Future<void> loadPets() async {
    setBusy(true);
    _currentPage = 1;
    await runSafe(() async {
      final species = _speciesFromFilter(
        _activeFilter,
      );
      final response = await _petService.getPets(
        species: species,
      );
      _pets = response.items;
      _totalCount = response.pagination.total;
      _hasMore =
          response.pagination.hasNext ?? false;
    });
    setBusy(false);
  }

  /// Loads the next page and appends results.
  Future<void> loadMorePets() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();
    await runSafe(() async {
      final species = _speciesFromFilter(
        _activeFilter,
      );
      final response = await _petService.getPets(
        page: _currentPage + 1,
        species: species,
      );
      _pets.addAll(response.items);
      _currentPage++;
      _totalCount = response.pagination.total;
      _hasMore =
          response.pagination.hasNext ?? false;
    });
    _isLoadingMore = false;
    notifyListeners();
  }

  /// Debounced search input handler.
  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounce?.cancel();
    _debounce = Timer(
      Duration(
        milliseconds:
            AppConstants.searchDebounceMs,
      ),
      loadPets,
    );
  }

  /// Updates the active filter chip and reloads.
  void onFilterChanged(String filter) {
    if (_activeFilter == filter) return;
    _activeFilter = filter;
    notifyListeners();
    loadPets();
  }

  /// Pull-to-refresh handler.
  Future<void> refresh() async {
    clearError();
    await loadPets();
  }

  // --------------------------------------------------
  // Navigation
  // --------------------------------------------------

  /// Navigates to the patient profile for [pet].
  void onPetTapped(Pet pet) {
    _navigationService
        .navigateToPatientProfileView(
      petId: pet.id,
    );
  }

  // --------------------------------------------------
  // Helpers
  // --------------------------------------------------

  String? _speciesFromFilter(String filter) {
    switch (filter) {
      case 'Dogs':
        return 'dog';
      case 'Cats':
        return 'cat';
      case 'Birds':
        return 'bird';
      case 'Small Pets':
        return 'small_pet';
      default:
        return null;
    }
  }
}

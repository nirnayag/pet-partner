import 'dart:async';

import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/models/pet_owner.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/pet_owner_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the pet-owner list screen.
///
/// Provides paginated loading, debounced search,
/// and navigation to create / detail views.
class PetOwnerListViewModel extends BaseViewModel {
  final _petOwnerService =
      locator<PetOwnerService>();
  final _navigationService =
      locator<NavigationService>();

  // ------------------------------------------------
  // State
  // ------------------------------------------------

  List<PetOwner> _owners = <PetOwner>[];

  /// The currently loaded pet owners.
  List<PetOwner> get owners => _owners;

  String _searchQuery = '';

  /// The current search query.
  String get searchQuery => _searchQuery;

  int _currentPage = 1;

  /// The last fetched page number.
  int get currentPage => _currentPage;

  bool _hasMore = true;

  /// Whether more pages are available.
  bool get hasMore => _hasMore;

  bool _isLoadingMore = false;

  /// Whether a load-more request is active.
  bool get isLoadingMore => _isLoadingMore;

  String? _errorMessage;

  /// An error message to display, or `null`.
  String? get errorMessage => _errorMessage;

  int _totalCount = 0;

  /// Total owners matching the current query.
  int get totalCount => _totalCount;

  Timer? _debounce;

  // ------------------------------------------------
  // Lifecycle
  // ------------------------------------------------

  /// Loads the initial page of pet owners.
  Future<void> initialise() async {
    await loadOwners();
  }

  @override
  void dispose() {
    _debounce?.cancel();
    super.dispose();
  }

  // ------------------------------------------------
  // Data loading
  // ------------------------------------------------

  /// Loads the first page, resetting state.
  Future<void> loadOwners() async {
    setBusy(true);
    _errorMessage = null;
    try {
      _currentPage = 1;
      final response =
          await _petOwnerService.getPetOwners(
        search: _searchQuery.isNotEmpty
            ? _searchQuery
            : null,
      );
      _owners = response.items;
      _totalCount = response.pagination.total;
      _hasMore =
          response.pagination.hasNext ?? false;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    }
    setBusy(false);
  }

  /// Loads the next page and appends results.
  Future<void> loadMoreOwners() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final response =
          await _petOwnerService.getPetOwners(
        page: _currentPage + 1,
        search: _searchQuery.isNotEmpty
            ? _searchQuery
            : null,
      );
      _owners.addAll(response.items);
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

  /// Debounced handler for search input.
  void onSearchChanged(String query) {
    _searchQuery = query;
    _debounce?.cancel();
    _debounce = Timer(
      const Duration(milliseconds: 400),
      loadOwners,
    );
  }

  /// Pull-to-refresh handler.
  Future<void> refresh() async {
    _errorMessage = null;
    await loadOwners();
  }

  // ------------------------------------------------
  // Navigation
  // ------------------------------------------------

  /// Opens the pet-owner detail screen.
  void onOwnerTapped(PetOwner owner) {
    _navigationService
        .navigateToPetOwnerDetailView(
      ownerId: owner.id,
    );
  }

  /// Opens the create-pet-owner form.
  void onAddOwnerTapped() {
    _navigationService
        .navigateToPetOwnerFormView();
  }
}

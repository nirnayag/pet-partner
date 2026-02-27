import 'package:partner/app/app.locator.dart';
import 'package:partner/app/app.router.dart';
import 'package:partner/core/enums/document_type.dart';
import 'package:partner/core/models/document/document.dart';
import 'package:partner/services/api_client.dart';
import 'package:partner/services/document_service.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for the document list screen.
///
/// Supports paginated loading with document-type
/// filtering.
class DocumentListViewModel extends BaseViewModel {
  /// Creates a [DocumentListViewModel].
  DocumentListViewModel({
    this.petId,
    this.medicalRecordId,
  });

  /// Optional pet ID to scope documents.
  final String? petId;

  /// Optional medical record ID to scope.
  final String? medicalRecordId;

  final _documentService =
      locator<DocumentService>();
  final _navigationService =
      locator<NavigationService>();

  // ------------------------------------------------
  // State
  // ------------------------------------------------

  List<Document> _documents = <Document>[];

  /// The current list of documents.
  List<Document> get documents => _documents;

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

  /// An error message, or `null`.
  String? get errorMessage => _errorMessage;

  int _totalCount = 0;

  /// Total documents matching the filter.
  int get totalCount => _totalCount;

  String _activeFilter = 'All';

  /// The currently active type-filter label.
  String get activeFilter => _activeFilter;

  /// Filter chip labels.
  static const filterLabels = <String>[
    'All',
    'Lab Results',
    'X-Rays',
    'Intake Forms',
    'Other',
  ];

  // ------------------------------------------------
  // Lifecycle
  // ------------------------------------------------

  /// Loads the initial page of documents.
  Future<void> initialise() async {
    await loadDocuments();
  }

  // ------------------------------------------------
  // Data loading
  // ------------------------------------------------

  /// Loads the first page, resetting state.
  Future<void> loadDocuments() async {
    setBusy(true);
    _errorMessage = null;
    try {
      _currentPage = 1;
      final response =
          await _documentService.getDocuments(
        petId: petId,
        medicalRecordId: medicalRecordId,
        documentType: _typeFromFilter(
          _activeFilter,
        ),
      );
      _documents = response.items;
      _totalCount = response.pagination.total;
      _hasMore =
          response.pagination.hasNext ?? false;
    } on ApiException catch (e) {
      _errorMessage = e.message;
    }
    setBusy(false);
  }

  /// Loads the next page and appends results.
  Future<void> loadMoreDocuments() async {
    if (_isLoadingMore || !_hasMore) return;
    _isLoadingMore = true;
    notifyListeners();
    try {
      final response =
          await _documentService.getDocuments(
        page: _currentPage + 1,
        petId: petId,
        medicalRecordId: medicalRecordId,
        documentType: _typeFromFilter(
          _activeFilter,
        ),
      );
      _documents.addAll(response.items);
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

  /// Updates the active filter and reloads.
  void onFilterChanged(String filter) {
    if (_activeFilter == filter) return;
    _activeFilter = filter;
    notifyListeners();
    loadDocuments();
  }

  /// Pull-to-refresh handler.
  Future<void> refresh() async {
    _errorMessage = null;
    await loadDocuments();
  }

  // ------------------------------------------------
  // Navigation
  // ------------------------------------------------

  /// Opens the upload document screen.
  void onUploadTapped() {
    _navigationService
        .navigateToDocumentUploadView(
      petId: petId,
      medicalRecordId: medicalRecordId,
    );
  }

  // ------------------------------------------------
  // Helpers
  // ------------------------------------------------

  String? _typeFromFilter(String filter) {
    switch (filter) {
      case 'Lab Results':
        return DocumentType.labResult.value;
      case 'X-Rays':
        return DocumentType.xray.value;
      case 'Intake Forms':
        return DocumentType.intakeForm.value;
      case 'Other':
        return DocumentType.other.value;
      default:
        return null;
    }
  }
}

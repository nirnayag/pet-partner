import 'dart:io';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:partner/app/app.locator.dart';
import 'package:partner/core/enums/document_type.dart';
import 'package:partner/services/document_service.dart';
import 'package:partner/ui/common/error_handling_mixin.dart';
import 'package:stacked/stacked.dart';
import 'package:stacked_services/stacked_services.dart';

/// ViewModel for uploading a document.
class DocumentUploadViewModel
    extends BaseViewModel
    with ErrorHandlingMixin {
  /// Creates a [DocumentUploadViewModel].
  DocumentUploadViewModel({
    this.petId,
    this.medicalRecordId,
  });

  /// Optional pet ID to associate.
  final String? petId;

  /// Optional medical record ID to associate.
  final String? medicalRecordId;

  final _documentService =
      locator<DocumentService>();
  final _navigationService =
      locator<NavigationService>();

  // ---- Controllers ----

  /// Controller for the title field.
  final titleController = TextEditingController();

  /// Controller for the description field.
  final descriptionController =
      TextEditingController();

  /// Controller for the pet ID field.
  final petIdController = TextEditingController();

  // ---- Form state ----

  /// Available document type options.
  static final documentTypeOptions =
      DocumentType.values;

  DocumentType _selectedType =
      DocumentType.other;

  /// The currently selected document type.
  DocumentType get selectedType => _selectedType;

  File? _selectedFile;

  /// The file selected for upload.
  File? get selectedFile => _selectedFile;

  /// The display name of the selected file.
  String? get selectedFileName =>
      _selectedFile?.path.split('/').last;

  // errorMessage and hasError provided by
  // ErrorHandlingMixin.

  double _uploadProgress = 0;

  /// Upload progress from 0.0 to 1.0.
  double get uploadProgress => _uploadProgress;

  bool _isUploading = false;

  /// Whether an upload is in progress.
  bool get isUploading => _isUploading;

  // ---- Lifecycle ----

  /// Initialises the form.
  void initialise() {
    if (petId != null) {
      petIdController.text = petId!;
    }
  }

  // ---- File picker ----

  /// Opens the file picker to select a file.
  Future<void> pickFile() async {
    final result =
        await FilePicker.platform.pickFiles();

    if (result != null &&
        result.files.single.path != null) {
      _selectedFile =
          File(result.files.single.path!);
      notifyListeners();
    }
  }

  /// Clears the selected file.
  void clearFile() {
    _selectedFile = null;
    notifyListeners();
  }

  // ---- Setters ----

  /// Sets the selected document type.
  void setDocumentType(DocumentType type) {
    _selectedType = type;
    notifyListeners();
  }

  // ---- Upload ----

  /// Validates and uploads the document.
  Future<void> upload() async {
    clearError();

    if (_selectedFile == null) {
      setError('Please select a file.');
      return;
    }

    final title = titleController.text.trim();
    if (title.isEmpty) {
      setError('Title is required.');
      return;
    }

    final resolvedPetId =
        petIdController.text.trim();
    if (resolvedPetId.isEmpty) {
      setError('Pet ID is required.');
      return;
    }

    final description =
        descriptionController.text.trim();

    _isUploading = true;
    _uploadProgress = 0;
    notifyListeners();

    // Simulate progress since the actual upload
    // is handled by ApiClient in a single call.
    _uploadProgress = 0.3;
    notifyListeners();

    final result = await runSafe(
      () => _documentService.uploadDocument(
        file: _selectedFile!,
        petId: resolvedPetId,
        documentType: _selectedType.value,
        title: title,
        description: description.isNotEmpty
            ? description
            : null,
        medicalRecordId: medicalRecordId,
      ),
    );

    _isUploading = false;
    if (result != null) {
      _uploadProgress = 1;
      notifyListeners();
      _navigationService.back<void>();
    } else {
      notifyListeners();
    }
  }

  /// Navigates back without uploading.
  void onBackTapped() {
    _navigationService.back<void>();
  }

  @override
  void dispose() {
    titleController.dispose();
    descriptionController.dispose();
    petIdController.dispose();
    super.dispose();
  }
}

import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/document_upload/document_upload_viewmodel.dart';
import 'package:partner/ui/views/document_upload/widgets/file_picker_area.dart';
import 'package:partner/ui/views/document_upload/widgets/upload_form_fields.dart';
import 'package:stacked/stacked.dart';

/// Screen for uploading a new document.
class DocumentUploadView
    extends StackedView<DocumentUploadViewModel> {
  /// Creates a [DocumentUploadView].
  const DocumentUploadView({
    this.petId,
    this.medicalRecordId,
    super.key,
  });

  /// Optional pre-filled pet ID.
  final String? petId;

  /// Optional pre-filled medical record ID.
  final String? medicalRecordId;

  @override
  DocumentUploadViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DocumentUploadViewModel(
        petId: petId,
        medicalRecordId: medicalRecordId,
      );

  @override
  void onViewModelReady(
    DocumentUploadViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    DocumentUploadViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      body: Column(
        children: [
          _AppBar(onBack: viewModel.onBackTapped),
          Expanded(
            child: SingleChildScrollView(
              padding: const EdgeInsets.fromLTRB(
                20,
                16,
                20,
                120,
              ),
              child: Column(
                crossAxisAlignment:
                    CrossAxisAlignment.start,
                children: [
                  if (viewModel.errorMessage !=
                      null)
                    _ErrorBanner(
                      message: viewModel
                          .errorMessage!,
                    ),
                  FilePickerArea(
                    onTap: viewModel.pickFile,
                    onClear: viewModel.clearFile,
                    fileName:
                        viewModel.selectedFileName,
                  ),
                  const SizedBox(height: 24),
                  if (viewModel.isUploading)
                    _ProgressBar(
                      progress: viewModel
                          .uploadProgress,
                    ),
                  UploadFormFields(
                    titleController:
                        viewModel.titleController,
                    descriptionController:
                        viewModel
                            .descriptionController,
                    petIdController:
                        viewModel.petIdController,
                    selectedType:
                        viewModel.selectedType,
                    onTypeChanged:
                        viewModel.setDocumentType,
                    showPetIdField:
                        viewModel.petId == null,
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
      bottomSheet: _UploadButton(
        isBusy: viewModel.isUploading,
        onTap: viewModel.upload,
      ),
    );
  }
}

// ---------------------------------------------------
// Private widgets
// ---------------------------------------------------

class _AppBar extends StatelessWidget {
  const _AppBar({required this.onBack});

  final VoidCallback onBack;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        16,
        50,
        16,
        16,
      ),
      decoration: const BoxDecoration(
        color: Colors.white,
        border: Border(
          bottom: BorderSide(
            color: kcVeryLightGrey,
            width: 0.5,
          ),
        ),
      ),
      child: Row(
        mainAxisAlignment:
            MainAxisAlignment.spaceBetween,
        children: [
          GestureDetector(
            onTap: onBack,
            child: const Icon(
              Icons.arrow_back_rounded,
              color: kcDarkGreyColor,
            ),
          ),
          Text(
            'Upload Document',
            style: GoogleFonts.manrope(
              fontSize: 18,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
          const SizedBox(width: 24),
        ],
      ),
    );
  }
}

class _ErrorBanner extends StatelessWidget {
  const _ErrorBanner({required this.message});

  final String message;

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      margin: const EdgeInsets.only(bottom: 16),
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color:
            Colors.red.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(
          color:
              Colors.red.withValues(alpha: 0.3),
        ),
      ),
      child: Text(
        message,
        style: GoogleFonts.manrope(
          fontSize: 13,
          fontWeight: FontWeight.w600,
          color: Colors.red[700],
        ),
      ),
    );
  }
}

class _ProgressBar extends StatelessWidget {
  const _ProgressBar({required this.progress});

  final double progress;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding:
          const EdgeInsets.only(bottom: 20),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Uploading... '
            '${(progress * 100).toInt()}%',
            style: GoogleFonts.manrope(
              fontSize: 13,
              fontWeight: FontWeight.w600,
              color: kcPrimaryColorDark,
            ),
          ),
          const SizedBox(height: 8),
          ClipRRect(
            borderRadius:
                BorderRadius.circular(4),
            child: LinearProgressIndicator(
              value: progress,
              backgroundColor: kcVeryLightGrey,
              valueColor:
                  const AlwaysStoppedAnimation(
                kcPrimaryColor,
              ),
              minHeight: 6,
            ),
          ),
        ],
      ),
    );
  }
}

class _UploadButton extends StatelessWidget {
  const _UploadButton({
    required this.isBusy,
    required this.onTap,
  });

  final bool isBusy;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.fromLTRB(
        20,
        12,
        20,
        40,
      ),
      decoration: BoxDecoration(
        color: Colors.white,
        boxShadow: [
          BoxShadow(
            color: Colors.black.withValues(
              alpha: 0.05,
            ),
            blurRadius: 20,
            offset: const Offset(0, -4),
          ),
        ],
      ),
      child: GestureDetector(
        onTap: isBusy ? null : onTap,
        child: Container(
          height: 56,
          decoration: BoxDecoration(
            color: isBusy
                ? kcLightGrey
                : kcPrimaryColor,
            borderRadius:
                BorderRadius.circular(18),
            boxShadow: isBusy
                ? null
                : [
                    BoxShadow(
                      color: kcPrimaryColor
                          .withValues(
                        alpha: 0.3,
                      ),
                      blurRadius: 12,
                    ),
                  ],
          ),
          child: Center(
            child: isBusy
                ? const SizedBox(
                    width: 24,
                    height: 24,
                    child:
                        CircularProgressIndicator(
                      strokeWidth: 2.5,
                      color: Colors.white,
                    ),
                  )
                : Text(
                    'Upload',
                    style: GoogleFonts.manrope(
                      fontSize: 16,
                      fontWeight:
                          FontWeight.w900,
                      color: kcNeutral900,
                    ),
                  ),
          ),
        ),
      ),
    );
  }
}

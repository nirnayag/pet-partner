import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/document_list/document_list_viewmodel.dart';
import 'package:partner/ui/views/document_list/widgets/document_card.dart';
import 'package:partner/ui/views/document_list/widgets/document_filter_chips.dart';
import 'package:partner/ui/widgets/empty_state.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

/// Screen listing documents with type filters.
class DocumentListView
    extends StackedView<DocumentListViewModel> {
  /// Creates a [DocumentListView].
  const DocumentListView({
    this.petId,
    this.medicalRecordId,
    super.key,
  });

  /// Optional pet ID scope.
  final String? petId;

  /// Optional medical record ID scope.
  final String? medicalRecordId;

  @override
  DocumentListViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      DocumentListViewModel(
        petId: petId,
        medicalRecordId: medicalRecordId,
      );

  @override
  void onViewModelReady(
    DocumentListViewModel viewModel,
  ) =>
      viewModel.initialise();

  @override
  Widget builder(
    BuildContext context,
    DocumentListViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      floatingActionButton: FloatingActionButton(
        onPressed: viewModel.onUploadTapped,
        backgroundColor: kcPrimaryColor,
        elevation: 8,
        shape: const CircleBorder(),
        child: const Icon(
          Icons.upload_file_rounded,
          color: kcNeutral900,
          size: 28,
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _Header(viewModel: viewModel),
            Expanded(
              child: _Body(
                viewModel: viewModel,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

// ---------------------------------------------------
// Header
// ---------------------------------------------------

class _Header extends StatelessWidget {
  const _Header({required this.viewModel});

  final DocumentListViewModel viewModel;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(
        20,
        20,
        20,
        10,
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Text(
            'Documents',
            style: GoogleFonts.manrope(
              fontSize: 24,
              fontWeight: FontWeight.w800,
              color: kcDarkGreyColor,
            ),
          ),
          const SizedBox(height: 16),
          DocumentFilterChips(
            labels:
                DocumentListViewModel.filterLabels,
            activeLabel: viewModel.activeFilter,
            onSelected:
                viewModel.onFilterChanged,
          ),
        ],
      ),
    );
  }
}

// ---------------------------------------------------
// Body
// ---------------------------------------------------

class _Body extends StatefulWidget {
  const _Body({required this.viewModel});

  final DocumentListViewModel viewModel;

  @override
  State<_Body> createState() => _BodyState();
}

class _BodyState extends State<_Body> {
  final _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController
      ..removeListener(_onScroll)
      ..dispose();
    super.dispose();
  }

  void _onScroll() {
    final maxScroll =
        _scrollController.position.maxScrollExtent;
    final current =
        _scrollController.position.pixels;
    if (current >= maxScroll - 200) {
      widget.viewModel.loadMoreDocuments();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    if (vm.isBusy) {
      return const LoadingShimmer();
    }

    if (vm.errorMessage != null) {
      return ErrorState(
        message: vm.errorMessage!,
        onRetry: vm.refresh,
      );
    }

    if (vm.documents.isEmpty) {
      return EmptyState(
        icon: Icons.folder_open_rounded,
        title: 'No documents found',
        description:
            'Uploaded documents will '
            'appear here.',
        actionLabel: 'Upload Document',
        onAction: vm.onUploadTapped,
      );
    }

    return RefreshIndicator(
      color: kcPrimaryColor,
      onRefresh: vm.refresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.symmetric(
          horizontal: 20,
        ),
        itemCount: vm.documents.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 16,
              ),
              child: Text(
                'Showing ${vm.totalCount}'
                ' documents',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kcPrimaryColor,
                ),
              ),
            );
          }

          final docIndex = index - 1;

          if (docIndex ==
              vm.documents.length) {
            if (vm.isLoadingMore) {
              return const Padding(
                padding: EdgeInsets.all(16),
                child: Center(
                  child:
                      CircularProgressIndicator(
                    color: kcPrimaryColor,
                    strokeWidth: 2,
                  ),
                ),
              );
            }
            return const SizedBox(height: 100);
          }

          return Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            child: DocumentCard(
              document: vm.documents[docIndex],
            ),
          );
        },
      ),
    );
  }
}

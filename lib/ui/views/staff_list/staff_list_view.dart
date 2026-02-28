import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/staff_list/staff_list_viewmodel.dart';
import 'package:partner/ui/views/staff_list/widgets/staff_filter_chips.dart';
import 'package:partner/ui/views/staff_list/widgets/staff_member_card.dart';
import 'package:partner/ui/widgets/empty_state.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

/// The staff list screen showing clinic staff
/// with role and status filters.
class StaffListView
    extends StackedView<StaffListViewModel> {
  /// Creates a [StaffListView].
  const StaffListView({super.key});

  @override
  Widget builder(
    BuildContext context,
    StaffListViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed: viewModel.navigateToAddStaff,
        backgroundColor: kcPrimaryColor,
        elevation: 8,
        icon: const Icon(
          Icons.add,
          color: kcNeutral900,
        ),
        label: Text(
          'Add Staff',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w800,
            color: kcNeutral900,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _StaffListHeader(
              viewModel: viewModel,
            ),
            Expanded(
              child: _StaffListBody(
                viewModel: viewModel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  StaffListViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      StaffListViewModel();

  @override
  void onViewModelReady(
    StaffListViewModel viewModel,
  ) =>
      viewModel.initialise();
}

class _StaffListHeader extends StatelessWidget {
  const _StaffListHeader({
    required this.viewModel,
  });

  final StaffListViewModel viewModel;

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
          Row(
            children: [
              GestureDetector(
                onTap: () =>
                    Navigator.of(context).pop(),
                child: const Icon(
                  Icons.arrow_back_rounded,
                  color: kcDarkGreyColor,
                ),
              ),
              const SizedBox(width: 12),
              Text(
                'Staff Management',
                style: GoogleFonts.manrope(
                  fontSize: 22,
                  fontWeight: FontWeight.w800,
                  color: kcDarkGreyColor,
                ),
              ),
            ],
          ),
          const SizedBox(height: 16),
          StaffFilterChips(
            roleFilter: viewModel.roleFilter,
            statusFilter:
                viewModel.statusFilter,
            onRoleChanged:
                viewModel.onRoleFilterChanged,
            onStatusChanged:
                viewModel.onStatusFilterChanged,
          ),
        ],
      ),
    );
  }
}

class _StaffListBody extends StatefulWidget {
  const _StaffListBody({
    required this.viewModel,
  });

  final StaffListViewModel viewModel;

  @override
  State<_StaffListBody> createState() =>
      _StaffListBodyState();
}

class _StaffListBodyState
    extends State<_StaffListBody> {
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
    final maxScroll = _scrollController
        .position.maxScrollExtent;
    final current =
        _scrollController.position.pixels;
    if (current >= maxScroll - 200) {
      widget.viewModel.loadMoreStaff();
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

    if (vm.staffMembers.isEmpty) {
      return const EmptyState(
        icon: Icons.people_outline_rounded,
        title: 'No staff found',
        description:
            'Add staff members to manage '
            'your clinic team.',
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
        itemCount: vm.staffMembers.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 16,
              ),
              child: Text(
                '${vm.totalCount} staff members',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kcPrimaryColor,
                ),
              ),
            );
          }

          final staffIndex = index - 1;

          if (staffIndex ==
              vm.staffMembers.length) {
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

          final user =
              vm.staffMembers[staffIndex];
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            child: StaffMemberCard(
              user: user,
              onTap: () =>
                  vm.navigateToEditStaff(user),
            ),
          );
        },
      ),
    );
  }
}

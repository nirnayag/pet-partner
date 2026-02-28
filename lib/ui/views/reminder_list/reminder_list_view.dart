import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:partner/ui/common/app_colors.dart';
import 'package:partner/ui/views/reminder_list/reminder_list_viewmodel.dart';
import 'package:partner/ui/views/reminder_list/widgets/reminder_card.dart';
import 'package:partner/ui/views/reminder_list/widgets/reminder_filter_chips.dart';
import 'package:partner/ui/widgets/empty_state.dart';
import 'package:partner/ui/widgets/error_state.dart';
import 'package:partner/ui/widgets/loading_shimmer.dart';
import 'package:stacked/stacked.dart';

/// The reminder list screen showing reminders
/// with status filters.
class ReminderListView
    extends StackedView<ReminderListViewModel> {
  /// Creates a [ReminderListView].
  const ReminderListView({super.key});

  @override
  Widget builder(
    BuildContext context,
    ReminderListViewModel viewModel,
    Widget? child,
  ) {
    return Scaffold(
      backgroundColor: kcBackgroundColor,
      floatingActionButton:
          FloatingActionButton.extended(
        onPressed:
            viewModel.navigateToCreateReminder,
        backgroundColor: kcPrimaryColor,
        elevation: 8,
        icon: const Icon(
          Icons.add,
          color: kcNeutral900,
        ),
        label: Text(
          'Create Reminder',
          style: GoogleFonts.manrope(
            fontWeight: FontWeight.w800,
            color: kcNeutral900,
          ),
        ),
      ),
      body: SafeArea(
        child: Column(
          children: [
            _ReminderListHeader(
              viewModel: viewModel,
            ),
            Expanded(
              child: _ReminderListBody(
                viewModel: viewModel,
              ),
            ),
          ],
        ),
      ),
    );
  }

  @override
  ReminderListViewModel viewModelBuilder(
    BuildContext context,
  ) =>
      ReminderListViewModel();

  @override
  void onViewModelReady(
    ReminderListViewModel viewModel,
  ) =>
      viewModel.initialise();
}

class _ReminderListHeader
    extends StatelessWidget {
  const _ReminderListHeader({
    required this.viewModel,
  });

  final ReminderListViewModel viewModel;

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
              Expanded(
                child: Text(
                  'Reminders',
                  style: GoogleFonts.manrope(
                    fontSize: 22,
                    fontWeight: FontWeight.w800,
                    color: kcDarkGreyColor,
                  ),
                ),
              ),
              _SendButton(
                isSending: viewModel.isSending,
                onTap: viewModel
                    .sendPendingReminders,
              ),
            ],
          ),
          const SizedBox(height: 16),
          ReminderFilterChips(
            statusFilter:
                viewModel.statusFilter,
            onStatusChanged:
                viewModel.onStatusFilterChanged,
          ),
        ],
      ),
    );
  }
}

class _SendButton extends StatelessWidget {
  const _SendButton({
    required this.isSending,
    required this.onTap,
  });

  final bool isSending;
  final VoidCallback onTap;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: isSending ? null : onTap,
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: 12,
          vertical: 8,
        ),
        decoration: BoxDecoration(
          color: kcPrimaryColor
              .withValues(alpha: 0.1),
          borderRadius:
              BorderRadius.circular(12),
        ),
        child: isSending
            ? const SizedBox(
                width: 16,
                height: 16,
                child:
                    CircularProgressIndicator(
                  strokeWidth: 2,
                  color: kcPrimaryColorDark,
                ),
              )
            : Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Icon(
                    Icons.send_rounded,
                    size: 14,
                    color: kcPrimaryColorDark,
                  ),
                  const SizedBox(width: 4),
                  Text(
                    'Send',
                    style: GoogleFonts.manrope(
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: kcPrimaryColorDark,
                    ),
                  ),
                ],
              ),
      ),
    );
  }
}

class _ReminderListBody extends StatefulWidget {
  const _ReminderListBody({
    required this.viewModel,
  });

  final ReminderListViewModel viewModel;

  @override
  State<_ReminderListBody> createState() =>
      _ReminderListBodyState();
}

class _ReminderListBodyState
    extends State<_ReminderListBody> {
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
      widget.viewModel.loadMoreReminders();
    }
  }

  @override
  Widget build(BuildContext context) {
    final vm = widget.viewModel;

    if (vm.isBusy) {
      return const LoadingShimmer();
    }

    if (vm.errorMessage != null &&
        vm.reminders.isEmpty) {
      return ErrorState(
        message: vm.errorMessage!,
        onRetry: vm.refresh,
      );
    }

    if (vm.reminders.isEmpty) {
      return const EmptyState(
        icon: Icons.notifications_none_rounded,
        title: 'No reminders',
        description:
            'Create reminders to notify '
            'pet owners.',
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
        itemCount: vm.reminders.length + 1,
        itemBuilder: (context, index) {
          if (index == 0) {
            return Padding(
              padding: const EdgeInsets.only(
                top: 10,
                bottom: 16,
              ),
              child: Text(
                '${vm.totalCount} reminders',
                style: GoogleFonts.manrope(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: kcPrimaryColor,
                ),
              ),
            );
          }

          final reminderIndex = index - 1;

          if (reminderIndex ==
              vm.reminders.length) {
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

          final reminder =
              vm.reminders[reminderIndex];
          return Padding(
            padding: const EdgeInsets.only(
              bottom: 12,
            ),
            child: ReminderCard(
              reminder: reminder,
              onTap: () => vm
                  .navigateToEditReminder(
                reminder,
              ),
              onDelete: () =>
                  vm.deleteReminder(reminder),
            ),
          );
        },
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/core/theme/app_spacing.dart';
import 'package:my_farm/features/member_dashboard/member_dashboard_models.dart';
import 'package:my_farm/features/member_dashboard/member_dashboard_viewmodel.dart';
import 'package:my_farm/features/member_dashboard/widgets/_empty_history.dart';

/// Paginated list of feed allocation history
class FeedHistoryList extends ConsumerWidget {
  final MemberDashboardViewModel viewModel;

  const FeedHistoryList({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(memberDashboardViewModelProvider(viewModel.memberId));

    if (state.feedHistoryPage == null || state.feedHistoryPage!.content.isEmpty) {
      return _EmptyHistory(
        message: 'No feed allocations recorded for this period',
        icon: Icons.grass,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with pagination info
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            'Feed History (${state.feedHistoryPage!.totalElements} total)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        // List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.feedHistoryPage!.content.length + 1, // +1 for load more
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            if (index == state.feedHistoryPage!.content.length) {
              // Load more button
              return _LoadMoreButton(
                isLoading: state.isLoadingHistory,
                hasMore: state.currentFeedPage < state.feedHistoryPage!.totalPages - 1,
                onPressed: () => viewModel.loadFeedHistory(),
              );
            }

            final feed = state.feedHistoryPage!.content[index];
            return _FeedTile(feed: feed);
          },
        ),
      ],
    );
  }
}

class _FeedTile extends StatelessWidget {
  final FeedAllocationDto feed;

  const _FeedTile({required this.feed});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.forestGreen500.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Icon(
          Icons.grass,
          color: AppColors.forestGreen500,
          size: 20,
        ),
      ),
      title: Text(
        feed.feedType,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        feed.date,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            '${feed.dailyKg} kg/day',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.forestGreen500,
                ),
          ),
          Text(
            '${feed.monthlyKg} kg/month',
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
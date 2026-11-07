import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/core/theme/app_spacing.dart';
import 'package:my_farm/features/member_dashboard/member_dashboard_viewmodel.dart';
import 'package:my_farm/features/member_dashboard/widgets/alert_tile.dart';
import 'package:my_farm/features/member_dashboard/widgets/balance_card.dart';
import 'package:my_farm/features/member_dashboard/widgets/contribution_card.dart';
import 'package:my_farm/features/member_dashboard/widgets/expense_card.dart';
import 'package:my_farm/features/member_dashboard/widgets/feed_allocation_card.dart';
import 'package:my_farm/features/member_dashboard/widgets/feed_history_list.dart';
import 'package:my_farm/features/member_dashboard/widgets/member_animal_card.dart';
import 'package:my_farm/features/member_dashboard/widgets/payment_history_list.dart';
import 'package:my_farm/features/member_dashboard/widgets/period_selector.dart';
import 'package:my_farm/features/member_dashboard/widgets/_stat_card.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

/// Member Dashboard Screen
class MemberDashboardScreen extends ConsumerWidget {
  final int memberId;

  const MemberDashboardScreen({
    super.key,
    required this.memberId,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final viewModel = ref.watch(memberDashboardViewModelProvider(memberId).notifier);
    final state = ref.watch(memberDashboardViewModelProvider(memberId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('My Dashboard'),
        actions: [
          PeriodSelector(viewModel: viewModel),
          const SizedBox(width: AppSpacing.md),
          IconButton(
            tooltip: 'Download PDF Report',
            icon: const Icon(Icons.picture_as_pdf),
            onPressed: () => _downloadReport(context, viewModel),
          ),
          const SizedBox(width: AppSpacing.sm),
        ],
      ),
      body: _buildBody(context, ref, state, viewModel),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    MemberDashboardState state,
    MemberDashboardViewModel viewModel,
  ) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return _ErrorView(
        message: state.error!,
        onRetry: () => viewModel.loadDashboard(),
      );
    }

    final dashboard = state.dashboard;
    if (dashboard == null) {
      return _ErrorView(
        message: 'No dashboard data available',
        onRetry: () => viewModel.loadDashboard(),
      );
    }

    final currencyFormat = NumberFormat.currency(locale: 'en_US', symbol: '\$');

    return RefreshIndicator(
      onRefresh: () => viewModel.loadDashboard(),
      child: CustomScrollView(
        slivers: [
          // Stats Grid
          SliverPadding(
            padding: const EdgeInsets.all(AppSpacing.md),
            sliver: SliverGrid(
              gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
                childAspectRatio: 1.1,
                crossAxisSpacing: AppSpacing.md,
                mainAxisSpacing: AppSpacing.md,
              ),
              delegate: SliverChildListDelegate([
                MemberAnimalCard(
                  totalAnimals: dashboard.totalAnimals,
                  totalWeight: dashboard.totalWeight,
                ),
                FeedAllocationCard(
                  dailyFeedKg: dashboard.dailyFeedKg,
                  monthlyFeedKg: dashboard.monthlyFeedKg,
                ),
                ContributionCard(
                  totalContributions: dashboard.totalContributions,
                  contributionCount: dashboard.contributionCount,
                ),
                ExpenseCard(
                  totalExpenses: dashboard.totalExpenses,
                  expenseCount: dashboard.expenseCount,
                ),
                BalanceCard(
                  totalPayments: dashboard.totalPayments,
                  paymentCount: dashboard.paymentCount,
                  outstandingBalance: dashboard.outstandingBalance,
                  netBalance: dashboard.netBalance,
                ),
                _QuickActionsCard(viewModel: viewModel),
              ]),
            ),
          ),

          // Alerts Section
          SliverToBoxAdapter(
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: AppSpacing.md),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const SizedBox(height: AppSpacing.sm),
                  Text(
                    'Alerts',
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: AppSpacing.sm),
                  if (dashboard.alerts.isEmpty)
                    const EmptyAlertsPlaceholder()
                  else
                    Column(
                      children: dashboard.alerts
                          .map((alert) => Padding(
                                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                                child: AlertTile(alert: alert),
                              ))
                          .toList(),
                    ),
                  const SizedBox(height: AppSpacing.lg),
                ],
              ),
            ),
          ),

          // Payment History Section
          SliverToBoxAdapter(
            child: PaymentHistoryList(viewModel: viewModel),
          ),

          // Feed History Section
          SliverToBoxAdapter(
            child: FeedHistoryList(viewModel: viewModel),
          ),

          // Bottom padding
          const SliverToBoxAdapter(
            child: SizedBox(height: AppSpacing.xl),
          ),
        ],
      ),
    );
  }

  Future<void> _downloadReport(
    BuildContext context,
    MemberDashboardViewModel viewModel,
  ) async {
    final messenger = ScaffoldMessenger.of(context);

    messenger.showSnackBar(
      const SnackBar(
        content: Row(
          children: [
            SizedBox(
              width: 20,
              height: 20,
              child: CircularProgressIndicator(strokeWidth: 2),
            ),
            SizedBox(width: 16),
            Text('Generating PDF report...'),
          ],
        ),
        duration: Duration(seconds: 30),
      ),
    );

    try {
      final path = await viewModel.downloadReport();

      if (context.mounted) {
        messenger.clearSnackBars();
        if (path != null) {
          messenger.showSnackBar(
            SnackBar(
              content: const Text('Report downloaded and opened'),
              action: SnackBarAction(
                label: 'Open',
                onPressed: () => OpenFile.open(path),
              ),
            ),
          );
        } else {
          messenger.showSnackBar(
            const SnackBar(
              content: Text('Failed to download report'),
              backgroundColor: AppColors.error500,
            ),
          );
        }
      }
    } catch (e) {
      if (context.mounted) {
        messenger.clearSnackBars();
        messenger.showSnackBar(
          SnackBar(
            content: Text('Error: $e'),
            backgroundColor: AppColors.error500,
          ),
        );
      }
    }
  }
}

/// Error view with retry button
class _ErrorView extends StatelessWidget {
  final String message;
  final VoidCallback onRetry;

  const _ErrorView({
    required this.message,
    required this.onRetry,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.xl),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: 64,
              color: Theme.of(context).colorScheme.error,
            ),
            const SizedBox(height: AppSpacing.md),
            Text(
              'Something went wrong',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppSpacing.sm),
            Text(
              message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: Theme.of(context).colorScheme.onSurfaceVariant,
                  ),
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSpacing.lg),
            FilledButton.icon(
              onPressed: onRetry,
              icon: const Icon(Icons.refresh),
              label: const Text('Try Again'),
            ),
          ],
        ),
      ),
    );
  }
}

/// Quick actions card for the stats grid
class _QuickActionsCard extends StatelessWidget {
  final MemberDashboardViewModel viewModel;

  const _QuickActionsCard({required this.viewModel});

  @override
  Widget build(BuildContext context) {
    return _StatCard(
      title: 'Quick Actions',
      value: '',
      subtitle: 'Tap to refresh',
      icon: Icons.flash_on,
      iconColor: AppColors.info500,
      onTap: () => viewModel.loadDashboard(),
    );
  }
}
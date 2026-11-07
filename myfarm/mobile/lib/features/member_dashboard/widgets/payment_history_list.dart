import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/core/theme/app_spacing.dart';
import 'package:my_farm/features/member_dashboard/member_dashboard_models.dart';
import 'package:my_farm/features/member_dashboard/member_dashboard_viewmodel.dart';
import 'package:my_farm/features/member_dashboard/widgets/_empty_history.dart';

/// Paginated list of payment history
class PaymentHistoryList extends ConsumerWidget {
  final MemberDashboardViewModel viewModel;

  const PaymentHistoryList({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(memberDashboardViewModelProvider(viewModel.memberId));

    if (state.paymentsPage == null || state.paymentsPage!.content.isEmpty) {
      return _EmptyHistory(
        message: 'No payments recorded for this period',
        icon: Icons.receipt,
      );
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Header with pagination info
        Padding(
          padding: const EdgeInsets.symmetric(vertical: AppSpacing.sm),
          child: Text(
            'Payment History (${state.paymentsPage!.totalElements} total)',
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.w600,
                ),
          ),
        ),
        // List
        ListView.separated(
          shrinkWrap: true,
          physics: const NeverScrollableScrollPhysics(),
          itemCount: state.paymentsPage!.content.length + 1, // +1 for load more
          separatorBuilder: (context, index) => const Divider(height: 1),
          itemBuilder: (context, index) {
            if (index == state.paymentsPage!.content.length) {
              // Load more button
              return _LoadMoreButton(
                isLoading: state.isLoadingHistory,
                hasMore: state.currentPaymentPage < state.paymentsPage!.totalPages - 1,
                onPressed: () => viewModel.loadPaymentHistory(),
              );
            }

            final payment = state.paymentsPage!.content[index];
            return _PaymentTile(payment: payment);
          },
        ),
      ],
    );
  }
}

class _PaymentTile extends StatelessWidget {
  final PaymentDto payment;

  const _PaymentTile({required this.payment});

  @override
  Widget build(BuildContext context) {
    return ListTile(
      contentPadding: const EdgeInsets.symmetric(vertical: AppSpacing.xs),
      leading: Container(
        padding: const EdgeInsets.all(AppSpacing.sm),
        decoration: BoxDecoration(
          color: AppColors.success500.withValues(alpha: 0.1),
          borderRadius: BorderRadius.circular(AppSpacing.radiusSm),
        ),
        child: Icon(
          Icons.payments,
          color: AppColors.success500,
          size: 20,
        ),
      ),
      title: Text(
        payment.description,
        style: Theme.of(context).textTheme.bodyLarge?.copyWith(
              fontWeight: FontWeight.w500,
            ),
      ),
      subtitle: Text(
        payment.date,
        style: Theme.of(context).textTheme.bodySmall?.copyWith(
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
      ),
      trailing: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.end,
        children: [
          Text(
            payment.amount,
            style: Theme.of(context).textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.success500,
                ),
          ),
          Text(
            payment.type,
            style: Theme.of(context).textTheme.labelSmall?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
          ),
        ],
      ),
    );
  }
}
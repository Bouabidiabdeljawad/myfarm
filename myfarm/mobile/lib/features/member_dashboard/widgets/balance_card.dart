import 'package:flutter/material.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/features/member_dashboard/widgets/_stat_card.dart';

/// Card displaying balance statistics
class BalanceCard extends StatelessWidget {
  final String totalPayments;
  final int paymentCount;
  final String outstandingBalance;
  final String netBalance;
  final VoidCallback? onTap;

  const BalanceCard({
    super.key,
    required this.totalPayments,
    required this.paymentCount,
    required this.outstandingBalance,
    required this.netBalance,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isPositiveOutstanding = !outstandingBalance.startsWith('-');
    final isPositiveNet = !netBalance.startsWith('-');

    return _StatCard(
      title: 'Balance',
      value: netBalance,
      subtitle: 'Outstanding: $outstandingBalance | $paymentCount payments',
      icon: Icons.account_balance_wallet,
      iconColor: isPositiveNet ? AppColors.success500 : AppColors.error500,
      valueColor: isPositiveNet ? AppColors.success500 : AppColors.error500,
      onTap: onTap,
    );
  }
}
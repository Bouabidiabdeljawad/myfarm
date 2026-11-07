import 'package:flutter/material.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/features/member_dashboard/widgets/_stat_card.dart';

/// Card displaying expense statistics
class ExpenseCard extends StatelessWidget {
  final String totalExpenses;
  final int expenseCount;
  final VoidCallback? onTap;

  const ExpenseCard({
    super.key,
    required this.totalExpenses,
    required this.expenseCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _StatCard(
      title: 'Expenses',
      value: totalExpenses,
      subtitle: '$expenseCount transactions',
      icon: Icons.receipt_long,
      iconColor: AppColors.error500,
      valueColor: AppColors.error500,
      onTap: onTap,
    );
  }
}
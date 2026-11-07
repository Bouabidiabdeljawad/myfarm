import 'package:flutter/material.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/features/member_dashboard/widgets/_stat_card.dart';

/// Card displaying feed allocation statistics
class FeedAllocationCard extends StatelessWidget {
  final double dailyFeedKg;
  final double monthlyFeedKg;
  final VoidCallback? onTap;

  const FeedAllocationCard({
    super.key,
    required this.dailyFeedKg,
    required this.monthlyFeedKg,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _StatCard(
      title: 'Feed Allocation',
      value: '${dailyFeedKg.toStringAsFixed(1)} kg/day',
      subtitle: '${monthlyFeedKg.toStringAsFixed(1)} kg/month',
      icon: Icons.grass,
      iconColor: AppColors.forestGreen500,
      onTap: onTap,
    );
  }
}
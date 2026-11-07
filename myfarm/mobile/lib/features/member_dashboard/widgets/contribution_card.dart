import 'package:flutter/material.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/features/member_dashboard/widgets/_stat_card.dart';

/// Card displaying contribution statistics
class ContributionCard extends StatelessWidget {
  final String totalContributions;
  final int contributionCount;
  final VoidCallback? onTap;

  const ContributionCard({
    super.key,
    required this.totalContributions,
    required this.contributionCount,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _StatCard(
      title: 'Contributions',
      value: totalContributions,
      subtitle: '$contributionCount transactions',
      icon: Icons.volunteer_activism,
      iconColor: AppColors.success500,
      valueColor: AppColors.success500,
      onTap: onTap,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/core/theme/app_spacing.dart';
import 'package:my_farm/features/member_dashboard/widgets/_stat_card.dart';

/// Card displaying animal statistics
class MemberAnimalCard extends StatelessWidget {
  final int totalAnimals;
  final double totalWeight;
  final VoidCallback? onTap;

  const MemberAnimalCard({
    super.key,
    required this.totalAnimals,
    required this.totalWeight,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return _StatCard(
      title: 'Animals',
      value: totalAnimals.toString(),
      subtitle: '${totalWeight.toStringAsFixed(1)} kg total weight',
      icon: Icons.pets,
      iconColor: AppColors.olive500,
      onTap: onTap,
    );
  }
}
import 'package:flutter/material.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/core/theme/app_spacing.dart';
import 'package:my_farm/features/member_dashboard/member_dashboard_models.dart';

/// Tile displaying an alert
class AlertTile extends StatelessWidget {
  final AlertProjection alert;

  const AlertTile({
    super.key,
    required this.alert,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.warning500.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.warning500.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.warning_amber_rounded,
            color: AppColors.warning500,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Expanded(
            child: Text(
              alert.message,
              style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                    color: AppColors.neutral800,
                  ),
            ),
          ),
        ],
      ),
    );
  }
}

/// Empty alerts placeholder
class EmptyAlertsPlaceholder extends StatelessWidget {
  const EmptyAlertsPlaceholder({super.key});

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.success500.withValues(alpha: 0.1),
        border: Border.all(color: AppColors.success500.withValues(alpha: 0.3)),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Row(
        children: [
          Icon(
            Icons.check_circle_outline,
            color: AppColors.success500,
            size: 20,
          ),
          const SizedBox(width: AppSpacing.sm),
          Text(
            'No alerts - everything looks good!',
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: AppColors.success500,
                ),
          ),
        ],
      ),
    );
  }
}
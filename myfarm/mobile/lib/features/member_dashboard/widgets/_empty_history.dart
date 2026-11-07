import 'package:flutter/material.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/core/theme/app_spacing.dart';

/// Empty history placeholder
class _EmptyHistory extends StatelessWidget {
  final String message;
  final IconData icon;

  const _EmptyHistory({
    required this.message,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(AppSpacing.xl),
      decoration: BoxDecoration(
        color: Theme.of(context).colorScheme.surfaceContainerHighest,
        border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
        borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      ),
      child: Column(
        children: [
          Icon(
            icon,
            size: 48,
            color: Theme.of(context).colorScheme.onSurfaceVariant.withValues(alpha: 0.5),
          ),
          const SizedBox(height: AppSpacing.sm),
          Text(
            message,
            style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                  color: Theme.of(context).colorScheme.onSurfaceVariant,
                ),
            textAlign: TextAlign.center,
          ),
        ],
      ),
    );
  }
}

/// Load more button for paginated lists
class _LoadMoreButton extends StatelessWidget {
  final bool isLoading;
  final bool hasMore;
  final VoidCallback onPressed;

  const _LoadMoreButton({
    required this.isLoading,
    required this.hasMore,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    if (!hasMore) {
      return const SizedBox.shrink();
    }

    return Padding(
      padding: const EdgeInsets.all(AppSpacing.md),
      child: Center(
        child: isLoading
            ? const CircularProgressIndicator()
            : TextButton.icon(
                onPressed: onPressed,
                icon: const Icon(Icons.keyboard_arrow_down),
                label: const Text('Load More'),
              ),
      ),
    );
  }
}
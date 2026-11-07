import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_farm/core/theme/app_colors.dart';
import 'package:my_farm/core/theme/app_spacing.dart';
import 'package:my_farm/features/member_dashboard/member_dashboard_viewmodel.dart';
import 'package:year_month_picker/year_month_picker.dart';

/// Period selector button with month/year picker
class PeriodSelector extends ConsumerWidget {
  final MemberDashboardViewModel viewModel;

  const PeriodSelector({
    super.key,
    required this.viewModel,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(memberDashboardViewModelProvider(viewModel.memberId));
    final periodFormat = DateFormat('MMMM yyyy');
    final displayText = periodFormat.format(DateTime(state.selectedPeriod.year, state.selectedPeriod.month));

    return InkWell(
      onTap: () => _showPeriodPicker(context),
      borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.md,
          vertical: AppSpacing.sm,
        ),
        decoration: BoxDecoration(
          color: Theme.of(context).colorScheme.surfaceContainerHighest,
          border: Border.all(color: Theme.of(context).colorScheme.outlineVariant),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMd),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(
              Icons.calendar_month,
              size: 20,
              color: Theme.of(context).colorScheme.primary,
            ),
            const SizedBox(width: AppSpacing.sm),
            Text(
              displayText,
              style: Theme.of(context).textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
            ),
            const SizedBox(width: AppSpacing.xs),
            Icon(
              Icons.keyboard_arrow_down,
              size: 20,
              color: Theme.of(context).colorScheme.onSurfaceVariant,
            ),
          ],
        ),
      ),
    );
  }

  Future<void> _showPeriodPicker(BuildContext context) async {
    final state = ref.read(memberDashboardViewModelProvider(viewModel.memberId));
    final currentDate = DateTime(state.selectedPeriod.year, state.selectedPeriod.month);

    final picked = await showYearMonthPickerDialog(
      context: context,
      initialYearMonth: currentDate,
      firstYear: 2020,
      lastYear: DateTime.now().year,
      builder: (context, child) {
        return Theme(
          data: Theme.of(context).copyWith(
            colorScheme: Theme.of(context).colorScheme.copyWith(
              primary: AppColors.olive500,
            ),
          ),
          child: child!,
        );
      },
    );

    if (picked != null) {
      final newPeriod = YearMonth(picked.year, picked.month);
      viewModel.setPeriod(newPeriod);
    }
  }
}
import 'dart:io';

import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:intl/intl.dart';
import 'package:my_farm/core/error/app_exception.dart';
import 'package:my_farm/core/logging/app_logger.dart';
import 'package:my_farm/features/member_dashboard/member_dashboard_api.dart';
import 'package:my_farm/features/member_dashboard/member_dashboard_models.dart';
import 'package:open_file/open_file.dart';
import 'package:path_provider/path_provider.dart';

part 'member_dashboard_viewmodel.freezed.dart';

/// State for the member dashboard
@freezed
class MemberDashboardState with _$MemberDashboardState {
  const factory MemberDashboardState({
    @Default(false) bool isLoading,
    @Default(false) bool isLoadingHistory,
    MemberDashboardDto? dashboard,
    PageResponse<PaymentDto>? paymentsPage,
    PageResponse<FeedAllocationDto>? feedHistoryPage,
    String? error,
    @Default(0) int currentPaymentPage,
    @Default(0) int currentFeedPage,
    required YearMonth selectedPeriod,
  }) = _MemberDashboardState;
}

/// ViewModel for the member dashboard
class MemberDashboardViewModel extends StateNotifier<MemberDashboardState> {
  final int memberId;
  final DateFormat _dateFormat = DateFormat('yyyy-MM-dd');
  final DateFormat _periodFormat = DateFormat('yyyy-MM');

  MemberDashboardViewModel({
    required this.memberId,
    required YearMonth initialPeriod,
  }) : super(MemberDashboardState(selectedPeriod: initialPeriod)) {
    loadDashboard();
  }

  /// Load the main dashboard summary
  Future<void> loadDashboard() async {
    state = state.copyWith(isLoading: true, error: null);

    try {
      final start = _dateFormat.format(DateTime(selectedPeriod.year, selectedPeriod.month, 1));
      final end = _dateFormat.format(DateTime(selectedPeriod.year, selectedPeriod.month + 1, 0));

      final dashboard = await MemberDashboardApi.getDashboard(
        memberId: memberId,
        start: start,
        end: end,
      );

      state = state.copyWith(
        isLoading: false,
        dashboard: dashboard,
        error: null,
      );

      // Load first page of history
      loadPaymentHistory();
      loadFeedHistory();
    } on AppException catch (e, stack) {
      AppLogger.e('Failed to load dashboard', stackTrace: stack);
      state = state.copyWith(
        isLoading: false,
        error: _mapError(e),
      );
    } catch (e, stack) {
      AppLogger.e('Unexpected error loading dashboard', stackTrace: stack);
      state = state.copyWith(
        isLoading: false,
        error: 'An unexpected error occurred',
      );
    }
  }

  /// Load paginated payment history
  Future<void> loadPaymentHistory({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(currentPaymentPage: 0, isLoadingHistory: true);
    } else if (state.paymentsPage != null &&
        state.currentPaymentPage >= state.paymentsPage!.totalPages - 1) {
      return; // Already at last page
    }

    if (!refresh) {
      state = state.copyWith(isLoadingHistory: true);
    }

    try {
      final start = _dateFormat.format(DateTime(selectedPeriod.year, selectedPeriod.month, 1));
      final end = _dateFormat.format(DateTime(selectedPeriod.year, selectedPeriod.month + 1, 0));

      final page = await MemberDashboardApi.getPaymentHistory(
        memberId: memberId,
        start: start,
        end: end,
        page: refresh ? 0 : state.currentPaymentPage,
      );

      if (refresh) {
        state = state.copyWith(
          paymentsPage: page,
          currentPaymentPage: 0,
          isLoadingHistory: false,
        );
      } else {
        // Append to existing page
        final existing = state.paymentsPage?.content ?? [];
        final combined = [...existing, ...page.content];
        final mergedPage = page.copyWith(content: combined);
        state = state.copyWith(
          paymentsPage: mergedPage,
          currentPaymentPage: state.currentPaymentPage + 1,
          isLoadingHistory: false,
        );
      }
    } on AppException catch (e, stack) {
      AppLogger.e('Failed to load payment history', stackTrace: stack);
      state = state.copyWith(
        isLoadingHistory: false,
        error: _mapError(e),
      );
    }
  }

  /// Load paginated feed allocation history
  Future<void> loadFeedHistory({bool refresh = false}) async {
    if (refresh) {
      state = state.copyWith(currentFeedPage: 0, isLoadingHistory: true);
    } else if (state.feedHistoryPage != null &&
        state.currentFeedPage >= state.feedHistoryPage!.totalPages - 1) {
      return; // Already at last page
    }

    if (!refresh) {
      state = state.copyWith(isLoadingHistory: true);
    }

    try {
      final start = _dateFormat.format(DateTime(selectedPeriod.year, selectedPeriod.month, 1));
      final end = _dateFormat.format(DateTime(selectedPeriod.year, selectedPeriod.month + 1, 0));

      final page = await MemberDashboardApi.getFeedHistory(
        memberId: memberId,
        start: start,
        end: end,
        page: refresh ? 0 : state.currentFeedPage,
      );

      if (refresh) {
        state = state.copyWith(
          feedHistoryPage: page,
          currentFeedPage: 0,
          isLoadingHistory: false,
        );
      } else {
        // Append to existing page
        final existing = state.feedHistoryPage?.content ?? [];
        final combined = [...existing, ...page.content];
        final mergedPage = page.copyWith(content: combined);
        state = state.copyWith(
          feedHistoryPage: mergedPage,
          currentFeedPage: state.currentFeedPage + 1,
          isLoadingHistory: false,
        );
      }
    } on AppException catch (e, stack) {
      AppLogger.e('Failed to load feed history', stackTrace: stack);
      state = state.copyWith(
        isLoadingHistory: false,
        error: _mapError(e),
      );
    }
  }

  /// Change the selected period and reload all data
  void setPeriod(YearMonth period) {
    state = state.copyWith(selectedPeriod: period);
    loadDashboard();
  }

  /// Download and save PDF report
  Future<String?> downloadReport() async {
    try {
      final bytes = await MemberDashboardApi.downloadReport(
        memberId: memberId,
        period: _periodFormat.format(DateTime(selectedPeriod.year, selectedPeriod.month)),
      );

      // Save to temp file
      final tempDir = await getTemporaryDirectory();
      final file = File('${tempDir.path}/member_report_${_periodFormat.format(DateTime(selectedPeriod.year, selectedPeriod.month))}.pdf');
      await file.writeAsBytes(bytes);

      // Open the file
      await OpenFile.open(file.path);

      return file.path;
    } on AppException catch (e, stack) {
      AppLogger.e('Failed to download report', stackTrace: stack);
      state = state.copyWith(error: _mapError(e));
      return null;
    } catch (e, stack) {
      AppLogger.e('Unexpected error downloading report', stackTrace: stack);
      state = state.copyWith(error: 'Failed to download report');
      return null;
    }
  }

  String _mapError(AppException e) {
    return switch (e) {
      NetworkException() => 'Network error. Please check your connection.',
      ServerException(:final statusCode) => switch (statusCode) {
          401 => 'Session expired. Please log in again.',
          403 => 'Access denied. You can only view your own dashboard.',
          404 => 'Data not found.',
          500 => 'Server error. Please try again later.',
          _ => 'Server error ($statusCode). Please try again.',
        },
      _ => 'An error occurred. Please try again.',
    };
  }
}

/// Provider for the member dashboard viewmodel
final memberDashboardViewModelProvider = StateNotifierProvider.autoDispose
    .family<MemberDashboardViewModel, MemberDashboardState, int>((ref, memberId) {
  return MemberDashboardViewModel(
    memberId: memberId,
    initialPeriod: YearMonth.now(),
  );
});
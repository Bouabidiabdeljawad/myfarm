import 'package:freezed_annotation/freezed_annotation.dart';
import 'package:intl/intl.dart';

part 'member_dashboard_models.freezed.dart';

/// Simple class to represent a year and month (without day)
/// Used for period selection in the dashboard
@freezed
class YearMonth with _$YearMonth {
  const factory YearMonth({
    required int year,
    required int month,
  }) = _YearMonth;

  /// Create YearMonth from current date
  factory YearMonth.now() {
    final now = DateTime.now();
    return YearMonth(year: now.year, month: now.month);
  }

  /// Create YearMonth from DateTime
  factory YearMonth.fromDateTime(DateTime dateTime) {
    return YearMonth(year: dateTime.year, month: dateTime.month);
  }
}

extension YearMonthExtensions on YearMonth {
  /// Convert to DateTime (first day of month)
  DateTime toDateTime() => DateTime(year, month, 1);

  /// Format as "yyyy-MM"
  String toPeriodString() => '${year.toString().padLeft(4, '0')}-${month.toString().padLeft(2, '0')}';

  /// Format as "MMMM yyyy" for display
  String toDisplayString() {
    final months = [
      'January', 'February', 'March', 'April', 'May', 'June',
      'July', 'August', 'September', 'October', 'November', 'December'
    ];
    return '${months[month - 1]} $year';
  }
}

/// Main dashboard DTO matching backend MemberDashboardDto
class MemberDashboardDto {
  final int totalAnimals;
  final double totalWeight;
  final double dailyFeedKg;
  final double monthlyFeedKg;
  final String totalContributions;
  final int contributionCount;
  final String totalExpenses;
  final int expenseCount;
  final String totalPayments;
  final int paymentCount;
  final String outstandingBalance;
  final String netBalance;
  final List<AlertProjection> alerts;

  MemberDashboardDto({
    required this.totalAnimals,
    required this.totalWeight,
    required this.dailyFeedKg,
    required this.monthlyFeedKg,
    required this.totalContributions,
    required this.contributionCount,
    required this.totalExpenses,
    required this.expenseCount,
    required this.totalPayments,
    required this.paymentCount,
    required this.outstandingBalance,
    required this.netBalance,
    required this.alerts,
  });

  factory MemberDashboardDto.fromJson(Map<String, dynamic> json) {
    return MemberDashboardDto(
      totalAnimals: json['totalAnimals'] ?? 0,
      totalWeight: (json['totalWeight'] ?? 0.0).toDouble(),
      dailyFeedKg: (json['dailyFeedKg'] ?? 0.0).toDouble(),
      monthlyFeedKg: (json['monthlyFeedKg'] ?? 0.0).toDouble(),
      totalContributions: json['totalContributions']?.toString() ?? '0.00',
      contributionCount: json['contributionCount'] ?? 0,
      totalExpenses: json['totalExpenses']?.toString() ?? '0.00',
      expenseCount: json['expenseCount'] ?? 0,
      totalPayments: json['totalPayments']?.toString() ?? '0.00',
      paymentCount: json['paymentCount'] ?? 0,
      outstandingBalance: json['outstandingBalance']?.toString() ?? '0.00',
      netBalance: json['netBalance']?.toString() ?? '0.00',
      alerts: (json['alerts'] as List<dynamic>? ?? [])
          .map((e) => AlertProjection.fromJson(e as Map<String, dynamic>))
          .toList(),
    );
  }

  String get formattedTotalContributions => NumberFormat.currency(locale: 'en_US', symbol: '\$').format(double.tryParse(totalContributions) ?? 0);
  String get formattedTotalExpenses => NumberFormat.currency(locale: 'en_US', symbol: '\$').format(double.tryParse(totalExpenses) ?? 0);
  String get formattedTotalPayments => NumberFormat.currency(locale: 'en_US', symbol: '\$').format(double.tryParse(totalPayments) ?? 0);
  String get formattedOutstandingBalance => NumberFormat.currency(locale: 'en_US', symbol: '\$').format(double.tryParse(outstandingBalance) ?? 0);
  String get formattedNetBalance => NumberFormat.currency(locale: 'en_US', symbol: '\$').format(double.tryParse(netBalance) ?? 0);
}

/// Alert projection
class AlertProjection {
  final String message;

  AlertProjection({required this.message});

  factory AlertProjection.fromJson(Map<String, dynamic> json) {
    return AlertProjection(message: json['message'] ?? '');
  }
}

/// Payment DTO for paginated history
class PaymentDto {
  final int id;
  final String amount;
  final String date;
  final String description;
  final String type;

  PaymentDto({
    required this.id,
    required this.amount,
    required this.date,
    required this.description,
    required this.type,
  });

  factory PaymentDto.fromJson(Map<String, dynamic> json) {
    return PaymentDto(
      id: json['id'] ?? 0,
      amount: json['amount']?.toString() ?? '0.00',
      date: json['date'] ?? '',
      description: json['description'] ?? '',
      type: json['type'] ?? '',
    );
  }
}

/// Feed Allocation DTO for paginated history
class FeedAllocationDto {
  final int id;
  final String feedType;
  final String dailyKg;
  final String monthlyKg;
  final String date;

  FeedAllocationDto({
    required this.id,
    required this.feedType,
    required this.dailyKg,
    required this.monthlyKg,
    required this.date,
  });

  factory FeedAllocationDto.fromJson(Map<String, dynamic> json) {
    return FeedAllocationDto(
      id: json['id'] ?? 0,
      feedType: json['feedType'] ?? '',
      dailyKg: json['dailyKg']?.toString() ?? '0.00',
      monthlyKg: json['monthlyKg']?.toString() ?? '0.00',
      date: json['date'] ?? '',
    );
  }
}

/// Paginated response wrapper
class PageResponse<T> {
  final List<T> content;
  final int totalPages;
  final int totalElements;
  final int number;
  final int size;
  final bool first;
  final bool last;
  final bool empty;
  final Sort sort;
  final Pageable pageable;

  PageResponse({
    required this.content,
    required this.totalPages,
    required this.totalElements,
    required this.number,
    required this.size,
    required this.first,
    required this.last,
    required this.empty,
    required this.sort,
    required this.pageable,
  });

  factory PageResponse.fromJson(Map<String, dynamic> json, T Function(Object?) fromJsonT) {
    return PageResponse<T>(
      content: (json['content'] as List<dynamic>? ?? []).map(fromJsonT).toList(),
      totalPages: json['totalPages'] ?? 0,
      totalElements: json['totalElements'] ?? 0,
      number: json['number'] ?? 0,
      size: json['size'] ?? 20,
      first: json['first'] ?? true,
      last: json['last'] ?? true,
      empty: json['empty'] ?? true,
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>? ?? {}),
      pageable: Pageable.fromJson(json['pageable'] as Map<String, dynamic>? ?? {}),
    );
  }
}

class Sort {
  final bool sorted;
  final bool unsorted;
  final bool empty;

  Sort({required this.sorted, required this.unsorted, required this.empty});

  factory Sort.fromJson(Map<String, dynamic> json) {
    return Sort(
      sorted: json['sorted'] ?? false,
      unsorted: json['unsorted'] ?? true,
      empty: json['empty'] ?? true,
    );
  }
}

class Pageable {
  final int pageNumber;
  final int pageSize;
  final Sort sort;
  final int offset;
  final bool paged;
  final bool unpaged;

  Pageable({
    required this.pageNumber,
    required this.pageSize,
    required this.sort,
    required this.offset,
    required this.paged,
    required this.unpaged,
  });

  factory Pageable.fromJson(Map<String, dynamic> json) {
    return Pageable(
      pageNumber: json['pageNumber'] ?? 0,
      pageSize: json['pageSize'] ?? 20,
      sort: Sort.fromJson(json['sort'] as Map<String, dynamic>? ?? {}),
      offset: json['offset'] ?? 0,
      paged: json['paged'] ?? true,
      unpaged: json['unpaged'] ?? false,
    );
  }
}
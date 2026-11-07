import 'dart:typed_data';

import 'package:dio/dio.dart';
import 'package:my_farm/core/network/api_client.dart';
import 'package:my_farm/features/member_dashboard/member_dashboard_models.dart';

/// API service for member dashboard endpoints
class MemberDashboardApi {
  static const String _basePath = '/member-dashboard';

  /// Get member dashboard summary
  ///
  /// [memberId] - The member ID
  /// [start] - Start date (yyyy-MM-dd)
  /// [end] - End date (yyyy-MM-dd)
  static Future<MemberDashboardDto> getDashboard({
    required int memberId,
    required String start,
    required String end,
  }) async {
    final response = await ApiClient.instance.get(
      '$_basePath',
      queryParameters: {
        'memberId': memberId,
        'start': start,
        'end': end,
      },
    );
    return MemberDashboardDto.fromJson(response.data as Map<String, dynamic>);
  }

  /// Get paginated payment history
  ///
  /// [memberId] - The member ID
  /// [start] - Start date (yyyy-MM-dd)
  /// [end] - End date (yyyy-MM-dd)
  /// [page] - Page number (0-based)
  /// [size] - Page size
  static Future<PageResponse<PaymentDto>> getPaymentHistory({
    required int memberId,
    required String start,
    required String end,
    int page = 0,
    int size = 20,
  }) async {
    final response = await ApiClient.instance.get(
      '$_basePath/payments',
      queryParameters: {
        'memberId': memberId,
        'start': start,
        'end': end,
        'page': page,
        'size': size,
      },
    );
    return PageResponse<PaymentDto>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => PaymentDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Get paginated feed allocation history
  ///
  /// [memberId] - The member ID
  /// [start] - Start date (yyyy-MM-dd)
  /// [end] - End date (yyyy-MM-dd)
  /// [page] - Page number (0-based)
  /// [size] - Page size
  static Future<PageResponse<FeedAllocationDto>> getFeedHistory({
    required int memberId,
    required String start,
    required String end,
    int page = 0,
    int size = 20,
  }) async {
    final response = await ApiClient.instance.get(
      '$_basePath/feed-history',
      queryParameters: {
        'memberId': memberId,
        'start': start,
        'end': end,
        'page': page,
        'size': size,
      },
    );
    return PageResponse<FeedAllocationDto>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => FeedAllocationDto.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Download PDF report
  ///
  /// [memberId] - The member ID
  /// [period] - Period in format "yyyy-MM"
  /// Returns the PDF file bytes
  static Future<Uint8List> downloadReport({
    required int memberId,
    required String period,
  }) async {
    final response = await ApiClient.instance.get(
      '$_basePath/report',
      queryParameters: {
        'memberId': memberId,
        'period': period,
      },
      options: Options(
        responseType: ResponseType.bytes,
        headers: {'Accept': 'application/pdf'},
      ),
    );
    return response.data as Uint8List;
  }
}
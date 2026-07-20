import 'package:freezed_annotation/freezed_annotation.dart';

part 'reports_summary.freezed.dart';
part 'reports_summary.g.dart';

@freezed
class ReportsSummary with _$ReportsSummary {
  const factory ReportsSummary({
    required double totalRevenue,
    required int totalOrders,
    required int totalProducts,
    required double cancelledRatio,
  }) = _ReportsSummary;

  factory ReportsSummary.fromJson(Map<String, dynamic> json) =>
      _$ReportsSummaryFromJson(json);
}
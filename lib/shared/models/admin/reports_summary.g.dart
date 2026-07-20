// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'reports_summary.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ReportsSummaryImpl _$$ReportsSummaryImplFromJson(Map<String, dynamic> json) =>
    _$ReportsSummaryImpl(
      totalRevenue: (json['totalRevenue'] as num).toDouble(),
      totalOrders: (json['totalOrders'] as num).toInt(),
      totalProducts: (json['totalProducts'] as num).toInt(),
      cancelledRatio: (json['cancelledRatio'] as num).toDouble(),
    );

Map<String, dynamic> _$$ReportsSummaryImplToJson(
  _$ReportsSummaryImpl instance,
) => <String, dynamic>{
  'totalRevenue': instance.totalRevenue,
  'totalOrders': instance.totalOrders,
  'totalProducts': instance.totalProducts,
  'cancelledRatio': instance.cancelledRatio,
};

class RecentOrderItem {
  final String? id;
  final double? totalPrice;
  final double? total;
  final String? status;
  final String? createdAt;

  const RecentOrderItem({
    this.id,
    this.totalPrice,
    this.total,
    this.status,
    this.createdAt,
  });

  factory RecentOrderItem.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString());
    }

    final t = parseDouble(json['total'] ?? json['totalPrice']);
    return RecentOrderItem(
      id: json['id'] as String?,
      totalPrice: t,
      total: t,
      status: json['status'] as String?,
      createdAt: json['createdAt'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'totalPrice': totalPrice,
        'total': total,
        'status': status,
        'createdAt': createdAt,
      };
}

class ReportsSummary {
  final double? totalRevenue;
  final int? totalOrders;
  final int? totalProducts;
  final int? totalUsers;
  final double? cancelledRatio;
  final List<RecentOrderItem>? recentOrders;

  const ReportsSummary({
    this.totalRevenue,
    this.totalOrders,
    this.totalProducts,
    this.totalUsers,
    this.cancelledRatio,
    this.recentOrders,
  });

  factory ReportsSummary.fromJson(Map<String, dynamic> json) {
    double? parseDouble(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toDouble();
      return double.tryParse(val.toString());
    }

    int? parseInt(dynamic val) {
      if (val == null) return null;
      if (val is num) return val.toInt();
      return int.tryParse(val.toString());
    }

    List<RecentOrderItem>? parseOrders(dynamic val) {
      if (val is List) {
        return val
            .map((e) => RecentOrderItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return null;
    }

    return ReportsSummary(
      totalRevenue: parseDouble(json['totalRevenue']),
      totalOrders: parseInt(json['totalOrders']),
      totalProducts: parseInt(json['totalProducts']),
      totalUsers: parseInt(json['totalUsers']),
      cancelledRatio: parseDouble(json['cancelledRatio']),
      recentOrders: parseOrders(json['recentOrders']),
    );
  }

  Map<String, dynamic> toJson() => {
        'totalRevenue': totalRevenue,
        'totalOrders': totalOrders,
        'totalProducts': totalProducts,
        'totalUsers': totalUsers,
        'cancelledRatio': cancelledRatio,
        'recentOrders': recentOrders?.map((e) => e.toJson()).toList(),
      };
}
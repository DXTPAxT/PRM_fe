import 'order_item.dart';

class Order {
  final String id;
  final String? userId;
  final String? addressId;
  final String? voucherId;
  final double total;
  final String status;
  final List<OrderItem> items;
  final String? createdAt;

  const Order({
    required this.id,
    this.userId,
    this.addressId,
    this.voucherId,
    required this.total,
    required this.status,
    this.items = const [],
    this.createdAt,
  });

  factory Order.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    List<OrderItem> parseItems(dynamic val) {
      if (val is List) {
        return val
            .map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
            .toList();
      }
      return [];
    }

    return Order(
      id: json['id'] as String? ?? '',
      userId: json['userId'] as String? ??
          json['user_id'] as String? ??
          (json['user'] is Map ? json['user']['id'] as String? : null),
      addressId: json['addressId'] as String? ?? json['address_id'] as String?,
      voucherId: json['voucherId'] as String? ?? json['voucher_id'] as String?,
      total: parseDouble(json['total']),
      status: json['status'] as String? ?? 'pending_payment',
      items: parseItems(json['items']),
      createdAt: json['createdAt'] as String? ?? json['created_at'] as String?,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'userId': userId,
        'addressId': addressId,
        'voucherId': voucherId,
        'total': total,
        'status': status,
        'items': items.map((e) => e.toJson()).toList(),
        'createdAt': createdAt,
      };
}

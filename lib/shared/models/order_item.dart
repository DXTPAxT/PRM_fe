class OrderItem {
  final String id;
  final String? orderId;
  final String? variantId;
  final int quantity;
  final double unitPrice;

  const OrderItem({
    required this.id,
    this.orderId,
    this.variantId,
    required this.quantity,
    required this.unitPrice,
  });

  factory OrderItem.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    int parseInt(dynamic val) {
      if (val == null) return 1;
      if (val is num) return val.toInt();
      if (val is String) return int.tryParse(val) ?? 1;
      return 1;
    }

    return OrderItem(
      id: json['id'] as String? ?? '',
      orderId: json['orderId'] as String? ?? json['order_id'] as String?,
      variantId: json['variantId'] as String? ?? json['variant_id'] as String?,
      quantity: parseInt(json['quantity']),
      unitPrice: parseDouble(json['unitPrice'] ?? json['unit_price']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'orderId': orderId,
        'variantId': variantId,
        'quantity': quantity,
        'unitPrice': unitPrice,
      };
}

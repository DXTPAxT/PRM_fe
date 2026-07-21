class Voucher {
  final String id;
  final String code;
  final double discount;
  final double minOrder;
  final String? expiresAt;
  final bool isActive;

  const Voucher({
    required this.id,
    required this.code,
    required this.discount,
    required this.minOrder,
    this.expiresAt,
    this.isActive = true,
  });

  factory Voucher.fromJson(Map<String, dynamic> json) {
    double parseDouble(dynamic val) {
      if (val == null) return 0.0;
      if (val is num) return val.toDouble();
      if (val is String) return double.tryParse(val) ?? 0.0;
      return 0.0;
    }

    return Voucher(
      id: json['id'] as String? ?? '',
      code: json['code'] as String? ?? '',
      discount: parseDouble(json['discount']),
      minOrder: parseDouble(json['minOrder'] ?? json['min_order']),
      expiresAt: json['expiresAt'] as String? ?? json['expires_at'] as String?,
      isActive: json['isActive'] as bool? ?? json['is_active'] as bool? ?? true,
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'code': code,
        'discount': discount,
        'minOrder': minOrder,
        'expiresAt': expiresAt,
        'isActive': isActive,
      };
}

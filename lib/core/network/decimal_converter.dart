import 'package:freezed_annotation/freezed_annotation.dart';

/// Chuyển field Decimal của Prisma sang double.
///
/// Prisma serialize `Decimal` thành **chuỗi** để không mất độ chính xác
/// (vd `"199000"`), trong khi các số tính bằng JS ở tầng service lại là number
/// (vd `lineTotal: 398000`). Cùng một response có thể lẫn cả hai kiểu, nên mọi
/// field tiền tệ phải đi qua converter này — nếu để `double` trần sẽ nổ
/// `type 'String' is not a subtype of type 'num' in type cast`.
class DecimalConverter implements JsonConverter<double, dynamic> {
  const DecimalConverter();

  @override
  double fromJson(dynamic json) {
    if (json == null) return 0;
    if (json is num) return json.toDouble();
    if (json is String) return double.tryParse(json) ?? 0;
    return 0;
  }

  @override
  dynamic toJson(double object) => object;
}

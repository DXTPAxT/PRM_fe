import 'package:freezed_annotation/freezed_annotation.dart';

part 'voucher.freezed.dart';
part 'voucher.g.dart';

@freezed
class Voucher with _$Voucher {
  const factory Voucher({
    required String id,
    required String code,
    required double discount,
    @JsonKey(name: 'min_order') required double minOrder,
    @JsonKey(name: 'expires_at') required String expiresAt,
  }) = _Voucher;

  factory Voucher.fromJson(Map<String, dynamic> json) => _$VoucherFromJson(json);
}

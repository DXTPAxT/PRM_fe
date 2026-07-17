import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_variant.freezed.dart';
part 'product_variant.g.dart';

@freezed
class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required String id,
    @JsonKey(name: 'product_id') required String productId,
    required String size,
    required String color,
    required double price,
    @JsonKey(name: 'stock_qty') required int stockQty,
    required String sku,
  }) = _ProductVariant;

  factory ProductVariant.fromJson(Map<String, dynamic> json) => _$ProductVariantFromJson(json);
}

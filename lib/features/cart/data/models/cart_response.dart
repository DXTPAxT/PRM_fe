import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/decimal_converter.dart';

part 'cart_response.freezed.dart';
part 'cart_response.g.dart';

/// Mirror response của `GET /cart` (BE `CartService.toResponse`).
/// KHÔNG mirror bảng DB — chỉ mirror shape API trả về.
@freezed
class CartResponse with _$CartResponse {
  const factory CartResponse({
    required String id,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    @Default([]) List<CartLineItem> items,
    @DecimalConverter() @Default(0) double subtotal,
  }) = _CartResponse;

  factory CartResponse.fromJson(Map<String, dynamic> json) =>
      _$CartResponseFromJson(json);
}

@freezed
class CartLineItem with _$CartLineItem {
  const factory CartLineItem({
    required String id,
    required int quantity,
    required CartVariant variant,
    required CartProduct product,
    @JsonKey(name: 'lineTotal') @DecimalConverter() @Default(0) double lineTotal,
  }) = _CartLineItem;

  factory CartLineItem.fromJson(Map<String, dynamic> json) =>
      _$CartLineItemFromJson(json);
}

@freezed
class CartVariant with _$CartVariant {
  const factory CartVariant({
    required String id,
    required String size,
    required String color,
    @DecimalConverter() @Default(0) double price,
    @JsonKey(name: 'stockQty') required int stockQty,
    required String sku,
  }) = _CartVariant;

  factory CartVariant.fromJson(Map<String, dynamic> json) =>
      _$CartVariantFromJson(json);
}

@freezed
class CartProduct with _$CartProduct {
  const factory CartProduct({
    required String id,
    required String name,
    required String status,
    String? image,
  }) = _CartProduct;

  factory CartProduct.fromJson(Map<String, dynamic> json) =>
      _$CartProductFromJson(json);
}

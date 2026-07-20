import 'package:freezed_annotation/freezed_annotation.dart';

import '../../../../core/network/decimal_converter.dart';

part 'order_detail.freezed.dart';
part 'order_detail.g.dart';

/// Mirror response `GET /orders/:id` và mỗi phần tử của `GET /orders`
/// (BE `ORDER_DETAIL_SELECT`). KHÔNG mirror bảng DB — model shared/order.dart
/// không đủ field (thiếu discount/shippingFee/payment/address) nên feature tự
/// định nghĩa model riêng theo đúng shape API.
@freezed
class OrderDetail with _$OrderDetail {
  const factory OrderDetail({
    required String id,
    @JsonKey(name: 'userId') required String userId,
    @JsonKey(name: 'addressId') required String addressId,
    @JsonKey(name: 'voucherId') String? voucherId,
    @DecimalConverter() @Default(0) double subtotal,
    @DecimalConverter() @Default(0) double discount,
    @JsonKey(name: 'shippingFee')
    @DecimalConverter()
    @Default(0)
    double shippingFee,
    @DecimalConverter() @Default(0) double total,
    required String status,
    @JsonKey(name: 'shippingCode') String? shippingCode,
    @JsonKey(name: 'createdAt') required DateTime createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    OrderAddress? address,
    @Default([]) List<OrderLineItem> items,
    OrderPayment? payment,
  }) = _OrderDetail;

  factory OrderDetail.fromJson(Map<String, dynamic> json) =>
      _$OrderDetailFromJson(json);
}

@freezed
class OrderAddress with _$OrderAddress {
  const factory OrderAddress({
    required String id,
    @JsonKey(name: 'fullName') required String fullName,
    required String phone,
    required String detail,
  }) = _OrderAddress;

  factory OrderAddress.fromJson(Map<String, dynamic> json) =>
      _$OrderAddressFromJson(json);
}

@freezed
class OrderLineItem with _$OrderLineItem {
  const factory OrderLineItem({
    required String id,
    required int quantity,
    @JsonKey(name: 'unitPrice') @DecimalConverter() @Default(0) double unitPrice,
    required OrderLineVariant variant,
  }) = _OrderLineItem;

  factory OrderLineItem.fromJson(Map<String, dynamic> json) =>
      _$OrderLineItemFromJson(json);
}

@freezed
class OrderLineVariant with _$OrderLineVariant {
  const factory OrderLineVariant({
    required String id,
    required String size,
    required String color,
    required String sku,
    required OrderLineProduct product,
  }) = _OrderLineVariant;

  factory OrderLineVariant.fromJson(Map<String, dynamic> json) =>
      _$OrderLineVariantFromJson(json);
}

@freezed
class OrderLineProduct with _$OrderLineProduct {
  const factory OrderLineProduct({
    required String id,
    required String name,
  }) = _OrderLineProduct;

  factory OrderLineProduct.fromJson(Map<String, dynamic> json) =>
      _$OrderLineProductFromJson(json);
}

@freezed
class OrderPayment with _$OrderPayment {
  const factory OrderPayment({
    required String id,
    required String method,
    required String status,
    @DecimalConverter() @Default(0) double amount,
    @JsonKey(name: 'paidAt') DateTime? paidAt,
  }) = _OrderPayment;

  factory OrderPayment.fromJson(Map<String, dynamic> json) =>
      _$OrderPaymentFromJson(json);
}

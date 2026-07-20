// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order_detail.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderDetailImpl _$$OrderDetailImplFromJson(Map<String, dynamic> json) =>
    _$OrderDetailImpl(
      id: json['id'] as String,
      userId: json['userId'] as String,
      addressId: json['addressId'] as String,
      voucherId: json['voucherId'] as String?,
      subtotal: json['subtotal'] == null
          ? 0
          : const DecimalConverter().fromJson(json['subtotal']),
      discount: json['discount'] == null
          ? 0
          : const DecimalConverter().fromJson(json['discount']),
      shippingFee: json['shippingFee'] == null
          ? 0
          : const DecimalConverter().fromJson(json['shippingFee']),
      total: json['total'] == null
          ? 0
          : const DecimalConverter().fromJson(json['total']),
      status: json['status'] as String,
      shippingCode: json['shippingCode'] as String?,
      createdAt: DateTime.parse(json['createdAt'] as String),
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      address: json['address'] == null
          ? null
          : OrderAddress.fromJson(json['address'] as Map<String, dynamic>),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => OrderLineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      payment: json['payment'] == null
          ? null
          : OrderPayment.fromJson(json['payment'] as Map<String, dynamic>),
    );

Map<String, dynamic> _$$OrderDetailImplToJson(_$OrderDetailImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'userId': instance.userId,
      'addressId': instance.addressId,
      'voucherId': instance.voucherId,
      'subtotal': const DecimalConverter().toJson(instance.subtotal),
      'discount': const DecimalConverter().toJson(instance.discount),
      'shippingFee': const DecimalConverter().toJson(instance.shippingFee),
      'total': const DecimalConverter().toJson(instance.total),
      'status': instance.status,
      'shippingCode': instance.shippingCode,
      'createdAt': instance.createdAt.toIso8601String(),
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'address': instance.address,
      'items': instance.items,
      'payment': instance.payment,
    };

_$OrderAddressImpl _$$OrderAddressImplFromJson(Map<String, dynamic> json) =>
    _$OrderAddressImpl(
      id: json['id'] as String,
      fullName: json['fullName'] as String,
      phone: json['phone'] as String,
      detail: json['detail'] as String,
    );

Map<String, dynamic> _$$OrderAddressImplToJson(_$OrderAddressImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'fullName': instance.fullName,
      'phone': instance.phone,
      'detail': instance.detail,
    };

_$OrderLineItemImpl _$$OrderLineItemImplFromJson(Map<String, dynamic> json) =>
    _$OrderLineItemImpl(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      unitPrice: json['unitPrice'] == null
          ? 0
          : const DecimalConverter().fromJson(json['unitPrice']),
      variant: OrderLineVariant.fromJson(
        json['variant'] as Map<String, dynamic>,
      ),
    );

Map<String, dynamic> _$$OrderLineItemImplToJson(_$OrderLineItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'unitPrice': const DecimalConverter().toJson(instance.unitPrice),
      'variant': instance.variant,
    };

_$OrderLineVariantImpl _$$OrderLineVariantImplFromJson(
  Map<String, dynamic> json,
) => _$OrderLineVariantImpl(
  id: json['id'] as String,
  size: json['size'] as String,
  color: json['color'] as String,
  sku: json['sku'] as String,
  product: OrderLineProduct.fromJson(json['product'] as Map<String, dynamic>),
);

Map<String, dynamic> _$$OrderLineVariantImplToJson(
  _$OrderLineVariantImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'size': instance.size,
  'color': instance.color,
  'sku': instance.sku,
  'product': instance.product,
};

_$OrderLineProductImpl _$$OrderLineProductImplFromJson(
  Map<String, dynamic> json,
) => _$OrderLineProductImpl(
  id: json['id'] as String,
  name: json['name'] as String,
);

Map<String, dynamic> _$$OrderLineProductImplToJson(
  _$OrderLineProductImpl instance,
) => <String, dynamic>{'id': instance.id, 'name': instance.name};

_$OrderPaymentImpl _$$OrderPaymentImplFromJson(Map<String, dynamic> json) =>
    _$OrderPaymentImpl(
      id: json['id'] as String,
      method: json['method'] as String,
      status: json['status'] as String,
      amount: json['amount'] == null
          ? 0
          : const DecimalConverter().fromJson(json['amount']),
      paidAt: json['paidAt'] == null
          ? null
          : DateTime.parse(json['paidAt'] as String),
    );

Map<String, dynamic> _$$OrderPaymentImplToJson(_$OrderPaymentImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'method': instance.method,
      'status': instance.status,
      'amount': const DecimalConverter().toJson(instance.amount),
      'paidAt': instance.paidAt?.toIso8601String(),
    };

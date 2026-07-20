// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'cart_response.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$CartResponseImpl _$$CartResponseImplFromJson(Map<String, dynamic> json) =>
    _$CartResponseImpl(
      id: json['id'] as String,
      updatedAt: json['updatedAt'] == null
          ? null
          : DateTime.parse(json['updatedAt'] as String),
      items:
          (json['items'] as List<dynamic>?)
              ?.map((e) => CartLineItem.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      subtotal: json['subtotal'] == null
          ? 0
          : const DecimalConverter().fromJson(json['subtotal']),
    );

Map<String, dynamic> _$$CartResponseImplToJson(_$CartResponseImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'updatedAt': instance.updatedAt?.toIso8601String(),
      'items': instance.items,
      'subtotal': const DecimalConverter().toJson(instance.subtotal),
    };

_$CartLineItemImpl _$$CartLineItemImplFromJson(Map<String, dynamic> json) =>
    _$CartLineItemImpl(
      id: json['id'] as String,
      quantity: (json['quantity'] as num).toInt(),
      variant: CartVariant.fromJson(json['variant'] as Map<String, dynamic>),
      product: CartProduct.fromJson(json['product'] as Map<String, dynamic>),
      lineTotal: json['lineTotal'] == null
          ? 0
          : const DecimalConverter().fromJson(json['lineTotal']),
    );

Map<String, dynamic> _$$CartLineItemImplToJson(_$CartLineItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'quantity': instance.quantity,
      'variant': instance.variant,
      'product': instance.product,
      'lineTotal': const DecimalConverter().toJson(instance.lineTotal),
    };

_$CartVariantImpl _$$CartVariantImplFromJson(Map<String, dynamic> json) =>
    _$CartVariantImpl(
      id: json['id'] as String,
      size: json['size'] as String,
      color: json['color'] as String,
      price: json['price'] == null
          ? 0
          : const DecimalConverter().fromJson(json['price']),
      stockQty: (json['stockQty'] as num).toInt(),
      sku: json['sku'] as String,
    );

Map<String, dynamic> _$$CartVariantImplToJson(_$CartVariantImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'size': instance.size,
      'color': instance.color,
      'price': const DecimalConverter().toJson(instance.price),
      'stockQty': instance.stockQty,
      'sku': instance.sku,
    };

_$CartProductImpl _$$CartProductImplFromJson(Map<String, dynamic> json) =>
    _$CartProductImpl(
      id: json['id'] as String,
      name: json['name'] as String,
      status: json['status'] as String,
      image: json['image'] as String?,
    );

Map<String, dynamic> _$$CartProductImplToJson(_$CartProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'name': instance.name,
      'status': instance.status,
      'image': instance.image,
    };

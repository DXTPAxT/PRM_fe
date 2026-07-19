// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductVariantImpl _$$ProductVariantImplFromJson(Map<String, dynamic> json) =>
    _$ProductVariantImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      size: json['size'] as String,
      color: json['color'] as String,
      price: (json['price'] as num).toDouble(),
      stockQty: (json['stockQty'] as num).toInt(),
      sku: json['sku'] as String,
    );

Map<String, dynamic> _$$ProductVariantImplToJson(
  _$ProductVariantImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'productId': instance.productId,
  'size': instance.size,
  'color': instance.color,
  'price': instance.price,
  'stockQty': instance.stockQty,
  'sku': instance.sku,
};

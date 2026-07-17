// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product_variant.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductVariantImpl _$$ProductVariantImplFromJson(Map<String, dynamic> json) =>
    _$ProductVariantImpl(
      id: json['id'] as String,
      productId: json['product_id'] as String,
      size: json['size'] as String,
      color: json['color'] as String,
      price: (json['price'] as num).toDouble(),
      stockQty: (json['stock_qty'] as num).toInt(),
      sku: json['sku'] as String,
    );

Map<String, dynamic> _$$ProductVariantImplToJson(
  _$ProductVariantImpl instance,
) => <String, dynamic>{
  'id': instance.id,
  'product_id': instance.productId,
  'size': instance.size,
  'color': instance.color,
  'price': instance.price,
  'stock_qty': instance.stockQty,
  'sku': instance.sku,
};

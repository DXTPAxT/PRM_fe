// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'wishlist_item.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$WishlistItemImpl _$$WishlistItemImplFromJson(Map<String, dynamic> json) =>
    _$WishlistItemImpl(
      id: json['id'] as String,
      productId: json['productId'] as String,
      productName: json['productName'] as String,
      basePrice: json['basePrice'] == null
          ? 0
          : const DecimalConverter().fromJson(json['basePrice']),
      status: json['status'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$WishlistItemImplToJson(_$WishlistItemImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'productId': instance.productId,
      'productName': instance.productName,
      'basePrice': const DecimalConverter().toJson(instance.basePrice),
      'status': instance.status,
      'thumbnailUrl': instance.thumbnailUrl,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

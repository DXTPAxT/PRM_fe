// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'product.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$ProductImpl _$$ProductImplFromJson(Map<String, dynamic> json) =>
    _$ProductImpl(
      id: json['id'] as String,
      categoryId: json['categoryId'] as String,
      categoryName: json['categoryName'] as String? ?? '',
      name: json['name'] as String,
      description: json['description'] as String?,
      basePrice: (json['basePrice'] as num).toDouble(),
      status: json['status'] as String,
      thumbnailUrl: json['thumbnailUrl'] as String?,
      avgRating: (json['avgRating'] as num?)?.toDouble() ?? 0,
      reviewCount: (json['reviewCount'] as num?)?.toInt() ?? 0,
      images:
          (json['images'] as List<dynamic>?)
              ?.map((e) => ProductImage.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      variants:
          (json['variants'] as List<dynamic>?)
              ?.map((e) => ProductVariant.fromJson(e as Map<String, dynamic>))
              .toList() ??
          const [],
      createdAt: json['createdAt'] == null
          ? null
          : DateTime.parse(json['createdAt'] as String),
    );

Map<String, dynamic> _$$ProductImplToJson(_$ProductImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'categoryId': instance.categoryId,
      'categoryName': instance.categoryName,
      'name': instance.name,
      'description': instance.description,
      'basePrice': instance.basePrice,
      'status': instance.status,
      'thumbnailUrl': instance.thumbnailUrl,
      'avgRating': instance.avgRating,
      'reviewCount': instance.reviewCount,
      'images': instance.images,
      'variants': instance.variants,
      'createdAt': instance.createdAt?.toIso8601String(),
    };

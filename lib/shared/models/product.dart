import 'package:freezed_annotation/freezed_annotation.dart';
import 'product_image.dart';
import 'product_variant.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String categoryId,
    @Default('') String categoryName,
    required String name,
    String? description,
    required double basePrice,
    required String status,
    String? thumbnailUrl,
    @Default(0) double avgRating,
    @Default(0) int reviewCount,
    @Default([]) List<ProductImage> images,
    @Default([]) List<ProductVariant> variants,
    DateTime? createdAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}

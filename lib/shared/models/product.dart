import 'package:freezed_annotation/freezed_annotation.dart';
import 'product_variant.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    @JsonKey(name: 'category_id') required String categoryId,
    required String name,
    @JsonKey(name: 'base_price') required double basePrice,
    required String status,
    @Default([]) List<ProductVariant> variants,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) => _$ProductFromJson(json);
}

import 'package:freezed_annotation/freezed_annotation.dart';
import '../../../../core/network/decimal_converter.dart';

part 'wishlist_item.freezed.dart';
part 'wishlist_item.g.dart';

@freezed
class WishlistItem with _$WishlistItem {
  const factory WishlistItem({
    required String id,
    required String productId,
    required String productName,
    @DecimalConverter() @Default(0) double basePrice,
    required String status,
    String? thumbnailUrl,
    DateTime? createdAt,
  }) = _WishlistItem;

  factory WishlistItem.fromJson(Map<String, dynamic> json) =>
      _$WishlistItemFromJson(json);
}

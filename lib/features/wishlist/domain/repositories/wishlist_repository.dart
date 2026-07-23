import '../../data/models/wishlist_item.dart';

abstract class WishlistRepository {
  Future<List<WishlistItem>> getWishlist();
  Future<void> addToWishlist(String productId);
  Future<void> removeFromWishlist(String productId);
  Future<bool> isInWishlist(String productId);
}

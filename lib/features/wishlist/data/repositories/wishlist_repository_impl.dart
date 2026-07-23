import '../../domain/repositories/wishlist_repository.dart';
import '../datasources/wishlist_remote_data_source.dart';
import '../models/wishlist_item.dart';

class WishlistRepositoryImpl implements WishlistRepository {
  final WishlistRemoteDataSource _remote;

  WishlistRepositoryImpl(this._remote);

  @override
  Future<List<WishlistItem>> getWishlist() async {
    final response = await _remote.getWishlist();
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Không thể tải danh sách yêu thích.');
  }

  @override
  Future<void> addToWishlist(String productId) async {
    final response = await _remote.addToWishlist(productId);
    if (!response.success) {
      throw Exception(response.message ?? 'Thêm yêu thích thất bại.');
    }
  }

  @override
  Future<void> removeFromWishlist(String productId) async {
    final response = await _remote.removeFromWishlist(productId);
    if (!response.success) {
      throw Exception(response.message ?? 'Xóa yêu thích thất bại.');
    }
  }

  @override
  Future<bool> isInWishlist(String productId) => _remote.isInWishlist(productId);
}

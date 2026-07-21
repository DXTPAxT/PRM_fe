import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../models/wishlist_item.dart';

class WishlistRemoteDataSource {
  final DioClient _dioClient;

  WishlistRemoteDataSource(this._dioClient);

  Future<ApiResponse<List<WishlistItem>>> getWishlist() async {
    final response = await _dioClient.get('/wishlist');
    final json = response.data as Map<String, dynamic>;
    return ApiResponse<List<WishlistItem>>.fromJson(
      json,
      (data) => (data as List<dynamic>)
          .map((item) => WishlistItem.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<void>> addToWishlist(String productId) async {
    final response = await _dioClient.post(
      '/wishlist',
      data: {'productId': productId},
    );
    return ApiResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (_) {},
    );
  }

  Future<ApiResponse<void>> removeFromWishlist(String productId) async {
    final response = await _dioClient.delete('/wishlist/$productId');
    return ApiResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (_) {},
    );
  }

  Future<bool> isInWishlist(String productId) async {
    final response = await _dioClient.get('/wishlist/check/$productId');
    final json = response.data as Map<String, dynamic>;
    final data = json['data'] as Map<String, dynamic>?;
    return data?['inWishlist'] as bool? ?? false;
  }
}

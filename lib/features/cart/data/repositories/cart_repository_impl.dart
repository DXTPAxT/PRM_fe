import '../../domain/repositories/cart_repository.dart';
import '../datasources/cart_remote_data_source.dart';
import '../models/cart_response.dart';

class CartRepositoryImpl implements CartRepository {
  final CartRemoteDataSource _remoteDataSource;

  CartRepositoryImpl(this._remoteDataSource);

  @override
  Future<CartResponse> getCart() async {
    final response = await _remoteDataSource.getCart();
    return _unwrap(response, 'Không thể tải giỏ hàng.');
  }

  @override
  Future<CartResponse> addItem({
    required String variantId,
    required int quantity,
  }) async {
    final response = await _remoteDataSource.addItem(
      variantId: variantId,
      quantity: quantity,
    );
    return _unwrap(response, 'Thêm vào giỏ hàng thất bại.');
  }

  @override
  Future<CartResponse> updateItem({
    required String itemId,
    required int quantity,
  }) async {
    final response = await _remoteDataSource.updateItem(
      itemId: itemId,
      quantity: quantity,
    );
    return _unwrap(response, 'Cập nhật số lượng thất bại.');
  }

  @override
  Future<CartResponse> removeItem(String itemId) async {
    final response = await _remoteDataSource.removeItem(itemId);
    return _unwrap(response, 'Xóa sản phẩm khỏi giỏ thất bại.');
  }

  @override
  Future<CartResponse> clear() async {
    final response = await _remoteDataSource.clear();
    return _unwrap(response, 'Xóa giỏ hàng thất bại.');
  }

  CartResponse _unwrap(dynamic response, String fallbackMessage) {
    if (response.success && response.data != null) {
      return response.data as CartResponse;
    }
    throw Exception(response.message ?? fallbackMessage);
  }
}

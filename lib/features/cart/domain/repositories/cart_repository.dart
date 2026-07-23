import '../../data/models/cart_response.dart';

abstract class CartRepository {
  Future<CartResponse> getCart();
  Future<CartResponse> addItem({
    required String variantId,
    required int quantity,
  });
  Future<CartResponse> updateItem({
    required String itemId,
    required int quantity,
  });
  Future<CartResponse> removeItem(String itemId);
  Future<CartResponse> clear();
}

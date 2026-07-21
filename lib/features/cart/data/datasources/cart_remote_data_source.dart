import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../models/cart_response.dart';

class CartRemoteDataSource {
  final DioClient _dioClient;

  CartRemoteDataSource(this._dioClient);

  Future<ApiResponse<CartResponse>> getCart() async {
    final response = await _dioClient.get('/cart');
    return _parse(response.data as Map<String, dynamic>);
  }

  Future<ApiResponse<CartResponse>> addItem({
    required String variantId,
    required int quantity,
  }) async {
    final response = await _dioClient.post(
      '/cart/items',
      data: {'variantId': variantId, 'quantity': quantity},
    );
    return _parse(response.data as Map<String, dynamic>);
  }

  Future<ApiResponse<CartResponse>> updateItem({
    required String itemId,
    required int quantity,
  }) async {
    final response = await _dioClient.patch(
      '/cart/items/$itemId',
      data: {'quantity': quantity},
    );
    return _parse(response.data as Map<String, dynamic>);
  }

  Future<ApiResponse<CartResponse>> removeItem(String itemId) async {
    final response = await _dioClient.delete('/cart/items/$itemId');
    return _parse(response.data as Map<String, dynamic>);
  }

  Future<ApiResponse<CartResponse>> clear() async {
    final response = await _dioClient.delete('/cart');
    return _parse(response.data as Map<String, dynamic>);
  }

  ApiResponse<CartResponse> _parse(Map<String, dynamic> json) {
    return ApiResponse<CartResponse>.fromJson(
      json,
      (data) => CartResponse.fromJson(data as Map<String, dynamic>),
    );
  }
}

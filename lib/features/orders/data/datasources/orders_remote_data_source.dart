import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../models/order_detail.dart';

class OrdersRemoteDataSource {
  final DioClient _dioClient;

  OrdersRemoteDataSource(this._dioClient);

  /// Tạo đơn từ giỏ hàng hiện tại (checkout). `POST /orders`.
  Future<ApiResponse<OrderDetail>> createOrder({
    required String addressId,
    required String paymentMethod,
    String? voucherId,
    int? toDistrictId,
    String? toWardCode,
  }) async {
    final response = await _dioClient.post(
      '/orders',
      data: {
        'addressId': addressId,
        'paymentMethod': paymentMethod,
        if (voucherId != null) 'voucherId': voucherId,
        if (toDistrictId != null) 'toDistrictId': toDistrictId,
        if (toWardCode != null) 'toWardCode': toWardCode,
      },
    );
    return _parseOne(response.data as Map<String, dynamic>);
  }

  /// Danh sách đơn của mình (phân trang, lọc theo status). `GET /orders`.
  Future<PagedResponse<OrderDetail>> getOrders({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dioClient.get(
      '/orders',
      queryParameters: {
        if (status != null) 'status': status,
        'page': page,
        'limit': limit,
      },
    );
    return PagedResponse<OrderDetail>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => OrderDetail.fromJson(json as Map<String, dynamic>),
    );
  }

  /// Chi tiết một đơn. `GET /orders/:id`.
  Future<ApiResponse<OrderDetail>> getOrderDetail(String id) async {
    final response = await _dioClient.get('/orders/$id');
    return _parseOne(response.data as Map<String, dynamic>);
  }

  /// Hủy đơn. `PATCH /orders/:id/cancel`.
  Future<ApiResponse<OrderDetail>> cancelOrder(String id) async {
    final response = await _dioClient.patch('/orders/$id/cancel');
    return _parseOne(response.data as Map<String, dynamic>);
  }

  /// Đánh giá sản phẩm đã mua. `POST /reviews`.
  Future<ApiResponse<dynamic>> createReview({
    required String productId,
    required int rating,
    String? comment,
  }) async {
    final response = await _dioClient.post(
      '/reviews',
      data: {
        'productId': productId,
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      },
    );
    return ApiResponse<dynamic>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json,
    );
  }

  ApiResponse<OrderDetail> _parseOne(Map<String, dynamic> json) {
    return ApiResponse<OrderDetail>.fromJson(
      json,
      (data) => OrderDetail.fromJson(data as Map<String, dynamic>),
    );
  }
}

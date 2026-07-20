import '../../domain/repositories/orders_repository.dart';
import '../datasources/orders_remote_data_source.dart';
import '../models/order_detail.dart';

class OrdersRepositoryImpl implements OrdersRepository {
  final OrdersRemoteDataSource _remoteDataSource;

  OrdersRepositoryImpl(this._remoteDataSource);

  @override
  Future<OrderDetail> createOrder({
    required String addressId,
    required String paymentMethod,
    String? voucherId,
    int? toDistrictId,
    String? toWardCode,
  }) async {
    final response = await _remoteDataSource.createOrder(
      addressId: addressId,
      paymentMethod: paymentMethod,
      voucherId: voucherId,
      toDistrictId: toDistrictId,
      toWardCode: toWardCode,
    );
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Đặt hàng thất bại.');
  }

  @override
  Future<OrdersPage> getOrders({
    String? status,
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _remoteDataSource.getOrders(
      status: status,
      page: page,
      limit: limit,
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Không thể tải danh sách đơn hàng.');
    }
    return OrdersPage(
      items: response.data,
      page: response.meta.page,
      totalPages: response.meta.totalPages,
    );
  }

  @override
  Future<OrderDetail> getOrderDetail(String id) async {
    final response = await _remoteDataSource.getOrderDetail(id);
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Không thể tải chi tiết đơn hàng.');
  }

  @override
  Future<OrderDetail> cancelOrder(String id) async {
    final response = await _remoteDataSource.cancelOrder(id);
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Hủy đơn hàng thất bại.');
  }

  @override
  Future<void> submitReview({
    required String productId,
    required int rating,
    String? comment,
  }) async {
    final response = await _remoteDataSource.createReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Gửi đánh giá thất bại.');
    }
  }
}

import '../../data/models/order_detail.dart';

/// Kết quả phân trang danh sách đơn hàng.
class OrdersPage {
  final List<OrderDetail> items;
  final int page;
  final int totalPages;

  const OrdersPage({
    required this.items,
    required this.page,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;
}

abstract class OrdersRepository {
  Future<OrderDetail> createOrder({
    required String addressId,
    required String paymentMethod,
    String? voucherId,
    int? toDistrictId,
    String? toWardCode,
  });
  Future<OrdersPage> getOrders({String? status, int page, int limit});
  Future<OrderDetail> getOrderDetail(String id);
  Future<OrderDetail> cancelOrder(String id);
  Future<void> submitReview({
    required String productId,
    required int rating,
    String? comment,
  });
}

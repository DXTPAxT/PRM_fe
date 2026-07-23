import '../../data/models/order_detail.dart';
import '../repositories/orders_repository.dart';

class CreateOrderUseCase {
  final OrdersRepository _repository;
  CreateOrderUseCase(this._repository);

  Future<OrderDetail> call({
    required String addressId,
    required String paymentMethod,
    String? voucherId,
    int? toDistrictId,
    String? toWardCode,
  }) =>
      _repository.createOrder(
        addressId: addressId,
        paymentMethod: paymentMethod,
        voucherId: voucherId,
        toDistrictId: toDistrictId,
        toWardCode: toWardCode,
      );
}

class GetOrdersListUseCase {
  final OrdersRepository _repository;
  GetOrdersListUseCase(this._repository);

  Future<OrdersPage> call({String? status, int page = 1, int limit = 20}) =>
      _repository.getOrders(status: status, page: page, limit: limit);
}

class GetOrderDetailUseCase {
  final OrdersRepository _repository;
  GetOrderDetailUseCase(this._repository);

  Future<OrderDetail> call(String id) => _repository.getOrderDetail(id);
}

class CancelOrderUseCase {
  final OrdersRepository _repository;
  CancelOrderUseCase(this._repository);

  Future<OrderDetail> call(String id) => _repository.cancelOrder(id);
}

class SubmitReviewUseCase {
  final OrdersRepository _repository;
  SubmitReviewUseCase(this._repository);

  Future<void> call({
    required String productId,
    required int rating,
    String? comment,
  }) =>
      _repository.submitReview(
        productId: productId,
        rating: rating,
        comment: comment,
      );
}

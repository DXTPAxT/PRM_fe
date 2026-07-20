import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../checkout/presentation/providers/checkout_provider.dart';
import '../../data/models/order_detail.dart';
import '../../domain/repositories/orders_repository.dart';
import 'orders_provider.dart';

class OrderDetailState {
  final OrderDetail? order;
  final bool isLoading;
  final bool isCancelling;
  final bool isSubmittingReview;
  final bool isRetryingPayment;
  final String? errorMessage;

  const OrderDetailState({
    this.order,
    this.isLoading = false,
    this.isCancelling = false,
    this.isSubmittingReview = false,
    this.isRetryingPayment = false,
    this.errorMessage,
  });

  OrderDetailState copyWith({
    OrderDetail? order,
    bool? isLoading,
    bool? isCancelling,
    bool? isSubmittingReview,
    bool? isRetryingPayment,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OrderDetailState(
      order: order ?? this.order,
      isLoading: isLoading ?? this.isLoading,
      isCancelling: isCancelling ?? this.isCancelling,
      isSubmittingReview: isSubmittingReview ?? this.isSubmittingReview,
      isRetryingPayment: isRetryingPayment ?? this.isRetryingPayment,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class OrderDetailNotifier extends StateNotifier<OrderDetailState> {
  final Ref _ref;
  final String orderId;

  OrderDetailNotifier(this._ref, this.orderId)
      : super(const OrderDetailState()) {
    load();
  }

  OrdersRepository get _repo => _ref.read(ordersRepositoryProvider);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final order = await _repo.getOrderDetail(orderId);
      state = state.copyWith(order: order, isLoading: false, clearError: true);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: _message(error));
    }
  }

  /// Hủy đơn. Trả về true nếu thành công (để UI hiện SnackBar/pop).
  Future<bool> cancel() async {
    state = state.copyWith(isCancelling: true, clearError: true);
    try {
      final order = await _repo.cancelOrder(orderId);
      state = state.copyWith(order: order, isCancelling: false);
      return true;
    } catch (error) {
      state = state.copyWith(isCancelling: false, errorMessage: _message(error));
      return false;
    }
  }

  /// Giả lập kết quả thanh toán qua `simulate-callback` — dùng để demo/kiểm
  /// thử cổng thanh toán online mà không cần cổng VNPay sandbox thật. Sau khi
  /// gọi, tải lại đơn để phản ánh trạng thái mới. Trả về true nếu gọi thành công.
  Future<bool> simulatePayment(bool success) async {
    state = state.copyWith(isRetryingPayment: true, clearError: true);
    try {
      await _ref
          .read(checkoutDataSourceProvider)
          .simulatePayment(orderId: orderId, success: success);
      await load();
      return true;
    } catch (error) {
      state = state.copyWith(
        isRetryingPayment: false,
        errorMessage: _message(error),
      );
      return false;
    }
  }

  Future<bool> submitReview({
    required String productId,
    required int rating,
    String? comment,
  }) async {
    state = state.copyWith(isSubmittingReview: true, clearError: true);
    try {
      await _repo.submitReview(
        productId: productId,
        rating: rating,
        comment: comment,
      );
      state = state.copyWith(isSubmittingReview: false);
      return true;
    } catch (error) {
      state =
          state.copyWith(isSubmittingReview: false, errorMessage: _message(error));
      return false;
    }
  }

  String _message(Object error) =>
      error.toString().replaceFirst('Exception: ', '');
}

final orderDetailProvider = StateNotifierProvider.family
    .autoDispose<OrderDetailNotifier, OrderDetailState, String>((ref, orderId) {
  return OrderDetailNotifier(ref, orderId);
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../orders/data/models/order_detail.dart';
import '../../../orders/presentation/providers/orders_provider.dart';
import '../../data/datasources/checkout_remote_data_source.dart';

/// Phương thức thanh toán — khớp enum `PaymentMethod` của BE.
enum PaymentMethodType {
  cod('cod', 'Thanh toán khi nhận hàng (COD)'),
  vnpay('vnpay', 'VNPay'),
  momo('momo', 'MoMo'),
  zalopay('zalopay', 'ZaloPay');

  final String value;
  final String label;
  const PaymentMethodType(this.value, this.label);

  bool get isOnline => this != PaymentMethodType.cod;
}

final checkoutDataSourceProvider = Provider<CheckoutRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CheckoutRemoteDataSource(dioClient);
});

class CheckoutState {
  final String? selectedAddressId;
  final PaymentMethodType paymentMethod;
  final bool isSubmitting;
  final String? errorMessage;

  const CheckoutState({
    this.selectedAddressId,
    this.paymentMethod = PaymentMethodType.cod,
    this.isSubmitting = false,
    this.errorMessage,
  });

  CheckoutState copyWith({
    String? selectedAddressId,
    PaymentMethodType? paymentMethod,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CheckoutState(
      selectedAddressId: selectedAddressId ?? this.selectedAddressId,
      paymentMethod: paymentMethod ?? this.paymentMethod,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

/// Kết quả sau khi tạo đơn — screen dựa vào đây để điều hướng / mở dialog.
class PlaceOrderResult {
  final OrderDetail order;

  /// Cần giả lập callback (mọi phương thức online: VNPay/Momo/ZaloPay).
  ///
  /// VNPay sandbox thật yêu cầu Return URL/IPN truy cập được từ internet
  /// (VNPay gọi ngược vào backend) — không khả thi khi chạy backend local,
  /// nên toàn bộ thanh toán online đều dùng `simulate-callback` để demo.
  final bool needsSimulate;

  const PlaceOrderResult({
    required this.order,
    this.needsSimulate = false,
  });

  bool get isCod => !needsSimulate;
}

class CheckoutNotifier extends StateNotifier<CheckoutState> {
  final Ref _ref;

  CheckoutNotifier(this._ref) : super(const CheckoutState());

  void selectAddress(String addressId) {
    state = state.copyWith(selectedAddressId: addressId);
  }

  void selectPaymentMethod(PaymentMethodType method) {
    state = state.copyWith(paymentMethod: method);
  }

  /// Tạo đơn. Trả về PlaceOrderResult nếu thành công, null nếu lỗi
  /// (errorMessage đã được set).
  Future<PlaceOrderResult?> placeOrder() async {
    final addressId = state.selectedAddressId;
    if (addressId == null) {
      state = state.copyWith(errorMessage: 'Vui lòng chọn địa chỉ giao hàng.');
      return null;
    }

    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      final order = await _ref.read(ordersRepositoryProvider).createOrder(
            addressId: addressId,
            paymentMethod: state.paymentMethod.value,
          );

      state = state.copyWith(isSubmitting: false);

      // Điều phối theo phương thức thanh toán: mọi phương thức online
      // (VNPay/Momo/ZaloPay) đều giả lập callback ở màn hình — xem ghi chú
      // ở PlaceOrderResult.needsSimulate.
      if (state.paymentMethod.isOnline) {
        return PlaceOrderResult(order: order, needsSimulate: true);
      }
      return PlaceOrderResult(order: order); // COD
    } catch (error) {
      state = state.copyWith(
        isSubmitting: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
      return null;
    }
  }

  /// Gọi giả lập thanh toán cho Momo/ZaloPay.
  Future<bool> simulatePayment(String orderId, bool success) async {
    try {
      await _ref
          .read(checkoutDataSourceProvider)
          .simulatePayment(orderId: orderId, success: success);
      return true;
    } catch (error) {
      state = state.copyWith(
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
      return false;
    }
  }
}

final checkoutProvider =
    StateNotifierProvider.autoDispose<CheckoutNotifier, CheckoutState>((ref) {
  return CheckoutNotifier(ref);
});

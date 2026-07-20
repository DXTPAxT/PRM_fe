import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';

/// Chỉ phụ trách phần thanh toán. Việc tạo đơn (`POST /orders`) tái dùng
/// `OrdersRepository` của feature orders (checkout phụ thuộc orders theo README).
class CheckoutRemoteDataSource {
  final DioClient _dioClient;

  CheckoutRemoteDataSource(this._dioClient);

  /// Giả lập callback cổng thanh toán (demo cho VNPay/Momo/ZaloPay — xem
  /// ghi chú ở `PlaceOrderResult.needsSimulate`).
  /// `POST /payments/orders/:id/simulate-callback`.
  Future<void> simulatePayment({
    required String orderId,
    required bool success,
  }) async {
    final response = await _dioClient.post(
      '/payments/orders/$orderId/simulate-callback',
      data: {'result': success ? 'paid' : 'failed'},
    );
    final parsed = ApiResponse<dynamic>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json,
    );
    if (!parsed.success) {
      throw Exception(parsed.message ?? 'Xử lý thanh toán thất bại.');
    }
  }
}

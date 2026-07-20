import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../shared/models/order.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/voucher.dart';
import '../../../../shared/models/admin/reports_summary.dart';

class AdminRemoteDataSource {
  final DioClient _dioClient;

  AdminRemoteDataSource(this._dioClient);

  // Products
  Future<ApiResponse<List<Product>>> getProducts() async {
    final response = await _dioClient.get('/products');
    return ApiResponse<List<Product>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((item) => Product.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<Product>> createProduct(Map<String, dynamic> data) async {
    final response = await _dioClient.post('/products', data: data);
    return ApiResponse<Product>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Product.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Product>> updateProduct(String id, Map<String, dynamic> data) async {
    final response = await _dioClient.put('/products/$id', data: data);
    return ApiResponse<Product>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Product.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<void>> deleteProduct(String id) async {
    final response = await _dioClient.delete('/products/$id');
    return ApiResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (_) {},
    );
  }

  // Orders
  Future<ApiResponse<List<Order>>> getOrders() async {
    final response = await _dioClient.get('/admin/orders');
    return ApiResponse<List<Order>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((item) => Order.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<Order>> updateOrderStatus(String id, String status) async {
    final response = await _dioClient.patch('/admin/orders/$id', data: {'status': status});
    return ApiResponse<Order>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Order.fromJson(json as Map<String, dynamic>),
    );
  }

  // Vouchers
  Future<ApiResponse<List<Voucher>>> getVouchers() async {
    final response = await _dioClient.get('/admin/vouchers');
    return ApiResponse<List<Voucher>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((item) => Voucher.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<ApiResponse<Voucher>> createVoucher(Map<String, dynamic> data) async {
    final response = await _dioClient.post('/admin/vouchers', data: data);
    return ApiResponse<Voucher>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Voucher.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Voucher>> updateVoucher(String id, Map<String, dynamic> data) async {
    final response = await _dioClient.put('/admin/vouchers/$id', data: data);
    return ApiResponse<Voucher>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Voucher.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<void>> deleteVoucher(String id) async {
    final response = await _dioClient.delete('/admin/vouchers/$id');
    return ApiResponse<void>.fromJson(
      response.data as Map<String, dynamic>,
      (_) {},
    );
  }

  // Reports
  Future<ApiResponse<ReportsSummary>> getReportsSummary() async {
    final response = await _dioClient.get('/admin/reports/summary');
    return ApiResponse<ReportsSummary>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => ReportsSummary.fromJson(json as Map<String, dynamic>),
    );
  }
}
import '../../../../shared/models/order.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/voucher.dart';
import '../../../../shared/models/admin/admin_user.dart';
import '../../../../shared/models/admin/reports_summary.dart';
import '../../domain/repositories/admin_repository.dart';
import '../datasources/admin_remote_data_source.dart';

class AdminRepositoryImpl implements AdminRepository {
  final AdminRemoteDataSource _remoteDataSource;

  AdminRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Product>> getProducts() async {
    final response = await _remoteDataSource.getProducts();
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Không thể tải danh sách sản phẩm.');
  }

  @override
  Future<Product> createProduct(Map<String, dynamic> data) async {
    final response = await _remoteDataSource.createProduct(data);
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Tạo sản phẩm thất bại.');
  }

  @override
  Future<Product> updateProduct(String id, Map<String, dynamic> data) async {
    final response = await _remoteDataSource.updateProduct(id, data);
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Cập nhật sản phẩm thất bại.');
  }

  @override
  Future<void> deleteProduct(String id) async {
    final response = await _remoteDataSource.deleteProduct(id);
    if (!response.success) {
      throw Exception(response.message ?? 'Xóa sản phẩm thất bại.');
    }
  }

  @override
  Future<List<Order>> getOrders() async {
    final response = await _remoteDataSource.getOrders();
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Không thể tải danh sách đơn hàng.');
  }

  @override
  Future<Order> updateOrderStatus(String id, String status) async {
    final response = await _remoteDataSource.updateOrderStatus(id, status);
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Cập nhật trạng thái đơn hàng thất bại.');
  }

  @override
  Future<List<AdminUser>> getUsers() async {
    final response = await _remoteDataSource.getUsers();
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Không thể tải danh sách người dùng.');
  }

  @override
  Future<AdminUser> updateUserRole(String id, String role) async {
    final response = await _remoteDataSource.updateUserRole(id, role);
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Cập nhật vai trò thất bại.');
  }

  @override
  Future<AdminUser> toggleUserActive(String id) async {
    final response = await _remoteDataSource.toggleUserActive(id);
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Thay đổi trạng thái thất bại.');
  }

  @override
  Future<List<Voucher>> getVouchers() async {
    final response = await _remoteDataSource.getVouchers();
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Không thể tải danh sách voucher.');
  }

  @override
  Future<Voucher> createVoucher(Map<String, dynamic> data) async {
    final response = await _remoteDataSource.createVoucher(data);
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Tạo voucher thất bại.');
  }

  @override
  Future<Voucher> updateVoucher(String id, Map<String, dynamic> data) async {
    final response = await _remoteDataSource.updateVoucher(id, data);
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Cập nhật voucher thất bại.');
  }

  @override
  Future<void> deleteVoucher(String id) async {
    final response = await _remoteDataSource.deleteVoucher(id);
    if (!response.success) {
      throw Exception(response.message ?? 'Xóa voucher thất bại.');
    }
  }

  @override
  Future<ReportsSummary> getReportsSummary() async {
    final response = await _remoteDataSource.getReportsSummary();
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Không thể tải báo cáo tổng quan.');
  }
}
import '../../../../shared/models/order.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/voucher.dart';
import '../../../../shared/models/admin/admin_user.dart';
import '../../../../shared/models/admin/reports_summary.dart';

abstract class AdminRepository {
  // Products
  Future<List<Product>> getProducts();
  Future<Product> createProduct(Map<String, dynamic> data);
  Future<Product> updateProduct(String id, Map<String, dynamic> data);
  Future<void> deleteProduct(String id);

  // Orders
  Future<List<Order>> getOrders();
  Future<Order> updateOrderStatus(String id, String status);

  // Users
  Future<List<AdminUser>> getUsers();
  Future<AdminUser> updateUserRole(String id, String role);
  Future<AdminUser> toggleUserActive(String id);

  // Vouchers
  Future<List<Voucher>> getVouchers();
  Future<Voucher> createVoucher(Map<String, dynamic> data);
  Future<Voucher> updateVoucher(String id, Map<String, dynamic> data);
  Future<void> deleteVoucher(String id);

  // Reports
  Future<ReportsSummary> getReportsSummary();
}
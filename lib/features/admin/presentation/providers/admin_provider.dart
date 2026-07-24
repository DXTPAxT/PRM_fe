import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/order.dart';
import '../../../../shared/models/voucher.dart';
import '../../../../shared/models/admin/admin_user.dart';
import '../../../../shared/models/admin/reports_summary.dart';
import '../../data/datasources/admin_remote_data_source.dart';
import '../../data/repositories/admin_repository_impl.dart';
import '../../domain/repositories/admin_repository.dart';

// Remote Data Source Provider
final adminRemoteDataSourceProvider = Provider<AdminRemoteDataSource>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return AdminRemoteDataSource(dioClient);
});

// Repository Provider
final adminRepositoryProvider = Provider<AdminRepository>((ref) {
  final dataSource = ref.watch(adminRemoteDataSourceProvider);
  return AdminRepositoryImpl(dataSource);
});

// Admin Dashboard State
class AdminDashboardState {
  final ReportsSummary? summary;
  final bool isLoading;
  final String? error;

  const AdminDashboardState({
    this.summary,
    this.isLoading = false,
    this.error,
  });
}

// Admin Dashboard Provider
final adminDashboardProvider =
    StateNotifierProvider<AdminDashboardNotifier, AdminDashboardState>((ref) {
  return AdminDashboardNotifier(ref);
});

class AdminDashboardNotifier extends StateNotifier<AdminDashboardState> {
  final Ref _ref;

  AdminDashboardNotifier(this._ref) : super(const AdminDashboardState()) {
    loadSummary();
  }

  Future<void> loadSummary() async {
    state = const AdminDashboardState(isLoading: true);
    try {
      final repository = _ref.read(adminRepositoryProvider);
      final summary = await repository.getReportsSummary();
      state = AdminDashboardState(summary: summary);
    } catch (e) {
      state = AdminDashboardState(error: e.toString());
    }
  }
}

// Admin Orders State
class AdminOrdersState {
  final List<Order> orders;
  final bool isLoading;
  final String? error;

  const AdminOrdersState({
    this.orders = const [],
    this.isLoading = false,
    this.error,
  });
}

// Admin Orders Provider
final adminOrdersProvider =
    StateNotifierProvider<AdminOrdersNotifier, AdminOrdersState>((ref) {
  return AdminOrdersNotifier(ref);
});

class AdminOrdersNotifier extends StateNotifier<AdminOrdersState> {
  final Ref _ref;

  AdminOrdersNotifier(this._ref) : super(const AdminOrdersState()) {
    loadOrders();
  }

  Future<void> loadOrders() async {
    state = const AdminOrdersState(isLoading: true);
    try {
      final repository = _ref.read(adminRepositoryProvider);
      final orders = await repository.getOrders();
      state = AdminOrdersState(orders: orders);
    } catch (e) {
      state = AdminOrdersState(error: e.toString());
    }
  }

  Future<void> updateOrderStatus(String orderId, String status) async {
    try {
      final repository = _ref.read(adminRepositoryProvider);
      await repository.updateOrderStatus(orderId, status);
      await loadOrders(); // Reload orders
    } catch (e) {
      state = AdminOrdersState(orders: state.orders, error: e.toString());
    }
  }
}

// Admin Products State
class AdminProductsState {
  final List<Product> products;
  final bool isLoading;
  final String? error;

  const AdminProductsState({
    this.products = const [],
    this.isLoading = false,
    this.error,
  });
}

// Admin Products Provider
final adminProductsProvider =
    StateNotifierProvider<AdminProductsNotifier, AdminProductsState>((ref) {
  return AdminProductsNotifier(ref);
});

class AdminProductsNotifier extends StateNotifier<AdminProductsState> {
  final Ref _ref;

  AdminProductsNotifier(this._ref) : super(const AdminProductsState());

  Future<void> loadProducts() async {
    state = const AdminProductsState(isLoading: true);
    try {
      final repository = _ref.read(adminRepositoryProvider);
      final products = await repository.getProducts();
      state = AdminProductsState(products: products);
    } catch (e) {
      state = AdminProductsState(
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> createProduct(Map<String, dynamic> data) async {
    try {
      final repository = _ref.read(adminRepositoryProvider);
      await repository.createProduct(data);
      await loadProducts();
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = AdminProductsState(products: state.products, error: msg);
      return false;
    }
  }

  Future<bool> updateProduct(String id, Map<String, dynamic> data) async {
    try {
      final repository = _ref.read(adminRepositoryProvider);
      await repository.updateProduct(id, data);
      await loadProducts();
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = AdminProductsState(products: state.products, error: msg);
      return false;
    }
  }

  Future<bool> deleteProduct(String id) async {
    try {
      final repository = _ref.read(adminRepositoryProvider);
      await repository.deleteProduct(id);
      await loadProducts();
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = AdminProductsState(products: state.products, error: msg);
      return false;
    }
  }

  void clearError() {
    state = AdminProductsState(
      products: state.products,
      isLoading: state.isLoading,
    );
  }
}

// Admin Users State
class AdminUsersState {
  final List<AdminUser> users;
  final bool isLoading;
  final String? error;

  const AdminUsersState({
    this.users = const [],
    this.isLoading = false,
    this.error,
  });
}

// Admin Users Provider
final adminUsersProvider =
    StateNotifierProvider<AdminUsersNotifier, AdminUsersState>((ref) {
  return AdminUsersNotifier(ref);
});

class AdminUsersNotifier extends StateNotifier<AdminUsersState> {
  final Ref _ref;

  AdminUsersNotifier(this._ref) : super(const AdminUsersState()) {
    loadUsers();
  }

  Future<void> loadUsers() async {
    state = const AdminUsersState(isLoading: true);
    try {
      final repository = _ref.read(adminRepositoryProvider);
      final users = await repository.getUsers();
      state = AdminUsersState(users: users);
    } catch (e) {
      state = AdminUsersState(error: e.toString());
    }
  }

  Future<void> updateUserRole(String userId, String role) async {
    try {
      final repository = _ref.read(adminRepositoryProvider);
      await repository.updateUserRole(userId, role);
      await loadUsers();
    } catch (e) {
      state = AdminUsersState(users: state.users, error: e.toString());
    }
  }

  Future<void> toggleUserActive(String userId) async {
    try {
      final repository = _ref.read(adminRepositoryProvider);
      await repository.toggleUserActive(userId);
      await loadUsers();
    } catch (e) {
      state = AdminUsersState(users: state.users, error: e.toString());
    }
  }
}

// Admin Vouchers State
class AdminVouchersState {
  final List<Voucher> vouchers;
  final bool isLoading;
  final String? error;

  const AdminVouchersState({
    this.vouchers = const [],
    this.isLoading = false,
    this.error,
  });
}

// Admin Vouchers Provider
final adminVouchersProvider =
    StateNotifierProvider<AdminVouchersNotifier, AdminVouchersState>((ref) {
  return AdminVouchersNotifier(ref);
});

class AdminVouchersNotifier extends StateNotifier<AdminVouchersState> {
  final Ref _ref;

  AdminVouchersNotifier(this._ref) : super(const AdminVouchersState()) {
    loadVouchers();
  }

  Future<void> loadVouchers() async {
    state = const AdminVouchersState(isLoading: true);
    try {
      final repository = _ref.read(adminRepositoryProvider);
      final vouchers = await repository.getVouchers();
      state = AdminVouchersState(vouchers: vouchers);
    } catch (e) {
      state = AdminVouchersState(
        error: e.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<bool> createVoucher(Map<String, dynamic> data) async {
    try {
      final repository = _ref.read(adminRepositoryProvider);
      await repository.createVoucher(data);
      await loadVouchers();
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = AdminVouchersState(vouchers: state.vouchers, error: msg);
      return false;
    }
  }

  Future<bool> updateVoucher(String id, Map<String, dynamic> data) async {
    try {
      final repository = _ref.read(adminRepositoryProvider);
      await repository.updateVoucher(id, data);
      await loadVouchers();
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = AdminVouchersState(vouchers: state.vouchers, error: msg);
      return false;
    }
  }

  Future<bool> deleteVoucher(String id) async {
    try {
      final repository = _ref.read(adminRepositoryProvider);
      await repository.deleteVoucher(id);
      await loadVouchers();
      return true;
    } catch (e) {
      final msg = e.toString().replaceFirst('Exception: ', '');
      state = AdminVouchersState(vouchers: state.vouchers, error: msg);
      return false;
    }
  }

  void clearError() {
    state = AdminVouchersState(
      vouchers: state.vouchers,
      isLoading: state.isLoading,
    );
  }
}
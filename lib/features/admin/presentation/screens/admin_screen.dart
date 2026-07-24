import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../widgets/admin_dashboard_tab.dart';
import '../widgets/admin_orders_tab.dart';
import '../widgets/admin_products_tab.dart';
import '../widgets/admin_users_tab.dart';
import '../widgets/admin_vouchers_tab.dart';

class AdminScreen extends ConsumerStatefulWidget {
  const AdminScreen({super.key});

  @override
  ConsumerState<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends ConsumerState<AdminScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 5, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Quản trị hệ thống'),
        actions: [
          IconButton(
            icon: const Icon(Icons.logout),
            tooltip: 'Đăng xuất',
            onPressed: () => _confirmLogout(context),
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          isScrollable: true,
          tabs: const [
            Tab(icon: Icon(Icons.dashboard_outlined), text: 'Tổng quan'),
            Tab(icon: Icon(Icons.shopping_cart_outlined), text: 'Đơn hàng'),
            Tab(icon: Icon(Icons.inventory_2_outlined), text: 'Hàng hóa'),
            Tab(icon: Icon(Icons.people_outlined), text: 'Người dùng'),
            Tab(icon: Icon(Icons.local_offer_outlined), text: 'Voucher'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: const [
          AdminDashboardTab(),
          AdminOrdersTab(),
          AdminProductsTab(),
          AdminUsersTab(),
          AdminVouchersTab(),
        ],
      ),
    );
  }

  void _confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Đăng xuất'),
        content: const Text('Bạn có chắc chắn muốn đăng xuất?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              Navigator.pop(ctx);
              ref.read(authProvider.notifier).logout();
            },
            child: const Text('Đăng xuất'),
          ),
        ],
      ),
    );
  }
}
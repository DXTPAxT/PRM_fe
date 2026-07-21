import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_provider.dart';

class AdminDashboardTab extends ConsumerWidget {
  const AdminDashboardTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final dashboardState = ref.watch(adminDashboardProvider);

    if (dashboardState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (dashboardState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Lỗi: ${dashboardState.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(adminDashboardProvider.notifier).loadSummary(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    final summary = dashboardState.summary;
    if (summary == null) {
      return const Center(child: Text('Không có dữ liệu'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(adminDashboardProvider.notifier).loadSummary(),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Tổng quan',
              style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 16),
            _buildStatCards(summary),
            const SizedBox(height: 24),
            const Text(
              'Đơn hàng gần đây',
              style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: 8),
            _buildRecentOrders(summary),
          ],
        ),
      ),
    );
  }

  Widget _buildStatCards(dynamic summary) {
    final double revenue = (summary.totalRevenue ?? 0).toDouble();
    return GridView.count(
      crossAxisCount: 2,
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      mainAxisSpacing: 12,
      crossAxisSpacing: 12,
      childAspectRatio: 1.5,
      children: [
        _buildStatCard(
          'Tổng sản phẩm',
          '${summary.totalProducts ?? 0}',
          Icons.inventory_2_outlined,
          Colors.blue,
        ),
        _buildStatCard(
          'Tổng đơn hàng',
          '${summary.totalOrders ?? 0}',
          Icons.shopping_cart_outlined,
          Colors.green,
        ),
        _buildStatCard(
          'Doanh thu',
          _formatCurrency(revenue),
          Icons.attach_money_outlined,
          Colors.orange,
        ),
        _buildStatCard(
          'Tổng người dùng',
          '${summary.totalUsers ?? 0}',
          Icons.people_outlined,
          Colors.purple,
        ),
      ],
    );
  }

  Widget _buildStatCard(String title, String value, IconData icon, Color color) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Icon(icon, color: color, size: 28),
            const Spacer(),
            Text(
              value,
              style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
            ),
            Text(
              title,
              style: TextStyle(fontSize: 12, color: Colors.grey[600]),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildRecentOrders(dynamic summary) {
    final orders = summary.recentOrders;
    if (orders == null || orders.isEmpty) {
      return const Card(
        child: Padding(
          padding: EdgeInsets.all(16),
          child: Text('Chưa có đơn hàng nào'),
        ),
      );
    }

    return Card(
      child: ListView.builder(
        shrinkWrap: true,
        physics: const NeverScrollableScrollPhysics(),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          final double itemTotal = (order.totalPrice ?? order.total ?? 0).toDouble();
          return ListTile(
            leading: const Icon(Icons.receipt_long_outlined),
            title: Text('Đơn #${order.id ?? ''}'),
            subtitle: Text('${order.status ?? 'Chưa xác định'}'),
            trailing: Text(_formatCurrency(itemTotal)),
          );
        },
      ),
    );
  }

  String _formatCurrency(double amount) {
    return '${amount.toStringAsFixed(0).replaceAllMapped(RegExp(r'(\d{1,3})(?=(\d{3})+(?!\d))'), (Match m) => '${m[1]}.')}đ';
  }
}
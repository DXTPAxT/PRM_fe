import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/admin_provider.dart';

class AdminOrdersTab extends ConsumerWidget {
  const AdminOrdersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final ordersState = ref.watch(adminOrdersProvider);

    if (ordersState.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (ordersState.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Lỗi: ${ordersState.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(adminOrdersProvider.notifier).loadOrders(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    final orders = ordersState.orders;
    if (orders.isEmpty) {
      return const Center(child: Text('Chưa có đơn hàng nào'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(adminOrdersProvider.notifier).loadOrders(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: orders.length,
        itemBuilder: (context, index) {
          final order = orders[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.receipt_long_outlined),
              title: Text('Đơn #${order.id}'),
              subtitle: Text('Trạng thái: ${_mapStatus(order.status)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text(
                    '${order.total.toStringAsFixed(0)}đ',
                    style: const TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(width: 8),
                  PopupMenuButton<String>(
                    onSelected: (status) {
                      ref.read(adminOrdersProvider.notifier).updateOrderStatus(order.id, status);
                    },
                    itemBuilder: (context) => [
                      const PopupMenuItem(value: 'pending', child: Text('Chờ xử lý')),
                      const PopupMenuItem(value: 'confirmed', child: Text('Đã xác nhận')),
                      const PopupMenuItem(value: 'shipped', child: Text('Đang giao')),
                      const PopupMenuItem(value: 'delivered', child: Text('Đã giao')),
                      const PopupMenuItem(value: 'cancelled', child: Text('Đã hủy')),
                    ],
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _mapStatus(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ xử lý';
      case 'confirmed':
        return 'Đã xác nhận';
      case 'shipped':
        return 'Đang giao';
      case 'delivered':
        return 'Đã giao';
      case 'cancelled':
        return 'Đã hủy';
      default:
        return status;
    }
  }
}
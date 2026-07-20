import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/voucher.dart';
import '../providers/admin_provider.dart';

class AdminVouchersTab extends ConsumerWidget {
  const AdminVouchersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final vouchersState = ref.watch(adminVouchersProvider);

    return Scaffold(
      body: _buildBody(context, ref, vouchersState),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateVoucherDialog(context, ref),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, AdminVouchersState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Lỗi: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(adminVouchersProvider.notifier).loadVouchers(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    final vouchers = state.vouchers;
    if (vouchers.isEmpty) {
      return const Center(child: Text('Chưa có voucher nào'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(adminVouchersProvider.notifier).loadVouchers(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: vouchers.length,
        itemBuilder: (context, index) {
          final voucher = vouchers[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.local_offer_outlined),
              title: Text(voucher.code),
              subtitle: Text('Giảm ${_formatDiscount(voucher.discount)}'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () => _showEditVoucherDialog(context, ref, voucher),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () => _confirmDelete(context, ref, voucher.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  String _formatDiscount(dynamic discount) {
    if (discount == null) return '0%';
    if (discount is double) {
      return '${discount.toStringAsFixed(0)}%';
    }
    return '$discount%';
  }

  void _showCreateVoucherDialog(BuildContext context, WidgetRef ref) {
    final codeController = TextEditingController();
    final discountController = TextEditingController();

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Tạo voucher mới'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Mã voucher',
                hintText: 'Nhập mã voucher',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: discountController,
              decoration: const InputDecoration(
                labelText: 'Giảm giá (%)',
                hintText: 'Nhập phần trăm giảm giá',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (codeController.text.isNotEmpty && discountController.text.isNotEmpty) {
                final discount = double.tryParse(discountController.text) ?? 0;
                ref.read(adminVouchersProvider.notifier).createVoucher({
                  'code': codeController.text,
                  'discount': discount,
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  void _showEditVoucherDialog(BuildContext context, WidgetRef ref, Voucher voucher) {
    final codeController = TextEditingController(text: voucher.code);
    final discountController = TextEditingController(
      text: voucher.discount.toString(),
    );

    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Chỉnh sửa voucher'),
        content: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            TextField(
              controller: codeController,
              decoration: const InputDecoration(
                labelText: 'Mã voucher',
                hintText: 'Nhập mã voucher',
              ),
            ),
            const SizedBox(height: 16),
            TextField(
              controller: discountController,
              decoration: const InputDecoration(
                labelText: 'Giảm giá (%)',
                hintText: 'Nhập phần trăm giảm giá',
              ),
              keyboardType: TextInputType.number,
            ),
          ],
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              if (codeController.text.isNotEmpty && discountController.text.isNotEmpty) {
                final discount = double.tryParse(discountController.text) ?? 0;
                ref.read(adminVouchersProvider.notifier).updateVoucher(voucher.id, {
                  'code': codeController.text,
                  'discount': discount,
                });
                Navigator.pop(context);
              }
            },
            child: const Text('Cập nhật'),
          ),
        ],
      ),
    );
  }

  void _confirmDelete(BuildContext context, WidgetRef ref, String voucherId) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa voucher này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(adminVouchersProvider.notifier).deleteVoucher(voucherId);
              Navigator.pop(context);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
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

    if (state.error != null && state.vouchers.isEmpty) {
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
              leading: Icon(
                Icons.local_offer_outlined,
                color: voucher.isActive ? Colors.green : Colors.grey,
              ),
              title: Text(
                voucher.code,
                style: TextStyle(
                  decoration: voucher.isActive ? null : TextDecoration.lineThrough,
                  color: voucher.isActive ? null : Colors.grey,
                ),
              ),
              subtitle: Text(
                'Giảm ${_formatDiscount(voucher.discount)} · Đơn tối thiểu: ${voucher.minOrder.toStringAsFixed(0)} VNĐ',
              ),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  Switch(
                    value: voucher.isActive,
                    onChanged: (newVal) async {
                      final success = await ref
                          .read(adminVouchersProvider.notifier)
                          .updateVoucher(voucher.id, {'isActive': newVal});
                      if (!success && context.mounted) {
                        final error = ref.read(adminVouchersProvider).error ?? 'Cập nhật thất bại';
                        ScaffoldMessenger.of(context).showSnackBar(
                          SnackBar(content: Text('Lỗi: $error'), backgroundColor: Colors.red),
                        );
                        ref.read(adminVouchersProvider.notifier).clearError();
                      }
                    },
                  ),
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
    if (discount == null) return '0 VNĐ';
    if (discount is num) {
      return '${discount.toStringAsFixed(0)} VNĐ';
    }
    return '$discount VNĐ';
  }

  void _showCreateVoucherDialog(BuildContext context, WidgetRef ref) {
    final codeController = TextEditingController();
    final discountController = TextEditingController();
    final minOrderController = TextEditingController(text: '0');

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Tạo voucher mới'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Mã voucher',
                  hintText: 'VD: SUMMER2026',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: discountController,
                decoration: const InputDecoration(
                  labelText: 'Số tiền giảm (VNĐ)',
                  hintText: 'VD: 50000',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: minOrderController,
                decoration: const InputDecoration(
                  labelText: 'Đơn tối thiểu (VNĐ)',
                  hintText: 'VD: 300000',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (codeController.text.trim().isNotEmpty && discountController.text.trim().isNotEmpty) {
                final discount = double.tryParse(discountController.text.trim()) ?? 0;
                final minOrder = double.tryParse(minOrderController.text.trim()) ?? 0;

                Navigator.pop(ctx);
                final success = await ref
                    .read(adminVouchersProvider.notifier)
                    .createVoucher({
                  'code': codeController.text.trim().toUpperCase(),
                  'discount': discount,
                  'minOrder': minOrder,
                });

                if (context.mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Tạo voucher thành công')),
                    );
                  } else {
                    final error = ref.read(adminVouchersProvider).error ?? 'Tạo voucher thất bại';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi: $error'), backgroundColor: Colors.red),
                    );
                    ref.read(adminVouchersProvider.notifier).clearError();
                  }
                }
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
      text: voucher.discount.toStringAsFixed(0),
    );
    final minOrderController = TextEditingController(
      text: voucher.minOrder.toStringAsFixed(0),
    );

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Chỉnh sửa voucher'),
        content: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: codeController,
                decoration: const InputDecoration(
                  labelText: 'Mã voucher',
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: discountController,
                decoration: const InputDecoration(
                  labelText: 'Số tiền giảm (VNĐ)',
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              TextField(
                controller: minOrderController,
                decoration: const InputDecoration(
                  labelText: 'Đơn tối thiểu (VNĐ)',
                ),
                keyboardType: TextInputType.number,
              ),
            ],
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              if (codeController.text.trim().isNotEmpty && discountController.text.trim().isNotEmpty) {
                final discount = double.tryParse(discountController.text.trim()) ?? 0;
                final minOrder = double.tryParse(minOrderController.text.trim()) ?? 0;

                Navigator.pop(ctx);
                final success = await ref
                    .read(adminVouchersProvider.notifier)
                    .updateVoucher(voucher.id, {
                  'code': codeController.text.trim().toUpperCase(),
                  'discount': discount,
                  'minOrder': minOrder,
                });

                if (context.mounted) {
                  if (success) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Cập nhật voucher thành công')),
                    );
                  } else {
                    final error = ref.read(adminVouchersProvider).error ?? 'Cập nhật thất bại';
                    ScaffoldMessenger.of(context).showSnackBar(
                      SnackBar(content: Text('Lỗi: $error'), backgroundColor: Colors.red),
                    );
                    ref.read(adminVouchersProvider.notifier).clearError();
                  }
                }
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
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa voucher này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(adminVouchersProvider.notifier)
                  .deleteVoucher(voucherId);

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Xóa voucher thành công')),
                  );
                } else {
                  final error = ref.read(adminVouchersProvider).error ?? 'Xóa voucher thất bại';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Lỗi: $error'), backgroundColor: Colors.red),
                  );
                  ref.read(adminVouchersProvider.notifier).clearError();
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
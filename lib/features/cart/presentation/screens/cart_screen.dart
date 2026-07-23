import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../providers/cart_provider.dart';
import '../widgets/cart_item_tile.dart';

class CartScreen extends ConsumerWidget {
  const CartScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(cartProvider);
    final notifier = ref.read(cartProvider.notifier);

    // Hiện lỗi (vd hết hàng) qua SnackBar, không chặn cả màn hình.
    ref.listen(cartProvider.select((s) => s.errorMessage), (previous, next) {
      if (next != null && next.isNotEmpty) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next)));
      }
    });

    return Scaffold(
      appBar: AppBar(
        title: const Text('Giỏ hàng'),
        actions: [
          if (!state.isEmpty)
            TextButton(
              onPressed: () => _confirmClear(context, notifier),
              child: const Text('Xóa hết'),
            ),
        ],
      ),
      body: _buildBody(context, ref, state, notifier),
      bottomNavigationBar: state.isEmpty
          ? null
          : _CheckoutBar(
              subtotal: state.subtotal,
              onCheckout: () => context.push('/checkout'),
            ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    CartState state,
    CartNotifier notifier,
  ) {
    if (state.isLoading && state.cart == null) {
      return const LoadingIndicator(message: 'Đang tải giỏ hàng...');
    }

    if (state.cart == null && state.errorMessage != null) {
      return ErrorStateWidget(
        message: state.errorMessage!,
        onRetry: notifier.load,
      );
    }

    if (state.isEmpty) {
      return EmptyStateWidget(
        icon: Icons.shopping_cart_outlined,
        title: 'Giỏ hàng trống',
        message: 'Hãy thêm sản phẩm yêu thích vào giỏ để bắt đầu mua sắm.',
        actionLabel: 'Khám phá sản phẩm',
        onActionPressed: () => context.go('/catalog'),
      );
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.builder(
        padding: const EdgeInsets.all(AppTheme.spaceM),
        itemCount: state.items.length,
        itemBuilder: (context, index) {
          final item = state.items[index];
          return CartItemTile(
            item: item,
            isMutating: state.mutatingItemIds.contains(item.id),
            onQuantityChanged: (qty) =>
                notifier.updateQuantity(itemId: item.id, quantity: qty),
            onRemove: () => notifier.removeItem(item.id),
          );
        },
      ),
    );
  }

  Future<void> _confirmClear(
    BuildContext context,
    CartNotifier notifier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Xóa toàn bộ giỏ hàng?'),
        content: const Text('Tất cả sản phẩm trong giỏ sẽ bị xóa.'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Hủy'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Xóa hết'),
          ),
        ],
      ),
    );
    if (confirmed == true) {
      await notifier.clear();
    }
  }
}

class _CheckoutBar extends StatelessWidget {
  final double subtotal;
  final VoidCallback onCheckout;

  const _CheckoutBar({required this.subtotal, required this.onCheckout});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return SafeArea(
      child: Container(
        padding: const EdgeInsets.all(AppTheme.spaceM),
        decoration: BoxDecoration(
          color: theme.colorScheme.surface,
          border: Border(top: BorderSide(color: Colors.grey.shade200)),
        ),
        child: Row(
          children: [
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisSize: MainAxisSize.min,
                children: [
                  Text('Tạm tính', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    formatVnd(subtotal),
                    style: theme.textTheme.titleLarge?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            const SizedBox(width: AppTheme.spaceM),
            ElevatedButton(
              onPressed: onCheckout,
              child: const Text('Thanh toán'),
            ),
          ],
        ),
      ),
    );
  }
}

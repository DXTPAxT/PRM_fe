import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../profile/presentation/providers/address_provider.dart';
import '../providers/checkout_provider.dart';

class CheckoutScreen extends ConsumerStatefulWidget {
  const CheckoutScreen({super.key});

  @override
  ConsumerState<CheckoutScreen> createState() => _CheckoutScreenState();
}

class _CheckoutScreenState extends ConsumerState<CheckoutScreen> {
  @override
  void initState() {
    super.initState();
    // Chọn sẵn địa chỉ mặc định khi danh sách sẵn sàng.
    WidgetsBinding.instance.addPostFrameCallback((_) => _preselectAddress());
  }

  void _preselectAddress() {
    final addresses = ref.read(addressProvider).addresses;
    if (addresses.isEmpty) return;
    final current = ref.read(checkoutProvider).selectedAddressId;
    if (current != null) return;
    final defaultAddr = addresses.firstWhere(
      (a) => a.isDefault,
      orElse: () => addresses.first,
    );
    ref.read(checkoutProvider.notifier).selectAddress(defaultAddr.id);
  }

  @override
  Widget build(BuildContext context) {
    final cart = ref.watch(cartProvider);
    final addressState = ref.watch(addressProvider);
    final checkout = ref.watch(checkoutProvider);

    // Khi địa chỉ vừa load xong, tự chọn mặc định.
    ref.listen(addressProvider.select((s) => s.addresses.length), (_, __) {
      _preselectAddress();
    });

    ref.listen(checkoutProvider.select((s) => s.errorMessage), (_, next) {
      if (next != null && next.isNotEmpty) {
        ScaffoldMessenger.of(context)
          ..hideCurrentSnackBar()
          ..showSnackBar(SnackBar(content: Text(next)));
      }
    });

    return Scaffold(
      appBar: AppBar(title: const Text('Thanh toán')),
      body: cart.isEmpty
          ? const EmptyStateWidget(
              icon: Icons.shopping_cart_outlined,
              title: 'Giỏ hàng trống',
              message: 'Không có sản phẩm nào để thanh toán.',
            )
          : ListView(
              padding: const EdgeInsets.all(AppTheme.spaceM),
              children: [
                const _SectionTitle('Địa chỉ giao hàng'),
                _AddressSection(state: addressState, checkout: checkout),
                const SizedBox(height: AppTheme.spaceL),
                const _SectionTitle('Phương thức thanh toán'),
                _PaymentSection(selected: checkout.paymentMethod),
                const SizedBox(height: AppTheme.spaceL),
                const _SectionTitle('Tóm tắt đơn hàng'),
                _OrderSummary(subtotal: cart.subtotal, itemCount: cart.itemCount),
              ],
            ),
      bottomNavigationBar: cart.isEmpty
          ? null
          : _PlaceOrderBar(
              total: cart.subtotal,
              isSubmitting: checkout.isSubmitting,
              enabled: checkout.selectedAddressId != null,
              onPlaceOrder: _placeOrder,
            ),
    );
  }

  Future<void> _placeOrder() async {
    final result = await ref.read(checkoutProvider.notifier).placeOrder();
    if (result == null || !mounted) return;

    final orderId = result.order.id;

    if (result.needsSimulate) {
      await _simulatePaymentDialog(orderId);
    }

    if (!mounted) return;
    // Giỏ đã được BE xóa khi tạo đơn → đồng bộ lại state giỏ.
    ref.read(cartProvider.notifier).refresh();
    // Điều hướng sang chi tiết đơn (thay thế checkout khỏi stack).
    context.pushReplacement('/orders/$orderId');
  }

  Future<void> _simulatePaymentDialog(String orderId) async {
    final paid = await showDialog<bool>(
      context: context,
      barrierDismissible: false,
      builder: (context) => AlertDialog(
        title: const Text('Giả lập thanh toán'),
        content: const Text(
          'Cổng thanh toán này đang ở chế độ demo. Chọn kết quả để tiếp tục.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Thất bại'),
          ),
          ElevatedButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Thành công'),
          ),
        ],
      ),
    );
    if (paid == null || !mounted) return;
    await ref.read(checkoutProvider.notifier).simulatePayment(orderId, paid);
    if (!mounted) return;
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(paid ? 'Thanh toán thành công!' : 'Thanh toán thất bại.'),
      ),
    );
  }
}

class _SectionTitle extends StatelessWidget {
  final String title;
  const _SectionTitle(this.title);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceS),
      child: Text(
        title,
        style: Theme.of(context)
            .textTheme
            .titleMedium
            ?.copyWith(fontWeight: FontWeight.bold),
      ),
    );
  }
}

class _AddressSection extends ConsumerWidget {
  final AddressState state;
  final CheckoutState checkout;

  const _AddressSection({required this.state, required this.checkout});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    if (state.isLoading && state.addresses.isEmpty) {
      return const Padding(
        padding: EdgeInsets.all(AppTheme.spaceL),
        child: Center(child: CircularProgressIndicator()),
      );
    }

    if (state.addresses.isEmpty) {
      return Card(
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceM),
          child: Column(
            children: [
              const Text('Bạn chưa có địa chỉ giao hàng.'),
              const SizedBox(height: AppTheme.spaceS),
              OutlinedButton.icon(
                onPressed: () => context.push('/addresses'),
                icon: const Icon(Icons.add_location_alt_outlined),
                label: const Text('Thêm địa chỉ'),
              ),
            ],
          ),
        ),
      );
    }

    return Column(
      children: [
        RadioGroup<String>(
          groupValue: checkout.selectedAddressId,
          onChanged: (value) {
            if (value != null) {
              ref.read(checkoutProvider.notifier).selectAddress(value);
            }
          },
          child: Column(
            children: [
              for (final address in state.addresses)
                Card(
                  child: RadioListTile<String>(
                    value: address.id,
                    title: Text(
                      '${address.fullName} · ${address.phone}',
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    subtitle: Text(address.detail),
                    secondary: address.isDefault
                        ? const Chip(
                            label: Text('Mặc định'),
                            visualDensity: VisualDensity.compact,
                          )
                        : null,
                  ),
                ),
            ],
          ),
        ),
        Align(
          alignment: Alignment.centerLeft,
          child: TextButton.icon(
            onPressed: () => context.push('/addresses'),
            icon: const Icon(Icons.add),
            label: const Text('Thêm địa chỉ mới'),
          ),
        ),
      ],
    );
  }
}

class _PaymentSection extends ConsumerWidget {
  final PaymentMethodType selected;
  const _PaymentSection({required this.selected});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Card(
      child: RadioGroup<PaymentMethodType>(
        groupValue: selected,
        onChanged: (value) {
          if (value != null) {
            ref.read(checkoutProvider.notifier).selectPaymentMethod(value);
          }
        },
        child: Column(
          children: [
            for (final method in PaymentMethodType.values)
              RadioListTile<PaymentMethodType>(
                value: method,
                title: Text(method.label),
                secondary: Icon(_iconFor(method)),
              ),
          ],
        ),
      ),
    );
  }

  IconData _iconFor(PaymentMethodType method) {
    switch (method) {
      case PaymentMethodType.cod:
        return Icons.payments_outlined;
      case PaymentMethodType.vnpay:
        return Icons.account_balance_outlined;
      case PaymentMethodType.momo:
      case PaymentMethodType.zalopay:
        return Icons.account_balance_wallet_outlined;
    }
  }
}

class _OrderSummary extends StatelessWidget {
  final double subtotal;
  final int itemCount;

  const _OrderSummary({required this.subtotal, required this.itemCount});

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceM),
        child: Column(
          children: [
            _row(context, 'Tạm tính ($itemCount sản phẩm)', formatVnd(subtotal)),
            const SizedBox(height: AppTheme.spaceS),
            _row(context, 'Phí vận chuyển', 'Tính khi xác nhận'),
            const Divider(height: AppTheme.spaceL),
            _row(
              context,
              'Tổng cộng',
              formatVnd(subtotal),
              emphasize: true,
            ),
          ],
        ),
      ),
    );
  }

  Widget _row(
    BuildContext context,
    String label,
    String value, {
    bool emphasize = false,
  }) {
    final theme = Theme.of(context);
    final style = emphasize
        ? theme.textTheme.titleMedium?.copyWith(
            fontWeight: FontWeight.bold,
            color: theme.colorScheme.primary,
          )
        : theme.textTheme.bodyMedium;
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: theme.textTheme.bodyMedium),
        Text(value, style: style),
      ],
    );
  }
}

class _PlaceOrderBar extends StatelessWidget {
  final double total;
  final bool isSubmitting;
  final bool enabled;
  final VoidCallback onPlaceOrder;

  const _PlaceOrderBar({
    required this.total,
    required this.isSubmitting,
    required this.enabled,
    required this.onPlaceOrder,
  });

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
                  Text('Tổng cộng', style: theme.textTheme.bodyMedium),
                  const SizedBox(height: 2),
                  Text(
                    formatVnd(total),
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
              onPressed: (enabled && !isSubmitting) ? onPlaceOrder : null,
              child: isSubmitting
                  ? const SizedBox(
                      width: 20,
                      height: 20,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Text('Đặt hàng'),
            ),
          ],
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../data/models/order_detail.dart';
import '../../domain/order_status_info.dart';
import '../providers/order_detail_provider.dart';
import '../widgets/order_status_timeline.dart';
import '../widgets/review_form_dialog.dart';

class OrderDetailScreen extends ConsumerWidget {
  final String orderId;

  const OrderDetailScreen({super.key, required this.orderId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(orderDetailProvider(orderId));
    final notifier = ref.read(orderDetailProvider(orderId).notifier);

    ref.listen(
      orderDetailProvider(orderId).select((s) => s.errorMessage),
      (_, next) {
        if (next != null && next.isNotEmpty) {
          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(SnackBar(content: Text(next)));
        }
      },
    );

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết đơn hàng')),
      body: _buildBody(context, ref, state, notifier),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    OrderDetailState state,
    OrderDetailNotifier notifier,
  ) {
    if (state.isLoading && state.order == null) {
      return const LoadingIndicator(message: 'Đang tải đơn hàng...');
    }
    if (state.order == null) {
      return ErrorStateWidget(
        message: state.errorMessage ?? 'Không tải được đơn hàng.',
        onRetry: notifier.load,
      );
    }

    final order = state.order!;
    return ListView(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      children: [
        _Card(
          title: 'Trạng thái đơn hàng',
          child: OrderStatusTimeline(status: order.status),
        ),
        if (order.address != null)
          _Card(
            title: 'Địa chỉ giao hàng',
            child: _AddressBlock(address: order.address!),
          ),
        _Card(
          title: 'Sản phẩm',
          child: _ItemsBlock(
            order: order,
            isSubmittingReview: state.isSubmittingReview,
            onReview: (item) => _openReview(context, ref, notifier, item),
          ),
        ),
        if (order.payment != null)
          _Card(
            title: 'Thanh toán',
            child: _PaymentBlock(payment: order.payment!),
          ),
        _Card(
          title: 'Tổng kết',
          child: _TotalsBlock(order: order),
        ),
        const SizedBox(height: AppTheme.spaceM),
        _ActionButtons(
          order: order,
          isCancelling: state.isCancelling,
          isRetryingPayment: state.isRetryingPayment,
          onCancel: () => _confirmCancel(context, notifier),
          onRetryPayment: () => _retryPayment(context, ref, notifier),
        ),
        const SizedBox(height: AppTheme.spaceL),
      ],
    );
  }

  /// Giả lập kết quả thanh toán qua `simulate-callback` (demo, không cần
  /// cổng VNPay sandbox thật — cổng thật yêu cầu Return URL/IPN truy cập
  /// được từ internet, không khả thi khi chạy backend local).
  Future<void> _retryPayment(
    BuildContext context,
    WidgetRef ref,
    OrderDetailNotifier notifier,
  ) async {
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
    if (paid == null || !context.mounted) return;

    final ok = await notifier.simulatePayment(paid);
    if (!context.mounted) return;

    final message = ok
        ? (paid ? 'Thanh toán thành công!' : 'Thanh toán thất bại.')
        : 'Không thể xử lý thanh toán. Vui lòng thử lại.';
    ScaffoldMessenger.of(context).showSnackBar(SnackBar(content: Text(message)));
  }

  Future<void> _confirmCancel(
    BuildContext context,
    OrderDetailNotifier notifier,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Hủy đơn hàng?'),
        content: const Text(
          'Đơn hàng sẽ bị hủy và tồn kho được hoàn lại. Hành động này không thể hoàn tác.',
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context, false),
            child: const Text('Không'),
          ),
          TextButton(
            onPressed: () => Navigator.pop(context, true),
            child: const Text('Hủy đơn'),
          ),
        ],
      ),
    );
    if (confirmed != true) return;
    final ok = await notifier.cancel();
    if (ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Đã hủy đơn hàng.')),
      );
    }
  }

  Future<void> _openReview(
    BuildContext context,
    WidgetRef ref,
    OrderDetailNotifier notifier,
    OrderLineItem item,
  ) async {
    final input = await showDialog<ReviewInput>(
      context: context,
      builder: (_) => ReviewFormDialog(productName: item.variant.product.name),
    );
    if (input == null) return;
    final ok = await notifier.submitReview(
      productId: item.variant.product.id,
      rating: input.rating,
      comment: input.comment,
    );
    if (ok && context.mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Cảm ơn bạn đã đánh giá!')),
      );
    }
  }
}

class _Card extends StatelessWidget {
  final String title;
  final Widget child;
  const _Card({required this.title, required this.child});

  @override
  Widget build(BuildContext context) {
    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceM),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceM),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              title,
              style: Theme.of(context)
                  .textTheme
                  .titleMedium
                  ?.copyWith(fontWeight: FontWeight.bold),
            ),
            const SizedBox(height: AppTheme.spaceM),
            child,
          ],
        ),
      ),
    );
  }
}

class _AddressBlock extends StatelessWidget {
  final OrderAddress address;
  const _AddressBlock({required this.address});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          '${address.fullName} · ${address.phone}',
          style: const TextStyle(fontWeight: FontWeight.w600),
        ),
        const SizedBox(height: AppTheme.spaceXS),
        Text(address.detail),
      ],
    );
  }
}

class _ItemsBlock extends StatelessWidget {
  final OrderDetail order;
  final bool isSubmittingReview;
  final ValueChanged<OrderLineItem> onReview;

  const _ItemsBlock({
    required this.order,
    required this.isSubmittingReview,
    required this.onReview,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final canReview =
        OrderStatusType.fromValue(order.status) == OrderStatusType.completed;

    return Column(
      children: [
        for (final item in order.items) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.variant.product.name,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                    const SizedBox(height: 2),
                    Text(
                      'Size ${item.variant.size} · ${item.variant.color}',
                      style: theme.textTheme.bodyMedium,
                    ),
                    Text(
                      '${formatVnd(item.unitPrice)} x ${item.quantity}',
                      style: theme.textTheme.bodyMedium,
                    ),
                  ],
                ),
              ),
              Text(
                formatVnd(item.unitPrice * item.quantity),
                style: const TextStyle(fontWeight: FontWeight.bold),
              ),
            ],
          ),
          if (canReview)
            Align(
              alignment: Alignment.centerRight,
              child: TextButton.icon(
                onPressed: isSubmittingReview ? null : () => onReview(item),
                icon: const Icon(Icons.star_border, size: 18),
                label: const Text('Đánh giá'),
              ),
            ),
          if (item != order.items.last) const Divider(),
        ],
      ],
    );
  }
}

class _PaymentBlock extends StatelessWidget {
  final OrderPayment payment;
  const _PaymentBlock({required this.payment});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        _row(context, 'Phương thức', _methodLabel(payment.method)),
        const SizedBox(height: AppTheme.spaceXS),
        _row(context, 'Trạng thái', _statusLabel(payment.status)),
        if (payment.paidAt != null) ...[
          const SizedBox(height: AppTheme.spaceXS),
          _row(context, 'Thời gian', formatDateTime(payment.paidAt!)),
        ],
      ],
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value, style: const TextStyle(fontWeight: FontWeight.w600)),
      ],
    );
  }

  String _methodLabel(String method) {
    switch (method) {
      case 'cod':
        return 'Thanh toán khi nhận hàng';
      case 'vnpay':
        return 'VNPay';
      case 'momo':
        return 'MoMo';
      case 'zalopay':
        return 'ZaloPay';
      default:
        return method;
    }
  }

  String _statusLabel(String status) {
    switch (status) {
      case 'pending':
        return 'Chờ thanh toán';
      case 'paid':
        return 'Đã thanh toán';
      case 'failed':
        return 'Thất bại';
      case 'refunded':
        return 'Đã hoàn tiền';
      default:
        return status;
    }
  }
}

class _TotalsBlock extends StatelessWidget {
  final OrderDetail order;
  const _TotalsBlock({required this.order});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Column(
      children: [
        _row(context, 'Tạm tính', formatVnd(order.subtotal)),
        if (order.discount > 0) ...[
          const SizedBox(height: AppTheme.spaceXS),
          _row(context, 'Giảm giá', formatVnd(-order.discount)),
        ],
        const SizedBox(height: AppTheme.spaceXS),
        _row(context, 'Phí vận chuyển', formatVnd(order.shippingFee)),
        const Divider(height: AppTheme.spaceL),
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Text('Tổng cộng', style: theme.textTheme.titleMedium),
            Text(
              formatVnd(order.total),
              style: theme.textTheme.titleLarge?.copyWith(
                color: theme.colorScheme.primary,
                fontWeight: FontWeight.bold,
              ),
            ),
          ],
        ),
      ],
    );
  }

  Widget _row(BuildContext context, String label, String value) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(label, style: Theme.of(context).textTheme.bodyMedium),
        Text(value),
      ],
    );
  }
}

class _ActionButtons extends StatelessWidget {
  final OrderDetail order;
  final bool isCancelling;
  final bool isRetryingPayment;
  final VoidCallback onCancel;
  final VoidCallback onRetryPayment;

  const _ActionButtons({
    required this.order,
    required this.isCancelling,
    required this.isRetryingPayment,
    required this.onCancel,
    required this.onRetryPayment,
  });

  bool get _canRetryPayment =>
      OrderStatusType.fromValue(order.status) ==
          OrderStatusType.pendingPayment &&
      order.payment?.method == 'vnpay' &&
      order.payment?.status != 'paid';

  @override
  Widget build(BuildContext context) {
    final cancellable = isOrderCancellable(order.status);
    if (!cancellable && !_canRetryPayment) {
      return const SizedBox.shrink();
    }
    return Column(
      children: [
        if (_canRetryPayment) ...[
          SizedBox(
            width: double.infinity,
            child: ElevatedButton.icon(
              onPressed: isRetryingPayment ? null : onRetryPayment,
              icon: isRetryingPayment
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(
                        strokeWidth: 2,
                        color: Colors.white,
                      ),
                    )
                  : const Icon(Icons.payment_outlined),
              label: const Text('Thanh toán lại'),
            ),
          ),
          if (cancellable) const SizedBox(height: AppTheme.spaceS),
        ],
        if (cancellable)
          SizedBox(
            width: double.infinity,
            child: OutlinedButton.icon(
              onPressed: isCancelling ? null : onCancel,
              icon: isCancelling
                  ? const SizedBox(
                      width: 18,
                      height: 18,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                  : const Icon(Icons.cancel_outlined),
              label: const Text('Hủy đơn hàng'),
              style: OutlinedButton.styleFrom(
                foregroundColor: Theme.of(context).colorScheme.error,
                side: BorderSide(color: Theme.of(context).colorScheme.error),
              ),
            ),
          ),
      ],
    );
  }
}

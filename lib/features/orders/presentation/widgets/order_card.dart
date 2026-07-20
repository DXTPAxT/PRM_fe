import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/order_detail.dart';
import 'order_status_badge.dart';

/// Thẻ tóm tắt một đơn trong danh sách.
class OrderCard extends StatelessWidget {
  final OrderDetail order;
  final VoidCallback onTap;

  const OrderCard({super.key, required this.order, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final itemCount = order.items.fold<int>(0, (sum, i) => sum + i.quantity);
    final firstItem = order.items.isNotEmpty ? order.items.first : null;

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceM),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
        child: Padding(
          padding: const EdgeInsets.all(AppTheme.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    'Đơn #${order.id.substring(0, 8).toUpperCase()}',
                    style: theme.textTheme.labelLarge,
                  ),
                  OrderStatusBadge(status: order.status),
                ],
              ),
              const SizedBox(height: AppTheme.spaceS),
              if (firstItem != null)
                Text(
                  firstItem.variant.product.name +
                      (order.items.length > 1
                          ? ' và ${order.items.length - 1} sản phẩm khác'
                          : ''),
                  style: theme.textTheme.bodyLarge,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
              const SizedBox(height: AppTheme.spaceS),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    formatDateTime(order.createdAt),
                    style: theme.textTheme.bodyMedium,
                  ),
                  Text.rich(
                    TextSpan(
                      children: [
                        TextSpan(
                          text: '$itemCount sản phẩm · ',
                          style: theme.textTheme.bodyMedium,
                        ),
                        TextSpan(
                          text: formatVnd(order.total),
                          style: theme.textTheme.titleMedium?.copyWith(
                            color: theme.colorScheme.primary,
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

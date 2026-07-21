import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/order_status_info.dart';

/// Badge nhỏ hiển thị trạng thái đơn với màu tương ứng.
class OrderStatusBadge extends StatelessWidget {
  final String status;

  const OrderStatusBadge({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final info = OrderStatusInfo.of(status);
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: AppTheme.spaceS,
        vertical: AppTheme.spaceXS,
      ),
      decoration: BoxDecoration(
        color: info.color.withValues(alpha: 0.12),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(info.icon, size: 14, color: info.color),
          const SizedBox(width: AppTheme.spaceXS),
          Text(
            info.label,
            style: TextStyle(
              color: info.color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

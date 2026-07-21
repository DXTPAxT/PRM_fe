import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../domain/order_status_info.dart';

/// Timeline dọc thể hiện tiến trình đơn hàng theo state machine BE.
/// Nếu đơn bị hủy, hiện trạng thái hủy nổi bật thay cho timeline.
class OrderStatusTimeline extends StatelessWidget {
  final String status;

  const OrderStatusTimeline({super.key, required this.status});

  @override
  Widget build(BuildContext context) {
    final current = OrderStatusType.fromValue(status);

    if (current == OrderStatusType.cancelled) {
      return _CancelledBanner();
    }

    final currentIndex = kOrderTimeline.indexOf(current);

    return Column(
      children: [
        for (var i = 0; i < kOrderTimeline.length; i++)
          _TimelineStep(
            info: OrderStatusInfo.of(kOrderTimeline[i].value),
            isDone: i <= currentIndex,
            isCurrent: i == currentIndex,
            isFirst: i == 0,
            isLast: i == kOrderTimeline.length - 1,
          ),
      ],
    );
  }
}

class _TimelineStep extends StatelessWidget {
  final OrderStatusInfo info;
  final bool isDone;
  final bool isCurrent;
  final bool isFirst;
  final bool isLast;

  const _TimelineStep({
    required this.info,
    required this.isDone,
    required this.isCurrent,
    required this.isFirst,
    required this.isLast,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final activeColor = theme.colorScheme.primary;
    final inactiveColor = Colors.grey.shade300;
    final dotColor = isDone ? activeColor : inactiveColor;

    return IntrinsicHeight(
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Column(
            children: [
              Expanded(
                child: Container(
                  width: 2,
                  color: isFirst
                      ? Colors.transparent
                      : (isDone ? activeColor : inactiveColor),
                ),
              ),
              Container(
                width: isCurrent ? 20 : 16,
                height: isCurrent ? 20 : 16,
                decoration: BoxDecoration(
                  color: isDone ? dotColor : Colors.white,
                  shape: BoxShape.circle,
                  border: Border.all(color: dotColor, width: 2),
                ),
                child: isDone
                    ? const Icon(Icons.check, size: 10, color: Colors.white)
                    : null,
              ),
              Expanded(
                child: Container(
                  width: 2,
                  color: isLast
                      ? Colors.transparent
                      : (isDone && !isCurrent ? activeColor : inactiveColor),
                ),
              ),
            ],
          ),
          const SizedBox(width: AppTheme.spaceM),
          Expanded(
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceM),
              child: Text(
                info.label,
                style: theme.textTheme.bodyLarge?.copyWith(
                  fontWeight: isCurrent ? FontWeight.bold : FontWeight.normal,
                  color: isDone
                      ? theme.textTheme.bodyLarge?.color
                      : Colors.grey.shade500,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}

class _CancelledBanner extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    final info = OrderStatusInfo.of(OrderStatusType.cancelled.value);
    return Container(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      decoration: BoxDecoration(
        color: info.color.withValues(alpha: 0.1),
        borderRadius: BorderRadius.circular(AppTheme.radiusM),
      ),
      child: Row(
        children: [
          Icon(info.icon, color: info.color),
          const SizedBox(width: AppTheme.spaceM),
          Expanded(
            child: Text(
              'Đơn hàng đã bị hủy',
              style: TextStyle(
                color: info.color,
                fontWeight: FontWeight.bold,
              ),
            ),
          ),
        ],
      ),
    );
  }
}

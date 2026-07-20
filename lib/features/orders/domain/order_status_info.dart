import 'package:flutter/material.dart';

/// Trạng thái đơn hàng — khớp enum `OrderStatus` của BE.
enum OrderStatusType {
  pendingPayment('pending_payment'),
  confirmed('confirmed'),
  packed('packed'),
  shipping('shipping'),
  delivered('delivered'),
  completed('completed'),
  cancelled('cancelled');

  final String value;
  const OrderStatusType(this.value);

  static OrderStatusType fromValue(String value) {
    return OrderStatusType.values.firstWhere(
      (e) => e.value == value,
      orElse: () => OrderStatusType.pendingPayment,
    );
  }
}

/// Thông tin hiển thị cho một trạng thái đơn: nhãn tiếng Việt, màu, icon.
class OrderStatusInfo {
  final String label;
  final Color color;
  final IconData icon;

  const OrderStatusInfo({
    required this.label,
    required this.color,
    required this.icon,
  });

  static OrderStatusInfo of(String status) {
    switch (OrderStatusType.fromValue(status)) {
      case OrderStatusType.pendingPayment:
        return const OrderStatusInfo(
          label: 'Chờ thanh toán',
          color: Color(0xFFF59E0B),
          icon: Icons.schedule,
        );
      case OrderStatusType.confirmed:
        return const OrderStatusInfo(
          label: 'Đã xác nhận',
          color: Color(0xFF3B82F6),
          icon: Icons.check_circle_outline,
        );
      case OrderStatusType.packed:
        return const OrderStatusInfo(
          label: 'Đang đóng gói',
          color: Color(0xFF6366F1),
          icon: Icons.inventory_2_outlined,
        );
      case OrderStatusType.shipping:
        return const OrderStatusInfo(
          label: 'Đang giao',
          color: Color(0xFF8B5CF6),
          icon: Icons.local_shipping_outlined,
        );
      case OrderStatusType.delivered:
        return const OrderStatusInfo(
          label: 'Đã giao',
          color: Color(0xFF10B981),
          icon: Icons.inventory_outlined,
        );
      case OrderStatusType.completed:
        return const OrderStatusInfo(
          label: 'Hoàn thành',
          color: Color(0xFF059669),
          icon: Icons.verified_outlined,
        );
      case OrderStatusType.cancelled:
        return const OrderStatusInfo(
          label: 'Đã hủy',
          color: Color(0xFFEF4444),
          icon: Icons.cancel_outlined,
        );
    }
  }
}

/// Các bước timeline của một đơn không bị hủy (theo state machine BE).
const List<OrderStatusType> kOrderTimeline = [
  OrderStatusType.pendingPayment,
  OrderStatusType.confirmed,
  OrderStatusType.packed,
  OrderStatusType.shipping,
  OrderStatusType.delivered,
  OrderStatusType.completed,
];

/// Đơn có hủy được không — khớp `isCancellable` của BE
/// (chỉ pending_payment và confirmed).
bool isOrderCancellable(String status) {
  final type = OrderStatusType.fromValue(status);
  return type == OrderStatusType.pendingPayment ||
      type == OrderStatusType.confirmed;
}

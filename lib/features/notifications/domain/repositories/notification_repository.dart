import '../../data/models/notification_item.dart';

abstract class NotificationRepository {
  Future<Map<String, dynamic>> getNotifications({int page, int limit});
  Future<void> markAsRead(String id);
  Future<void> markAllAsRead();
}

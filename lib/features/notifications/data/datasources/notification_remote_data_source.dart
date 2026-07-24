import '../../../../core/network/dio_client.dart';
import '../models/notification_item.dart';

class NotificationRemoteDataSource {
  final DioClient _dioClient;

  NotificationRemoteDataSource(this._dioClient);

  Future<Map<String, dynamic>> getNotifications({
    int page = 1,
    int limit = 20,
  }) async {
    final response = await _dioClient.get(
      '/notifications',
      queryParameters: {'page': page, 'limit': limit},
    );
    final json = response.data as Map<String, dynamic>;
    final rawData = json['data'] as List? ?? [];
    final items = rawData
        .map((e) => NotificationItem.fromJson(e as Map<String, dynamic>))
        .toList();
    final meta = json['meta'] as Map<String, dynamic>?;
    return {
      'items': items,
      'unreadCount': meta?['unreadCount'] as int? ?? 0,
      'totalPages': meta?['totalPages'] as int? ?? 1,
    };
  }

  Future<void> markAsRead(String id) async {
    await _dioClient.patch('/notifications/$id/read');
  }

  Future<void> markAllAsRead() async {
    await _dioClient.patch('/notifications/read-all');
  }
}

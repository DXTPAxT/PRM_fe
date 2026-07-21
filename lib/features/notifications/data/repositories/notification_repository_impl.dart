import '../../domain/repositories/notification_repository.dart';
import '../datasources/notification_remote_data_source.dart';

class NotificationRepositoryImpl implements NotificationRepository {
  final NotificationRemoteDataSource _remote;

  NotificationRepositoryImpl(this._remote);

  @override
  Future<Map<String, dynamic>> getNotifications({int page = 1, int limit = 20}) =>
      _remote.getNotifications(page: page, limit: limit);

  @override
  Future<void> markAsRead(String id) => _remote.markAsRead(id);

  @override
  Future<void> markAllAsRead() => _remote.markAllAsRead();
}

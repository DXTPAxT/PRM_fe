import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/notification_remote_data_source.dart';
import '../../data/models/notification_item.dart';
import '../../data/repositories/notification_repository_impl.dart';
import '../../domain/repositories/notification_repository.dart';

final notificationRepositoryProvider = Provider<NotificationRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return NotificationRepositoryImpl(NotificationRemoteDataSource(dioClient));
});

class NotificationState {
  final List<NotificationItem> items;
  final int unreadCount;
  final bool isLoading;
  final String? errorMessage;

  const NotificationState({
    this.items = const [],
    this.unreadCount = 0,
    this.isLoading = false,
    this.errorMessage,
  });

  NotificationState copyWith({
    List<NotificationItem>? items,
    int? unreadCount,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return NotificationState(
      items: items ?? this.items,
      unreadCount: unreadCount ?? this.unreadCount,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class NotificationNotifier extends StateNotifier<NotificationState> {
  final Ref _ref;

  NotificationNotifier(this._ref) : super(const NotificationState()) {
    _ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated &&
          previous?.status != AuthStatus.authenticated) {
        load();
      } else if (next.status == AuthStatus.unauthenticated) {
        state = const NotificationState();
      }
    });

    if (_ref.read(authProvider).status == AuthStatus.authenticated) {
      load();
    }
  }

  NotificationRepository get _repo => _ref.read(notificationRepositoryProvider);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _repo.getNotifications();
      state = state.copyWith(
        items: result['items'] as List<NotificationItem>,
        unreadCount: result['unreadCount'] as int,
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  Future<void> markAsRead(String id) async {
    try {
      await _repo.markAsRead(id);
      state = state.copyWith(
        items: state.items.map((item) {
          if (item.id == id) return item.copyWith(isRead: true);
          return item;
        }).toList(),
        unreadCount: (state.unreadCount - 1).clamp(0, state.unreadCount),
      );
    } catch (_) {}
  }

  Future<void> markAllAsRead() async {
    try {
      await _repo.markAllAsRead();
      state = state.copyWith(
        items: state.items.map((item) => item.copyWith(isRead: true)).toList(),
        unreadCount: 0,
      );
    } catch (_) {}
  }
}

final notificationProvider =
    StateNotifierProvider<NotificationNotifier, NotificationState>((ref) {
  return NotificationNotifier(ref);
});

/// Số lượng thông báo chưa đọc — dùng cho badge trên bottom bar hoặc bell icon.
final unreadCountProvider = Provider<int>((ref) {
  return ref.watch(notificationProvider).unreadCount;
});

import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/orders_remote_data_source.dart';
import '../../data/models/order_detail.dart';
import '../../data/repositories/orders_repository_impl.dart';
import '../../domain/repositories/orders_repository.dart';

// ── Providers hạ tầng ─────────────────────────────────────────────────────
final ordersRepositoryProvider = Provider<OrdersRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return OrdersRepositoryImpl(OrdersRemoteDataSource(dioClient));
});

// ── State cho danh sách đơn theo một trạng thái (một tab) ──────────────────
class OrdersListState {
  final List<OrderDetail> orders;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final int page;
  final String? errorMessage;

  const OrdersListState({
    this.orders = const [],
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.page = 1,
    this.errorMessage,
  });

  OrdersListState copyWith({
    List<OrderDetail>? orders,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    int? page,
    String? errorMessage,
    bool clearError = false,
  }) {
    return OrdersListState(
      orders: orders ?? this.orders,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      page: page ?? this.page,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class OrdersListNotifier extends StateNotifier<OrdersListState> {
  final Ref _ref;

  /// null = tab "Tất cả"; ngược lại lọc theo giá trị OrderStatus.
  final String? statusFilter;

  OrdersListNotifier(this._ref, this.statusFilter)
      : super(const OrdersListState()) {
    load();
  }

  OrdersRepository get _repo => _ref.read(ordersRepositoryProvider);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result =
          await _repo.getOrders(status: statusFilter, page: 1, limit: 20);
      state = state.copyWith(
        orders: result.items,
        page: 1,
        hasMore: result.hasMore,
        isLoading: false,
        clearError: true,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: _message(error));
    }
  }

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;
    state = state.copyWith(isLoadingMore: true);
    try {
      final nextPage = state.page + 1;
      final result = await _repo.getOrders(
        status: statusFilter,
        page: nextPage,
        limit: 20,
      );
      state = state.copyWith(
        orders: [...state.orders, ...result.items],
        page: nextPage,
        hasMore: result.hasMore,
        isLoadingMore: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: _message(error),
      );
    }
  }

  Future<void> refresh() => load();

  String _message(Object error) =>
      error.toString().replaceFirst('Exception: ', '');
}

/// Provider theo từng tab (family theo statusFilter). autoDispose để rời tab
/// thì giải phóng, nhưng ta giữ lại qua keepAlive khi cần refresh sau checkout.
final ordersListProvider = StateNotifierProvider.family
    .autoDispose<OrdersListNotifier, OrdersListState, String?>((ref, status) {
  return OrdersListNotifier(ref, status);
});

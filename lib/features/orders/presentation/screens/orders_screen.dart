import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../providers/orders_provider.dart';
import '../widgets/order_card.dart';

/// Định nghĩa một tab: nhãn + status filter (null = tất cả).
class _OrderTab {
  final String label;
  final String? status;
  const _OrderTab(this.label, this.status);
}

const _tabs = <_OrderTab>[
  _OrderTab('Tất cả', null),
  _OrderTab('Chờ thanh toán', 'pending_payment'),
  _OrderTab('Đang xử lý', 'confirmed'),
  _OrderTab('Đang giao', 'shipping'),
  _OrderTab('Hoàn thành', 'completed'),
  _OrderTab('Đã hủy', 'cancelled'),
];

class OrdersScreen extends ConsumerWidget {
  const OrdersScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final auth = ref.watch(authProvider);

    if (auth.status != AuthStatus.authenticated) {
      return Scaffold(
        appBar: AppBar(title: const Text('Đơn hàng')),
        body: const EmptyStateWidget(
          icon: Icons.receipt_long_outlined,
          title: 'Chưa đăng nhập',
          message: 'Đăng nhập để xem lịch sử đơn hàng của bạn.',
        ),
      );
    }

    return DefaultTabController(
      length: _tabs.length,
      child: Scaffold(
        appBar: AppBar(
          title: const Text('Đơn hàng'),
          bottom: TabBar(
            isScrollable: true,
            tabAlignment: TabAlignment.start,
            tabs: [for (final tab in _tabs) Tab(text: tab.label)],
          ),
        ),
        body: TabBarView(
          children: [
            for (final tab in _tabs) _OrdersTabView(status: tab.status),
          ],
        ),
      ),
    );
  }
}

class _OrdersTabView extends ConsumerStatefulWidget {
  final String? status;
  const _OrdersTabView({required this.status});

  @override
  ConsumerState<_OrdersTabView> createState() => _OrdersTabViewState();
}

class _OrdersTabViewState extends ConsumerState<_OrdersTabView>
    with AutomaticKeepAliveClientMixin {
  final _scrollController = ScrollController();

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  void _onScroll() {
    if (_scrollController.position.pixels >=
        _scrollController.position.maxScrollExtent - 200) {
      ref.read(ordersListProvider(widget.status).notifier).loadMore();
    }
  }

  @override
  void dispose() {
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    final state = ref.watch(ordersListProvider(widget.status));
    final notifier = ref.read(ordersListProvider(widget.status).notifier);

    if (state.isLoading && state.orders.isEmpty) {
      return const LoadingIndicator(message: 'Đang tải đơn hàng...');
    }

    if (state.orders.isEmpty && state.errorMessage != null) {
      return ErrorStateWidget(
        message: state.errorMessage!,
        onRetry: notifier.refresh,
      );
    }

    if (state.orders.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.receipt_long_outlined,
        title: 'Chưa có đơn hàng',
        message: 'Bạn chưa có đơn hàng nào trong mục này.',
      );
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: ListView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppTheme.spaceM),
        itemCount: state.orders.length + (state.hasMore ? 1 : 0),
        itemBuilder: (context, index) {
          if (index >= state.orders.length) {
            return const Padding(
              padding: EdgeInsets.all(AppTheme.spaceM),
              child: Center(child: CircularProgressIndicator()),
            );
          }
          final order = state.orders[index];
          return OrderCard(
            order: order,
            onTap: () async {
              await context.push('/orders/${order.id}');
              // Quay lại từ chi tiết (có thể vừa hủy đơn) → refresh danh sách.
              notifier.refresh();
            },
          );
        },
      ),
    );
  }
}

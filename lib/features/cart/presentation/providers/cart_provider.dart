import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/cart_remote_data_source.dart';
import '../../data/models/cart_response.dart';
import '../../data/repositories/cart_repository_impl.dart';
import '../../domain/repositories/cart_repository.dart';

// ── Providers hạ tầng ─────────────────────────────────────────────────────
final cartRepositoryProvider = Provider<CartRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CartRepositoryImpl(CartRemoteDataSource(dioClient));
});

// ── State ─────────────────────────────────────────────────────────────────
class CartState {
  final CartResponse? cart;
  final bool isLoading;

  /// Id của các item đang được cập nhật (số lượng hoặc xóa) — dùng để disable
  /// nút và hiện spinner nhỏ trên đúng dòng đó, không khóa cả màn hình.
  final Set<String> mutatingItemIds;
  final String? errorMessage;

  const CartState({
    this.cart,
    this.isLoading = false,
    this.mutatingItemIds = const {},
    this.errorMessage,
  });

  List<CartLineItem> get items => cart?.items ?? const [];
  double get subtotal => cart?.subtotal ?? 0;
  int get itemCount =>
      items.fold(0, (sum, item) => sum + item.quantity);
  bool get isEmpty => items.isEmpty;

  CartState copyWith({
    CartResponse? cart,
    bool? isLoading,
    Set<String>? mutatingItemIds,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CartState(
      cart: cart ?? this.cart,
      isLoading: isLoading ?? this.isLoading,
      mutatingItemIds: mutatingItemIds ?? this.mutatingItemIds,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────
class CartNotifier extends StateNotifier<CartState> {
  final Ref _ref;

  CartNotifier(this._ref) : super(const CartState()) {
    // Chỉ tải giỏ khi đã đăng nhập; đăng xuất thì xóa giỏ khỏi state.
    _ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated &&
          previous?.status != AuthStatus.authenticated) {
        load();
      } else if (next.status == AuthStatus.unauthenticated) {
        state = const CartState();
      }
    });

    if (_ref.read(authProvider).status == AuthStatus.authenticated) {
      load();
    }
  }

  CartRepository get _repo => _ref.read(cartRepositoryProvider);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final cart = await _repo.getCart();
      state = state.copyWith(cart: cart, isLoading: false, clearError: true);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _message(error),
      );
    }
  }

  Future<void> refresh() => load();

  /// Thêm sản phẩm vào giỏ. Trả về true nếu thành công (để UI hiện SnackBar).
  Future<bool> addItem({required String variantId, int quantity = 1}) async {
    try {
      final cart = await _repo.addItem(variantId: variantId, quantity: quantity);
      state = state.copyWith(cart: cart, clearError: true);
      return true;
    } catch (error) {
      state = state.copyWith(errorMessage: _message(error));
      return false;
    }
  }

  Future<void> updateQuantity({
    required String itemId,
    required int quantity,
  }) async {
    if (quantity < 1) return;
    _markMutating(itemId, true);
    try {
      final cart = await _repo.updateItem(itemId: itemId, quantity: quantity);
      state = state.copyWith(cart: cart, clearError: true);
    } catch (error) {
      state = state.copyWith(errorMessage: _message(error));
    } finally {
      _markMutating(itemId, false);
    }
  }

  Future<void> removeItem(String itemId) async {
    _markMutating(itemId, true);
    try {
      final cart = await _repo.removeItem(itemId);
      state = state.copyWith(cart: cart, clearError: true);
    } catch (error) {
      state = state.copyWith(errorMessage: _message(error));
    } finally {
      _markMutating(itemId, false);
    }
  }

  Future<void> clear() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final cart = await _repo.clear();
      state = state.copyWith(cart: cart, isLoading: false, clearError: true);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: _message(error),
      );
    }
  }

  void _markMutating(String itemId, bool mutating) {
    final next = Set<String>.from(state.mutatingItemIds);
    if (mutating) {
      next.add(itemId);
    } else {
      next.remove(itemId);
    }
    state = state.copyWith(mutatingItemIds: next);
  }

  String _message(Object error) =>
      error.toString().replaceFirst('Exception: ', '');
}

final cartProvider =
    StateNotifierProvider<CartNotifier, CartState>((ref) {
  return CartNotifier(ref);
});

/// Tổng số lượng sản phẩm trong giỏ — dùng cho badge trên bottom navigation.
final cartItemCountProvider = Provider<int>((ref) {
  return ref.watch(cartProvider).itemCount;
});

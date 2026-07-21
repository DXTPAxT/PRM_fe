import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/wishlist_remote_data_source.dart';
import '../../data/models/wishlist_item.dart';
import '../../data/repositories/wishlist_repository_impl.dart';
import '../../domain/repositories/wishlist_repository.dart';

final wishlistRepositoryProvider = Provider<WishlistRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return WishlistRepositoryImpl(WishlistRemoteDataSource(dioClient));
});

class WishlistState {
  final List<WishlistItem> items;
  final bool isLoading;
  final String? errorMessage;

  const WishlistState({
    this.items = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  /// Set các productId đang trong wishlist — dùng để check nhanh trái tim.
  Set<String> get productIds => items.map((e) => e.productId).toSet();

  WishlistState copyWith({
    List<WishlistItem>? items,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return WishlistState(
      items: items ?? this.items,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class WishlistNotifier extends StateNotifier<WishlistState> {
  final Ref _ref;

  WishlistNotifier(this._ref) : super(const WishlistState()) {
    _ref.listen(authProvider, (previous, next) {
      if (next.status == AuthStatus.authenticated &&
          previous?.status != AuthStatus.authenticated) {
        load();
      } else if (next.status == AuthStatus.unauthenticated) {
        state = const WishlistState();
      }
    });

    if (_ref.read(authProvider).status == AuthStatus.authenticated) {
      load();
    }
  }

  WishlistRepository get _repo => _ref.read(wishlistRepositoryProvider);

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final items = await _repo.getWishlist();
      state = state.copyWith(items: items, isLoading: false, clearError: true);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Toggle yêu thích: nếu đã có thì xóa, chưa có thì thêm.
  /// Trả về true nếu kết quả cuối cùng là "đang yêu thích".
  Future<bool> toggle(String productId) async {
    final isCurrently = state.productIds.contains(productId);
    try {
      if (isCurrently) {
        await _repo.removeFromWishlist(productId);
      } else {
        await _repo.addToWishlist(productId);
      }
      await load(); // Refresh danh sách
      return !isCurrently;
    } catch (error) {
      state = state.copyWith(
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
      return isCurrently;
    }
  }
}

final wishlistProvider =
    StateNotifierProvider<WishlistNotifier, WishlistState>((ref) {
  return WishlistNotifier(ref);
});

/// Kiểm tra nhanh 1 productId có trong wishlist không — dùng cho icon trái tim.
final isInWishlistProvider = Provider.family<bool, String>((ref, productId) {
  return ref.watch(wishlistProvider).productIds.contains(productId);
});

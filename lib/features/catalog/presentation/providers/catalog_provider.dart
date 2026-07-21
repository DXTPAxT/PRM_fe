import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/storage/hive_cache.dart';
import '../../../../shared/models/category.dart';
import '../../../../shared/models/product.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../data/datasources/catalog_remote_data_source.dart';
import '../../data/models/product_query.dart';
import '../../data/repositories/catalog_repository_impl.dart';
import '../../domain/repositories/catalog_repository.dart';

// ── Providers hạ tầng ─────────────────────────────────────────────────────
final catalogRepositoryProvider = Provider<CatalogRepository>((ref) {
  final dioClient = ref.watch(dioClientProvider);
  return CatalogRepositoryImpl(CatalogRemoteDataSource(dioClient));
});

// ── State ─────────────────────────────────────────────────────────────────
class CatalogState {
  final List<Category> categories;
  final List<Product> products;
  final ProductQuery query;
  final bool isLoading;
  final bool isLoadingMore;
  final bool hasMore;
  final String? errorMessage;

  const CatalogState({
    this.categories = const [],
    this.products = const [],
    this.query = const ProductQuery(),
    this.isLoading = false,
    this.isLoadingMore = false,
    this.hasMore = false,
    this.errorMessage,
  });

  CatalogState copyWith({
    List<Category>? categories,
    List<Product>? products,
    ProductQuery? query,
    bool? isLoading,
    bool? isLoadingMore,
    bool? hasMore,
    String? errorMessage,
    bool clearError = false,
  }) {
    return CatalogState(
      categories: categories ?? this.categories,
      products: products ?? this.products,
      query: query ?? this.query,
      isLoading: isLoading ?? this.isLoading,
      isLoadingMore: isLoadingMore ?? this.isLoadingMore,
      hasMore: hasMore ?? this.hasMore,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

// ── Notifier ──────────────────────────────────────────────────────────────
class CatalogNotifier extends StateNotifier<CatalogState> {
  final Ref _ref;

  CatalogNotifier(this._ref) : super(const CatalogState()) {
    loadInitial();
  }

  CatalogRepository get _repository => _ref.read(catalogRepositoryProvider);

  bool _isValidUuid(String str) {
    return RegExp(
      r'^[0-9a-fA-F]{8}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{4}-[0-9a-fA-F]{12}$',
    ).hasMatch(str);
  }

  /// Đọc categories từ Hive trước để hiện ngay, rồi mới gọi mạng.
  Future<void> _loadCategories() async {
    final box = HiveCache.getBox(HiveCache.categoriesBoxName);

    final cached = box.get('items');
    if (cached is List && cached.isNotEmpty) {
      try {
        final categories = cached
            .map((item) =>
                Category.fromJson(Map<String, dynamic>.from(item as Map)))
            .toList();
        final hasInvalidId = categories.any((c) => !_isValidUuid(c.id));
        if (!hasInvalidId) {
          state = state.copyWith(categories: categories);
        } else {
          await box.delete('items');
        }
      } catch (_) {
        await box.delete('items'); // cache hỏng thì bỏ đi, không làm sập app
      }
    }

    try {
      final categories = await _repository.getCategories();
      state = state.copyWith(categories: categories);
      await box.put('items', categories.map((c) => c.toJson()).toList());
    } catch (_) {
      // Lỗi danh mục không chặn danh sách sản phẩm — bỏ qua có chủ đích.
    }
  }

  Future<void> loadInitial() async {
    state = state.copyWith(isLoading: true, clearError: true);
    await _loadCategories();
    await _fetchFirstPage();
  }

  Future<void> _fetchFirstPage() async {
    try {
      final query = state.query.copyWith(page: 1);
      final result = await _repository.getProducts(query);
      state = state.copyWith(
        products: result.items,
        query: query,
        hasMore: result.hasMore,
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

  Future<void> loadMore() async {
    if (state.isLoadingMore || !state.hasMore || state.isLoading) return;

    state = state.copyWith(isLoadingMore: true);
    try {
      final nextQuery = state.query.copyWith(page: state.query.page + 1);
      final result = await _repository.getProducts(nextQuery);
      state = state.copyWith(
        products: [...state.products, ...result.items],
        query: nextQuery,
        hasMore: result.hasMore,
        isLoadingMore: false,
      );
    } catch (error) {
      state = state.copyWith(
        isLoadingMore: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Đổi bộ lọc — luôn tải lại từ trang 1.
  Future<void> applyQuery(ProductQuery query) async {
    state = state.copyWith(query: query, isLoading: true, clearError: true);
    await _fetchFirstPage();
  }

  Future<void> selectCategory(String? categoryId) async {
    final query = categoryId == null
        ? state.query.copyWith(clearCategoryId: true, page: 1)
        : state.query.copyWith(categoryId: categoryId, page: 1);
    await applyQuery(query);
  }

  Future<void> refresh() async {
    await applyQuery(state.query.copyWith(page: 1));
  }
}

final catalogProvider =
    StateNotifierProvider<CatalogNotifier, CatalogState>((ref) {
  return CatalogNotifier(ref);
});

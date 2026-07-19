# Catalog Frontend (Product + Search + Review) — Implementation Plan

> **For agentic workers:** REQUIRED SUB-SKILL: Use superpowers:subagent-driven-development (recommended) or superpowers:executing-plans to implement this plan task-by-task. Steps use checkbox (`- [ ]`) syntax for tracking.

**Goal:** Xây màn duyệt sản phẩm, tìm kiếm, lọc, xem chi tiết và đánh giá cho Member 2, thay thế `catalog_screen.dart` hiện chỉ hiện "Coming Soon".

**Architecture:** Clean Architecture 3 lớp (data / domain / presentation) trong `lib/features/catalog/`, bám đúng khuôn mẫu của `lib/features/auth/`. State dùng `StateNotifier` + State class tự viết có `copyWith` — **không** dùng `AsyncNotifier`, **không** dùng codegen Riverpod. Repository ném `Exception(message)` — **không** dùng `Either`/`dartz`.

**Tech Stack:** Flutter (Dart 3), flutter_riverpod 2.5, go_router 14, dio 5, freezed + json_serializable, Hive.

**Điều kiện tiên quyết:** Backend đã chạy và có đủ 10 endpoint (xem plan BE `docs/superpowers/plans/2026-07-19-catalog-be.md` ở repo `PRM_be`). Kiểm tra bằng `curl http://localhost:3000/api/products?limit=1` trước khi bắt đầu.

## Global Constraints

- **KHÔNG sửa** `lib/features/auth/`, `lib/features/profile/`, `lib/features/cart/`, `lib/features/orders/`, `lib/features/wishlist/`, `lib/features/admin/` — của Member 1, 3, 4.
- **KHÔNG gọi** API `/cart`, `/wishlist`, `/orders`, `/users` — không thuộc phần Member 2.
- `lib/core/` chỉ được sửa **đúng một chỗ**: thêm route `/products/:id` vào `app_router.dart` (Task 6).
- **KHÔNG thêm dependency mới vào `pubspec.yaml`.** Không có `cached_network_image` — dùng `Image.network` kèm `loadingBuilder` và `errorBuilder`.
- Sau mỗi lần sửa file trong `lib/shared/models/`, phải chạy lại `dart run build_runner build --delete-conflicting-outputs`.
- Toàn bộ text hiển thị cho người dùng viết bằng tiếng Việt có dấu.
- Tái sử dụng widget có sẵn ở `lib/core/widgets/common_widgets.dart`: `LoadingIndicator`, `EmptyStateWidget`, `ErrorStateWidget`. Không viết lại.
- Khoảng cách dùng hằng `AppTheme.spaceS / spaceM / spaceL` từ `lib/core/theme/app_theme.dart`.

## API Contract (BE trả camelCase)

Base URL lấy từ `Env.apiBaseUrl`. Mọi response bọc trong `{ success, data, message, meta? }`.

| Method | Path | Auth | Ghi chú |
|---|---|---|---|
| GET | `/categories` | không | `[{id, name, parentId}]` |
| GET | `/products` | không | Query: `categoryId, search, minPrice, maxPrice, size, color, sort, page, limit` |
| GET | `/products/{id}` | không | Kèm `images[]`, `variants[]` |
| GET | `/products/{id}/reviews` | không | Query `page`, `limit` |
| POST | `/reviews` | JWT | Body `{productId, rating, comment?}` — **409** nếu đã đánh giá |
| PATCH | `/reviews/{id}` | JWT | Body `{rating?, comment?}` |
| DELETE | `/reviews/{id}` | JWT | |

`sort` ∈ `newest` | `price_asc` | `price_desc` | `name_asc`

**Shape của một sản phẩm trong list:**
```json
{ "id": "...", "categoryId": "...", "categoryName": "Áo thun", "name": "Áo thun basic",
  "basePrice": 250000, "status": "active", "thumbnailUrl": "https://...",
  "avgRating": 4.7, "reviewCount": 3, "createdAt": "2026-01-01T00:00:00.000Z" }
```

**Chi tiết có thêm:**
```json
{ "description": "Cotton 100%",
  "images": [{"id":"...","url":"...","sortOrder":0}],
  "variants": [{"id":"...","productId":"...","size":"M","color":"Đen",
                "price":260000,"stockQty":10,"sku":"AT-M-DEN"}] }
```

**Review:**
```json
{ "id":"...", "userId":"...", "userFullName":"Nguyễn Văn A", "productId":"...",
  "rating":5, "comment":"Đẹp", "createdAt":"2026-01-01T00:00:00.000Z" }
```

## File Structure

| File | Trách nhiệm |
|---|---|
| `lib/shared/models/*.dart` | Model dùng chung — sửa ở Task 1 |
| `lib/features/catalog/data/models/product_query.dart` | Gói tham số lọc thành object bất biến |
| `lib/features/catalog/data/datasources/catalog_remote_data_source.dart` | Gọi HTTP, parse `ApiResponse`/`PagedResponse` |
| `lib/features/catalog/data/repositories/catalog_repository_impl.dart` | Unwrap response, ném `Exception` khi thất bại |
| `lib/features/catalog/domain/repositories/catalog_repository.dart` | Interface |
| `lib/features/catalog/domain/usecases/*.dart` | Một usecase một file |
| `lib/features/catalog/presentation/providers/catalog_provider.dart` | State list + filter + paging |
| `lib/features/catalog/presentation/providers/product_detail_provider.dart` | State chi tiết + variant đang chọn |
| `lib/features/catalog/presentation/providers/review_provider.dart` | State review + gửi/sửa/xóa |
| `lib/features/catalog/presentation/screens/*.dart` | 3 màn hình |
| `lib/features/catalog/presentation/widgets/*.dart` | 5 widget tái sử dụng |

---

### Task 1: Sửa model trong `shared/`

**Lý do làm trước tiên:** 4 model hiện dùng `@JsonKey(name: 'category_id')` snake_case, trong khi BE trả camelCase. Không sửa thì **mọi lời gọi API đều parse fail**. Đã xác nhận chưa file nào import chúng → sửa an toàn.

**Files:**
- Modify: `lib/shared/models/product.dart`
- Modify: `lib/shared/models/category.dart`
- Modify: `lib/shared/models/product_variant.dart`
- Modify: `lib/shared/models/review.dart`
- Create: `lib/shared/models/product_image.dart`

**Interfaces:**
- Produces: `Product`, `Category`, `ProductVariant`, `Review`, `ProductImage` — tất cả `fromJson`/`toJson` dùng camelCase

- [ ] **Step 1: Tạo `product_image.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_image.freezed.dart';
part 'product_image.g.dart';

@freezed
class ProductImage with _$ProductImage {
  const factory ProductImage({
    required String id,
    required String url,
    @Default(0) int sortOrder,
  }) = _ProductImage;

  factory ProductImage.fromJson(Map<String, dynamic> json) =>
      _$ProductImageFromJson(json);
}
```

- [ ] **Step 2: Ghi đè `category.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'category.freezed.dart';
part 'category.g.dart';

@freezed
class Category with _$Category {
  const factory Category({
    required String id,
    required String name,
    String? parentId,
  }) = _Category;

  factory Category.fromJson(Map<String, dynamic> json) =>
      _$CategoryFromJson(json);
}
```

- [ ] **Step 3: Ghi đè `product_variant.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'product_variant.freezed.dart';
part 'product_variant.g.dart';

@freezed
class ProductVariant with _$ProductVariant {
  const factory ProductVariant({
    required String id,
    required String productId,
    required String size,
    required String color,
    required double price,
    required int stockQty,
    required String sku,
  }) = _ProductVariant;

  factory ProductVariant.fromJson(Map<String, dynamic> json) =>
      _$ProductVariantFromJson(json);
}
```

- [ ] **Step 4: Ghi đè `product.dart`**

Dùng **chung một class cho cả list lẫn detail** — field chỉ có ở detail để mặc định `null`/`[]`.

```dart
import 'package:freezed_annotation/freezed_annotation.dart';
import 'product_image.dart';
import 'product_variant.dart';

part 'product.freezed.dart';
part 'product.g.dart';

@freezed
class Product with _$Product {
  const factory Product({
    required String id,
    required String categoryId,
    @Default('') String categoryName,
    required String name,
    String? description,
    required double basePrice,
    required String status,
    String? thumbnailUrl,
    @Default(0) double avgRating,
    @Default(0) int reviewCount,
    @Default([]) List<ProductImage> images,
    @Default([]) List<ProductVariant> variants,
    DateTime? createdAt,
  }) = _Product;

  factory Product.fromJson(Map<String, dynamic> json) =>
      _$ProductFromJson(json);
}
```

- [ ] **Step 5: Ghi đè `review.dart`**

```dart
import 'package:freezed_annotation/freezed_annotation.dart';

part 'review.freezed.dart';
part 'review.g.dart';

@freezed
class Review with _$Review {
  const factory Review({
    required String id,
    required String userId,
    @Default('Người dùng') String userFullName,
    required String productId,
    required int rating,
    String? comment,
    DateTime? createdAt,
  }) = _Review;

  factory Review.fromJson(Map<String, dynamic> json) => _$ReviewFromJson(json);
}
```

- [ ] **Step 6: Sinh lại code**

Run: `dart run build_runner build --delete-conflicting-outputs`
Expected: `Succeeded after ...` — không có dòng `[SEVERE]`.

- [ ] **Step 7: Kiểm tra biên dịch**

Run: `flutter analyze lib/shared/models`
Expected: `No issues found!`

- [ ] **Step 8: Commit**

```bash
git add lib/shared/models
git commit -m "fix(models): switch catalog models to camelCase matching API"
```

---

### Task 2: Data layer — query object, data source, repository

**Files:**
- Create: `lib/features/catalog/data/models/product_query.dart`
- Create: `lib/features/catalog/data/datasources/catalog_remote_data_source.dart`
- Create: `lib/features/catalog/domain/repositories/catalog_repository.dart`
- Create: `lib/features/catalog/data/repositories/catalog_repository_impl.dart`

**Interfaces:**
- Consumes: `Product`, `Category`, `Review` (Task 1); `DioClient`, `ApiResponse`, `PagedResponse`, `PaginationMeta` từ `lib/core/network/`
- Produces:
  - `ProductQuery` — có `copyWith` và `toQueryParameters()`
  - `ProductSort` enum — `newest`, `priceAsc`, `priceDesc`, `nameAsc`
  - `CatalogRepository` với 6 method (xem Step 3)
  - `PagedResult<T>` — `{ items, page, totalPages }`

- [ ] **Step 1: Tạo `product_query.dart`**

```dart
enum ProductSort { newest, priceAsc, priceDesc, nameAsc }

extension ProductSortX on ProductSort {
  /// Giá trị BE nhận ở query param `sort`.
  String get apiValue {
    switch (this) {
      case ProductSort.newest:
        return 'newest';
      case ProductSort.priceAsc:
        return 'price_asc';
      case ProductSort.priceDesc:
        return 'price_desc';
      case ProductSort.nameAsc:
        return 'name_asc';
    }
  }

  String get label {
    switch (this) {
      case ProductSort.newest:
        return 'Mới nhất';
      case ProductSort.priceAsc:
        return 'Giá thấp đến cao';
      case ProductSort.priceDesc:
        return 'Giá cao đến thấp';
      case ProductSort.nameAsc:
        return 'Tên A-Z';
    }
  }
}

/// Gói toàn bộ tham số lọc thành một object bất biến.
/// Đổi filter = tạo bản sao mới rồi tải lại từ trang 1.
class ProductQuery {
  final String? categoryId;
  final String? search;
  final double? minPrice;
  final double? maxPrice;
  final String? size;
  final String? color;
  final ProductSort sort;
  final int page;
  final int limit;

  const ProductQuery({
    this.categoryId,
    this.search,
    this.minPrice,
    this.maxPrice,
    this.size,
    this.color,
    this.sort = ProductSort.newest,
    this.page = 1,
    this.limit = 20,
  });

  ProductQuery copyWith({
    String? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? size,
    String? color,
    ProductSort? sort,
    int? page,
    int? limit,
    bool clearCategoryId = false,
    bool clearSearch = false,
    bool clearPrice = false,
    bool clearSize = false,
    bool clearColor = false,
  }) {
    return ProductQuery(
      categoryId: clearCategoryId ? null : categoryId ?? this.categoryId,
      search: clearSearch ? null : search ?? this.search,
      minPrice: clearPrice ? null : minPrice ?? this.minPrice,
      maxPrice: clearPrice ? null : maxPrice ?? this.maxPrice,
      size: clearSize ? null : size ?? this.size,
      color: clearColor ? null : color ?? this.color,
      sort: sort ?? this.sort,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  /// Bỏ hẳn key có giá trị null — BE bật forbidNonWhitelisted,
  /// gửi key rỗng sẽ bị từ chối 400.
  Map<String, dynamic> toQueryParameters() {
    return {
      if (categoryId != null) 'categoryId': categoryId,
      if (search != null && search!.isNotEmpty) 'search': search,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (size != null) 'size': size,
      if (color != null) 'color': color,
      'sort': sort.apiValue,
      'page': page,
      'limit': limit,
    };
  }

  /// Có filter nào đang bật ngoài sắp xếp không (để hiện chấm đỏ trên icon lọc).
  bool get hasActiveFilter =>
      categoryId != null ||
      minPrice != null ||
      maxPrice != null ||
      size != null ||
      color != null;
}
```

- [ ] **Step 2: Tạo `catalog_remote_data_source.dart`**

```dart
import '../../../../core/network/api_response.dart';
import '../../../../core/network/dio_client.dart';
import '../../../../shared/models/category.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/review.dart';
import '../models/product_query.dart';

class CatalogRemoteDataSource {
  final DioClient _dioClient;

  CatalogRemoteDataSource(this._dioClient);

  Future<ApiResponse<List<Category>>> getCategories() async {
    final response = await _dioClient.get('/categories');
    return ApiResponse<List<Category>>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => (json as List<dynamic>)
          .map((item) => Category.fromJson(item as Map<String, dynamic>))
          .toList(),
    );
  }

  Future<PagedResponse<Product>> getProducts(ProductQuery query) async {
    final response = await _dioClient.get(
      '/products',
      queryParameters: query.toQueryParameters(),
    );
    return PagedResponse<Product>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Product.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Product>> getProductDetail(String id) async {
    final response = await _dioClient.get('/products/$id');
    return ApiResponse<Product>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Product.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<PagedResponse<Review>> getProductReviews(
    String productId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _dioClient.get(
      '/products/$productId/reviews',
      queryParameters: {'page': page, 'limit': limit},
    );
    return PagedResponse<Review>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Review.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Review>> createReview({
    required String productId,
    required int rating,
    String? comment,
  }) async {
    final response = await _dioClient.post(
      '/reviews',
      data: {
        'productId': productId,
        'rating': rating,
        if (comment != null && comment.isNotEmpty) 'comment': comment,
      },
    );
    return ApiResponse<Review>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Review.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<Review>> updateReview({
    required String id,
    int? rating,
    String? comment,
  }) async {
    final response = await _dioClient.patch(
      '/reviews/$id',
      data: {
        if (rating != null) 'rating': rating,
        if (comment != null) 'comment': comment,
      },
    );
    return ApiResponse<Review>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => Review.fromJson(json as Map<String, dynamic>),
    );
  }

  Future<ApiResponse<dynamic>> deleteReview(String id) async {
    final response = await _dioClient.delete('/reviews/$id');
    return ApiResponse<dynamic>.fromJson(
      response.data as Map<String, dynamic>,
      (json) => json,
    );
  }
}
```

- [ ] **Step 3: Tạo interface repository**

`lib/features/catalog/domain/repositories/catalog_repository.dart`:

```dart
import '../../../../shared/models/category.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/review.dart';
import '../../data/models/product_query.dart';

/// Kết quả có phân trang, dùng chung cho product và review.
class PagedResult<T> {
  final List<T> items;
  final int page;
  final int totalPages;

  const PagedResult({
    required this.items,
    required this.page,
    required this.totalPages,
  });

  bool get hasMore => page < totalPages;
}

abstract class CatalogRepository {
  Future<List<Category>> getCategories();
  Future<PagedResult<Product>> getProducts(ProductQuery query);
  Future<Product> getProductDetail(String id);
  Future<PagedResult<Review>> getProductReviews(
    String productId, {
    int page,
    int limit,
  });
  Future<Review> createReview({
    required String productId,
    required int rating,
    String? comment,
  });
  Future<Review> updateReview({
    required String id,
    int? rating,
    String? comment,
  });
  Future<void> deleteReview(String id);
}
```

- [ ] **Step 4: Tạo repository implementation**

`lib/features/catalog/data/repositories/catalog_repository_impl.dart`:

```dart
import '../../../../shared/models/category.dart';
import '../../../../shared/models/product.dart';
import '../../../../shared/models/review.dart';
import '../../domain/repositories/catalog_repository.dart';
import '../datasources/catalog_remote_data_source.dart';
import '../models/product_query.dart';

class CatalogRepositoryImpl implements CatalogRepository {
  final CatalogRemoteDataSource _remoteDataSource;

  CatalogRepositoryImpl(this._remoteDataSource);

  @override
  Future<List<Category>> getCategories() async {
    final response = await _remoteDataSource.getCategories();
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Không thể tải danh mục.');
  }

  @override
  Future<PagedResult<Product>> getProducts(ProductQuery query) async {
    final response = await _remoteDataSource.getProducts(query);
    if (!response.success) {
      throw Exception(response.message ?? 'Không thể tải danh sách sản phẩm.');
    }
    return PagedResult<Product>(
      items: response.data,
      page: response.meta.page,
      totalPages: response.meta.totalPages,
    );
  }

  @override
  Future<Product> getProductDetail(String id) async {
    final response = await _remoteDataSource.getProductDetail(id);
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Không thể tải chi tiết sản phẩm.');
  }

  @override
  Future<PagedResult<Review>> getProductReviews(
    String productId, {
    int page = 1,
    int limit = 10,
  }) async {
    final response = await _remoteDataSource.getProductReviews(
      productId,
      page: page,
      limit: limit,
    );
    if (!response.success) {
      throw Exception(response.message ?? 'Không thể tải đánh giá.');
    }
    return PagedResult<Review>(
      items: response.data,
      page: response.meta.page,
      totalPages: response.meta.totalPages,
    );
  }

  @override
  Future<Review> createReview({
    required String productId,
    required int rating,
    String? comment,
  }) async {
    final response = await _remoteDataSource.createReview(
      productId: productId,
      rating: rating,
      comment: comment,
    );
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Gửi đánh giá thất bại.');
  }

  @override
  Future<Review> updateReview({
    required String id,
    int? rating,
    String? comment,
  }) async {
    final response = await _remoteDataSource.updateReview(
      id: id,
      rating: rating,
      comment: comment,
    );
    if (response.success && response.data != null) return response.data!;
    throw Exception(response.message ?? 'Cập nhật đánh giá thất bại.');
  }

  @override
  Future<void> deleteReview(String id) async {
    final response = await _remoteDataSource.deleteReview(id);
    if (!response.success) {
      throw Exception(response.message ?? 'Xóa đánh giá thất bại.');
    }
  }
}
```

- [ ] **Step 5: Kiểm tra biên dịch**

Run: `flutter analyze lib/features/catalog`
Expected: `No issues found!`

- [ ] **Step 6: Commit**

```bash
git add lib/features/catalog
git commit -m "feat(catalog): add data layer - query, data source, repository"
```

---

### Task 3: Usecases + catalog provider

**Files:**
- Create: `lib/features/catalog/domain/usecases/get_categories_usecase.dart`
- Create: `lib/features/catalog/domain/usecases/get_products_usecase.dart`
- Create: `lib/features/catalog/domain/usecases/get_product_detail_usecase.dart`
- Create: `lib/features/catalog/domain/usecases/get_product_reviews_usecase.dart`
- Create: `lib/features/catalog/domain/usecases/create_review_usecase.dart`
- Create: `lib/features/catalog/presentation/providers/catalog_provider.dart`

**Interfaces:**
- Consumes: `CatalogRepository`, `PagedResult`, `ProductQuery` (Task 2); `dioClientProvider` từ `lib/features/auth/presentation/providers/auth_provider.dart` (chỉ đọc, không sửa file đó)
- Produces:
  - `catalogRepositoryProvider` — `Provider<CatalogRepository>`
  - `catalogProvider` — `StateNotifierProvider<CatalogNotifier, CatalogState>`
  - `CatalogNotifier.loadInitial()`, `.loadMore()`, `.applyQuery(ProductQuery)`, `.selectCategory(String?)`, `.refresh()`

- [ ] **Step 1: Tạo 5 usecase**

`get_categories_usecase.dart`:

```dart
import '../../../../shared/models/category.dart';
import '../repositories/catalog_repository.dart';

class GetCategoriesUseCase {
  final CatalogRepository _repository;
  GetCategoriesUseCase(this._repository);

  Future<List<Category>> call() => _repository.getCategories();
}
```

`get_products_usecase.dart`:

```dart
import '../../../../shared/models/product.dart';
import '../../data/models/product_query.dart';
import '../repositories/catalog_repository.dart';

class GetProductsUseCase {
  final CatalogRepository _repository;
  GetProductsUseCase(this._repository);

  Future<PagedResult<Product>> call(ProductQuery query) =>
      _repository.getProducts(query);
}
```

`get_product_detail_usecase.dart`:

```dart
import '../../../../shared/models/product.dart';
import '../repositories/catalog_repository.dart';

class GetProductDetailUseCase {
  final CatalogRepository _repository;
  GetProductDetailUseCase(this._repository);

  Future<Product> call(String id) => _repository.getProductDetail(id);
}
```

`get_product_reviews_usecase.dart`:

```dart
import '../../../../shared/models/review.dart';
import '../repositories/catalog_repository.dart';

class GetProductReviewsUseCase {
  final CatalogRepository _repository;
  GetProductReviewsUseCase(this._repository);

  Future<PagedResult<Review>> call(String productId, {int page = 1}) =>
      _repository.getProductReviews(productId, page: page);
}
```

`create_review_usecase.dart`:

```dart
import '../../../../shared/models/review.dart';
import '../repositories/catalog_repository.dart';

class CreateReviewUseCase {
  final CatalogRepository _repository;
  CreateReviewUseCase(this._repository);

  Future<Review> call({
    required String productId,
    required int rating,
    String? comment,
  }) =>
      _repository.createReview(
        productId: productId,
        rating: rating,
        comment: comment,
      );
}
```

- [ ] **Step 2: Tạo `catalog_provider.dart`**

```dart
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
        state = state.copyWith(categories: categories);
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
```

- [ ] **Step 3: Kiểm tra biên dịch**

Run: `flutter analyze lib/features/catalog`
Expected: `No issues found!`

- [ ] **Step 4: Commit**

```bash
git add lib/features/catalog
git commit -m "feat(catalog): add usecases and catalog state provider"
```

---

### Task 4: Màn danh sách sản phẩm

**Files:**
- Create: `lib/features/catalog/presentation/widgets/product_card.dart`
- Modify: `lib/features/catalog/presentation/screens/catalog_screen.dart` (thay toàn bộ stub)

**Interfaces:**
- Consumes: `catalogProvider`, `CatalogState` (Task 3); `LoadingIndicator`, `EmptyStateWidget`, `ErrorStateWidget` từ `lib/core/widgets/common_widgets.dart`
- Produces: `ProductCard({required Product product, VoidCallback? onTap})`

- [ ] **Step 1: Tạo `product_card.dart`**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/product.dart';

/// Định dạng giá kiểu Việt Nam: 250000 -> "250.000 ₫"
String formatVnd(double amount) {
  final digits = amount.round().toString();
  final buffer = StringBuffer();
  for (var i = 0; i < digits.length; i++) {
    if (i > 0 && (digits.length - i) % 3 == 0) buffer.write('.');
    buffer.write(digits[i]);
  }
  return '${buffer.toString()} ₫';
}

class ProductCard extends StatelessWidget {
  final Product product;
  final VoidCallback? onTap;

  const ProductCard({super.key, required this.product, this.onTap});

  @override
  Widget build(BuildContext context) {
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: onTap,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            AspectRatio(
              aspectRatio: 1,
              child: product.thumbnailUrl == null
                  ? Container(
                      color: Colors.grey.shade200,
                      child: Icon(
                        Icons.image_not_supported_outlined,
                        color: Colors.grey.shade400,
                      ),
                    )
                  : Image.network(
                      product.thumbnailUrl!,
                      fit: BoxFit.cover,
                      loadingBuilder: (context, child, progress) {
                        if (progress == null) return child;
                        return Container(
                          color: Colors.grey.shade100,
                          child: const Center(
                            child: SizedBox(
                              width: 24,
                              height: 24,
                              child: CircularProgressIndicator(strokeWidth: 2),
                            ),
                          ),
                        );
                      },
                      errorBuilder: (context, error, stack) => Container(
                        color: Colors.grey.shade200,
                        child: Icon(
                          Icons.broken_image_outlined,
                          color: Colors.grey.shade400,
                        ),
                      ),
                    ),
            ),
            Padding(
              padding: const EdgeInsets.all(AppTheme.spaceS),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    product.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Text(
                    formatVnd(product.basePrice),
                    style: Theme.of(context).textTheme.titleSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                          color: Theme.of(context).colorScheme.primary,
                        ),
                  ),
                  const SizedBox(height: 4),
                  Row(
                    children: [
                      const Icon(Icons.star, size: 14, color: Colors.amber),
                      const SizedBox(width: 2),
                      Text(
                        product.reviewCount == 0
                            ? 'Chưa có đánh giá'
                            : '${product.avgRating} (${product.reviewCount})',
                        style: Theme.of(context).textTheme.bodySmall?.copyWith(
                              color: Colors.grey.shade600,
                            ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Ghi đè `catalog_screen.dart`**

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../providers/catalog_provider.dart';
import '../widgets/product_card.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Tải thêm khi cuộn tới 80% chiều dài danh sách.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent * 0.8) {
      ref.read(catalogProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(catalogProvider);
    final notifier = ref.read(catalogProvider.notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Danh mục sản phẩm')),
      body: Column(
        children: [
          if (state.categories.isNotEmpty)
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceM,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: AppTheme.spaceS),
                    child: ChoiceChip(
                      label: const Text('Tất cả'),
                      selected: state.query.categoryId == null,
                      onSelected: (_) => notifier.selectCategory(null),
                    ),
                  ),
                  ...state.categories.map(
                    (category) => Padding(
                      padding: const EdgeInsets.only(right: AppTheme.spaceS),
                      child: ChoiceChip(
                        label: Text(category.name),
                        selected: state.query.categoryId == category.id,
                        onSelected: (_) => notifier.selectCategory(category.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child: _buildBody(state, notifier)),
        ],
      ),
    );
  }

  Widget _buildBody(CatalogState state, CatalogNotifier notifier) {
    if (state.isLoading) {
      return const LoadingIndicator(message: 'Đang tải sản phẩm...');
    }

    if (state.errorMessage != null && state.products.isEmpty) {
      return ErrorStateWidget(
        message: state.errorMessage!,
        onRetry: notifier.refresh,
      );
    }

    if (state.products.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.inventory_2_outlined,
        title: 'Không có sản phẩm',
        message: 'Không tìm thấy sản phẩm nào phù hợp với bộ lọc.',
      );
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppTheme.spaceM),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppTheme.spaceM,
          mainAxisSpacing: AppTheme.spaceM,
          childAspectRatio: 0.62,
        ),
        itemCount: state.products.length + (state.isLoadingMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= state.products.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return ProductCard(product: state.products[index]);
        },
      ),
    );
  }
}
```

- [ ] **Step 3: Chạy app và kiểm tra bằng mắt**

```bash
flutter run --dart-define=API_BASE_URL=http://10.0.2.2:3000/api
```

Đăng nhập bằng tài khoản seed, mở tab **"Danh mục"**.
Expected: hiện lưới 2 cột với **4 sản phẩm seed**, có ảnh, giá định dạng `250.000 ₫`, và hàng chip danh mục ở trên.

Nếu lưới trống mà log Dio báo lỗi parse → quay lại Task 1, model chưa đúng camelCase.

- [ ] **Step 4: Kiểm tra analyze**

Run: `flutter analyze lib/features/catalog`
Expected: `No issues found!`

- [ ] **Step 5: Commit**

```bash
git add lib/features/catalog
git commit -m "feat(catalog): implement product grid with infinite scroll"
```

---

### Task 5: Bộ lọc + tìm kiếm

**Files:**
- Create: `lib/features/catalog/presentation/widgets/filter_bottom_sheet.dart`
- Create: `lib/features/catalog/presentation/screens/search_screen.dart`
- Modify: `lib/features/catalog/presentation/screens/catalog_screen.dart`

**Interfaces:**
- Consumes: `catalogProvider`, `ProductQuery`, `ProductSort` (Task 2-3), `ProductCard` (Task 4)
- Produces: `showFilterBottomSheet(context, current) → Future<ProductQuery?>`, `SearchScreen`

- [ ] **Step 1: Tạo `filter_bottom_sheet.dart`**

Size và màu hardcode — BE không có endpoint trả danh sách giá trị đang tồn tại, và thêm endpoint đó là việc thừa cho quy mô đồ án.

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/product_query.dart';

const kAvailableSizes = ['S', 'M', 'L', 'XL'];
const kAvailableColors = ['Đen', 'Trắng', 'Xanh', 'Be'];

Future<ProductQuery?> showFilterBottomSheet(
  BuildContext context,
  ProductQuery current,
) {
  return showModalBottomSheet<ProductQuery>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _FilterSheet(current: current),
  );
}

class _FilterSheet extends StatefulWidget {
  final ProductQuery current;
  const _FilterSheet({required this.current});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;
  String? _size;
  String? _color;
  late ProductSort _sort;

  @override
  void initState() {
    super.initState();
    _minController = TextEditingController(
      text: widget.current.minPrice?.round().toString() ?? '',
    );
    _maxController = TextEditingController(
      text: widget.current.maxPrice?.round().toString() ?? '',
    );
    _size = widget.current.size;
    _color = widget.current.color;
    _sort = widget.current.sort;
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _apply() {
    final min = double.tryParse(_minController.text.trim());
    final max = double.tryParse(_maxController.text.trim());

    var query = widget.current.copyWith(
      clearPrice: true,
      clearSize: true,
      clearColor: true,
      sort: _sort,
      page: 1,
    );
    query = query.copyWith(
      minPrice: min,
      maxPrice: max,
      size: _size,
      color: _color,
    );

    Navigator.of(context).pop(query);
  }

  void _clear() {
    Navigator.of(context).pop(
      widget.current.copyWith(
        clearPrice: true,
        clearSize: true,
        clearColor: true,
        sort: ProductSort.newest,
        page: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppTheme.spaceL,
        right: AppTheme.spaceL,
        top: AppTheme.spaceL,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppTheme.spaceL,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bộ lọc',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.spaceL),

            const Text('Khoảng giá'),
            const SizedBox(height: AppTheme.spaceS),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Từ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceM),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Đến',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceL),

            const Text('Kích cỡ'),
            const SizedBox(height: AppTheme.spaceS),
            Wrap(
              spacing: AppTheme.spaceS,
              children: kAvailableSizes.map((size) {
                return ChoiceChip(
                  label: Text(size),
                  selected: _size == size,
                  onSelected: (selected) =>
                      setState(() => _size = selected ? size : null),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spaceL),

            const Text('Màu sắc'),
            const SizedBox(height: AppTheme.spaceS),
            Wrap(
              spacing: AppTheme.spaceS,
              children: kAvailableColors.map((color) {
                return ChoiceChip(
                  label: Text(color),
                  selected: _color == color,
                  onSelected: (selected) =>
                      setState(() => _color = selected ? color : null),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spaceL),

            const Text('Sắp xếp'),
            const SizedBox(height: AppTheme.spaceS),
            DropdownButtonFormField<ProductSort>(
              initialValue: _sort,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: ProductSort.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _sort = value ?? ProductSort.newest),
            ),
            const SizedBox(height: AppTheme.spaceL),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clear,
                    child: const Text('Xóa lọc'),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _apply,
                    child: const Text('Áp dụng'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
```

- [ ] **Step 2: Tạo `search_screen.dart`**

Debounce 400ms bằng `Timer` — không bắn request mỗi ký tự.

```dart
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../shared/models/product.dart';
import '../../data/models/product_query.dart';
import '../providers/catalog_provider.dart';
import '../widgets/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  List<Product> _results = const [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _search(value.trim());
    });
  }

  Future<void> _search(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _results = const [];
        _hasSearched = false;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ref
          .read(catalogRepositoryProvider)
          .getProducts(ProductQuery(search: keyword, limit: 30));
      if (!mounted) return;
      setState(() {
        _results = result.items;
        _isLoading = false;
        _hasSearched = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasSearched = true;
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Tìm sản phẩm...',
            border: InputBorder.none,
          ),
          onChanged: _onChanged,
          onSubmitted: (value) => _search(value.trim()),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _search('');
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator(message: 'Đang tìm...');
    }

    if (_errorMessage != null) {
      return ErrorStateWidget(
        message: _errorMessage!,
        onRetry: () => _search(_controller.text.trim()),
      );
    }

    if (!_hasSearched) {
      return const EmptyStateWidget(
        icon: Icons.search,
        title: 'Tìm kiếm sản phẩm',
        message: 'Nhập tên sản phẩm bạn muốn tìm.',
      );
    }

    if (_results.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off,
        title: 'Không tìm thấy',
        message: 'Thử từ khóa khác xem sao.',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppTheme.spaceM,
        mainAxisSpacing: AppTheme.spaceM,
        childAspectRatio: 0.62,
      ),
      itemCount: _results.length,
      itemBuilder: (context, index) => ProductCard(product: _results[index]),
    );
  }
}
```

- [ ] **Step 3: Nối nút search và filter vào `catalog_screen.dart`**

Thêm import:

```dart
import '../widgets/filter_bottom_sheet.dart';
import 'search_screen.dart';
```

Thay `appBar` trong `build()` bằng:

```dart
      appBar: AppBar(
        title: const Text('Danh mục sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Tìm kiếm',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: state.query.hasActiveFilter,
              child: const Icon(Icons.filter_list),
            ),
            tooltip: 'Bộ lọc',
            onPressed: () async {
              final result = await showFilterBottomSheet(
                context,
                state.query,
              );
              if (result != null) {
                await notifier.applyQuery(result);
              }
            },
          ),
        ],
      ),
```

- [ ] **Step 4: Kiểm tra thủ công**

Chạy lại app:
1. Bấm icon lọc → đặt khoảng giá `200000` đến `400000` → Áp dụng → lưới chỉ còn sản phẩm trong khoảng đó, icon lọc có chấm đỏ
2. Bấm "Xóa lọc" → về đủ 4 sản phẩm, chấm đỏ biến mất
3. Bấm icon search → gõ `áo` → sau ~0.4 giây hiện kết quả
4. Xóa từ khóa → về màn hình gợi ý tìm kiếm

- [ ] **Step 5: Commit**

```bash
flutter analyze lib/features/catalog
git add lib/features/catalog
git commit -m "feat(catalog): add filter bottom sheet and debounced search"
```

---

### Task 6: Màn chi tiết sản phẩm + chọn biến thể

**Files:**
- Create: `lib/features/catalog/presentation/providers/product_detail_provider.dart`
- Create: `lib/features/catalog/presentation/widgets/variant_selector.dart`
- Create: `lib/features/catalog/presentation/screens/product_detail_screen.dart`
- Modify: `lib/core/router/app_router.dart` — **chỗ duy nhất được đụng `core/`**
- Modify: `lib/features/catalog/presentation/screens/catalog_screen.dart`

**Interfaces:**
- Consumes: `catalogRepositoryProvider` (Task 3), `formatVnd` từ `product_card.dart` (Task 4)
- Produces: `productDetailProvider` — `StateNotifierProvider.family<ProductDetailNotifier, ProductDetailState, String>`

- [ ] **Step 1: Tạo `product_detail_provider.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/product.dart';
import '../../../../shared/models/product_variant.dart';
import 'catalog_provider.dart';

class ProductDetailState {
  final Product? product;
  final String? selectedSize;
  final String? selectedColor;
  final bool isLoading;
  final String? errorMessage;

  const ProductDetailState({
    this.product,
    this.selectedSize,
    this.selectedColor,
    this.isLoading = false,
    this.errorMessage,
  });

  /// Biến thể khớp cả size lẫn màu đang chọn; chưa đủ thông tin thì null.
  ProductVariant? get selectedVariant {
    if (product == null || selectedSize == null || selectedColor == null) {
      return null;
    }
    for (final variant in product!.variants) {
      if (variant.size == selectedSize && variant.color == selectedColor) {
        return variant;
      }
    }
    return null;
  }

  List<String> get availableSizes {
    if (product == null) return const [];
    return product!.variants.map((v) => v.size).toSet().toList();
  }

  /// Màu còn khả dụng với size đang chọn (chưa chọn size thì trả toàn bộ).
  List<String> get availableColors {
    if (product == null) return const [];
    final variants = selectedSize == null
        ? product!.variants
        : product!.variants.where((v) => v.size == selectedSize);
    return variants.map((v) => v.color).toSet().toList();
  }

  ProductDetailState copyWith({
    Product? product,
    String? selectedSize,
    String? selectedColor,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
    bool clearColor = false,
  }) {
    return ProductDetailState(
      product: product ?? this.product,
      selectedSize: selectedSize ?? this.selectedSize,
      selectedColor: clearColor ? null : selectedColor ?? this.selectedColor,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class ProductDetailNotifier extends StateNotifier<ProductDetailState> {
  final Ref _ref;
  final String productId;

  ProductDetailNotifier(this._ref, this.productId)
      : super(const ProductDetailState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final product =
          await _ref.read(catalogRepositoryProvider).getProductDetail(productId);
      state = ProductDetailState(product: product);
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  /// Đổi size có thể làm màu đang chọn không còn hợp lệ — bỏ chọn màu luôn.
  void selectSize(String size) {
    state = state.copyWith(selectedSize: size, clearColor: true);
  }

  void selectColor(String color) {
    state = state.copyWith(selectedColor: color);
  }
}

final productDetailProvider = StateNotifierProvider.family
    .autoDispose<ProductDetailNotifier, ProductDetailState, String>(
  (ref, productId) => ProductDetailNotifier(ref, productId),
);
```

- [ ] **Step 2: Tạo `variant_selector.dart`**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/product_detail_provider.dart';
import 'product_card.dart' show formatVnd;

class VariantSelector extends StatelessWidget {
  final ProductDetailState state;
  final void Function(String size) onSizeSelected;
  final void Function(String color) onColorSelected;

  const VariantSelector({
    super.key,
    required this.state,
    required this.onSizeSelected,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final variant = state.selectedVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kích cỡ', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppTheme.spaceS),
        Wrap(
          spacing: AppTheme.spaceS,
          children: state.availableSizes.map((size) {
            return ChoiceChip(
              label: Text(size),
              selected: state.selectedSize == size,
              onSelected: (_) => onSizeSelected(size),
            );
          }).toList(),
        ),
        const SizedBox(height: AppTheme.spaceL),

        const Text('Màu sắc', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppTheme.spaceS),
        Wrap(
          spacing: AppTheme.spaceS,
          children: state.availableColors.map((color) {
            return ChoiceChip(
              label: Text(color),
              selected: state.selectedColor == color,
              onSelected: (_) => onColorSelected(color),
            );
          }).toList(),
        ),

        if (variant != null) ...[
          const SizedBox(height: AppTheme.spaceL),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spaceM),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatVnd(variant.price),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  variant.stockQty > 0
                      ? 'Còn ${variant.stockQty} sản phẩm'
                      : 'Hết hàng',
                  style: TextStyle(
                    color: variant.stockQty > 0
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'SKU: ${variant.sku}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}
```

- [ ] **Step 3: Tạo `product_detail_screen.dart`**

Nút "Thêm vào giỏ" **để disabled** — giỏ hàng là phần của Member 3.

```dart
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../providers/product_detail_provider.dart';
import '../widgets/product_card.dart' show formatVnd;
import '../widgets/variant_selector.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productDetailProvider(productId));
    final notifier = ref.read(productDetailProvider(productId).notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
      body: _buildBody(context, state, notifier),
      bottomNavigationBar: state.product == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceM),
                child: Tooltip(
                  message: 'Chức năng giỏ hàng do Member 3 phát triển',
                  child: ElevatedButton.icon(
                    onPressed: null, // Cố ý disabled — không thuộc phần M2
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Thêm vào giỏ'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildBody(
    BuildContext context,
    ProductDetailState state,
    ProductDetailNotifier notifier,
  ) {
    if (state.isLoading) {
      return const LoadingIndicator(message: 'Đang tải sản phẩm...');
    }

    if (state.errorMessage != null) {
      return ErrorStateWidget(
        message: state.errorMessage!,
        onRetry: notifier.load,
      );
    }

    final product = state.product;
    if (product == null) {
      return const EmptyStateWidget(
        icon: Icons.inventory_2_outlined,
        title: 'Không tìm thấy',
        message: 'Sản phẩm này không còn tồn tại.',
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceL),
      children: [
        if (product.images.isNotEmpty)
          SizedBox(
            height: 320,
            child: PageView.builder(
              itemCount: product.images.length,
              itemBuilder: (context, index) => Image.network(
                product.images[index].url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(AppTheme.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spaceS),
              Row(
                children: [
                  const Icon(Icons.star, size: 18, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    product.reviewCount == 0
                        ? 'Chưa có đánh giá'
                        : '${product.avgRating} · ${product.reviewCount} đánh giá',
                  ),
                  const Spacer(),
                  Chip(label: Text(product.categoryName)),
                ],
              ),
              const SizedBox(height: AppTheme.spaceS),
              Text(
                formatVnd(product.basePrice),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spaceL),

              VariantSelector(
                state: state,
                onSizeSelected: notifier.selectSize,
                onColorSelected: notifier.selectColor,
              ),

              if (product.description != null &&
                  product.description!.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spaceL),
                const Text(
                  'Mô tả',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppTheme.spaceS),
                Text(product.description!),
              ],
            ],
          ),
        ),
      ],
    );
  }
}
```

- [ ] **Step 4: Thêm route — chỗ duy nhất sửa `core/`**

Trong `lib/core/router/app_router.dart`, thêm import:

```dart
import '../../features/catalog/presentation/screens/product_detail_screen.dart';
```

Thêm `GoRoute` vào mảng `routes`, **ngay trước** `StatefulShellRoute.indexedStack` (đặt ở cấp top-level để màn chi tiết che bottom nav):

```dart
      GoRoute(
        path: '/products/:id',
        builder: (context, state) => ProductDetailScreen(
          productId: state.pathParameters['id']!,
        ),
      ),
```

> Báo Member 1 và leader rằng bạn đã thêm route này — `core/` là code chung theo quy ước mục 7 của CONTRIBUTING.

- [ ] **Step 5: Nối điều hướng từ card**

Trong `catalog_screen.dart`, thêm import:

```dart
import 'package:go_router/go_router.dart';
```

Sửa `ProductCard` trong `itemBuilder`:

```dart
          return ProductCard(
            product: state.products[index],
            onTap: () => context.push('/products/${state.products[index].id}'),
          );
```

Làm tương tự trong `search_screen.dart` (thêm import `go_router` và `onTap`):

```dart
      itemBuilder: (context, index) => ProductCard(
        product: _results[index],
        onTap: () => context.push('/products/${_results[index].id}'),
      ),
```

- [ ] **Step 6: Kiểm tra thủ công**

Chạy lại app:
1. Bấm vào một sản phẩm → mở màn chi tiết full màn hình, **không thấy bottom nav**
2. Chọn size `M` → danh sách màu lọc lại theo size đó
3. Chọn màu → hiện khối giá + tồn kho + SKU của đúng biến thể
4. Đổi sang size khác → màu bị bỏ chọn, khối giá biến mất
5. Nút "Thêm vào giỏ" xám, giữ lâu hiện tooltip

- [ ] **Step 7: Commit**

```bash
flutter analyze lib/features/catalog lib/core/router
git add lib/features/catalog lib/core/router
git commit -m "feat(catalog): add product detail screen with variant selector"
```

---

### Task 7: Đánh giá sản phẩm

**Files:**
- Create: `lib/features/catalog/presentation/providers/review_provider.dart`
- Create: `lib/features/catalog/presentation/widgets/review_list.dart`
- Create: `lib/features/catalog/presentation/widgets/review_form_sheet.dart`
- Modify: `lib/features/catalog/presentation/screens/product_detail_screen.dart`

**Interfaces:**
- Consumes: `catalogRepositoryProvider` (Task 3); `authProvider` từ `lib/features/auth/presentation/providers/auth_provider.dart` (chỉ đọc `user.id`)
- Produces: `reviewProvider` — `StateNotifierProvider.family<ReviewNotifier, ReviewState, String>`

- [ ] **Step 1: Tạo `review_provider.dart`**

```dart
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/review.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'catalog_provider.dart';

class ReviewState {
  final List<Review> reviews;
  final Review? myReview;
  final int page;
  final bool hasMore;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;

  const ReviewState({
    this.reviews = const [],
    this.myReview,
    this.page = 1,
    this.hasMore = false,
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  ReviewState copyWith({
    List<Review>? reviews,
    Review? myReview,
    int? page,
    bool? hasMore,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    bool clearMyReview = false,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      myReview: clearMyReview ? null : myReview ?? this.myReview,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class ReviewNotifier extends StateNotifier<ReviewState> {
  final Ref _ref;
  final String productId;

  ReviewNotifier(this._ref, this.productId) : super(const ReviewState()) {
    load();
  }

  String _clean(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _ref
          .read(catalogRepositoryProvider)
          .getProductReviews(productId, page: 1);
      final currentUserId = _ref.read(authProvider).user?.id;

      Review? mine;
      for (final review in result.items) {
        if (review.userId == currentUserId) {
          mine = review;
          break;
        }
      }

      state = ReviewState(
        reviews: result.items,
        myReview: mine,
        page: result.page,
        hasMore: result.hasMore,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: _clean(error));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    try {
      final result = await _ref
          .read(catalogRepositoryProvider)
          .getProductReviews(productId, page: state.page + 1);
      state = state.copyWith(
        reviews: [...state.reviews, ...result.items],
        page: result.page,
        hasMore: result.hasMore,
      );
    } catch (error) {
      state = state.copyWith(errorMessage: _clean(error));
    }
  }

  /// Gửi đánh giá mới. BE trả 409 nếu user đã đánh giá sản phẩm này.
  Future<void> submit({required int rating, String? comment}) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await _ref.read(catalogRepositoryProvider).createReview(
            productId: productId,
            rating: rating,
            comment: comment,
          );
      state = state.copyWith(isSubmitting: false);
      await load();
    } catch (error) {
      state = state.copyWith(isSubmitting: false, errorMessage: _clean(error));
      rethrow;
    }
  }

  Future<void> edit({
    required String id,
    required int rating,
    String? comment,
  }) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await _ref.read(catalogRepositoryProvider).updateReview(
            id: id,
            rating: rating,
            comment: comment,
          );
      state = state.copyWith(isSubmitting: false);
      await load();
    } catch (error) {
      state = state.copyWith(isSubmitting: false, errorMessage: _clean(error));
      rethrow;
    }
  }

  Future<void> remove(String id) async {
    try {
      await _ref.read(catalogRepositoryProvider).deleteReview(id);
      state = state.copyWith(clearMyReview: true);
      await load();
    } catch (error) {
      state = state.copyWith(errorMessage: _clean(error));
      rethrow;
    }
  }
}

final reviewProvider = StateNotifierProvider.family
    .autoDispose<ReviewNotifier, ReviewState, String>(
  (ref, productId) => ReviewNotifier(ref, productId),
);
```

- [ ] **Step 2: Tạo `review_list.dart`**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/review.dart';

class ReviewList extends StatelessWidget {
  final List<Review> reviews;
  final int maxItems;

  const ReviewList({
    super.key,
    required this.reviews,
    this.maxItems = 3,
  });

  @override
  Widget build(BuildContext context) {
    if (reviews.isEmpty) {
      return Padding(
        padding: const EdgeInsets.symmetric(vertical: AppTheme.spaceM),
        child: Text(
          'Chưa có đánh giá nào. Hãy là người đầu tiên!',
          style: TextStyle(color: Colors.grey.shade600),
        ),
      );
    }

    final visible = reviews.take(maxItems).toList();

    return Column(
      children: visible.map((review) {
        return Padding(
          padding: const EdgeInsets.only(bottom: AppTheme.spaceM),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  CircleAvatar(
                    radius: 16,
                    child: Text(
                      review.userFullName.isNotEmpty
                          ? review.userFullName[0].toUpperCase()
                          : '?',
                    ),
                  ),
                  const SizedBox(width: AppTheme.spaceS),
                  Expanded(
                    child: Text(
                      review.userFullName,
                      style: const TextStyle(fontWeight: FontWeight.w600),
                    ),
                  ),
                  Row(
                    children: List.generate(
                      5,
                      (index) => Icon(
                        index < review.rating
                            ? Icons.star
                            : Icons.star_border,
                        size: 14,
                        color: Colors.amber,
                      ),
                    ),
                  ),
                ],
              ),
              if (review.comment != null && review.comment!.isNotEmpty) ...[
                const SizedBox(height: 4),
                Padding(
                  padding: const EdgeInsets.only(left: 40),
                  child: Text(review.comment!),
                ),
              ],
            ],
          ),
        );
      }).toList(),
    );
  }
}
```

- [ ] **Step 3: Tạo `review_form_sheet.dart`**

```dart
import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../../../shared/models/review.dart';

class ReviewFormResult {
  final int rating;
  final String? comment;

  const ReviewFormResult({required this.rating, this.comment});
}

Future<ReviewFormResult?> showReviewFormSheet(
  BuildContext context, {
  Review? existing,
}) {
  return showModalBottomSheet<ReviewFormResult>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _ReviewForm(existing: existing),
  );
}

class _ReviewForm extends StatefulWidget {
  final Review? existing;
  const _ReviewForm({this.existing});

  @override
  State<_ReviewForm> createState() => _ReviewFormState();
}

class _ReviewFormState extends State<_ReviewForm> {
  late int _rating;
  late final TextEditingController _commentController;

  @override
  void initState() {
    super.initState();
    _rating = widget.existing?.rating ?? 5;
    _commentController =
        TextEditingController(text: widget.existing?.comment ?? '');
  }

  @override
  void dispose() {
    _commentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final isEditing = widget.existing != null;

    return Padding(
      padding: EdgeInsets.only(
        left: AppTheme.spaceL,
        right: AppTheme.spaceL,
        top: AppTheme.spaceL,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppTheme.spaceL,
      ),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            isEditing ? 'Sửa đánh giá' : 'Viết đánh giá',
            style: Theme.of(context).textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
          ),
          const SizedBox(height: AppTheme.spaceL),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: List.generate(5, (index) {
              final star = index + 1;
              return IconButton(
                iconSize: 36,
                icon: Icon(
                  star <= _rating ? Icons.star : Icons.star_border,
                  color: Colors.amber,
                ),
                onPressed: () => setState(() => _rating = star),
              );
            }),
          ),
          const SizedBox(height: AppTheme.spaceM),
          TextField(
            controller: _commentController,
            maxLines: 4,
            maxLength: 1000,
            decoration: const InputDecoration(
              labelText: 'Nhận xét (không bắt buộc)',
              border: OutlineInputBorder(),
              alignLabelWithHint: true,
            ),
          ),
          const SizedBox(height: AppTheme.spaceM),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              minimumSize: const Size.fromHeight(48),
            ),
            onPressed: () => Navigator.of(context).pop(
              ReviewFormResult(
                rating: _rating,
                comment: _commentController.text.trim(),
              ),
            ),
            child: Text(isEditing ? 'Cập nhật' : 'Gửi đánh giá'),
          ),
        ],
      ),
    );
  }
}
```

- [ ] **Step 4: Gắn khu review vào `product_detail_screen.dart`**

Thêm import:

```dart
import '../providers/review_provider.dart';
import '../widgets/review_form_sheet.dart';
import '../widgets/review_list.dart';
```

Sửa signature `_buildBody` để nhận `WidgetRef`:

```dart
  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ProductDetailState state,
    ProductDetailNotifier notifier,
  ) {
```

Và trong `build()`, sửa lời gọi thành:

```dart
      body: _buildBody(context, ref, state, notifier),
```

Thêm vào cuối `Column` bên trong `Padding` (sau khối mô tả):

```dart
              const SizedBox(height: AppTheme.spaceL),
              const Divider(),
              const SizedBox(height: AppTheme.spaceM),
              _buildReviewSection(context, ref),
```

Thêm method mới vào class `ProductDetailScreen`:

```dart
  Widget _buildReviewSection(BuildContext context, WidgetRef ref) {
    final reviewState = ref.watch(reviewProvider(productId));
    final reviewNotifier = ref.read(reviewProvider(productId).notifier);

    Future<void> openForm() async {
      final result = await showReviewFormSheet(
        context,
        existing: reviewState.myReview,
      );
      if (result == null) return;

      try {
        if (reviewState.myReview != null) {
          await reviewNotifier.edit(
            id: reviewState.myReview!.id,
            rating: result.rating,
            comment: result.comment,
          );
        } else {
          await reviewNotifier.submit(
            rating: result.rating,
            comment: result.comment,
          );
        }
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu đánh giá của bạn.')),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString().replaceFirst('Exception: ', ''),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Đánh giá',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: reviewState.isSubmitting ? null : openForm,
              icon: Icon(
                reviewState.myReview != null ? Icons.edit : Icons.rate_review,
                size: 18,
              ),
              label: Text(
                reviewState.myReview != null ? 'Sửa đánh giá' : 'Viết đánh giá',
              ),
            ),
          ],
        ),
        if (reviewState.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppTheme.spaceM),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          ReviewList(reviews: reviewState.reviews),
        if (reviewState.hasMore)
          Center(
            child: TextButton(
              onPressed: reviewNotifier.loadMore,
              child: const Text('Xem thêm đánh giá'),
            ),
          ),
      ],
    );
  }
```

- [ ] **Step 5: Kiểm tra thủ công**

1. Mở chi tiết sản phẩm → cuộn xuống thấy khu "Đánh giá", ban đầu ghi "Chưa có đánh giá nào"
2. Bấm "Viết đánh giá" → chọn 4 sao, nhập nhận xét → Gửi
3. Danh sách hiện đánh giá vừa gửi, nút đổi thành "Sửa đánh giá"
4. Bấm "Sửa đánh giá" → form hiện lại đúng 4 sao và nhận xét cũ → đổi thành 5 sao → Cập nhật → danh sách cập nhật

- [ ] **Step 6: Commit**

```bash
flutter analyze lib/features/catalog
git add lib/features/catalog
git commit -m "feat(catalog): add product reviews with submit and edit"
```

---

## Nghiệm thu cuối

- [ ] `flutter analyze` — không lỗi trên toàn bộ `lib/`
- [ ] Tab "Danh mục" hiện lưới 4 sản phẩm seed kèm ảnh và giá `250.000 ₫`
- [ ] Chip danh mục lọc đúng; chip "Tất cả" bỏ lọc
- [ ] Bộ lọc khoảng giá / size / màu / sắp xếp đều đổi kết quả
- [ ] Icon lọc hiện chấm đỏ khi đang có filter
- [ ] Search "áo" trả kết quả sau ~400ms, không bắn request mỗi ký tự
- [ ] Chi tiết: chọn size + màu → giá, tồn kho, SKU đổi theo đúng biến thể
- [ ] Đổi size làm bỏ chọn màu
- [ ] Gửi đánh giá thành công; gửi lần 2 chuyển sang chế độ sửa
- [ ] Nút "Thêm vào giỏ" disabled kèm tooltip
- [ ] `git diff lib/core/` **chỉ** cho thấy route `/products/:id` được thêm
- [ ] Đã báo Member 1 + leader về thay đổi trong `core/router/app_router.dart`

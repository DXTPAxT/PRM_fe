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

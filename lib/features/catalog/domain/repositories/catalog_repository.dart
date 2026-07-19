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
    int page = 1,
    int limit = 10,
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

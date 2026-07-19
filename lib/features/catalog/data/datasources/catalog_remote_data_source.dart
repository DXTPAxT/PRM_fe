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

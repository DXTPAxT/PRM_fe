import '../../../../shared/models/review.dart';
import '../repositories/catalog_repository.dart';

class GetProductReviewsUseCase {
  final CatalogRepository _repository;
  GetProductReviewsUseCase(this._repository);

  Future<PagedResult<Review>> call(String productId, {int page = 1}) =>
      _repository.getProductReviews(productId, page: page);
}

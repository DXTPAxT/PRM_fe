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

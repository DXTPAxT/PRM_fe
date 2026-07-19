import '../../../../shared/models/product.dart';
import '../repositories/catalog_repository.dart';

class GetProductDetailUseCase {
  final CatalogRepository _repository;
  GetProductDetailUseCase(this._repository);

  Future<Product> call(String id) => _repository.getProductDetail(id);
}

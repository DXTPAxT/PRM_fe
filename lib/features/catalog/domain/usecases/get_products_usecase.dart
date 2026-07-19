import '../../../../shared/models/product.dart';
import '../../data/models/product_query.dart';
import '../repositories/catalog_repository.dart';

class GetProductsUseCase {
  final CatalogRepository _repository;
  GetProductsUseCase(this._repository);

  Future<PagedResult<Product>> call(ProductQuery query) =>
      _repository.getProducts(query);
}

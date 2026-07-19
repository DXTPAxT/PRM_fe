import '../../../../shared/models/category.dart';
import '../repositories/catalog_repository.dart';

class GetCategoriesUseCase {
  final CatalogRepository _repository;
  GetCategoriesUseCase(this._repository);

  Future<List<Category>> call() => _repository.getCategories();
}

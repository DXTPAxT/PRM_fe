import '../../data/models/cart_response.dart';
import '../repositories/cart_repository.dart';

class GetCartUseCase {
  final CartRepository _repository;
  GetCartUseCase(this._repository);

  Future<CartResponse> call() => _repository.getCart();
}

class AddToCartUseCase {
  final CartRepository _repository;
  AddToCartUseCase(this._repository);

  Future<CartResponse> call({
    required String variantId,
    required int quantity,
  }) =>
      _repository.addItem(variantId: variantId, quantity: quantity);
}

class UpdateCartQtyUseCase {
  final CartRepository _repository;
  UpdateCartQtyUseCase(this._repository);

  Future<CartResponse> call({
    required String itemId,
    required int quantity,
  }) =>
      _repository.updateItem(itemId: itemId, quantity: quantity);
}

class RemoveFromCartUseCase {
  final CartRepository _repository;
  RemoveFromCartUseCase(this._repository);

  Future<CartResponse> call(String itemId) => _repository.removeItem(itemId);
}

class ClearCartUseCase {
  final CartRepository _repository;
  ClearCartUseCase(this._repository);

  Future<CartResponse> call() => _repository.clear();
}

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
      final firstVariant =
          product.variants.isNotEmpty ? product.variants.first : null;
      state = ProductDetailState(
        product: product,
        selectedSize: firstVariant?.size,
        selectedColor: firstVariant?.color,
      );
    } catch (error) {
      state = state.copyWith(
        isLoading: false,
        errorMessage: error.toString().replaceFirst('Exception: ', ''),
      );
    }
  }

  void selectSize(String size) {
    final availableForSize = state.product?.variants
            .where((v) => v.size == size)
            .map((v) => v.color)
            .toList() ??
        [];
    final validColor = availableForSize.contains(state.selectedColor)
        ? state.selectedColor
        : (availableForSize.isNotEmpty ? availableForSize.first : null);
    state = state.copyWith(
      selectedSize: size,
      selectedColor: validColor,
    );
  }

  void selectColor(String color) {
    state = state.copyWith(selectedColor: color);
  }
}

final productDetailProvider = StateNotifierProvider.family
    .autoDispose<ProductDetailNotifier, ProductDetailState, String>(
  (ref, productId) => ProductDetailNotifier(ref, productId),
);

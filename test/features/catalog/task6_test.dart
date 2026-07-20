import 'package:clothing_store_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:clothing_store_app/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:clothing_store_app/features/catalog/presentation/providers/product_detail_provider.dart';
import 'package:clothing_store_app/features/catalog/presentation/screens/product_detail_screen.dart';
import 'package:clothing_store_app/shared/models/product.dart';
import 'package:clothing_store_app/shared/models/product_variant.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCatalogRepository implements CatalogRepository {
  final Product dummyProduct = const Product(
    id: 'prod-1',
    categoryId: 'cat-1',
    categoryName: 'Áo thun',
    name: 'Áo thun basic',
    description: 'Cotton 100% thoáng mát',
    basePrice: 250000,
    status: 'active',
    avgRating: 4.5,
    reviewCount: 10,
    images: [],
    variants: [
      ProductVariant(
        id: 'var-m-black',
        productId: 'prod-1',
        size: 'M',
        color: 'Đen',
        price: 260000,
        stockQty: 10,
        sku: 'AT-M-DEN',
      ),
      ProductVariant(
        id: 'var-m-white',
        productId: 'prod-1',
        size: 'M',
        color: 'Trắng',
        price: 260000,
        stockQty: 5,
        sku: 'AT-M-TRANG',
      ),
      ProductVariant(
        id: 'var-l-black',
        productId: 'prod-1',
        size: 'L',
        color: 'Đen',
        price: 270000,
        stockQty: 0,
        sku: 'AT-L-DEN',
      ),
    ],
  );

  @override
  Future<Product> getProductDetail(String id) async {
    if (id == 'prod-1') {
      return dummyProduct;
    }
    throw Exception('Sản phẩm không tồn tại');
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Task 6 - Product Detail & Variant Selector', () {
    test('ProductDetailState logic: available sizes, colors filtering & selection', () {
      final repo = MockCatalogRepository();
      final product = repo.dummyProduct;

      var state = ProductDetailState(product: product);

      // Scenario 1: Initial state
      expect(state.availableSizes, containsAll(['M', 'L']));
      expect(state.selectedSize, isNull);
      expect(state.selectedColor, isNull);
      expect(state.selectedVariant, isNull);

      // Scenario 2: Select size 'M'
      state = state.copyWith(selectedSize: 'M', clearColor: true);
      expect(state.selectedSize, equals('M'));
      expect(state.availableColors, containsAll(['Đen', 'Trắng']));
      expect(state.selectedVariant, isNull);

      // Scenario 3: Select color 'Đen'
      state = state.copyWith(selectedColor: 'Đen');
      expect(state.selectedVariant, isNotNull);
      expect(state.selectedVariant!.sku, equals('AT-M-DEN'));
      expect(state.selectedVariant!.price, equals(260000));

      // Scenario 4: Change size to 'L' -> resets selected color
      state = state.copyWith(selectedSize: 'L', clearColor: true);
      expect(state.selectedSize, equals('L'));
      expect(state.selectedColor, isNull);
      expect(state.selectedVariant, isNull);
      expect(state.availableColors, containsAll(['Đen']));
    });

    testWidgets('ProductDetailScreen displays detail and handles variant interaction & cart button states', (tester) async {
      final mockRepo = MockCatalogRepository();

      // Set screen height larger to accommodate full detail screen
      tester.view.physicalSize = const Size(800, 1600);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(
            home: ProductDetailScreen(productId: 'prod-1'),
          ),
        ),
      );

      // Pump to finish async provider load
      await tester.pumpAndSettle();

      // Check product title, category, description
      expect(find.text('Áo thun basic'), findsOneWidget);
      expect(find.text('Cotton 100% thoáng mát'), findsOneWidget);

      // Price block for variant is NOT visible initially
      expect(find.text('SKU: AT-M-DEN'), findsNothing);

      // Scenario 2: Select size 'M'
      final chipM = find.widgetWithText(ChoiceChip, 'M');
      await tester.ensureVisible(chipM);
      await tester.tap(chipM);
      await tester.pumpAndSettle();

      // Scenario 3: Select color 'Đen'
      final chipDen = find.widgetWithText(ChoiceChip, 'Đen');
      await tester.ensureVisible(chipDen);
      await tester.tap(chipDen);
      await tester.pumpAndSettle();

      // Price block, stock and SKU should now be visible
      expect(find.text('260.000 ₫'), findsWidgets);
      expect(find.text('Còn 10 sản phẩm'), findsOneWidget);
      expect(find.text('SKU: AT-M-DEN'), findsOneWidget);

      // Scenario 4: Switch size to 'L' -> color is cleared, SKU block disappears
      final chipL = find.widgetWithText(ChoiceChip, 'L');
      await tester.ensureVisible(chipL);
      await tester.tap(chipL);
      await tester.pumpAndSettle();
      expect(find.text('SKU: AT-M-DEN'), findsNothing);

      // Scenario 5: Chưa chọn đủ biến thể (vừa đổi size L nên color bị xóa)
      // -> nút giỏ hàng disabled và nhắc chọn size/màu.
      // (Member 3 đã nối chức năng giỏ hàng; trước đây nút luôn disabled.)
      final promptBtnFinder =
          find.widgetWithText(ElevatedButton, 'Chọn size và màu');
      expect(promptBtnFinder, findsOneWidget);
      final ElevatedButton promptBtn = tester.widget(promptBtnFinder);
      expect(promptBtn.onPressed, isNull); // disabled khi chưa đủ biến thể

      // Chọn màu 'Đen' cho size L — biến thể này stockQty = 0
      // -> nút hiển thị "Hết hàng" và vẫn disabled.
      final chipDenL = find.widgetWithText(ChoiceChip, 'Đen');
      await tester.ensureVisible(chipDenL);
      await tester.tap(chipDenL);
      await tester.pumpAndSettle();

      final outOfStockFinder =
          find.widgetWithText(ElevatedButton, 'Hết hàng');
      expect(outOfStockFinder, findsOneWidget);
      final ElevatedButton outOfStockBtn = tester.widget(outOfStockFinder);
      expect(outOfStockBtn.onPressed, isNull); // hết hàng -> không cho thêm
    });
  });
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:clothing_store_app/features/catalog/data/models/product_query.dart';
import 'package:clothing_store_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:clothing_store_app/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:clothing_store_app/features/catalog/presentation/screens/search_screen.dart';
import 'package:clothing_store_app/features/catalog/presentation/widgets/filter_bottom_sheet.dart';
import 'package:clothing_store_app/shared/models/product.dart';

class MockCatalogRepository implements CatalogRepository {
  List<ProductQuery> queriesHandled = [];

  @override
  Future<PagedResult<Product>> getProducts(ProductQuery query) async {
    queriesHandled.add(query);
    if (query.search == 'áo') {
      return const PagedResult(
        items: [
          Product(
            id: '1',
            categoryId: 'cat1',
            name: 'Áo thun basic',
            basePrice: 250000,
            status: 'active',
          ),
        ],
        page: 1,
        totalPages: 1,
      );
    }
    return const PagedResult(items: [], page: 1, totalPages: 1);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Task 5 - Filter Bottom Sheet & Constants', () {
    test('Check hardcoded sizes and colors constants', () {
      expect(kAvailableSizes, equals(['S', 'M', 'L', 'XL']));
      expect(kAvailableColors, equals(['Đen', 'Trắng', 'Xanh', 'Be']));
    });

    testWidgets('Filter bottom sheet applies price and variant filters', (tester) async {
      ProductQuery? resultQuery;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  resultQuery = await showFilterBottomSheet(
                    context,
                    const ProductQuery(),
                  );
                },
                child: const Text('Open Filter'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Filter'));
      await tester.pumpAndSettle();

      expect(find.text('Bộ lọc'), findsOneWidget);
      expect(find.text('Khoảng giá'), findsOneWidget);

      // Enter Min Price 200000 and Max Price 400000
      final textFields = find.byType(TextField);
      await tester.enterText(textFields.at(0), '200000');
      await tester.enterText(textFields.at(1), '400000');

      // Select Size 'M'
      await tester.tap(find.text('M'));
      await tester.pumpAndSettle();

      // Tap 'Áp dụng'
      await tester.tap(find.text('Áp dụng'));
      await tester.pumpAndSettle();

      expect(resultQuery, isNotNull);
      expect(resultQuery!.minPrice, 200000);
      expect(resultQuery!.maxPrice, 400000);
      expect(resultQuery!.size, 'M');
      expect(resultQuery!.hasActiveFilter, isTrue);
    });

    testWidgets('Filter bottom sheet clears filters', (tester) async {
      ProductQuery? resultQuery;

      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: Builder(
              builder: (context) => ElevatedButton(
                onPressed: () async {
                  resultQuery = await showFilterBottomSheet(
                    context,
                    const ProductQuery(minPrice: 200000, size: 'M'),
                  );
                },
                child: const Text('Open Filter'),
              ),
            ),
          ),
        ),
      );

      await tester.tap(find.text('Open Filter'));
      await tester.pumpAndSettle();

      await tester.tap(find.text('Xóa lọc'));
      await tester.pumpAndSettle();

      expect(resultQuery, isNotNull);
      expect(resultQuery!.minPrice, isNull);
      expect(resultQuery!.maxPrice, isNull);
      expect(resultQuery!.size, isNull);
      expect(resultQuery!.hasActiveFilter, isFalse);
    });
  });

  group('Task 5 - Search Screen Debounce', () {
    testWidgets('Search screen debounces input by 400ms', (tester) async {
      final mockRepo = MockCatalogRepository();

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogRepositoryProvider.overrideWithValue(mockRepo),
          ],
          child: const MaterialApp(
            home: SearchScreen(),
          ),
        ),
      );

      // Initially shows search prompt
      expect(find.text('Tìm kiếm sản phẩm'), findsOneWidget);

      // Type "á"
      await tester.enterText(find.byType(TextField), 'á');
      await tester.pump(const Duration(milliseconds: 200));

      // 200ms has elapsed - request should not have been fired yet
      expect(mockRepo.queriesHandled, isEmpty);

      // Type "áo" before 400ms finished -> cancels previous timer and starts new 400ms timer
      await tester.enterText(find.byType(TextField), 'áo');
      await tester.pump(const Duration(milliseconds: 300));
      // Total elapsed from second type: 300ms < 400ms -> still no request
      expect(mockRepo.queriesHandled, isEmpty);

      // Pump remaining 150ms to pass the 400ms boundary + network completion
      await tester.pump(const Duration(milliseconds: 150));
      await tester.pumpAndSettle();

      // Request fired with search="áo"
      expect(mockRepo.queriesHandled.length, 1);
      expect(mockRepo.queriesHandled.first.search, 'áo');
      expect(find.text('Áo thun basic'), findsOneWidget);
    });
  });
}

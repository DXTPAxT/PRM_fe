import 'package:clothing_store_app/features/auth/presentation/providers/auth_provider.dart';
import 'package:clothing_store_app/features/catalog/domain/repositories/catalog_repository.dart';
import 'package:clothing_store_app/features/catalog/presentation/providers/catalog_provider.dart';
import 'package:clothing_store_app/features/catalog/presentation/screens/product_detail_screen.dart';
import 'package:clothing_store_app/features/catalog/presentation/widgets/review_list.dart';
import 'package:clothing_store_app/shared/models/product.dart';
import 'package:clothing_store_app/shared/models/review.dart';
import 'package:clothing_store_app/shared/models/user.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_test/flutter_test.dart';

class MockCatalogRepositoryForReview implements CatalogRepository {
  final List<Review> reviews = [
    const Review(
      id: 'rev-1',
      userId: 'other-user',
      userFullName: 'Trần Văn B',
      productId: 'prod-1',
      rating: 4,
      comment: 'Hàng đẹp, vải mát',
    ),
  ];

  final Product dummyProduct = const Product(
    id: 'prod-1',
    categoryId: 'cat-1',
    categoryName: 'Áo thun',
    name: 'Áo thun basic',
    description: 'Cotton 100%',
    basePrice: 250000,
    status: 'active',
  );

  @override
  Future<Product> getProductDetail(String id) async => dummyProduct;

  @override
  Future<PagedResult<Review>> getProductReviews(
    String productId, {
    int page = 1,
    int limit = 10,
  }) async {
    return PagedResult(
      items: List.from(reviews),
      page: page,
      totalPages: 1,
    );
  }

  @override
  Future<Review> createReview({
    required String productId,
    required int rating,
    String? comment,
  }) async {
    final existing = reviews.where((r) => r.userId == 'user-123');
    if (existing.isNotEmpty) {
      throw Exception('Bạn đã đánh giá sản phẩm này rồi');
    }
    final newReview = Review(
      id: 'rev-my',
      userId: 'user-123',
      userFullName: 'Nguyễn Văn A',
      productId: productId,
      rating: rating,
      comment: comment,
    );
    reviews.add(newReview);
    return newReview;
  }

  @override
  Future<Review> updateReview({
    required String id,
    int? rating,
    String? comment,
  }) async {
    final index = reviews.indexWhere((r) => r.id == id);
    if (index == -1) throw Exception('Không tìm thấy đánh giá');
    final old = reviews[index];
    final updated = Review(
      id: old.id,
      userId: old.userId,
      userFullName: old.userFullName,
      productId: old.productId,
      rating: rating ?? old.rating,
      comment: comment ?? old.comment,
    );
    reviews[index] = updated;
    return updated;
  }

  @override
  Future<void> deleteReview(String id) async {
    reviews.removeWhere((r) => r.id == id);
  }

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

class TestAuthNotifier extends StateNotifier<AuthState> implements AuthNotifier {
  TestAuthNotifier(User user) : super(AuthState.authenticated(user));

  @override
  dynamic noSuchMethod(Invocation invocation) => super.noSuchMethod(invocation);
}

void main() {
  group('Task 7 - Product Reviews', () {
    testWidgets('ReviewList displays empty state when reviews is empty', (tester) async {
      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ReviewList(reviews: []),
          ),
        ),
      );

      expect(find.text('Chưa có đánh giá nào. Hãy là người đầu tiên!'), findsOneWidget);
    });

    testWidgets('ReviewList renders reviews correctly', (tester) async {
      const reviewList = [
        Review(
          id: 'rev-1',
          userId: 'u1',
          userFullName: 'Lê Văn C',
          productId: 'p1',
          rating: 5,
          comment: 'Rất tuyệt vời!',
        ),
      ];

      await tester.pumpWidget(
        const MaterialApp(
          home: Scaffold(
            body: ReviewList(reviews: reviewList),
          ),
        ),
      );

      expect(find.text('Lê Văn C'), findsOneWidget);
      expect(find.text('Rất tuyệt vời!'), findsOneWidget);
    });

    testWidgets('ProductDetailScreen integrates reviews and handles create/edit flow', (tester) async {
      final mockRepo = MockCatalogRepositoryForReview();

      tester.view.physicalSize = const Size(800, 2000);
      tester.view.devicePixelRatio = 1.0;
      addTearDown(tester.view.resetPhysicalSize);

      const fakeUser = User(
        id: 'user-123',
        email: 'user@example.com',
        fullName: 'Nguyễn Văn A',
        role: 'customer',
      );

      await tester.pumpWidget(
        ProviderScope(
          overrides: [
            catalogRepositoryProvider.overrideWithValue(mockRepo),
            authProvider.overrideWith((ref) => TestAuthNotifier(fakeUser)),
          ],
          child: const MaterialApp(
            home: ProductDetailScreen(productId: 'prod-1'),
          ),
        ),
      );

      await tester.pumpAndSettle();

      // Initially 1 review from 'Trần Văn B'
      expect(find.text('Trần Văn B'), findsOneWidget);
      expect(find.text('Viết đánh giá'), findsOneWidget);

      // Tap "Viết đánh giá"
      await tester.tap(find.text('Viết đánh giá'));
      await tester.pumpAndSettle();

      // ReviewFormSheet pops up
      expect(find.text('Viết đánh giá'), findsWidgets);
      final textField = find.byType(TextField);
      await tester.enterText(textField, 'Sản phẩm quá đẹp');
      await tester.tap(find.text('Gửi đánh giá'));
      await tester.pumpAndSettle();

      // Check review created, myReview populated, button changed to "Sửa đánh giá"
      expect(find.text('Sửa đánh giá'), findsOneWidget);
      expect(find.text('Sản phẩm quá đẹp'), findsOneWidget);

      // Tap "Sửa đánh giá"
      await tester.tap(find.text('Sửa đánh giá'));
      await tester.pumpAndSettle();

      expect(find.text('Sửa đánh giá'), findsWidgets);
      expect(find.text('Sản phẩm quá đẹp'), findsWidgets); // Pre-filled comment in sheet & list item

      await tester.enterText(find.byType(TextField), 'Đã dùng 1 tuần, rất ưng');
      await tester.tap(find.text('Cập nhật'));
      await tester.pumpAndSettle();

      expect(find.text('Đã dùng 1 tuần, rất ưng'), findsOneWidget);
    });
  });
}

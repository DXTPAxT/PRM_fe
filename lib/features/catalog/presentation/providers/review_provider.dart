import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../shared/models/review.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import 'catalog_provider.dart';

class ReviewState {
  final List<Review> reviews;
  final Review? myReview;
  final int page;
  final bool hasMore;
  final bool isLoading;
  final bool isSubmitting;
  final String? errorMessage;

  const ReviewState({
    this.reviews = const [],
    this.myReview,
    this.page = 1,
    this.hasMore = false,
    this.isLoading = false,
    this.isSubmitting = false,
    this.errorMessage,
  });

  ReviewState copyWith({
    List<Review>? reviews,
    Review? myReview,
    int? page,
    bool? hasMore,
    bool? isLoading,
    bool? isSubmitting,
    String? errorMessage,
    bool clearError = false,
    bool clearMyReview = false,
  }) {
    return ReviewState(
      reviews: reviews ?? this.reviews,
      myReview: clearMyReview ? null : myReview ?? this.myReview,
      page: page ?? this.page,
      hasMore: hasMore ?? this.hasMore,
      isLoading: isLoading ?? this.isLoading,
      isSubmitting: isSubmitting ?? this.isSubmitting,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class ReviewNotifier extends StateNotifier<ReviewState> {
  final Ref _ref;
  final String productId;

  ReviewNotifier(this._ref, this.productId) : super(const ReviewState()) {
    load();
  }

  String _clean(Object error) =>
      error.toString().replaceFirst('Exception: ', '');

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final result = await _ref
          .read(catalogRepositoryProvider)
          .getProductReviews(productId, page: 1);
      final currentUserId = _ref.read(authProvider).user?.id;

      Review? mine;
      for (final review in result.items) {
        if (review.userId == currentUserId) {
          mine = review;
          break;
        }
      }

      state = ReviewState(
        reviews: result.items,
        myReview: mine,
        page: result.page,
        hasMore: result.hasMore,
      );
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: _clean(error));
    }
  }

  Future<void> loadMore() async {
    if (!state.hasMore || state.isLoading) return;
    try {
      final result = await _ref
          .read(catalogRepositoryProvider)
          .getProductReviews(productId, page: state.page + 1);
      state = state.copyWith(
        reviews: [...state.reviews, ...result.items],
        page: result.page,
        hasMore: result.hasMore,
      );
    } catch (error) {
      state = state.copyWith(errorMessage: _clean(error));
    }
  }

  /// Gửi đánh giá mới. BE trả 409 nếu user đã đánh giá sản phẩm này.
  Future<void> submit({required int rating, String? comment}) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await _ref.read(catalogRepositoryProvider).createReview(
            productId: productId,
            rating: rating,
            comment: comment,
          );
      state = state.copyWith(isSubmitting: false);
      await load();
    } catch (error) {
      state = state.copyWith(isSubmitting: false, errorMessage: _clean(error));
      rethrow;
    }
  }

  Future<void> edit({
    required String id,
    required int rating,
    String? comment,
  }) async {
    state = state.copyWith(isSubmitting: true, clearError: true);
    try {
      await _ref.read(catalogRepositoryProvider).updateReview(
            id: id,
            rating: rating,
            comment: comment,
          );
      state = state.copyWith(isSubmitting: false);
      await load();
    } catch (error) {
      state = state.copyWith(isSubmitting: false, errorMessage: _clean(error));
      rethrow;
    }
  }

  Future<void> remove(String id) async {
    try {
      await _ref.read(catalogRepositoryProvider).deleteReview(id);
      state = state.copyWith(clearMyReview: true);
      await load();
    } catch (error) {
      state = state.copyWith(errorMessage: _clean(error));
      rethrow;
    }
  }
}

final reviewProvider = StateNotifierProvider.family
    .autoDispose<ReviewNotifier, ReviewState, String>(
  (ref, productId) => ReviewNotifier(ref, productId),
);

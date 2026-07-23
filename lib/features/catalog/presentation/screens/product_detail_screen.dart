import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../shared/models/product_variant.dart';
import '../../../cart/presentation/providers/cart_provider.dart';
import '../../../wishlist/presentation/providers/wishlist_provider.dart';
import '../providers/product_detail_provider.dart';
import '../providers/review_provider.dart';
import '../widgets/product_card.dart' show formatVnd;
import '../widgets/review_form_sheet.dart';
import '../widgets/review_list.dart';
import '../widgets/variant_selector.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productDetailProvider(productId));
    final notifier = ref.read(productDetailProvider(productId).notifier);
    final isWishlisted = ref.watch(isInWishlistProvider(productId));

    return Scaffold(
      appBar: AppBar(
        title: const Text('Chi tiết sản phẩm'),
        actions: [
          IconButton(
            icon: Icon(
              isWishlisted ? Icons.favorite : Icons.favorite_border,
              color: isWishlisted ? Colors.red : null,
            ),
            tooltip: isWishlisted ? 'Xóa khỏi yêu thích' : 'Thêm vào yêu thích',
            onPressed: () async {
              final added = await ref.read(wishlistProvider.notifier).toggle(productId);
              if (context.mounted) {
                ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                  content: Text(added
                      ? 'Đã thêm vào danh sách yêu thích'
                      : 'Đã xóa khỏi danh sách yêu thích'),
                ));
              }
            },
          ),
        ],
      ),
      body: _buildBody(context, ref, state, notifier),
      bottomNavigationBar: state.product == null
          ? null
          : _AddToCartBar(variant: state.selectedVariant),
    );
  }

  Widget _buildBody(
    BuildContext context,
    WidgetRef ref,
    ProductDetailState state,
    ProductDetailNotifier notifier,
  ) {
    if (state.isLoading) {
      return const LoadingIndicator(message: 'Đang tải sản phẩm...');
    }

    if (state.errorMessage != null) {
      return ErrorStateWidget(
        message: state.errorMessage!,
        onRetry: notifier.load,
      );
    }

    final product = state.product;
    if (product == null) {
      return const EmptyStateWidget(
        icon: Icons.inventory_2_outlined,
        title: 'Không tìm thấy',
        message: 'Sản phẩm này không còn tồn tại.',
      );
    }

    return ListView(
      padding: const EdgeInsets.only(bottom: AppTheme.spaceL),
      children: [
        if (product.images.isNotEmpty)
          SizedBox(
            height: 320,
            child: PageView.builder(
              itemCount: product.images.length,
              itemBuilder: (context, index) => Image.network(
                product.images[index].url,
                fit: BoxFit.cover,
                errorBuilder: (context, error, stack) => Container(
                  color: Colors.grey.shade200,
                  child: Icon(
                    Icons.broken_image_outlined,
                    size: 48,
                    color: Colors.grey.shade400,
                  ),
                ),
              ),
            ),
          ),
        Padding(
          padding: const EdgeInsets.all(AppTheme.spaceL),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                product.name,
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spaceS),
              Row(
                children: [
                  const Icon(Icons.star, size: 18, color: Colors.amber),
                  const SizedBox(width: 4),
                  Text(
                    product.reviewCount == 0
                        ? 'Chưa có đánh giá'
                        : '${product.avgRating} · ${product.reviewCount} đánh giá',
                  ),
                  const Spacer(),
                  Chip(label: Text(product.categoryName)),
                ],
              ),
              const SizedBox(height: AppTheme.spaceS),
              Text(
                formatVnd(product.basePrice),
                style: Theme.of(context).textTheme.headlineSmall?.copyWith(
                      color: Theme.of(context).colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
              ),
              const SizedBox(height: AppTheme.spaceL),

              VariantSelector(
                state: state,
                onSizeSelected: notifier.selectSize,
                onColorSelected: notifier.selectColor,
              ),

              if (product.description != null &&
                  product.description!.isNotEmpty) ...[
                const SizedBox(height: AppTheme.spaceL),
                const Text(
                  'Mô tả',
                  style: TextStyle(fontWeight: FontWeight.w600),
                ),
                const SizedBox(height: AppTheme.spaceS),
                Text(product.description!),
              ],

              const SizedBox(height: AppTheme.spaceL),
              const Divider(),
              const SizedBox(height: AppTheme.spaceM),
              _buildReviewSection(context, ref),
            ],
          ),
        ),
      ],
    );
  }

  Widget _buildReviewSection(BuildContext context, WidgetRef ref) {
    final reviewState = ref.watch(reviewProvider(productId));
    final reviewNotifier = ref.read(reviewProvider(productId).notifier);

    Future<void> openForm() async {
      final result = await showReviewFormSheet(
        context,
        existing: reviewState.myReview,
      );
      if (result == null) return;

      try {
        if (reviewState.myReview != null) {
          await reviewNotifier.edit(
            id: reviewState.myReview!.id,
            rating: result.rating,
            comment: result.comment,
          );
        } else {
          await reviewNotifier.submit(
            rating: result.rating,
            comment: result.comment,
          );
        }
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã lưu đánh giá của bạn.')),
        );
      } catch (error) {
        if (!context.mounted) return;
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              error.toString().replaceFirst('Exception: ', ''),
            ),
          ),
        );
      }
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            const Text(
              'Đánh giá',
              style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
            ),
            const Spacer(),
            TextButton.icon(
              onPressed: reviewState.isSubmitting ? null : openForm,
              icon: Icon(
                reviewState.myReview != null ? Icons.edit : Icons.rate_review,
                size: 18,
              ),
              label: Text(
                reviewState.myReview != null ? 'Sửa đánh giá' : 'Viết đánh giá',
              ),
            ),
          ],
        ),
        if (reviewState.isLoading)
          const Padding(
            padding: EdgeInsets.symmetric(vertical: AppTheme.spaceM),
            child: Center(child: CircularProgressIndicator()),
          )
        else
          ReviewList(reviews: reviewState.reviews),
        if (reviewState.hasMore)
          Center(
            child: TextButton(
              onPressed: reviewNotifier.loadMore,
              child: const Text('Xem thêm đánh giá'),
            ),
          ),
      ],
    );
  }
}

/// Nút thêm vào giỏ (Member 3). Chỉ bật khi đã chọn đủ biến thể và còn hàng.
class _AddToCartBar extends ConsumerStatefulWidget {
  final ProductVariant? variant;

  const _AddToCartBar({required this.variant});

  @override
  ConsumerState<_AddToCartBar> createState() => _AddToCartBarState();
}

class _AddToCartBarState extends ConsumerState<_AddToCartBar> {
  bool _isAdding = false;

  Future<void> _addToCart() async {
    final variant = widget.variant;
    if (variant == null) return;

    setState(() => _isAdding = true);
    final ok = await ref
        .read(cartProvider.notifier)
        .addItem(variantId: variant.id, quantity: 1);
    if (!mounted) return;
    setState(() => _isAdding = false);

    if (ok) {
      final messenger = ScaffoldMessenger.of(context);
      messenger
        ..hideCurrentSnackBar()
        ..showSnackBar(
          SnackBar(
            content: const Text('Đã thêm vào giỏ hàng'),
            duration: const Duration(seconds: 3),
            action: SnackBarAction(
              label: 'Xem giỏ',
              onPressed: () {
                messenger.hideCurrentSnackBar();
                context.go('/cart');
              },
            ),
          ),
        );
    }
    // Lỗi đã được cartProvider set vào state; hiện luôn ở đây cho tiện.
    final error = ref.read(cartProvider).errorMessage;
    if (!ok && error != null) {
      ScaffoldMessenger.of(context)
        ..hideCurrentSnackBar()
        ..showSnackBar(SnackBar(content: Text(error)));
    }
  }

  @override
  Widget build(BuildContext context) {
    final variant = widget.variant;
    final outOfStock = variant != null && variant.stockQty <= 0;
    final enabled = variant != null && !outOfStock && !_isAdding;

    final label = variant == null
        ? 'Chọn size và màu'
        : outOfStock
            ? 'Hết hàng'
            : 'Thêm vào giỏ';

    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceM),
        child: ElevatedButton.icon(
          onPressed: enabled ? _addToCart : null,
          icon: _isAdding
              ? const SizedBox(
                  width: 20,
                  height: 20,
                  child: CircularProgressIndicator(
                    strokeWidth: 2,
                    color: Colors.white,
                  ),
                )
              : const Icon(Icons.shopping_cart_outlined),
          label: Text(label),
          style: ElevatedButton.styleFrom(
            minimumSize: const Size.fromHeight(48),
          ),
        ),
      ),
    );
  }
}

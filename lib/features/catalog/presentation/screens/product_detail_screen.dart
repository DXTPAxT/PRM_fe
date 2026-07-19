import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../providers/product_detail_provider.dart';
import '../widgets/product_card.dart' show formatVnd;
import '../widgets/variant_selector.dart';

class ProductDetailScreen extends ConsumerWidget {
  final String productId;

  const ProductDetailScreen({super.key, required this.productId});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(productDetailProvider(productId));
    final notifier = ref.read(productDetailProvider(productId).notifier);

    return Scaffold(
      appBar: AppBar(title: const Text('Chi tiết sản phẩm')),
      body: _buildBody(context, state, notifier),
      bottomNavigationBar: state.product == null
          ? null
          : SafeArea(
              child: Padding(
                padding: const EdgeInsets.all(AppTheme.spaceM),
                child: Tooltip(
                  message: 'Chức năng giỏ hàng do Member 3 phát triển',
                  child: ElevatedButton.icon(
                    onPressed: null, // Cố ý disabled — không thuộc phần M2
                    icon: const Icon(Icons.shopping_cart_outlined),
                    label: const Text('Thêm vào giỏ'),
                    style: ElevatedButton.styleFrom(
                      minimumSize: const Size.fromHeight(48),
                    ),
                  ),
                ),
              ),
            ),
    );
  }

  Widget _buildBody(
    BuildContext context,
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
            ],
          ),
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../catalog/presentation/providers/catalog_provider.dart';
import '../../../catalog/presentation/widgets/product_card.dart';
import '../../../notifications/presentation/providers/notification_provider.dart';
import '../providers/auth_provider.dart';

class HomeScreen extends ConsumerWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final catalogState = ref.watch(catalogProvider);
    final catalogNotifier = ref.read(catalogProvider.notifier);

    final user = authState.user;

    return Scaffold(
      appBar: AppBar(
        title: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'PRM Clothing Store',
              style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
            ),
            if (user != null)
              Text(
                'Xin chào, ${user.fullName} 👋',
                style: const TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
              ),
          ],
        ),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            onPressed: () => context.push('/catalog'),
            tooltip: 'Tìm kiếm sản phẩm',
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: ref.watch(unreadCountProvider) > 0,
              label: Text('${ref.watch(unreadCountProvider)}'),
              child: const Icon(Icons.notifications_none_outlined),
            ),
            onPressed: () => context.push('/notifications'),
            tooltip: 'Thông báo',
          ),
        ],
      ),
      body: RefreshIndicator(
        onRefresh: catalogNotifier.refresh,
        child: ListView(
          padding: const EdgeInsets.all(AppTheme.spaceM),
          children: [
            // Search Input Trigger
            GestureDetector(
              onTap: () => context.push('/catalog'),
              child: Container(
                padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                decoration: BoxDecoration(
                  color: Colors.grey.shade100,
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(color: Colors.grey.shade300),
                ),
                child: Row(
                  children: [
                    Icon(Icons.search, color: Colors.grey.shade600),
                    const SizedBox(width: 12),
                    Text(
                      'Tìm kiếm sản phẩm, áo, quần...',
                      style: TextStyle(color: Colors.grey.shade600, fontSize: 14),
                    ),
                  ],
                ),
              ),
            ),
            const SizedBox(height: AppTheme.spaceL),

            // Banner Promotion Card
            _buildPromoBanner(context),
            const SizedBox(height: AppTheme.spaceL),

            // Categories Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Danh Mục Sản Phẩm',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => context.go('/catalog'),
                  child: const Text('Xem tất cả'),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceS),

            // Categories Horizontal List
            _buildCategoryList(context, ref, catalogState),
            const SizedBox(height: AppTheme.spaceL),

            // Products Section Header
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  'Sản Phẩm Nổi Bật',
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),
                TextButton(
                  onPressed: () => context.go('/catalog'),
                  child: const Text('Tất cả sản phẩm'),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceS),

            // Products Grid / Content State
            _buildProductsGrid(context, catalogState, catalogNotifier),
          ],
        ),
      ),
    );
  }

  Widget _buildPromoBanner(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(20),
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Theme.of(context).colorScheme.primary,
            Theme.of(context).colorScheme.primary.withValues(alpha: 0.75),
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(16),
        boxShadow: [
          BoxShadow(
            color: Theme.of(context).colorScheme.primary.withValues(alpha: 0.3),
            blurRadius: 10,
            offset: const Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Container(
            padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 4),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.2),
              borderRadius: BorderRadius.circular(20),
            ),
            child: const Text(
              '🔥 KHUYẾN MÃI HOT',
              style: TextStyle(
                color: Colors.white,
                fontWeight: FontWeight.bold,
                fontSize: 12,
              ),
            ),
          ),
          const SizedBox(height: 12),
          const Text(
            'Bộ Sưu Tập Mùa Hè 2026',
            style: TextStyle(
              color: Colors.white,
              fontSize: 22,
              fontWeight: FontWeight.bold,
            ),
          ),
          const SizedBox(height: 6),
          const Text(
            'Giảm tới 20% cho đơn hàng đầu tiên với mã WELCOME10',
            style: TextStyle(color: Colors.white70, fontSize: 13),
          ),
          const SizedBox(height: 16),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.white,
              foregroundColor: Theme.of(context).colorScheme.primary,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(20),
              ),
            ),
            onPressed: () => context.go('/catalog'),
            child: const Text('Khám Phá Ngay', style: TextStyle(fontWeight: FontWeight.bold)),
          ),
        ],
      ),
    );
  }

  Widget _buildCategoryList(
    BuildContext context,
    WidgetRef ref,
    CatalogState catalogState,
  ) {
    if (catalogState.categories.isEmpty) {
      return const SizedBox(
        height: 40,
        child: Center(child: Text('Đang tải danh mục...')),
      );
    }

    return SizedBox(
      height: 44,
      child: ListView.separated(
        scrollDirection: Axis.horizontal,
        itemCount: catalogState.categories.length + 1,
        separatorBuilder: (_, __) => const SizedBox(width: 8),
        itemBuilder: (context, index) {
          if (index == 0) {
            final isSelected = catalogState.query.categoryId == null;
            return ChoiceChip(
              label: const Text('Tất cả'),
              selected: isSelected,
              onSelected: (_) {
                ref.read(catalogProvider.notifier).selectCategory(null);
              },
            );
          }
          final category = catalogState.categories[index - 1];
          final isSelected = catalogState.query.categoryId == category.id;
          return ChoiceChip(
            label: Text(category.name),
            selected: isSelected,
            onSelected: (_) {
              ref.read(catalogProvider.notifier).selectCategory(category.id);
            },
          );
        },
      ),
    );
  }

  Widget _buildProductsGrid(
    BuildContext context,
    CatalogState catalogState,
    CatalogNotifier catalogNotifier,
  ) {
    if (catalogState.isLoading && catalogState.products.isEmpty) {
      return const Padding(
        padding: EdgeInsets.symmetric(vertical: 40),
        child: LoadingIndicator(message: 'Đang tải sản phẩm...'),
      );
    }

    if (catalogState.errorMessage != null && catalogState.products.isEmpty) {
      return ErrorStateWidget(
        message: catalogState.errorMessage!,
        onRetry: catalogNotifier.loadInitial,
      );
    }

    if (catalogState.products.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.inventory_2_outlined,
        title: 'Chưa có sản phẩm',
        message: 'Hiện chưa có sản phẩm nào thuộc danh mục này.',
      );
    }

    return GridView.builder(
      shrinkWrap: true,
      physics: const NeverScrollableScrollPhysics(),
      itemCount: catalogState.products.length,
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        childAspectRatio: 0.62,
        crossAxisSpacing: 12,
        mainAxisSpacing: 12,
      ),
      itemBuilder: (context, index) {
        final product = catalogState.products[index];
        return ProductCard(
          product: product,
          onTap: () => context.push('/products/${product.id}'),
        );
      },
    );
  }
}

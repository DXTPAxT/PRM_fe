import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../providers/catalog_provider.dart';
import '../widgets/product_card.dart';

import '../widgets/filter_bottom_sheet.dart';
import 'search_screen.dart';

class CatalogScreen extends ConsumerStatefulWidget {
  const CatalogScreen({super.key});

  @override
  ConsumerState<CatalogScreen> createState() => _CatalogScreenState();
}

class _CatalogScreenState extends ConsumerState<CatalogScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    _scrollController.addListener(_onScroll);
  }

  @override
  void dispose() {
    _scrollController.removeListener(_onScroll);
    _scrollController.dispose();
    super.dispose();
  }

  /// Tải thêm khi cuộn tới 80% chiều dài danh sách.
  void _onScroll() {
    if (!_scrollController.hasClients) return;
    final position = _scrollController.position;
    if (position.pixels >= position.maxScrollExtent * 0.8) {
      ref.read(catalogProvider.notifier).loadMore();
    }
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(catalogProvider);
    final notifier = ref.read(catalogProvider.notifier);

    return Scaffold(
      appBar: AppBar(
        title: const Text('Danh mục sản phẩm'),
        actions: [
          IconButton(
            icon: const Icon(Icons.search),
            tooltip: 'Tìm kiếm',
            onPressed: () => Navigator.of(context).push(
              MaterialPageRoute(builder: (_) => const SearchScreen()),
            ),
          ),
          IconButton(
            icon: Badge(
              isLabelVisible: state.query.hasActiveFilter,
              child: const Icon(Icons.filter_list),
            ),
            tooltip: 'Bộ lọc',
            onPressed: () async {
              final result = await showFilterBottomSheet(
                context,
                state.query,
              );
              if (result != null) {
                await notifier.applyQuery(result);
              }
            },
          ),
        ],
      ),
      body: Column(
        children: [
          if (state.categories.isNotEmpty)
            SizedBox(
              height: 48,
              child: ListView(
                scrollDirection: Axis.horizontal,
                padding: const EdgeInsets.symmetric(
                  horizontal: AppTheme.spaceM,
                ),
                children: [
                  Padding(
                    padding: const EdgeInsets.only(right: AppTheme.spaceS),
                    child: ChoiceChip(
                      label: const Text('Tất cả'),
                      selected: state.query.categoryId == null,
                      onSelected: (_) => notifier.selectCategory(null),
                    ),
                  ),
                  ...state.categories.map(
                    (category) => Padding(
                      padding: const EdgeInsets.only(right: AppTheme.spaceS),
                      child: ChoiceChip(
                        label: Text(category.name),
                        selected: state.query.categoryId == category.id,
                        onSelected: (_) => notifier.selectCategory(category.id),
                      ),
                    ),
                  ),
                ],
              ),
            ),
          Expanded(child: _buildBody(state, notifier)),
        ],
      ),
    );
  }

  Widget _buildBody(CatalogState state, CatalogNotifier notifier) {
    if (state.isLoading) {
      return const LoadingIndicator(message: 'Đang tải sản phẩm...');
    }

    if (state.errorMessage != null && state.products.isEmpty) {
      return ErrorStateWidget(
        message: state.errorMessage!,
        onRetry: notifier.refresh,
      );
    }

    if (state.products.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.inventory_2_outlined,
        title: 'Không có sản phẩm',
        message: 'Không tìm thấy sản phẩm nào phù hợp với bộ lọc.',
      );
    }

    return RefreshIndicator(
      onRefresh: notifier.refresh,
      child: GridView.builder(
        controller: _scrollController,
        padding: const EdgeInsets.all(AppTheme.spaceM),
        gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
          crossAxisCount: 2,
          crossAxisSpacing: AppTheme.spaceM,
          mainAxisSpacing: AppTheme.spaceM,
          childAspectRatio: 0.62,
        ),
        itemCount: state.products.length + (state.isLoadingMore ? 2 : 0),
        itemBuilder: (context, index) {
          if (index >= state.products.length) {
            return const Center(child: CircularProgressIndicator());
          }
          return ProductCard(
            product: state.products[index],
            onTap: () => context.push('/products/${state.products[index].id}'),
          );
        },
      ),
    );
  }
}

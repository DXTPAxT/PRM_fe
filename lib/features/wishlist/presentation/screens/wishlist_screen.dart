import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../providers/wishlist_provider.dart';
import '../widgets/wishlist_item_card.dart';

class WishlistScreen extends ConsumerWidget {
  const WishlistScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(wishlistProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Sản phẩm yêu thích')),
      body: state.isLoading
          ? const Center(child: CircularProgressIndicator())
          : state.items.isEmpty
              ? Center(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      Icon(Icons.favorite_border, size: 64,
                          color: Theme.of(context).colorScheme.outline),
                      const SizedBox(height: 16),
                      const Text('Chưa có sản phẩm yêu thích nào.'),
                    ],
                  ),
                )
              : RefreshIndicator(
                  onRefresh: () => ref.read(wishlistProvider.notifier).load(),
                  child: ListView.separated(
                    padding: const EdgeInsets.all(16),
                    itemCount: state.items.length,
                    separatorBuilder: (_, __) => const SizedBox(height: 8),
                    itemBuilder: (context, index) {
                      final item = state.items[index];
                      return WishlistItemCard(
                        item: item,
                        onRemove: () {
                          ref.read(wishlistProvider.notifier).toggle(item.productId);
                        },
                      );
                    },
                  ),
                ),
    );
  }
}

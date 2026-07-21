import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/wishlist_item.dart';

class WishlistItemCard extends StatelessWidget {
  final WishlistItem item;
  final VoidCallback onRemove;

  const WishlistItemCard({
    super.key,
    required this.item,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    return Card(
      clipBehavior: Clip.antiAlias,
      child: InkWell(
        onTap: () => context.push('/products/${item.productId}'),
        child: Row(
          children: [
            SizedBox(
              width: 100,
              height: 100,
              child: item.thumbnailUrl != null
                  ? Image.network(item.thumbnailUrl!, fit: BoxFit.cover)
                  : Container(
                      color: theme.colorScheme.surfaceContainerHighest,
                      child: const Icon(Icons.image_outlined, size: 40),
                    ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.productName,
                    style: theme.textTheme.titleSmall,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 4),
                  Text(
                    '${item.basePrice.toStringAsFixed(0)}đ',
                    style: theme.textTheme.bodyMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ],
              ),
            ),
            IconButton(
              icon: const Icon(Icons.favorite, color: Colors.red),
              tooltip: 'Xóa khỏi yêu thích',
              onPressed: onRemove,
            ),
          ],
        ),
      ),
    );
  }
}

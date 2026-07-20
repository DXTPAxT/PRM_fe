import 'package:flutter/material.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/utils/formatters.dart';
import '../../data/models/cart_response.dart';

/// Một dòng sản phẩm trong giỏ: ảnh, tên, biến thể, giá, stepper số lượng, xóa.
class CartItemTile extends StatelessWidget {
  final CartLineItem item;
  final bool isMutating;
  final ValueChanged<int> onQuantityChanged;
  final VoidCallback onRemove;

  const CartItemTile({
    super.key,
    required this.item,
    required this.isMutating,
    required this.onQuantityChanged,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final variant = item.variant;
    final atMaxStock = item.quantity >= variant.stockQty;

    return Card(
      margin: const EdgeInsets.only(bottom: AppTheme.spaceM),
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceM),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            _Thumbnail(imageUrl: item.product.image),
            const SizedBox(width: AppTheme.spaceM),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    item.product.name,
                    style: theme.textTheme.titleMedium
                        ?.copyWith(fontWeight: FontWeight.w600),
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: AppTheme.spaceXS),
                  Text(
                    'Size ${variant.size} · ${variant.color}',
                    style: theme.textTheme.bodyMedium,
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  Text(
                    formatVnd(item.lineTotal),
                    style: theme.textTheme.titleMedium?.copyWith(
                      color: theme.colorScheme.primary,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const SizedBox(height: AppTheme.spaceS),
                  Row(
                    children: [
                      _QuantityStepper(
                        quantity: item.quantity,
                        enabled: !isMutating,
                        canIncrease: !atMaxStock,
                        onChanged: onQuantityChanged,
                      ),
                      const Spacer(),
                      if (isMutating)
                        const SizedBox(
                          width: 20,
                          height: 20,
                          child: CircularProgressIndicator(strokeWidth: 2),
                        )
                      else
                        IconButton(
                          onPressed: onRemove,
                          icon: const Icon(Icons.delete_outline),
                          color: theme.colorScheme.error,
                          tooltip: 'Xóa',
                        ),
                    ],
                  ),
                  if (atMaxStock)
                    Text(
                      'Tối đa ${variant.stockQty} sản phẩm trong kho',
                      style: theme.textTheme.labelLarge?.copyWith(
                        color: theme.colorScheme.error,
                      ),
                    ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _Thumbnail extends StatelessWidget {
  final String? imageUrl;
  const _Thumbnail({this.imageUrl});

  @override
  Widget build(BuildContext context) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(AppTheme.radiusS),
      child: SizedBox(
        width: 72,
        height: 72,
        child: imageUrl != null && imageUrl!.isNotEmpty
            ? Image.network(
                imageUrl!,
                fit: BoxFit.cover,
                errorBuilder: (_, __, ___) => const _ThumbnailPlaceholder(),
              )
            : const _ThumbnailPlaceholder(),
      ),
    );
  }
}

class _ThumbnailPlaceholder extends StatelessWidget {
  const _ThumbnailPlaceholder();

  @override
  Widget build(BuildContext context) {
    return Container(
      color: Colors.grey.shade200,
      child: Icon(Icons.image_outlined, color: Colors.grey.shade400),
    );
  }
}

class _QuantityStepper extends StatelessWidget {
  final int quantity;
  final bool enabled;
  final bool canIncrease;
  final ValueChanged<int> onChanged;

  const _QuantityStepper({
    required this.quantity,
    required this.enabled,
    required this.canIncrease,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(AppTheme.radiusS),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          _StepButton(
            icon: Icons.remove,
            enabled: enabled && quantity > 1,
            onTap: () => onChanged(quantity - 1),
          ),
          SizedBox(
            width: 36,
            child: Text(
              '$quantity',
              textAlign: TextAlign.center,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
          _StepButton(
            icon: Icons.add,
            enabled: enabled && canIncrease,
            onTap: () => onChanged(quantity + 1),
          ),
        ],
      ),
    );
  }
}

class _StepButton extends StatelessWidget {
  final IconData icon;
  final bool enabled;
  final VoidCallback onTap;

  const _StepButton({
    required this.icon,
    required this.enabled,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: enabled ? onTap : null,
      child: Padding(
        padding: const EdgeInsets.all(AppTheme.spaceS),
        child: Icon(
          icon,
          size: 18,
          color: enabled ? null : Colors.grey.shade400,
        ),
      ),
    );
  }
}

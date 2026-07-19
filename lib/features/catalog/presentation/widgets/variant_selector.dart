import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../providers/product_detail_provider.dart';
import 'product_card.dart' show formatVnd;

class VariantSelector extends StatelessWidget {
  final ProductDetailState state;
  final void Function(String size) onSizeSelected;
  final void Function(String color) onColorSelected;

  const VariantSelector({
    super.key,
    required this.state,
    required this.onSizeSelected,
    required this.onColorSelected,
  });

  @override
  Widget build(BuildContext context) {
    final variant = state.selectedVariant;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text('Kích cỡ', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppTheme.spaceS),
        Wrap(
          spacing: AppTheme.spaceS,
          children: state.availableSizes.map((size) {
            return ChoiceChip(
              label: Text(size),
              selected: state.selectedSize == size,
              onSelected: (_) => onSizeSelected(size),
            );
          }).toList(),
        ),
        const SizedBox(height: AppTheme.spaceL),

        const Text('Màu sắc', style: TextStyle(fontWeight: FontWeight.w600)),
        const SizedBox(height: AppTheme.spaceS),
        Wrap(
          spacing: AppTheme.spaceS,
          children: state.availableColors.map((color) {
            return ChoiceChip(
              label: Text(color),
              selected: state.selectedColor == color,
              onSelected: (_) => onColorSelected(color),
            );
          }).toList(),
        ),

        if (variant != null) ...[
          const SizedBox(height: AppTheme.spaceL),
          Container(
            width: double.infinity,
            padding: const EdgeInsets.all(AppTheme.spaceM),
            decoration: BoxDecoration(
              color: Colors.grey.shade100,
              borderRadius: BorderRadius.circular(8),
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  formatVnd(variant.price),
                  style: Theme.of(context).textTheme.titleLarge?.copyWith(
                        fontWeight: FontWeight.bold,
                        color: Theme.of(context).colorScheme.primary,
                      ),
                ),
                const SizedBox(height: 4),
                Text(
                  variant.stockQty > 0
                      ? 'Còn ${variant.stockQty} sản phẩm'
                      : 'Hết hàng',
                  style: TextStyle(
                    color: variant.stockQty > 0
                        ? Colors.green.shade700
                        : Colors.red.shade700,
                  ),
                ),
                const SizedBox(height: 4),
                Text(
                  'SKU: ${variant.sku}',
                  style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: Colors.grey.shade600,
                      ),
                ),
              ],
            ),
          ),
        ],
      ],
    );
  }
}

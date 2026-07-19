import 'package:flutter/material.dart';
import '../../../../core/theme/app_theme.dart';
import '../../data/models/product_query.dart';

const kAvailableSizes = ['S', 'M', 'L', 'XL'];
const kAvailableColors = ['Đen', 'Trắng', 'Xanh', 'Be'];

Future<ProductQuery?> showFilterBottomSheet(
  BuildContext context,
  ProductQuery current,
) {
  return showModalBottomSheet<ProductQuery>(
    context: context,
    isScrollControlled: true,
    builder: (_) => _FilterSheet(current: current),
  );
}

class _FilterSheet extends StatefulWidget {
  final ProductQuery current;
  const _FilterSheet({required this.current});

  @override
  State<_FilterSheet> createState() => _FilterSheetState();
}

class _FilterSheetState extends State<_FilterSheet> {
  late final TextEditingController _minController;
  late final TextEditingController _maxController;
  String? _size;
  String? _color;
  late ProductSort _sort;

  @override
  void initState() {
    super.initState();
    _minController = TextEditingController(
      text: widget.current.minPrice?.round().toString() ?? '',
    );
    _maxController = TextEditingController(
      text: widget.current.maxPrice?.round().toString() ?? '',
    );
    _size = widget.current.size;
    _color = widget.current.color;
    _sort = widget.current.sort;
  }

  @override
  void dispose() {
    _minController.dispose();
    _maxController.dispose();
    super.dispose();
  }

  void _apply() {
    final min = double.tryParse(_minController.text.trim());
    final max = double.tryParse(_maxController.text.trim());

    var query = widget.current.copyWith(
      clearPrice: true,
      clearSize: true,
      clearColor: true,
      sort: _sort,
      page: 1,
    );
    query = query.copyWith(
      minPrice: min,
      maxPrice: max,
      size: _size,
      color: _color,
    );

    Navigator.of(context).pop(query);
  }

  void _clear() {
    Navigator.of(context).pop(
      widget.current.copyWith(
        clearPrice: true,
        clearSize: true,
        clearColor: true,
        sort: ProductSort.newest,
        page: 1,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: EdgeInsets.only(
        left: AppTheme.spaceL,
        right: AppTheme.spaceL,
        top: AppTheme.spaceL,
        bottom: MediaQuery.of(context).viewInsets.bottom + AppTheme.spaceL,
      ),
      child: SingleChildScrollView(
        child: Column(
          mainAxisSize: MainAxisSize.min,
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Bộ lọc',
              style: Theme.of(context).textTheme.titleLarge?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
            ),
            const SizedBox(height: AppTheme.spaceL),

            const Text('Khoảng giá'),
            const SizedBox(height: AppTheme.spaceS),
            Row(
              children: [
                Expanded(
                  child: TextField(
                    controller: _minController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Từ',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceM),
                Expanded(
                  child: TextField(
                    controller: _maxController,
                    keyboardType: TextInputType.number,
                    decoration: const InputDecoration(
                      labelText: 'Đến',
                      border: OutlineInputBorder(),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: AppTheme.spaceL),

            const Text('Kích cỡ'),
            const SizedBox(height: AppTheme.spaceS),
            Wrap(
              spacing: AppTheme.spaceS,
              children: kAvailableSizes.map((size) {
                return ChoiceChip(
                  label: Text(size),
                  selected: _size == size,
                  onSelected: (selected) =>
                      setState(() => _size = selected ? size : null),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spaceL),

            const Text('Màu sắc'),
            const SizedBox(height: AppTheme.spaceS),
            Wrap(
              spacing: AppTheme.spaceS,
              children: kAvailableColors.map((color) {
                return ChoiceChip(
                  label: Text(color),
                  selected: _color == color,
                  onSelected: (selected) =>
                      setState(() => _color = selected ? color : null),
                );
              }).toList(),
            ),
            const SizedBox(height: AppTheme.spaceL),

            const Text('Sắp xếp'),
            const SizedBox(height: AppTheme.spaceS),
            DropdownButtonFormField<ProductSort>(
              initialValue: _sort,
              decoration: const InputDecoration(border: OutlineInputBorder()),
              items: ProductSort.values
                  .map((s) => DropdownMenuItem(value: s, child: Text(s.label)))
                  .toList(),
              onChanged: (value) =>
                  setState(() => _sort = value ?? ProductSort.newest),
            ),
            const SizedBox(height: AppTheme.spaceL),

            Row(
              children: [
                Expanded(
                  child: OutlinedButton(
                    onPressed: _clear,
                    child: const Text('Xóa lọc'),
                  ),
                ),
                const SizedBox(width: AppTheme.spaceM),
                Expanded(
                  child: ElevatedButton(
                    onPressed: _apply,
                    child: const Text('Áp dụng'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

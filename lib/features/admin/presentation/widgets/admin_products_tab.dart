import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/product.dart';
import '../../../catalog/presentation/providers/catalog_provider.dart';
import '../providers/admin_provider.dart';

class AdminProductsTab extends ConsumerStatefulWidget {
  const AdminProductsTab({super.key});

  @override
  ConsumerState<AdminProductsTab> createState() => _AdminProductsTabState();
}

class _AdminProductsTabState extends ConsumerState<AdminProductsTab> {
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      ref.read(adminProductsProvider.notifier).loadProducts();
      ref.read(catalogProvider.notifier).loadInitial();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(adminProductsProvider);

    return Scaffold(
      body: _buildBody(state),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showCreateProductDialog(context),
        child: const Icon(Icons.add),
      ),
    );
  }

  Widget _buildBody(AdminProductsState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null && state.products.isEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Lỗi: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () =>
                  ref.read(adminProductsProvider.notifier).loadProducts(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    final products = state.products;
    if (products.isEmpty) {
      return const Center(child: Text('Chưa có sản phẩm nào'));
    }

    return RefreshIndicator(
      onRefresh: () =>
          ref.read(adminProductsProvider.notifier).loadProducts(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: products.length,
        itemBuilder: (context, index) {
          final product = products[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: const Icon(Icons.inventory_2_outlined),
              title: Text(product.name),
              subtitle: Text('${product.basePrice.toStringAsFixed(0)} VNĐ'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  IconButton(
                    icon: const Icon(Icons.edit_outlined),
                    onPressed: () =>
                        _showEditProductDialog(context, product),
                  ),
                  IconButton(
                    icon: const Icon(Icons.delete_outline, color: Colors.red),
                    onPressed: () =>
                        _confirmDelete(context, product.id),
                  ),
                ],
              ),
            ),
          );
        },
      ),
    );
  }

  void _showCreateProductDialog(BuildContext context) {
    final nameController = TextEditingController();
    final priceController = TextEditingController();
    final descController = TextEditingController();
    final categories = ref.read(catalogProvider).categories;

    String? selectedCategoryId = categories.isNotEmpty ? categories.first.id : null;

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Tạo sản phẩm mới'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên sản phẩm',
                    hintText: 'Nhập tên sản phẩm',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Giá (VNĐ)',
                    hintText: 'Nhập giá sản phẩm',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                if (categories.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: selectedCategoryId,
                    decoration: const InputDecoration(labelText: 'Danh mục'),
                    items: categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        selectedCategoryId = val;
                      });
                    },
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả',
                    hintText: 'Nhập mô tả sản phẩm',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty &&
                    priceController.text.trim().isNotEmpty) {
                  final price = double.tryParse(priceController.text.trim()) ?? 0;
                  final categoryId = selectedCategoryId ?? (categories.isNotEmpty ? categories.first.id : '');

                  if (categoryId.isEmpty) {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(content: Text('Vui lòng chọn danh mục cho sản phẩm')),
                    );
                    return;
                  }

                  final payload = {
                    'categoryId': categoryId,
                    'name': nameController.text.trim(),
                    'basePrice': price,
                    'description': descController.text.trim(),
                    'variants': [
                      {
                        'size': 'F',
                        'color': 'Mặc định',
                        'price': price,
                        'stockQty': 100,
                        'sku': 'SKU-${DateTime.now().millisecondsSinceEpoch}',
                      }
                    ],
                  };

                  Navigator.pop(ctx);
                  final success = await ref
                      .read(adminProductsProvider.notifier)
                      .createProduct(payload);

                  if (context.mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Tạo sản phẩm mới thành công')),
                      );
                    } else {
                      final error = ref.read(adminProductsProvider).error ?? 'Tạo thất bại';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      ref.read(adminProductsProvider.notifier).clearError();
                    }
                  }
                }
              },
              child: const Text('Tạo'),
            ),
          ],
        ),
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, Product product) {
    final nameController = TextEditingController(text: product.name);
    final priceController =
        TextEditingController(text: product.basePrice.toStringAsFixed(0));
    final descController =
        TextEditingController(text: product.description ?? '');
    final categories = ref.read(catalogProvider).categories;

    String? selectedCategoryId = product.categoryId.isNotEmpty
        ? product.categoryId
        : (categories.isNotEmpty ? categories.first.id : null);

    showDialog(
      context: context,
      builder: (ctx) => StatefulBuilder(
        builder: (ctx, setDialogState) => AlertDialog(
          title: const Text('Chỉnh sửa sản phẩm'),
          content: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                TextField(
                  controller: nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tên sản phẩm',
                  ),
                ),
                const SizedBox(height: 16),
                TextField(
                  controller: priceController,
                  decoration: const InputDecoration(
                    labelText: 'Giá (VNĐ)',
                  ),
                  keyboardType: TextInputType.number,
                ),
                const SizedBox(height: 16),
                if (categories.isNotEmpty)
                  DropdownButtonFormField<String>(
                    initialValue: categories.any((c) => c.id == selectedCategoryId)
                        ? selectedCategoryId
                        : null,
                    decoration: const InputDecoration(labelText: 'Danh mục'),
                    items: categories
                        .map(
                          (c) => DropdownMenuItem(
                            value: c.id,
                            child: Text(c.name),
                          ),
                        )
                        .toList(),
                    onChanged: (val) {
                      setDialogState(() {
                        selectedCategoryId = val;
                      });
                    },
                  ),
                const SizedBox(height: 16),
                TextField(
                  controller: descController,
                  decoration: const InputDecoration(
                    labelText: 'Mô tả',
                  ),
                  maxLines: 3,
                ),
              ],
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(ctx),
              child: const Text('Hủy'),
            ),
            ElevatedButton(
              onPressed: () async {
                if (nameController.text.trim().isNotEmpty &&
                    priceController.text.trim().isNotEmpty) {
                  final price = double.tryParse(priceController.text.trim()) ?? product.basePrice;

                  final payload = <String, dynamic>{
                    'name': nameController.text.trim(),
                    'basePrice': price,
                    'description': descController.text.trim(),
                  };

                  if (selectedCategoryId != null && selectedCategoryId!.isNotEmpty) {
                    payload['categoryId'] = selectedCategoryId;
                  }

                  Navigator.pop(ctx);
                  final success = await ref
                      .read(adminProductsProvider.notifier)
                      .updateProduct(product.id, payload);

                  if (context.mounted) {
                    if (success) {
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(content: Text('Cập nhật sản phẩm thành công')),
                      );
                    } else {
                      final error = ref.read(adminProductsProvider).error ?? 'Cập nhật thất bại';
                      ScaffoldMessenger.of(context).showSnackBar(
                        SnackBar(
                          content: Text('Lỗi: $error'),
                          backgroundColor: Colors.red,
                        ),
                      );
                      ref.read(adminProductsProvider.notifier).clearError();
                    }
                  }
                }
              },
              child: const Text('Cập nhật'),
            ),
          ],
        ),
      ),
    );
  }

  void _confirmDelete(BuildContext context, String productId) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: const Text('Xác nhận xóa'),
        content: const Text('Bạn có chắc chắn muốn xóa sản phẩm này?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () async {
              Navigator.pop(ctx);
              final success = await ref
                  .read(adminProductsProvider.notifier)
                  .deleteProduct(productId);

              if (context.mounted) {
                if (success) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Đã ngừng bán sản phẩm thành công')),
                  );
                } else {
                  final error = ref.read(adminProductsProvider).error ?? 'Xóa thất bại';
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Lỗi: $error'),
                      backgroundColor: Colors.red,
                    ),
                  );
                  ref.read(adminProductsProvider.notifier).clearError();
                }
              }
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
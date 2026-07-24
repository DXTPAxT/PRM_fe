import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/product.dart';
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
    Future.microtask(
      () => ref.read(adminProductsProvider.notifier).loadProducts(),
    );
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

    if (state.error != null) {
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

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                ref.read(adminProductsProvider.notifier).createProduct({
                  'name': nameController.text,
                  'price': double.tryParse(priceController.text) ?? 0,
                  'description': descController.text,
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Tạo'),
          ),
        ],
      ),
    );
  }

  void _showEditProductDialog(BuildContext context, Product product) {
    final nameController = TextEditingController(text: product.name);
    final priceController =
        TextEditingController(text: product.basePrice.toString());
    final descController =
        TextEditingController(text: product.description);

    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
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
            onPressed: () {
              if (nameController.text.isNotEmpty &&
                  priceController.text.isNotEmpty) {
                ref
                    .read(adminProductsProvider.notifier)
                    .updateProduct(product.id, {
                  'name': nameController.text,
                  'price': double.tryParse(priceController.text) ?? 0,
                  'description': descController.text,
                });
                Navigator.pop(ctx);
              }
            },
            child: const Text('Cập nhật'),
          ),
        ],
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
            onPressed: () {
              ref
                  .read(adminProductsProvider.notifier)
                  .deleteProduct(productId);
              Navigator.pop(ctx);
            },
            style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
  }
}
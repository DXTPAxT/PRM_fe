import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';

import '../../../../core/theme/app_theme.dart';
import '../../../../core/widgets/common_widgets.dart';
import '../../../../shared/models/product.dart';
import '../../data/models/product_query.dart';
import '../providers/catalog_provider.dart';
import '../widgets/product_card.dart';

class SearchScreen extends ConsumerStatefulWidget {
  const SearchScreen({super.key});

  @override
  ConsumerState<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends ConsumerState<SearchScreen> {
  final TextEditingController _controller = TextEditingController();
  Timer? _debounce;

  List<Product> _results = const [];
  bool _isLoading = false;
  bool _hasSearched = false;
  String? _errorMessage;

  @override
  void dispose() {
    _debounce?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _onChanged(String value) {
    _debounce?.cancel();
    _debounce = Timer(const Duration(milliseconds: 400), () {
      _search(value.trim());
    });
  }

  Future<void> _search(String keyword) async {
    if (keyword.isEmpty) {
      setState(() {
        _results = const [];
        _hasSearched = false;
        _errorMessage = null;
      });
      return;
    }

    setState(() {
      _isLoading = true;
      _errorMessage = null;
    });

    try {
      final result = await ref
          .read(catalogRepositoryProvider)
          .getProducts(ProductQuery(search: keyword, limit: 30));
      if (!mounted) return;
      setState(() {
        _results = result.items;
        _isLoading = false;
        _hasSearched = true;
      });
    } catch (error) {
      if (!mounted) return;
      setState(() {
        _isLoading = false;
        _hasSearched = true;
        _errorMessage = error.toString().replaceFirst('Exception: ', '');
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: TextField(
          controller: _controller,
          autofocus: true,
          textInputAction: TextInputAction.search,
          decoration: const InputDecoration(
            hintText: 'Tìm sản phẩm...',
            border: InputBorder.none,
          ),
          onChanged: _onChanged,
          onSubmitted: (value) => _search(value.trim()),
        ),
        actions: [
          if (_controller.text.isNotEmpty)
            IconButton(
              icon: const Icon(Icons.clear),
              onPressed: () {
                _controller.clear();
                _search('');
              },
            ),
        ],
      ),
      body: _buildBody(),
    );
  }

  Widget _buildBody() {
    if (_isLoading) {
      return const LoadingIndicator(message: 'Đang tìm...');
    }

    if (_errorMessage != null) {
      return ErrorStateWidget(
        message: _errorMessage!,
        onRetry: () => _search(_controller.text.trim()),
      );
    }

    if (!_hasSearched) {
      return const EmptyStateWidget(
        icon: Icons.search,
        title: 'Tìm kiếm sản phẩm',
        message: 'Nhập tên sản phẩm bạn muốn tìm.',
      );
    }

    if (_results.isEmpty) {
      return const EmptyStateWidget(
        icon: Icons.search_off,
        title: 'Không tìm thấy',
        message: 'Thử từ khóa khác xem sao.',
      );
    }

    return GridView.builder(
      padding: const EdgeInsets.all(AppTheme.spaceM),
      gridDelegate: const SliverGridDelegateWithFixedCrossAxisCount(
        crossAxisCount: 2,
        crossAxisSpacing: AppTheme.spaceM,
        mainAxisSpacing: AppTheme.spaceM,
        childAspectRatio: 0.62,
      ),
      itemCount: _results.length,
      itemBuilder: (context, index) => ProductCard(
        product: _results[index],
        onTap: () => context.push('/products/${_results[index].id}'),
      ),
    );
  }
}

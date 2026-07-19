enum ProductSort { newest, priceAsc, priceDesc, nameAsc }

extension ProductSortX on ProductSort {
  /// Giá trị BE nhận ở query param `sort`.
  String get apiValue {
    switch (this) {
      case ProductSort.newest:
        return 'newest';
      case ProductSort.priceAsc:
        return 'price_asc';
      case ProductSort.priceDesc:
        return 'price_desc';
      case ProductSort.nameAsc:
        return 'name_asc';
    }
  }

  String get label {
    switch (this) {
      case ProductSort.newest:
        return 'Mới nhất';
      case ProductSort.priceAsc:
        return 'Giá thấp đến cao';
      case ProductSort.priceDesc:
        return 'Giá cao đến thấp';
      case ProductSort.nameAsc:
        return 'Tên A-Z';
    }
  }
}

/// Gói toàn bộ tham số lọc thành một object bất biến.
/// Đổi filter = tạo bản sao mới rồi tải lại từ trang 1.
class ProductQuery {
  final String? categoryId;
  final String? search;
  final double? minPrice;
  final double? maxPrice;
  final String? size;
  final String? color;
  final ProductSort sort;
  final int page;
  final int limit;

  const ProductQuery({
    this.categoryId,
    this.search,
    this.minPrice,
    this.maxPrice,
    this.size,
    this.color,
    this.sort = ProductSort.newest,
    this.page = 1,
    this.limit = 20,
  });

  ProductQuery copyWith({
    String? categoryId,
    String? search,
    double? minPrice,
    double? maxPrice,
    String? size,
    String? color,
    ProductSort? sort,
    int? page,
    int? limit,
    bool clearCategoryId = false,
    bool clearSearch = false,
    bool clearPrice = false,
    bool clearSize = false,
    bool clearColor = false,
  }) {
    return ProductQuery(
      categoryId: clearCategoryId ? null : categoryId ?? this.categoryId,
      search: clearSearch ? null : search ?? this.search,
      minPrice: clearPrice ? null : minPrice ?? this.minPrice,
      maxPrice: clearPrice ? null : maxPrice ?? this.maxPrice,
      size: clearSize ? null : size ?? this.size,
      color: clearColor ? null : color ?? this.color,
      sort: sort ?? this.sort,
      page: page ?? this.page,
      limit: limit ?? this.limit,
    );
  }

  /// Bỏ hẳn key có giá trị null — BE bật forbidNonWhitelisted,
  /// gửi key rỗng sẽ bị từ chối 400.
  Map<String, dynamic> toQueryParameters() {
    return {
      if (categoryId != null && categoryId!.isNotEmpty) 'categoryId': categoryId,
      if (search != null && search!.isNotEmpty) 'search': search,
      if (minPrice != null) 'minPrice': minPrice,
      if (maxPrice != null) 'maxPrice': maxPrice,
      if (size != null && size!.isNotEmpty) 'size': size,
      if (color != null && color!.isNotEmpty) 'color': color,
      'sort': sort.apiValue,
      'page': page,
      'limit': limit,
    };
  }

  /// Có filter nào đang bật ngoài sắp xếp không (để hiện chấm đỏ trên icon lọc).
  bool get hasActiveFilter =>
      (categoryId != null && categoryId!.isNotEmpty) ||
      minPrice != null ||
      maxPrice != null ||
      (size != null && size!.isNotEmpty) ||
      (color != null && color!.isNotEmpty);
}

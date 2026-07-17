class PaginationMeta {
  final int page;
  final int totalPages;

  const PaginationMeta({
    required this.page,
    required this.totalPages,
  });

  factory PaginationMeta.fromJson(Map<String, dynamic> json) {
    return PaginationMeta(
      page: json['page'] as int? ?? 1,
      totalPages: json['totalPages'] as int? ?? 1,
    );
  }

  Map<String, dynamic> toJson() => {
        'page': page,
        'totalPages': totalPages,
      };
}

class ApiResponse<T> {
  final bool success;
  final T? data;
  final String? message;
  final PaginationMeta? meta;

  const ApiResponse({
    required this.success,
    this.data,
    this.message,
    this.meta,
  });

  factory ApiResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawData = json['data'];
    return ApiResponse<T>(
      success: json['success'] as bool? ?? false,
      data: rawData != null ? fromJsonT(rawData) : null,
      message: json['message'] as String?,
      meta: json['meta'] != null
          ? PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : null,
    );
  }
}

class PagedResponse<T> {
  final bool success;
  final List<T> data;
  final String? message;
  final PaginationMeta meta;

  const PagedResponse({
    required this.success,
    required this.data,
    this.message,
    required this.meta,
  });

  factory PagedResponse.fromJson(
    Map<String, dynamic> json,
    T Function(Object? json) fromJsonT,
  ) {
    final rawData = json['data'] as List? ?? [];
    return PagedResponse<T>(
      success: json['success'] as bool? ?? false,
      data: rawData.map((e) => fromJsonT(e)).toList(),
      message: json['message'] as String?,
      meta: json['meta'] != null
          ? PaginationMeta.fromJson(json['meta'] as Map<String, dynamic>)
          : const PaginationMeta(page: 1, totalPages: 1),
    );
  }
}

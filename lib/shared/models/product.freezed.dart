// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

Product _$ProductFromJson(Map<String, dynamic> json) {
  return _Product.fromJson(json);
}

/// @nodoc
mixin _$Product {
  String get id => throw _privateConstructorUsedError;
  String get categoryId => throw _privateConstructorUsedError;
  String get categoryName => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String? get description => throw _privateConstructorUsedError;
  double get basePrice => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  double get avgRating => throw _privateConstructorUsedError;
  int get reviewCount => throw _privateConstructorUsedError;
  List<ProductImage> get images => throw _privateConstructorUsedError;
  List<ProductVariant> get variants => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this Product to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductCopyWith<Product> get copyWith => throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductCopyWith<$Res> {
  factory $ProductCopyWith(Product value, $Res Function(Product) then) =
      _$ProductCopyWithImpl<$Res, Product>;
  @useResult
  $Res call({
    String id,
    String categoryId,
    String categoryName,
    String name,
    String? description,
    double basePrice,
    String status,
    String? thumbnailUrl,
    double avgRating,
    int reviewCount,
    List<ProductImage> images,
    List<ProductVariant> variants,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$ProductCopyWithImpl<$Res, $Val extends Product>
    implements $ProductCopyWith<$Res> {
  _$ProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? name = null,
    Object? description = freezed,
    Object? basePrice = null,
    Object? status = null,
    Object? thumbnailUrl = freezed,
    Object? avgRating = null,
    Object? reviewCount = null,
    Object? images = null,
    Object? variants = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryId: null == categoryId
                ? _value.categoryId
                : categoryId // ignore: cast_nullable_to_non_nullable
                      as String,
            categoryName: null == categoryName
                ? _value.categoryName
                : categoryName // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            description: freezed == description
                ? _value.description
                : description // ignore: cast_nullable_to_non_nullable
                      as String?,
            basePrice: null == basePrice
                ? _value.basePrice
                : basePrice // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            thumbnailUrl: freezed == thumbnailUrl
                ? _value.thumbnailUrl
                : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                      as String?,
            avgRating: null == avgRating
                ? _value.avgRating
                : avgRating // ignore: cast_nullable_to_non_nullable
                      as double,
            reviewCount: null == reviewCount
                ? _value.reviewCount
                : reviewCount // ignore: cast_nullable_to_non_nullable
                      as int,
            images: null == images
                ? _value.images
                : images // ignore: cast_nullable_to_non_nullable
                      as List<ProductImage>,
            variants: null == variants
                ? _value.variants
                : variants // ignore: cast_nullable_to_non_nullable
                      as List<ProductVariant>,
            createdAt: freezed == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductImplCopyWith<$Res> implements $ProductCopyWith<$Res> {
  factory _$$ProductImplCopyWith(
    _$ProductImpl value,
    $Res Function(_$ProductImpl) then,
  ) = __$$ProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String categoryId,
    String categoryName,
    String name,
    String? description,
    double basePrice,
    String status,
    String? thumbnailUrl,
    double avgRating,
    int reviewCount,
    List<ProductImage> images,
    List<ProductVariant> variants,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$ProductImplCopyWithImpl<$Res>
    extends _$ProductCopyWithImpl<$Res, _$ProductImpl>
    implements _$$ProductImplCopyWith<$Res> {
  __$$ProductImplCopyWithImpl(
    _$ProductImpl _value,
    $Res Function(_$ProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? categoryId = null,
    Object? categoryName = null,
    Object? name = null,
    Object? description = freezed,
    Object? basePrice = null,
    Object? status = null,
    Object? thumbnailUrl = freezed,
    Object? avgRating = null,
    Object? reviewCount = null,
    Object? images = null,
    Object? variants = null,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$ProductImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryId: null == categoryId
            ? _value.categoryId
            : categoryId // ignore: cast_nullable_to_non_nullable
                  as String,
        categoryName: null == categoryName
            ? _value.categoryName
            : categoryName // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        description: freezed == description
            ? _value.description
            : description // ignore: cast_nullable_to_non_nullable
                  as String?,
        basePrice: null == basePrice
            ? _value.basePrice
            : basePrice // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        thumbnailUrl: freezed == thumbnailUrl
            ? _value.thumbnailUrl
            : thumbnailUrl // ignore: cast_nullable_to_non_nullable
                  as String?,
        avgRating: null == avgRating
            ? _value.avgRating
            : avgRating // ignore: cast_nullable_to_non_nullable
                  as double,
        reviewCount: null == reviewCount
            ? _value.reviewCount
            : reviewCount // ignore: cast_nullable_to_non_nullable
                  as int,
        images: null == images
            ? _value._images
            : images // ignore: cast_nullable_to_non_nullable
                  as List<ProductImage>,
        variants: null == variants
            ? _value._variants
            : variants // ignore: cast_nullable_to_non_nullable
                  as List<ProductVariant>,
        createdAt: freezed == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductImpl implements _Product {
  const _$ProductImpl({
    required this.id,
    required this.categoryId,
    this.categoryName = '',
    required this.name,
    this.description,
    required this.basePrice,
    required this.status,
    this.thumbnailUrl,
    this.avgRating = 0,
    this.reviewCount = 0,
    final List<ProductImage> images = const [],
    final List<ProductVariant> variants = const [],
    this.createdAt,
  }) : _images = images,
       _variants = variants;

  factory _$ProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductImplFromJson(json);

  @override
  final String id;
  @override
  final String categoryId;
  @override
  @JsonKey()
  final String categoryName;
  @override
  final String name;
  @override
  final String? description;
  @override
  final double basePrice;
  @override
  final String status;
  @override
  final String? thumbnailUrl;
  @override
  @JsonKey()
  final double avgRating;
  @override
  @JsonKey()
  final int reviewCount;
  final List<ProductImage> _images;
  @override
  @JsonKey()
  List<ProductImage> get images {
    if (_images is EqualUnmodifiableListView) return _images;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_images);
  }

  final List<ProductVariant> _variants;
  @override
  @JsonKey()
  List<ProductVariant> get variants {
    if (_variants is EqualUnmodifiableListView) return _variants;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_variants);
  }

  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'Product(id: $id, categoryId: $categoryId, categoryName: $categoryName, name: $name, description: $description, basePrice: $basePrice, status: $status, thumbnailUrl: $thumbnailUrl, avgRating: $avgRating, reviewCount: $reviewCount, images: $images, variants: $variants, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.categoryId, categoryId) ||
                other.categoryId == categoryId) &&
            (identical(other.categoryName, categoryName) ||
                other.categoryName == categoryName) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.description, description) ||
                other.description == description) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.avgRating, avgRating) ||
                other.avgRating == avgRating) &&
            (identical(other.reviewCount, reviewCount) ||
                other.reviewCount == reviewCount) &&
            const DeepCollectionEquality().equals(other._images, _images) &&
            const DeepCollectionEquality().equals(other._variants, _variants) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    categoryId,
    categoryName,
    name,
    description,
    basePrice,
    status,
    thumbnailUrl,
    avgRating,
    reviewCount,
    const DeepCollectionEquality().hash(_images),
    const DeepCollectionEquality().hash(_variants),
    createdAt,
  );

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      __$$ProductImplCopyWithImpl<_$ProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductImplToJson(this);
  }
}

abstract class _Product implements Product {
  const factory _Product({
    required final String id,
    required final String categoryId,
    final String categoryName,
    required final String name,
    final String? description,
    required final double basePrice,
    required final String status,
    final String? thumbnailUrl,
    final double avgRating,
    final int reviewCount,
    final List<ProductImage> images,
    final List<ProductVariant> variants,
    final DateTime? createdAt,
  }) = _$ProductImpl;

  factory _Product.fromJson(Map<String, dynamic> json) = _$ProductImpl.fromJson;

  @override
  String get id;
  @override
  String get categoryId;
  @override
  String get categoryName;
  @override
  String get name;
  @override
  String? get description;
  @override
  double get basePrice;
  @override
  String get status;
  @override
  String? get thumbnailUrl;
  @override
  double get avgRating;
  @override
  int get reviewCount;
  @override
  List<ProductImage> get images;
  @override
  List<ProductVariant> get variants;
  @override
  DateTime? get createdAt;

  /// Create a copy of Product
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductImplCopyWith<_$ProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

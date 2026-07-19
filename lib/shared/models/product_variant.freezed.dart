// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'product_variant.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ProductVariant _$ProductVariantFromJson(Map<String, dynamic> json) {
  return _ProductVariant.fromJson(json);
}

/// @nodoc
mixin _$ProductVariant {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get size => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  double get price => throw _privateConstructorUsedError;
  int get stockQty => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;

  /// Serializes this ProductVariant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ProductVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ProductVariantCopyWith<ProductVariant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ProductVariantCopyWith<$Res> {
  factory $ProductVariantCopyWith(
    ProductVariant value,
    $Res Function(ProductVariant) then,
  ) = _$ProductVariantCopyWithImpl<$Res, ProductVariant>;
  @useResult
  $Res call({
    String id,
    String productId,
    String size,
    String color,
    double price,
    int stockQty,
    String sku,
  });
}

/// @nodoc
class _$ProductVariantCopyWithImpl<$Res, $Val extends ProductVariant>
    implements $ProductVariantCopyWith<$Res> {
  _$ProductVariantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ProductVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? size = null,
    Object? color = null,
    Object? price = null,
    Object? stockQty = null,
    Object? sku = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            productId: null == productId
                ? _value.productId
                : productId // ignore: cast_nullable_to_non_nullable
                      as String,
            size: null == size
                ? _value.size
                : size // ignore: cast_nullable_to_non_nullable
                      as String,
            color: null == color
                ? _value.color
                : color // ignore: cast_nullable_to_non_nullable
                      as String,
            price: null == price
                ? _value.price
                : price // ignore: cast_nullable_to_non_nullable
                      as double,
            stockQty: null == stockQty
                ? _value.stockQty
                : stockQty // ignore: cast_nullable_to_non_nullable
                      as int,
            sku: null == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ProductVariantImplCopyWith<$Res>
    implements $ProductVariantCopyWith<$Res> {
  factory _$$ProductVariantImplCopyWith(
    _$ProductVariantImpl value,
    $Res Function(_$ProductVariantImpl) then,
  ) = __$$ProductVariantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String productId,
    String size,
    String color,
    double price,
    int stockQty,
    String sku,
  });
}

/// @nodoc
class __$$ProductVariantImplCopyWithImpl<$Res>
    extends _$ProductVariantCopyWithImpl<$Res, _$ProductVariantImpl>
    implements _$$ProductVariantImplCopyWith<$Res> {
  __$$ProductVariantImplCopyWithImpl(
    _$ProductVariantImpl _value,
    $Res Function(_$ProductVariantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ProductVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? size = null,
    Object? color = null,
    Object? price = null,
    Object? stockQty = null,
    Object? sku = null,
  }) {
    return _then(
      _$ProductVariantImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        size: null == size
            ? _value.size
            : size // ignore: cast_nullable_to_non_nullable
                  as String,
        color: null == color
            ? _value.color
            : color // ignore: cast_nullable_to_non_nullable
                  as String,
        price: null == price
            ? _value.price
            : price // ignore: cast_nullable_to_non_nullable
                  as double,
        stockQty: null == stockQty
            ? _value.stockQty
            : stockQty // ignore: cast_nullable_to_non_nullable
                  as int,
        sku: null == sku
            ? _value.sku
            : sku // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ProductVariantImpl implements _ProductVariant {
  const _$ProductVariantImpl({
    required this.id,
    required this.productId,
    required this.size,
    required this.color,
    required this.price,
    required this.stockQty,
    required this.sku,
  });

  factory _$ProductVariantImpl.fromJson(Map<String, dynamic> json) =>
      _$$ProductVariantImplFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final String size;
  @override
  final String color;
  @override
  final double price;
  @override
  final int stockQty;
  @override
  final String sku;

  @override
  String toString() {
    return 'ProductVariant(id: $id, productId: $productId, size: $size, color: $color, price: $price, stockQty: $stockQty, sku: $sku)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ProductVariantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stockQty, stockQty) ||
                other.stockQty == stockQty) &&
            (identical(other.sku, sku) || other.sku == sku));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productId,
    size,
    color,
    price,
    stockQty,
    sku,
  );

  /// Create a copy of ProductVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ProductVariantImplCopyWith<_$ProductVariantImpl> get copyWith =>
      __$$ProductVariantImplCopyWithImpl<_$ProductVariantImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ProductVariantImplToJson(this);
  }
}

abstract class _ProductVariant implements ProductVariant {
  const factory _ProductVariant({
    required final String id,
    required final String productId,
    required final String size,
    required final String color,
    required final double price,
    required final int stockQty,
    required final String sku,
  }) = _$ProductVariantImpl;

  factory _ProductVariant.fromJson(Map<String, dynamic> json) =
      _$ProductVariantImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  String get size;
  @override
  String get color;
  @override
  double get price;
  @override
  int get stockQty;
  @override
  String get sku;

  /// Create a copy of ProductVariant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ProductVariantImplCopyWith<_$ProductVariantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'wishlist_item.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

WishlistItem _$WishlistItemFromJson(Map<String, dynamic> json) {
  return _WishlistItem.fromJson(json);
}

/// @nodoc
mixin _$WishlistItem {
  String get id => throw _privateConstructorUsedError;
  String get productId => throw _privateConstructorUsedError;
  String get productName => throw _privateConstructorUsedError;
  @DecimalConverter()
  double get basePrice => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get thumbnailUrl => throw _privateConstructorUsedError;
  DateTime? get createdAt => throw _privateConstructorUsedError;

  /// Serializes this WishlistItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $WishlistItemCopyWith<WishlistItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $WishlistItemCopyWith<$Res> {
  factory $WishlistItemCopyWith(
    WishlistItem value,
    $Res Function(WishlistItem) then,
  ) = _$WishlistItemCopyWithImpl<$Res, WishlistItem>;
  @useResult
  $Res call({
    String id,
    String productId,
    String productName,
    @DecimalConverter() double basePrice,
    String status,
    String? thumbnailUrl,
    DateTime? createdAt,
  });
}

/// @nodoc
class _$WishlistItemCopyWithImpl<$Res, $Val extends WishlistItem>
    implements $WishlistItemCopyWith<$Res> {
  _$WishlistItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? basePrice = null,
    Object? status = null,
    Object? thumbnailUrl = freezed,
    Object? createdAt = freezed,
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
            productName: null == productName
                ? _value.productName
                : productName // ignore: cast_nullable_to_non_nullable
                      as String,
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
abstract class _$$WishlistItemImplCopyWith<$Res>
    implements $WishlistItemCopyWith<$Res> {
  factory _$$WishlistItemImplCopyWith(
    _$WishlistItemImpl value,
    $Res Function(_$WishlistItemImpl) then,
  ) = __$$WishlistItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String productId,
    String productName,
    @DecimalConverter() double basePrice,
    String status,
    String? thumbnailUrl,
    DateTime? createdAt,
  });
}

/// @nodoc
class __$$WishlistItemImplCopyWithImpl<$Res>
    extends _$WishlistItemCopyWithImpl<$Res, _$WishlistItemImpl>
    implements _$$WishlistItemImplCopyWith<$Res> {
  __$$WishlistItemImplCopyWithImpl(
    _$WishlistItemImpl _value,
    $Res Function(_$WishlistItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? productId = null,
    Object? productName = null,
    Object? basePrice = null,
    Object? status = null,
    Object? thumbnailUrl = freezed,
    Object? createdAt = freezed,
  }) {
    return _then(
      _$WishlistItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        productId: null == productId
            ? _value.productId
            : productId // ignore: cast_nullable_to_non_nullable
                  as String,
        productName: null == productName
            ? _value.productName
            : productName // ignore: cast_nullable_to_non_nullable
                  as String,
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
class _$WishlistItemImpl implements _WishlistItem {
  const _$WishlistItemImpl({
    required this.id,
    required this.productId,
    required this.productName,
    @DecimalConverter() this.basePrice = 0,
    required this.status,
    this.thumbnailUrl,
    this.createdAt,
  });

  factory _$WishlistItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$WishlistItemImplFromJson(json);

  @override
  final String id;
  @override
  final String productId;
  @override
  final String productName;
  @override
  @JsonKey()
  @DecimalConverter()
  final double basePrice;
  @override
  final String status;
  @override
  final String? thumbnailUrl;
  @override
  final DateTime? createdAt;

  @override
  String toString() {
    return 'WishlistItem(id: $id, productId: $productId, productName: $productName, basePrice: $basePrice, status: $status, thumbnailUrl: $thumbnailUrl, createdAt: $createdAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$WishlistItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.productId, productId) ||
                other.productId == productId) &&
            (identical(other.productName, productName) ||
                other.productName == productName) &&
            (identical(other.basePrice, basePrice) ||
                other.basePrice == basePrice) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.thumbnailUrl, thumbnailUrl) ||
                other.thumbnailUrl == thumbnailUrl) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    productId,
    productName,
    basePrice,
    status,
    thumbnailUrl,
    createdAt,
  );

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$WishlistItemImplCopyWith<_$WishlistItemImpl> get copyWith =>
      __$$WishlistItemImplCopyWithImpl<_$WishlistItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$WishlistItemImplToJson(this);
  }
}

abstract class _WishlistItem implements WishlistItem {
  const factory _WishlistItem({
    required final String id,
    required final String productId,
    required final String productName,
    @DecimalConverter() final double basePrice,
    required final String status,
    final String? thumbnailUrl,
    final DateTime? createdAt,
  }) = _$WishlistItemImpl;

  factory _WishlistItem.fromJson(Map<String, dynamic> json) =
      _$WishlistItemImpl.fromJson;

  @override
  String get id;
  @override
  String get productId;
  @override
  String get productName;
  @override
  @DecimalConverter()
  double get basePrice;
  @override
  String get status;
  @override
  String? get thumbnailUrl;
  @override
  DateTime? get createdAt;

  /// Create a copy of WishlistItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$WishlistItemImplCopyWith<_$WishlistItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

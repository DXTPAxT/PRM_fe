// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'cart_response.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

CartResponse _$CartResponseFromJson(Map<String, dynamic> json) {
  return _CartResponse.fromJson(json);
}

/// @nodoc
mixin _$CartResponse {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  List<CartLineItem> get items => throw _privateConstructorUsedError;
  @DecimalConverter()
  double get subtotal => throw _privateConstructorUsedError;

  /// Serializes this CartResponse to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartResponseCopyWith<CartResponse> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartResponseCopyWith<$Res> {
  factory $CartResponseCopyWith(
    CartResponse value,
    $Res Function(CartResponse) then,
  ) = _$CartResponseCopyWithImpl<$Res, CartResponse>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    List<CartLineItem> items,
    @DecimalConverter() double subtotal,
  });
}

/// @nodoc
class _$CartResponseCopyWithImpl<$Res, $Val extends CartResponse>
    implements $CartResponseCopyWith<$Res> {
  _$CartResponseCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? updatedAt = freezed,
    Object? items = null,
    Object? subtotal = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<CartLineItem>,
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartResponseImplCopyWith<$Res>
    implements $CartResponseCopyWith<$Res> {
  factory _$$CartResponseImplCopyWith(
    _$CartResponseImpl value,
    $Res Function(_$CartResponseImpl) then,
  ) = __$$CartResponseImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    List<CartLineItem> items,
    @DecimalConverter() double subtotal,
  });
}

/// @nodoc
class __$$CartResponseImplCopyWithImpl<$Res>
    extends _$CartResponseCopyWithImpl<$Res, _$CartResponseImpl>
    implements _$$CartResponseImplCopyWith<$Res> {
  __$$CartResponseImplCopyWithImpl(
    _$CartResponseImpl _value,
    $Res Function(_$CartResponseImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartResponse
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? updatedAt = freezed,
    Object? items = null,
    Object? subtotal = null,
  }) {
    return _then(
      _$CartResponseImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<CartLineItem>,
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartResponseImpl implements _CartResponse {
  const _$CartResponseImpl({
    required this.id,
    @JsonKey(name: 'updatedAt') this.updatedAt,
    final List<CartLineItem> items = const [],
    @DecimalConverter() this.subtotal = 0,
  }) : _items = items;

  factory _$CartResponseImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartResponseImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  final List<CartLineItem> _items;
  @override
  @JsonKey()
  List<CartLineItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  @JsonKey()
  @DecimalConverter()
  final double subtotal;

  @override
  String toString() {
    return 'CartResponse(id: $id, updatedAt: $updatedAt, items: $items, subtotal: $subtotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartResponseImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    updatedAt,
    const DeepCollectionEquality().hash(_items),
    subtotal,
  );

  /// Create a copy of CartResponse
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartResponseImplCopyWith<_$CartResponseImpl> get copyWith =>
      __$$CartResponseImplCopyWithImpl<_$CartResponseImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartResponseImplToJson(this);
  }
}

abstract class _CartResponse implements CartResponse {
  const factory _CartResponse({
    required final String id,
    @JsonKey(name: 'updatedAt') final DateTime? updatedAt,
    final List<CartLineItem> items,
    @DecimalConverter() final double subtotal,
  }) = _$CartResponseImpl;

  factory _CartResponse.fromJson(Map<String, dynamic> json) =
      _$CartResponseImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt;
  @override
  List<CartLineItem> get items;
  @override
  @DecimalConverter()
  double get subtotal;

  /// Create a copy of CartResponse
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartResponseImplCopyWith<_$CartResponseImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartLineItem _$CartLineItemFromJson(Map<String, dynamic> json) {
  return _CartLineItem.fromJson(json);
}

/// @nodoc
mixin _$CartLineItem {
  String get id => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  CartVariant get variant => throw _privateConstructorUsedError;
  CartProduct get product => throw _privateConstructorUsedError;
  @JsonKey(name: 'lineTotal')
  @DecimalConverter()
  double get lineTotal => throw _privateConstructorUsedError;

  /// Serializes this CartLineItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartLineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartLineItemCopyWith<CartLineItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartLineItemCopyWith<$Res> {
  factory $CartLineItemCopyWith(
    CartLineItem value,
    $Res Function(CartLineItem) then,
  ) = _$CartLineItemCopyWithImpl<$Res, CartLineItem>;
  @useResult
  $Res call({
    String id,
    int quantity,
    CartVariant variant,
    CartProduct product,
    @JsonKey(name: 'lineTotal') @DecimalConverter() double lineTotal,
  });

  $CartVariantCopyWith<$Res> get variant;
  $CartProductCopyWith<$Res> get product;
}

/// @nodoc
class _$CartLineItemCopyWithImpl<$Res, $Val extends CartLineItem>
    implements $CartLineItemCopyWith<$Res> {
  _$CartLineItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartLineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? variant = null,
    Object? product = null,
    Object? lineTotal = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            quantity: null == quantity
                ? _value.quantity
                : quantity // ignore: cast_nullable_to_non_nullable
                      as int,
            variant: null == variant
                ? _value.variant
                : variant // ignore: cast_nullable_to_non_nullable
                      as CartVariant,
            product: null == product
                ? _value.product
                : product // ignore: cast_nullable_to_non_nullable
                      as CartProduct,
            lineTotal: null == lineTotal
                ? _value.lineTotal
                : lineTotal // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }

  /// Create a copy of CartLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartVariantCopyWith<$Res> get variant {
    return $CartVariantCopyWith<$Res>(_value.variant, (value) {
      return _then(_value.copyWith(variant: value) as $Val);
    });
  }

  /// Create a copy of CartLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $CartProductCopyWith<$Res> get product {
    return $CartProductCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$CartLineItemImplCopyWith<$Res>
    implements $CartLineItemCopyWith<$Res> {
  factory _$$CartLineItemImplCopyWith(
    _$CartLineItemImpl value,
    $Res Function(_$CartLineItemImpl) then,
  ) = __$$CartLineItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int quantity,
    CartVariant variant,
    CartProduct product,
    @JsonKey(name: 'lineTotal') @DecimalConverter() double lineTotal,
  });

  @override
  $CartVariantCopyWith<$Res> get variant;
  @override
  $CartProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$CartLineItemImplCopyWithImpl<$Res>
    extends _$CartLineItemCopyWithImpl<$Res, _$CartLineItemImpl>
    implements _$$CartLineItemImplCopyWith<$Res> {
  __$$CartLineItemImplCopyWithImpl(
    _$CartLineItemImpl _value,
    $Res Function(_$CartLineItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartLineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? variant = null,
    Object? product = null,
    Object? lineTotal = null,
  }) {
    return _then(
      _$CartLineItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        variant: null == variant
            ? _value.variant
            : variant // ignore: cast_nullable_to_non_nullable
                  as CartVariant,
        product: null == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as CartProduct,
        lineTotal: null == lineTotal
            ? _value.lineTotal
            : lineTotal // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartLineItemImpl implements _CartLineItem {
  const _$CartLineItemImpl({
    required this.id,
    required this.quantity,
    required this.variant,
    required this.product,
    @JsonKey(name: 'lineTotal') @DecimalConverter() this.lineTotal = 0,
  });

  factory _$CartLineItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartLineItemImplFromJson(json);

  @override
  final String id;
  @override
  final int quantity;
  @override
  final CartVariant variant;
  @override
  final CartProduct product;
  @override
  @JsonKey(name: 'lineTotal')
  @DecimalConverter()
  final double lineTotal;

  @override
  String toString() {
    return 'CartLineItem(id: $id, quantity: $quantity, variant: $variant, product: $product, lineTotal: $lineTotal)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartLineItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.variant, variant) || other.variant == variant) &&
            (identical(other.product, product) || other.product == product) &&
            (identical(other.lineTotal, lineTotal) ||
                other.lineTotal == lineTotal));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, quantity, variant, product, lineTotal);

  /// Create a copy of CartLineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartLineItemImplCopyWith<_$CartLineItemImpl> get copyWith =>
      __$$CartLineItemImplCopyWithImpl<_$CartLineItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartLineItemImplToJson(this);
  }
}

abstract class _CartLineItem implements CartLineItem {
  const factory _CartLineItem({
    required final String id,
    required final int quantity,
    required final CartVariant variant,
    required final CartProduct product,
    @JsonKey(name: 'lineTotal') @DecimalConverter() final double lineTotal,
  }) = _$CartLineItemImpl;

  factory _CartLineItem.fromJson(Map<String, dynamic> json) =
      _$CartLineItemImpl.fromJson;

  @override
  String get id;
  @override
  int get quantity;
  @override
  CartVariant get variant;
  @override
  CartProduct get product;
  @override
  @JsonKey(name: 'lineTotal')
  @DecimalConverter()
  double get lineTotal;

  /// Create a copy of CartLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartLineItemImplCopyWith<_$CartLineItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartVariant _$CartVariantFromJson(Map<String, dynamic> json) {
  return _CartVariant.fromJson(json);
}

/// @nodoc
mixin _$CartVariant {
  String get id => throw _privateConstructorUsedError;
  String get size => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  @DecimalConverter()
  double get price => throw _privateConstructorUsedError;
  @JsonKey(name: 'stockQty')
  int get stockQty => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;

  /// Serializes this CartVariant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartVariantCopyWith<CartVariant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartVariantCopyWith<$Res> {
  factory $CartVariantCopyWith(
    CartVariant value,
    $Res Function(CartVariant) then,
  ) = _$CartVariantCopyWithImpl<$Res, CartVariant>;
  @useResult
  $Res call({
    String id,
    String size,
    String color,
    @DecimalConverter() double price,
    @JsonKey(name: 'stockQty') int stockQty,
    String sku,
  });
}

/// @nodoc
class _$CartVariantCopyWithImpl<$Res, $Val extends CartVariant>
    implements $CartVariantCopyWith<$Res> {
  _$CartVariantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
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
abstract class _$$CartVariantImplCopyWith<$Res>
    implements $CartVariantCopyWith<$Res> {
  factory _$$CartVariantImplCopyWith(
    _$CartVariantImpl value,
    $Res Function(_$CartVariantImpl) then,
  ) = __$$CartVariantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String size,
    String color,
    @DecimalConverter() double price,
    @JsonKey(name: 'stockQty') int stockQty,
    String sku,
  });
}

/// @nodoc
class __$$CartVariantImplCopyWithImpl<$Res>
    extends _$CartVariantCopyWithImpl<$Res, _$CartVariantImpl>
    implements _$$CartVariantImplCopyWith<$Res> {
  __$$CartVariantImplCopyWithImpl(
    _$CartVariantImpl _value,
    $Res Function(_$CartVariantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? size = null,
    Object? color = null,
    Object? price = null,
    Object? stockQty = null,
    Object? sku = null,
  }) {
    return _then(
      _$CartVariantImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
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
class _$CartVariantImpl implements _CartVariant {
  const _$CartVariantImpl({
    required this.id,
    required this.size,
    required this.color,
    @DecimalConverter() this.price = 0,
    @JsonKey(name: 'stockQty') required this.stockQty,
    required this.sku,
  });

  factory _$CartVariantImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartVariantImplFromJson(json);

  @override
  final String id;
  @override
  final String size;
  @override
  final String color;
  @override
  @JsonKey()
  @DecimalConverter()
  final double price;
  @override
  @JsonKey(name: 'stockQty')
  final int stockQty;
  @override
  final String sku;

  @override
  String toString() {
    return 'CartVariant(id: $id, size: $size, color: $color, price: $price, stockQty: $stockQty, sku: $sku)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartVariantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.price, price) || other.price == price) &&
            (identical(other.stockQty, stockQty) ||
                other.stockQty == stockQty) &&
            (identical(other.sku, sku) || other.sku == sku));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, size, color, price, stockQty, sku);

  /// Create a copy of CartVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartVariantImplCopyWith<_$CartVariantImpl> get copyWith =>
      __$$CartVariantImplCopyWithImpl<_$CartVariantImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartVariantImplToJson(this);
  }
}

abstract class _CartVariant implements CartVariant {
  const factory _CartVariant({
    required final String id,
    required final String size,
    required final String color,
    @DecimalConverter() final double price,
    @JsonKey(name: 'stockQty') required final int stockQty,
    required final String sku,
  }) = _$CartVariantImpl;

  factory _CartVariant.fromJson(Map<String, dynamic> json) =
      _$CartVariantImpl.fromJson;

  @override
  String get id;
  @override
  String get size;
  @override
  String get color;
  @override
  @DecimalConverter()
  double get price;
  @override
  @JsonKey(name: 'stockQty')
  int get stockQty;
  @override
  String get sku;

  /// Create a copy of CartVariant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartVariantImplCopyWith<_$CartVariantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

CartProduct _$CartProductFromJson(Map<String, dynamic> json) {
  return _CartProduct.fromJson(json);
}

/// @nodoc
mixin _$CartProduct {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  String? get image => throw _privateConstructorUsedError;

  /// Serializes this CartProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $CartProductCopyWith<CartProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $CartProductCopyWith<$Res> {
  factory $CartProductCopyWith(
    CartProduct value,
    $Res Function(CartProduct) then,
  ) = _$CartProductCopyWithImpl<$Res, CartProduct>;
  @useResult
  $Res call({String id, String name, String status, String? image});
}

/// @nodoc
class _$CartProductCopyWithImpl<$Res, $Val extends CartProduct>
    implements $CartProductCopyWith<$Res> {
  _$CartProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
    Object? image = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            name: null == name
                ? _value.name
                : name // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            image: freezed == image
                ? _value.image
                : image // ignore: cast_nullable_to_non_nullable
                      as String?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$CartProductImplCopyWith<$Res>
    implements $CartProductCopyWith<$Res> {
  factory _$$CartProductImplCopyWith(
    _$CartProductImpl value,
    $Res Function(_$CartProductImpl) then,
  ) = __$$CartProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name, String status, String? image});
}

/// @nodoc
class __$$CartProductImplCopyWithImpl<$Res>
    extends _$CartProductCopyWithImpl<$Res, _$CartProductImpl>
    implements _$$CartProductImplCopyWith<$Res> {
  __$$CartProductImplCopyWithImpl(
    _$CartProductImpl _value,
    $Res Function(_$CartProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? name = null,
    Object? status = null,
    Object? image = freezed,
  }) {
    return _then(
      _$CartProductImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        image: freezed == image
            ? _value.image
            : image // ignore: cast_nullable_to_non_nullable
                  as String?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$CartProductImpl implements _CartProduct {
  const _$CartProductImpl({
    required this.id,
    required this.name,
    required this.status,
    this.image,
  });

  factory _$CartProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$CartProductImplFromJson(json);

  @override
  final String id;
  @override
  final String name;
  @override
  final String status;
  @override
  final String? image;

  @override
  String toString() {
    return 'CartProduct(id: $id, name: $name, status: $status, image: $image)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$CartProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.image, image) || other.image == image));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name, status, image);

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$CartProductImplCopyWith<_$CartProductImpl> get copyWith =>
      __$$CartProductImplCopyWithImpl<_$CartProductImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$CartProductImplToJson(this);
  }
}

abstract class _CartProduct implements CartProduct {
  const factory _CartProduct({
    required final String id,
    required final String name,
    required final String status,
    final String? image,
  }) = _$CartProductImpl;

  factory _CartProduct.fromJson(Map<String, dynamic> json) =
      _$CartProductImpl.fromJson;

  @override
  String get id;
  @override
  String get name;
  @override
  String get status;
  @override
  String? get image;

  /// Create a copy of CartProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$CartProductImplCopyWith<_$CartProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

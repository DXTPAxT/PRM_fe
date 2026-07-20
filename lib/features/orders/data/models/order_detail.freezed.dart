// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'order_detail.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

OrderDetail _$OrderDetailFromJson(Map<String, dynamic> json) {
  return _OrderDetail.fromJson(json);
}

/// @nodoc
mixin _$OrderDetail {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'userId')
  String get userId => throw _privateConstructorUsedError;
  @JsonKey(name: 'addressId')
  String get addressId => throw _privateConstructorUsedError;
  @JsonKey(name: 'voucherId')
  String? get voucherId => throw _privateConstructorUsedError;
  @DecimalConverter()
  double get subtotal => throw _privateConstructorUsedError;
  @DecimalConverter()
  double get discount => throw _privateConstructorUsedError;
  @JsonKey(name: 'shippingFee')
  @DecimalConverter()
  double get shippingFee => throw _privateConstructorUsedError;
  @DecimalConverter()
  double get total => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @JsonKey(name: 'shippingCode')
  String? get shippingCode => throw _privateConstructorUsedError;
  @JsonKey(name: 'createdAt')
  DateTime get createdAt => throw _privateConstructorUsedError;
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt => throw _privateConstructorUsedError;
  OrderAddress? get address => throw _privateConstructorUsedError;
  List<OrderLineItem> get items => throw _privateConstructorUsedError;
  OrderPayment? get payment => throw _privateConstructorUsedError;

  /// Serializes this OrderDetail to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderDetailCopyWith<OrderDetail> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderDetailCopyWith<$Res> {
  factory $OrderDetailCopyWith(
    OrderDetail value,
    $Res Function(OrderDetail) then,
  ) = _$OrderDetailCopyWithImpl<$Res, OrderDetail>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'userId') String userId,
    @JsonKey(name: 'addressId') String addressId,
    @JsonKey(name: 'voucherId') String? voucherId,
    @DecimalConverter() double subtotal,
    @DecimalConverter() double discount,
    @JsonKey(name: 'shippingFee') @DecimalConverter() double shippingFee,
    @DecimalConverter() double total,
    String status,
    @JsonKey(name: 'shippingCode') String? shippingCode,
    @JsonKey(name: 'createdAt') DateTime createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    OrderAddress? address,
    List<OrderLineItem> items,
    OrderPayment? payment,
  });

  $OrderAddressCopyWith<$Res>? get address;
  $OrderPaymentCopyWith<$Res>? get payment;
}

/// @nodoc
class _$OrderDetailCopyWithImpl<$Res, $Val extends OrderDetail>
    implements $OrderDetailCopyWith<$Res> {
  _$OrderDetailCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? addressId = null,
    Object? voucherId = freezed,
    Object? subtotal = null,
    Object? discount = null,
    Object? shippingFee = null,
    Object? total = null,
    Object? status = null,
    Object? shippingCode = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? address = freezed,
    Object? items = null,
    Object? payment = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            userId: null == userId
                ? _value.userId
                : userId // ignore: cast_nullable_to_non_nullable
                      as String,
            addressId: null == addressId
                ? _value.addressId
                : addressId // ignore: cast_nullable_to_non_nullable
                      as String,
            voucherId: freezed == voucherId
                ? _value.voucherId
                : voucherId // ignore: cast_nullable_to_non_nullable
                      as String?,
            subtotal: null == subtotal
                ? _value.subtotal
                : subtotal // ignore: cast_nullable_to_non_nullable
                      as double,
            discount: null == discount
                ? _value.discount
                : discount // ignore: cast_nullable_to_non_nullable
                      as double,
            shippingFee: null == shippingFee
                ? _value.shippingFee
                : shippingFee // ignore: cast_nullable_to_non_nullable
                      as double,
            total: null == total
                ? _value.total
                : total // ignore: cast_nullable_to_non_nullable
                      as double,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            shippingCode: freezed == shippingCode
                ? _value.shippingCode
                : shippingCode // ignore: cast_nullable_to_non_nullable
                      as String?,
            createdAt: null == createdAt
                ? _value.createdAt
                : createdAt // ignore: cast_nullable_to_non_nullable
                      as DateTime,
            updatedAt: freezed == updatedAt
                ? _value.updatedAt
                : updatedAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
            address: freezed == address
                ? _value.address
                : address // ignore: cast_nullable_to_non_nullable
                      as OrderAddress?,
            items: null == items
                ? _value.items
                : items // ignore: cast_nullable_to_non_nullable
                      as List<OrderLineItem>,
            payment: freezed == payment
                ? _value.payment
                : payment // ignore: cast_nullable_to_non_nullable
                      as OrderPayment?,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderAddressCopyWith<$Res>? get address {
    if (_value.address == null) {
      return null;
    }

    return $OrderAddressCopyWith<$Res>(_value.address!, (value) {
      return _then(_value.copyWith(address: value) as $Val);
    });
  }

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderPaymentCopyWith<$Res>? get payment {
    if (_value.payment == null) {
      return null;
    }

    return $OrderPaymentCopyWith<$Res>(_value.payment!, (value) {
      return _then(_value.copyWith(payment: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderDetailImplCopyWith<$Res>
    implements $OrderDetailCopyWith<$Res> {
  factory _$$OrderDetailImplCopyWith(
    _$OrderDetailImpl value,
    $Res Function(_$OrderDetailImpl) then,
  ) = __$$OrderDetailImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'userId') String userId,
    @JsonKey(name: 'addressId') String addressId,
    @JsonKey(name: 'voucherId') String? voucherId,
    @DecimalConverter() double subtotal,
    @DecimalConverter() double discount,
    @JsonKey(name: 'shippingFee') @DecimalConverter() double shippingFee,
    @DecimalConverter() double total,
    String status,
    @JsonKey(name: 'shippingCode') String? shippingCode,
    @JsonKey(name: 'createdAt') DateTime createdAt,
    @JsonKey(name: 'updatedAt') DateTime? updatedAt,
    OrderAddress? address,
    List<OrderLineItem> items,
    OrderPayment? payment,
  });

  @override
  $OrderAddressCopyWith<$Res>? get address;
  @override
  $OrderPaymentCopyWith<$Res>? get payment;
}

/// @nodoc
class __$$OrderDetailImplCopyWithImpl<$Res>
    extends _$OrderDetailCopyWithImpl<$Res, _$OrderDetailImpl>
    implements _$$OrderDetailImplCopyWith<$Res> {
  __$$OrderDetailImplCopyWithImpl(
    _$OrderDetailImpl _value,
    $Res Function(_$OrderDetailImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? userId = null,
    Object? addressId = null,
    Object? voucherId = freezed,
    Object? subtotal = null,
    Object? discount = null,
    Object? shippingFee = null,
    Object? total = null,
    Object? status = null,
    Object? shippingCode = freezed,
    Object? createdAt = null,
    Object? updatedAt = freezed,
    Object? address = freezed,
    Object? items = null,
    Object? payment = freezed,
  }) {
    return _then(
      _$OrderDetailImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        userId: null == userId
            ? _value.userId
            : userId // ignore: cast_nullable_to_non_nullable
                  as String,
        addressId: null == addressId
            ? _value.addressId
            : addressId // ignore: cast_nullable_to_non_nullable
                  as String,
        voucherId: freezed == voucherId
            ? _value.voucherId
            : voucherId // ignore: cast_nullable_to_non_nullable
                  as String?,
        subtotal: null == subtotal
            ? _value.subtotal
            : subtotal // ignore: cast_nullable_to_non_nullable
                  as double,
        discount: null == discount
            ? _value.discount
            : discount // ignore: cast_nullable_to_non_nullable
                  as double,
        shippingFee: null == shippingFee
            ? _value.shippingFee
            : shippingFee // ignore: cast_nullable_to_non_nullable
                  as double,
        total: null == total
            ? _value.total
            : total // ignore: cast_nullable_to_non_nullable
                  as double,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        shippingCode: freezed == shippingCode
            ? _value.shippingCode
            : shippingCode // ignore: cast_nullable_to_non_nullable
                  as String?,
        createdAt: null == createdAt
            ? _value.createdAt
            : createdAt // ignore: cast_nullable_to_non_nullable
                  as DateTime,
        updatedAt: freezed == updatedAt
            ? _value.updatedAt
            : updatedAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
        address: freezed == address
            ? _value.address
            : address // ignore: cast_nullable_to_non_nullable
                  as OrderAddress?,
        items: null == items
            ? _value._items
            : items // ignore: cast_nullable_to_non_nullable
                  as List<OrderLineItem>,
        payment: freezed == payment
            ? _value.payment
            : payment // ignore: cast_nullable_to_non_nullable
                  as OrderPayment?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderDetailImpl implements _OrderDetail {
  const _$OrderDetailImpl({
    required this.id,
    @JsonKey(name: 'userId') required this.userId,
    @JsonKey(name: 'addressId') required this.addressId,
    @JsonKey(name: 'voucherId') this.voucherId,
    @DecimalConverter() this.subtotal = 0,
    @DecimalConverter() this.discount = 0,
    @JsonKey(name: 'shippingFee') @DecimalConverter() this.shippingFee = 0,
    @DecimalConverter() this.total = 0,
    required this.status,
    @JsonKey(name: 'shippingCode') this.shippingCode,
    @JsonKey(name: 'createdAt') required this.createdAt,
    @JsonKey(name: 'updatedAt') this.updatedAt,
    this.address,
    final List<OrderLineItem> items = const [],
    this.payment,
  }) : _items = items;

  factory _$OrderDetailImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderDetailImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'userId')
  final String userId;
  @override
  @JsonKey(name: 'addressId')
  final String addressId;
  @override
  @JsonKey(name: 'voucherId')
  final String? voucherId;
  @override
  @JsonKey()
  @DecimalConverter()
  final double subtotal;
  @override
  @JsonKey()
  @DecimalConverter()
  final double discount;
  @override
  @JsonKey(name: 'shippingFee')
  @DecimalConverter()
  final double shippingFee;
  @override
  @JsonKey()
  @DecimalConverter()
  final double total;
  @override
  final String status;
  @override
  @JsonKey(name: 'shippingCode')
  final String? shippingCode;
  @override
  @JsonKey(name: 'createdAt')
  final DateTime createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  final DateTime? updatedAt;
  @override
  final OrderAddress? address;
  final List<OrderLineItem> _items;
  @override
  @JsonKey()
  List<OrderLineItem> get items {
    if (_items is EqualUnmodifiableListView) return _items;
    // ignore: implicit_dynamic_type
    return EqualUnmodifiableListView(_items);
  }

  @override
  final OrderPayment? payment;

  @override
  String toString() {
    return 'OrderDetail(id: $id, userId: $userId, addressId: $addressId, voucherId: $voucherId, subtotal: $subtotal, discount: $discount, shippingFee: $shippingFee, total: $total, status: $status, shippingCode: $shippingCode, createdAt: $createdAt, updatedAt: $updatedAt, address: $address, items: $items, payment: $payment)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderDetailImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.userId, userId) || other.userId == userId) &&
            (identical(other.addressId, addressId) ||
                other.addressId == addressId) &&
            (identical(other.voucherId, voucherId) ||
                other.voucherId == voucherId) &&
            (identical(other.subtotal, subtotal) ||
                other.subtotal == subtotal) &&
            (identical(other.discount, discount) ||
                other.discount == discount) &&
            (identical(other.shippingFee, shippingFee) ||
                other.shippingFee == shippingFee) &&
            (identical(other.total, total) || other.total == total) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.shippingCode, shippingCode) ||
                other.shippingCode == shippingCode) &&
            (identical(other.createdAt, createdAt) ||
                other.createdAt == createdAt) &&
            (identical(other.updatedAt, updatedAt) ||
                other.updatedAt == updatedAt) &&
            (identical(other.address, address) || other.address == address) &&
            const DeepCollectionEquality().equals(other._items, _items) &&
            (identical(other.payment, payment) || other.payment == payment));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    id,
    userId,
    addressId,
    voucherId,
    subtotal,
    discount,
    shippingFee,
    total,
    status,
    shippingCode,
    createdAt,
    updatedAt,
    address,
    const DeepCollectionEquality().hash(_items),
    payment,
  );

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderDetailImplCopyWith<_$OrderDetailImpl> get copyWith =>
      __$$OrderDetailImplCopyWithImpl<_$OrderDetailImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderDetailImplToJson(this);
  }
}

abstract class _OrderDetail implements OrderDetail {
  const factory _OrderDetail({
    required final String id,
    @JsonKey(name: 'userId') required final String userId,
    @JsonKey(name: 'addressId') required final String addressId,
    @JsonKey(name: 'voucherId') final String? voucherId,
    @DecimalConverter() final double subtotal,
    @DecimalConverter() final double discount,
    @JsonKey(name: 'shippingFee') @DecimalConverter() final double shippingFee,
    @DecimalConverter() final double total,
    required final String status,
    @JsonKey(name: 'shippingCode') final String? shippingCode,
    @JsonKey(name: 'createdAt') required final DateTime createdAt,
    @JsonKey(name: 'updatedAt') final DateTime? updatedAt,
    final OrderAddress? address,
    final List<OrderLineItem> items,
    final OrderPayment? payment,
  }) = _$OrderDetailImpl;

  factory _OrderDetail.fromJson(Map<String, dynamic> json) =
      _$OrderDetailImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'userId')
  String get userId;
  @override
  @JsonKey(name: 'addressId')
  String get addressId;
  @override
  @JsonKey(name: 'voucherId')
  String? get voucherId;
  @override
  @DecimalConverter()
  double get subtotal;
  @override
  @DecimalConverter()
  double get discount;
  @override
  @JsonKey(name: 'shippingFee')
  @DecimalConverter()
  double get shippingFee;
  @override
  @DecimalConverter()
  double get total;
  @override
  String get status;
  @override
  @JsonKey(name: 'shippingCode')
  String? get shippingCode;
  @override
  @JsonKey(name: 'createdAt')
  DateTime get createdAt;
  @override
  @JsonKey(name: 'updatedAt')
  DateTime? get updatedAt;
  @override
  OrderAddress? get address;
  @override
  List<OrderLineItem> get items;
  @override
  OrderPayment? get payment;

  /// Create a copy of OrderDetail
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderDetailImplCopyWith<_$OrderDetailImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderAddress _$OrderAddressFromJson(Map<String, dynamic> json) {
  return _OrderAddress.fromJson(json);
}

/// @nodoc
mixin _$OrderAddress {
  String get id => throw _privateConstructorUsedError;
  @JsonKey(name: 'fullName')
  String get fullName => throw _privateConstructorUsedError;
  String get phone => throw _privateConstructorUsedError;
  String get detail => throw _privateConstructorUsedError;

  /// Serializes this OrderAddress to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderAddressCopyWith<OrderAddress> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderAddressCopyWith<$Res> {
  factory $OrderAddressCopyWith(
    OrderAddress value,
    $Res Function(OrderAddress) then,
  ) = _$OrderAddressCopyWithImpl<$Res, OrderAddress>;
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'fullName') String fullName,
    String phone,
    String detail,
  });
}

/// @nodoc
class _$OrderAddressCopyWithImpl<$Res, $Val extends OrderAddress>
    implements $OrderAddressCopyWith<$Res> {
  _$OrderAddressCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = null,
    Object? detail = null,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            fullName: null == fullName
                ? _value.fullName
                : fullName // ignore: cast_nullable_to_non_nullable
                      as String,
            phone: null == phone
                ? _value.phone
                : phone // ignore: cast_nullable_to_non_nullable
                      as String,
            detail: null == detail
                ? _value.detail
                : detail // ignore: cast_nullable_to_non_nullable
                      as String,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderAddressImplCopyWith<$Res>
    implements $OrderAddressCopyWith<$Res> {
  factory _$$OrderAddressImplCopyWith(
    _$OrderAddressImpl value,
    $Res Function(_$OrderAddressImpl) then,
  ) = __$$OrderAddressImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    @JsonKey(name: 'fullName') String fullName,
    String phone,
    String detail,
  });
}

/// @nodoc
class __$$OrderAddressImplCopyWithImpl<$Res>
    extends _$OrderAddressCopyWithImpl<$Res, _$OrderAddressImpl>
    implements _$$OrderAddressImplCopyWith<$Res> {
  __$$OrderAddressImplCopyWithImpl(
    _$OrderAddressImpl _value,
    $Res Function(_$OrderAddressImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? fullName = null,
    Object? phone = null,
    Object? detail = null,
  }) {
    return _then(
      _$OrderAddressImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        fullName: null == fullName
            ? _value.fullName
            : fullName // ignore: cast_nullable_to_non_nullable
                  as String,
        phone: null == phone
            ? _value.phone
            : phone // ignore: cast_nullable_to_non_nullable
                  as String,
        detail: null == detail
            ? _value.detail
            : detail // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderAddressImpl implements _OrderAddress {
  const _$OrderAddressImpl({
    required this.id,
    @JsonKey(name: 'fullName') required this.fullName,
    required this.phone,
    required this.detail,
  });

  factory _$OrderAddressImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderAddressImplFromJson(json);

  @override
  final String id;
  @override
  @JsonKey(name: 'fullName')
  final String fullName;
  @override
  final String phone;
  @override
  final String detail;

  @override
  String toString() {
    return 'OrderAddress(id: $id, fullName: $fullName, phone: $phone, detail: $detail)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderAddressImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.fullName, fullName) ||
                other.fullName == fullName) &&
            (identical(other.phone, phone) || other.phone == phone) &&
            (identical(other.detail, detail) || other.detail == detail));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, fullName, phone, detail);

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderAddressImplCopyWith<_$OrderAddressImpl> get copyWith =>
      __$$OrderAddressImplCopyWithImpl<_$OrderAddressImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderAddressImplToJson(this);
  }
}

abstract class _OrderAddress implements OrderAddress {
  const factory _OrderAddress({
    required final String id,
    @JsonKey(name: 'fullName') required final String fullName,
    required final String phone,
    required final String detail,
  }) = _$OrderAddressImpl;

  factory _OrderAddress.fromJson(Map<String, dynamic> json) =
      _$OrderAddressImpl.fromJson;

  @override
  String get id;
  @override
  @JsonKey(name: 'fullName')
  String get fullName;
  @override
  String get phone;
  @override
  String get detail;

  /// Create a copy of OrderAddress
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderAddressImplCopyWith<_$OrderAddressImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderLineItem _$OrderLineItemFromJson(Map<String, dynamic> json) {
  return _OrderLineItem.fromJson(json);
}

/// @nodoc
mixin _$OrderLineItem {
  String get id => throw _privateConstructorUsedError;
  int get quantity => throw _privateConstructorUsedError;
  @JsonKey(name: 'unitPrice')
  @DecimalConverter()
  double get unitPrice => throw _privateConstructorUsedError;
  OrderLineVariant get variant => throw _privateConstructorUsedError;

  /// Serializes this OrderLineItem to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderLineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderLineItemCopyWith<OrderLineItem> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderLineItemCopyWith<$Res> {
  factory $OrderLineItemCopyWith(
    OrderLineItem value,
    $Res Function(OrderLineItem) then,
  ) = _$OrderLineItemCopyWithImpl<$Res, OrderLineItem>;
  @useResult
  $Res call({
    String id,
    int quantity,
    @JsonKey(name: 'unitPrice') @DecimalConverter() double unitPrice,
    OrderLineVariant variant,
  });

  $OrderLineVariantCopyWith<$Res> get variant;
}

/// @nodoc
class _$OrderLineItemCopyWithImpl<$Res, $Val extends OrderLineItem>
    implements $OrderLineItemCopyWith<$Res> {
  _$OrderLineItemCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderLineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? variant = null,
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
            unitPrice: null == unitPrice
                ? _value.unitPrice
                : unitPrice // ignore: cast_nullable_to_non_nullable
                      as double,
            variant: null == variant
                ? _value.variant
                : variant // ignore: cast_nullable_to_non_nullable
                      as OrderLineVariant,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderLineVariantCopyWith<$Res> get variant {
    return $OrderLineVariantCopyWith<$Res>(_value.variant, (value) {
      return _then(_value.copyWith(variant: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderLineItemImplCopyWith<$Res>
    implements $OrderLineItemCopyWith<$Res> {
  factory _$$OrderLineItemImplCopyWith(
    _$OrderLineItemImpl value,
    $Res Function(_$OrderLineItemImpl) then,
  ) = __$$OrderLineItemImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    int quantity,
    @JsonKey(name: 'unitPrice') @DecimalConverter() double unitPrice,
    OrderLineVariant variant,
  });

  @override
  $OrderLineVariantCopyWith<$Res> get variant;
}

/// @nodoc
class __$$OrderLineItemImplCopyWithImpl<$Res>
    extends _$OrderLineItemCopyWithImpl<$Res, _$OrderLineItemImpl>
    implements _$$OrderLineItemImplCopyWith<$Res> {
  __$$OrderLineItemImplCopyWithImpl(
    _$OrderLineItemImpl _value,
    $Res Function(_$OrderLineItemImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderLineItem
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? quantity = null,
    Object? unitPrice = null,
    Object? variant = null,
  }) {
    return _then(
      _$OrderLineItemImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        quantity: null == quantity
            ? _value.quantity
            : quantity // ignore: cast_nullable_to_non_nullable
                  as int,
        unitPrice: null == unitPrice
            ? _value.unitPrice
            : unitPrice // ignore: cast_nullable_to_non_nullable
                  as double,
        variant: null == variant
            ? _value.variant
            : variant // ignore: cast_nullable_to_non_nullable
                  as OrderLineVariant,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderLineItemImpl implements _OrderLineItem {
  const _$OrderLineItemImpl({
    required this.id,
    required this.quantity,
    @JsonKey(name: 'unitPrice') @DecimalConverter() this.unitPrice = 0,
    required this.variant,
  });

  factory _$OrderLineItemImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderLineItemImplFromJson(json);

  @override
  final String id;
  @override
  final int quantity;
  @override
  @JsonKey(name: 'unitPrice')
  @DecimalConverter()
  final double unitPrice;
  @override
  final OrderLineVariant variant;

  @override
  String toString() {
    return 'OrderLineItem(id: $id, quantity: $quantity, unitPrice: $unitPrice, variant: $variant)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderLineItemImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.quantity, quantity) ||
                other.quantity == quantity) &&
            (identical(other.unitPrice, unitPrice) ||
                other.unitPrice == unitPrice) &&
            (identical(other.variant, variant) || other.variant == variant));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, quantity, unitPrice, variant);

  /// Create a copy of OrderLineItem
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderLineItemImplCopyWith<_$OrderLineItemImpl> get copyWith =>
      __$$OrderLineItemImplCopyWithImpl<_$OrderLineItemImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderLineItemImplToJson(this);
  }
}

abstract class _OrderLineItem implements OrderLineItem {
  const factory _OrderLineItem({
    required final String id,
    required final int quantity,
    @JsonKey(name: 'unitPrice') @DecimalConverter() final double unitPrice,
    required final OrderLineVariant variant,
  }) = _$OrderLineItemImpl;

  factory _OrderLineItem.fromJson(Map<String, dynamic> json) =
      _$OrderLineItemImpl.fromJson;

  @override
  String get id;
  @override
  int get quantity;
  @override
  @JsonKey(name: 'unitPrice')
  @DecimalConverter()
  double get unitPrice;
  @override
  OrderLineVariant get variant;

  /// Create a copy of OrderLineItem
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderLineItemImplCopyWith<_$OrderLineItemImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderLineVariant _$OrderLineVariantFromJson(Map<String, dynamic> json) {
  return _OrderLineVariant.fromJson(json);
}

/// @nodoc
mixin _$OrderLineVariant {
  String get id => throw _privateConstructorUsedError;
  String get size => throw _privateConstructorUsedError;
  String get color => throw _privateConstructorUsedError;
  String get sku => throw _privateConstructorUsedError;
  OrderLineProduct get product => throw _privateConstructorUsedError;

  /// Serializes this OrderLineVariant to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderLineVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderLineVariantCopyWith<OrderLineVariant> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderLineVariantCopyWith<$Res> {
  factory $OrderLineVariantCopyWith(
    OrderLineVariant value,
    $Res Function(OrderLineVariant) then,
  ) = _$OrderLineVariantCopyWithImpl<$Res, OrderLineVariant>;
  @useResult
  $Res call({
    String id,
    String size,
    String color,
    String sku,
    OrderLineProduct product,
  });

  $OrderLineProductCopyWith<$Res> get product;
}

/// @nodoc
class _$OrderLineVariantCopyWithImpl<$Res, $Val extends OrderLineVariant>
    implements $OrderLineVariantCopyWith<$Res> {
  _$OrderLineVariantCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderLineVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? size = null,
    Object? color = null,
    Object? sku = null,
    Object? product = null,
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
            sku: null == sku
                ? _value.sku
                : sku // ignore: cast_nullable_to_non_nullable
                      as String,
            product: null == product
                ? _value.product
                : product // ignore: cast_nullable_to_non_nullable
                      as OrderLineProduct,
          )
          as $Val,
    );
  }

  /// Create a copy of OrderLineVariant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @pragma('vm:prefer-inline')
  $OrderLineProductCopyWith<$Res> get product {
    return $OrderLineProductCopyWith<$Res>(_value.product, (value) {
      return _then(_value.copyWith(product: value) as $Val);
    });
  }
}

/// @nodoc
abstract class _$$OrderLineVariantImplCopyWith<$Res>
    implements $OrderLineVariantCopyWith<$Res> {
  factory _$$OrderLineVariantImplCopyWith(
    _$OrderLineVariantImpl value,
    $Res Function(_$OrderLineVariantImpl) then,
  ) = __$$OrderLineVariantImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String size,
    String color,
    String sku,
    OrderLineProduct product,
  });

  @override
  $OrderLineProductCopyWith<$Res> get product;
}

/// @nodoc
class __$$OrderLineVariantImplCopyWithImpl<$Res>
    extends _$OrderLineVariantCopyWithImpl<$Res, _$OrderLineVariantImpl>
    implements _$$OrderLineVariantImplCopyWith<$Res> {
  __$$OrderLineVariantImplCopyWithImpl(
    _$OrderLineVariantImpl _value,
    $Res Function(_$OrderLineVariantImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderLineVariant
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? size = null,
    Object? color = null,
    Object? sku = null,
    Object? product = null,
  }) {
    return _then(
      _$OrderLineVariantImpl(
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
        sku: null == sku
            ? _value.sku
            : sku // ignore: cast_nullable_to_non_nullable
                  as String,
        product: null == product
            ? _value.product
            : product // ignore: cast_nullable_to_non_nullable
                  as OrderLineProduct,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderLineVariantImpl implements _OrderLineVariant {
  const _$OrderLineVariantImpl({
    required this.id,
    required this.size,
    required this.color,
    required this.sku,
    required this.product,
  });

  factory _$OrderLineVariantImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderLineVariantImplFromJson(json);

  @override
  final String id;
  @override
  final String size;
  @override
  final String color;
  @override
  final String sku;
  @override
  final OrderLineProduct product;

  @override
  String toString() {
    return 'OrderLineVariant(id: $id, size: $size, color: $color, sku: $sku, product: $product)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderLineVariantImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.size, size) || other.size == size) &&
            (identical(other.color, color) || other.color == color) &&
            (identical(other.sku, sku) || other.sku == sku) &&
            (identical(other.product, product) || other.product == product));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, size, color, sku, product);

  /// Create a copy of OrderLineVariant
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderLineVariantImplCopyWith<_$OrderLineVariantImpl> get copyWith =>
      __$$OrderLineVariantImplCopyWithImpl<_$OrderLineVariantImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderLineVariantImplToJson(this);
  }
}

abstract class _OrderLineVariant implements OrderLineVariant {
  const factory _OrderLineVariant({
    required final String id,
    required final String size,
    required final String color,
    required final String sku,
    required final OrderLineProduct product,
  }) = _$OrderLineVariantImpl;

  factory _OrderLineVariant.fromJson(Map<String, dynamic> json) =
      _$OrderLineVariantImpl.fromJson;

  @override
  String get id;
  @override
  String get size;
  @override
  String get color;
  @override
  String get sku;
  @override
  OrderLineProduct get product;

  /// Create a copy of OrderLineVariant
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderLineVariantImplCopyWith<_$OrderLineVariantImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderLineProduct _$OrderLineProductFromJson(Map<String, dynamic> json) {
  return _OrderLineProduct.fromJson(json);
}

/// @nodoc
mixin _$OrderLineProduct {
  String get id => throw _privateConstructorUsedError;
  String get name => throw _privateConstructorUsedError;

  /// Serializes this OrderLineProduct to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderLineProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderLineProductCopyWith<OrderLineProduct> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderLineProductCopyWith<$Res> {
  factory $OrderLineProductCopyWith(
    OrderLineProduct value,
    $Res Function(OrderLineProduct) then,
  ) = _$OrderLineProductCopyWithImpl<$Res, OrderLineProduct>;
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class _$OrderLineProductCopyWithImpl<$Res, $Val extends OrderLineProduct>
    implements $OrderLineProductCopyWith<$Res> {
  _$OrderLineProductCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderLineProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
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
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderLineProductImplCopyWith<$Res>
    implements $OrderLineProductCopyWith<$Res> {
  factory _$$OrderLineProductImplCopyWith(
    _$OrderLineProductImpl value,
    $Res Function(_$OrderLineProductImpl) then,
  ) = __$$OrderLineProductImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({String id, String name});
}

/// @nodoc
class __$$OrderLineProductImplCopyWithImpl<$Res>
    extends _$OrderLineProductCopyWithImpl<$Res, _$OrderLineProductImpl>
    implements _$$OrderLineProductImplCopyWith<$Res> {
  __$$OrderLineProductImplCopyWithImpl(
    _$OrderLineProductImpl _value,
    $Res Function(_$OrderLineProductImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderLineProduct
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({Object? id = null, Object? name = null}) {
    return _then(
      _$OrderLineProductImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        name: null == name
            ? _value.name
            : name // ignore: cast_nullable_to_non_nullable
                  as String,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderLineProductImpl implements _OrderLineProduct {
  const _$OrderLineProductImpl({required this.id, required this.name});

  factory _$OrderLineProductImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderLineProductImplFromJson(json);

  @override
  final String id;
  @override
  final String name;

  @override
  String toString() {
    return 'OrderLineProduct(id: $id, name: $name)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderLineProductImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.name, name) || other.name == name));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(runtimeType, id, name);

  /// Create a copy of OrderLineProduct
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderLineProductImplCopyWith<_$OrderLineProductImpl> get copyWith =>
      __$$OrderLineProductImplCopyWithImpl<_$OrderLineProductImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderLineProductImplToJson(this);
  }
}

abstract class _OrderLineProduct implements OrderLineProduct {
  const factory _OrderLineProduct({
    required final String id,
    required final String name,
  }) = _$OrderLineProductImpl;

  factory _OrderLineProduct.fromJson(Map<String, dynamic> json) =
      _$OrderLineProductImpl.fromJson;

  @override
  String get id;
  @override
  String get name;

  /// Create a copy of OrderLineProduct
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderLineProductImplCopyWith<_$OrderLineProductImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

OrderPayment _$OrderPaymentFromJson(Map<String, dynamic> json) {
  return _OrderPayment.fromJson(json);
}

/// @nodoc
mixin _$OrderPayment {
  String get id => throw _privateConstructorUsedError;
  String get method => throw _privateConstructorUsedError;
  String get status => throw _privateConstructorUsedError;
  @DecimalConverter()
  double get amount => throw _privateConstructorUsedError;
  @JsonKey(name: 'paidAt')
  DateTime? get paidAt => throw _privateConstructorUsedError;

  /// Serializes this OrderPayment to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $OrderPaymentCopyWith<OrderPayment> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $OrderPaymentCopyWith<$Res> {
  factory $OrderPaymentCopyWith(
    OrderPayment value,
    $Res Function(OrderPayment) then,
  ) = _$OrderPaymentCopyWithImpl<$Res, OrderPayment>;
  @useResult
  $Res call({
    String id,
    String method,
    String status,
    @DecimalConverter() double amount,
    @JsonKey(name: 'paidAt') DateTime? paidAt,
  });
}

/// @nodoc
class _$OrderPaymentCopyWithImpl<$Res, $Val extends OrderPayment>
    implements $OrderPaymentCopyWith<$Res> {
  _$OrderPaymentCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? method = null,
    Object? status = null,
    Object? amount = null,
    Object? paidAt = freezed,
  }) {
    return _then(
      _value.copyWith(
            id: null == id
                ? _value.id
                : id // ignore: cast_nullable_to_non_nullable
                      as String,
            method: null == method
                ? _value.method
                : method // ignore: cast_nullable_to_non_nullable
                      as String,
            status: null == status
                ? _value.status
                : status // ignore: cast_nullable_to_non_nullable
                      as String,
            amount: null == amount
                ? _value.amount
                : amount // ignore: cast_nullable_to_non_nullable
                      as double,
            paidAt: freezed == paidAt
                ? _value.paidAt
                : paidAt // ignore: cast_nullable_to_non_nullable
                      as DateTime?,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$OrderPaymentImplCopyWith<$Res>
    implements $OrderPaymentCopyWith<$Res> {
  factory _$$OrderPaymentImplCopyWith(
    _$OrderPaymentImpl value,
    $Res Function(_$OrderPaymentImpl) then,
  ) = __$$OrderPaymentImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    String id,
    String method,
    String status,
    @DecimalConverter() double amount,
    @JsonKey(name: 'paidAt') DateTime? paidAt,
  });
}

/// @nodoc
class __$$OrderPaymentImplCopyWithImpl<$Res>
    extends _$OrderPaymentCopyWithImpl<$Res, _$OrderPaymentImpl>
    implements _$$OrderPaymentImplCopyWith<$Res> {
  __$$OrderPaymentImplCopyWithImpl(
    _$OrderPaymentImpl _value,
    $Res Function(_$OrderPaymentImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? id = null,
    Object? method = null,
    Object? status = null,
    Object? amount = null,
    Object? paidAt = freezed,
  }) {
    return _then(
      _$OrderPaymentImpl(
        id: null == id
            ? _value.id
            : id // ignore: cast_nullable_to_non_nullable
                  as String,
        method: null == method
            ? _value.method
            : method // ignore: cast_nullable_to_non_nullable
                  as String,
        status: null == status
            ? _value.status
            : status // ignore: cast_nullable_to_non_nullable
                  as String,
        amount: null == amount
            ? _value.amount
            : amount // ignore: cast_nullable_to_non_nullable
                  as double,
        paidAt: freezed == paidAt
            ? _value.paidAt
            : paidAt // ignore: cast_nullable_to_non_nullable
                  as DateTime?,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$OrderPaymentImpl implements _OrderPayment {
  const _$OrderPaymentImpl({
    required this.id,
    required this.method,
    required this.status,
    @DecimalConverter() this.amount = 0,
    @JsonKey(name: 'paidAt') this.paidAt,
  });

  factory _$OrderPaymentImpl.fromJson(Map<String, dynamic> json) =>
      _$$OrderPaymentImplFromJson(json);

  @override
  final String id;
  @override
  final String method;
  @override
  final String status;
  @override
  @JsonKey()
  @DecimalConverter()
  final double amount;
  @override
  @JsonKey(name: 'paidAt')
  final DateTime? paidAt;

  @override
  String toString() {
    return 'OrderPayment(id: $id, method: $method, status: $status, amount: $amount, paidAt: $paidAt)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$OrderPaymentImpl &&
            (identical(other.id, id) || other.id == id) &&
            (identical(other.method, method) || other.method == method) &&
            (identical(other.status, status) || other.status == status) &&
            (identical(other.amount, amount) || other.amount == amount) &&
            (identical(other.paidAt, paidAt) || other.paidAt == paidAt));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode =>
      Object.hash(runtimeType, id, method, status, amount, paidAt);

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$OrderPaymentImplCopyWith<_$OrderPaymentImpl> get copyWith =>
      __$$OrderPaymentImplCopyWithImpl<_$OrderPaymentImpl>(this, _$identity);

  @override
  Map<String, dynamic> toJson() {
    return _$$OrderPaymentImplToJson(this);
  }
}

abstract class _OrderPayment implements OrderPayment {
  const factory _OrderPayment({
    required final String id,
    required final String method,
    required final String status,
    @DecimalConverter() final double amount,
    @JsonKey(name: 'paidAt') final DateTime? paidAt,
  }) = _$OrderPaymentImpl;

  factory _OrderPayment.fromJson(Map<String, dynamic> json) =
      _$OrderPaymentImpl.fromJson;

  @override
  String get id;
  @override
  String get method;
  @override
  String get status;
  @override
  @DecimalConverter()
  double get amount;
  @override
  @JsonKey(name: 'paidAt')
  DateTime? get paidAt;

  /// Create a copy of OrderPayment
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$OrderPaymentImplCopyWith<_$OrderPaymentImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

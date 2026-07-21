// coverage:ignore-file
// GENERATED CODE - DO NOT MODIFY BY HAND
// ignore_for_file: type=lint
// ignore_for_file: unused_element, deprecated_member_use, deprecated_member_use_from_same_package, use_function_type_syntax_for_parameters, unnecessary_const, avoid_init_to_null, invalid_override_different_default_values_named, prefer_expression_function_bodies, annotate_overrides, invalid_annotation_target, unnecessary_question_mark

part of 'reports_summary.dart';

// **************************************************************************
// FreezedGenerator
// **************************************************************************

T _$identity<T>(T value) => value;

final _privateConstructorUsedError = UnsupportedError(
  'It seems like you constructed your class using `MyClass._()`. This constructor is only meant to be used by freezed and you are not supposed to need it nor use it.\nPlease check the documentation here for more information: https://github.com/rrousselGit/freezed#adding-getters-and-methods-to-our-models',
);

ReportsSummary _$ReportsSummaryFromJson(Map<String, dynamic> json) {
  return _ReportsSummary.fromJson(json);
}

/// @nodoc
mixin _$ReportsSummary {
  double get totalRevenue => throw _privateConstructorUsedError;
  int get totalOrders => throw _privateConstructorUsedError;
  int get totalProducts => throw _privateConstructorUsedError;
  double get cancelledRatio => throw _privateConstructorUsedError;

  /// Serializes this ReportsSummary to a JSON map.
  Map<String, dynamic> toJson() => throw _privateConstructorUsedError;

  /// Create a copy of ReportsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  $ReportsSummaryCopyWith<ReportsSummary> get copyWith =>
      throw _privateConstructorUsedError;
}

/// @nodoc
abstract class $ReportsSummaryCopyWith<$Res> {
  factory $ReportsSummaryCopyWith(
    ReportsSummary value,
    $Res Function(ReportsSummary) then,
  ) = _$ReportsSummaryCopyWithImpl<$Res, ReportsSummary>;
  @useResult
  $Res call({
    double totalRevenue,
    int totalOrders,
    int totalProducts,
    double cancelledRatio,
  });
}

/// @nodoc
class _$ReportsSummaryCopyWithImpl<$Res, $Val extends ReportsSummary>
    implements $ReportsSummaryCopyWith<$Res> {
  _$ReportsSummaryCopyWithImpl(this._value, this._then);

  // ignore: unused_field
  final $Val _value;
  // ignore: unused_field
  final $Res Function($Val) _then;

  /// Create a copy of ReportsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? totalOrders = null,
    Object? totalProducts = null,
    Object? cancelledRatio = null,
  }) {
    return _then(
      _value.copyWith(
            totalRevenue: null == totalRevenue
                ? _value.totalRevenue
                : totalRevenue // ignore: cast_nullable_to_non_nullable
                      as double,
            totalOrders: null == totalOrders
                ? _value.totalOrders
                : totalOrders // ignore: cast_nullable_to_non_nullable
                      as int,
            totalProducts: null == totalProducts
                ? _value.totalProducts
                : totalProducts // ignore: cast_nullable_to_non_nullable
                      as int,
            cancelledRatio: null == cancelledRatio
                ? _value.cancelledRatio
                : cancelledRatio // ignore: cast_nullable_to_non_nullable
                      as double,
          )
          as $Val,
    );
  }
}

/// @nodoc
abstract class _$$ReportsSummaryImplCopyWith<$Res>
    implements $ReportsSummaryCopyWith<$Res> {
  factory _$$ReportsSummaryImplCopyWith(
    _$ReportsSummaryImpl value,
    $Res Function(_$ReportsSummaryImpl) then,
  ) = __$$ReportsSummaryImplCopyWithImpl<$Res>;
  @override
  @useResult
  $Res call({
    double totalRevenue,
    int totalOrders,
    int totalProducts,
    double cancelledRatio,
  });
}

/// @nodoc
class __$$ReportsSummaryImplCopyWithImpl<$Res>
    extends _$ReportsSummaryCopyWithImpl<$Res, _$ReportsSummaryImpl>
    implements _$$ReportsSummaryImplCopyWith<$Res> {
  __$$ReportsSummaryImplCopyWithImpl(
    _$ReportsSummaryImpl _value,
    $Res Function(_$ReportsSummaryImpl) _then,
  ) : super(_value, _then);

  /// Create a copy of ReportsSummary
  /// with the given fields replaced by the non-null parameter values.
  @pragma('vm:prefer-inline')
  @override
  $Res call({
    Object? totalRevenue = null,
    Object? totalOrders = null,
    Object? totalProducts = null,
    Object? cancelledRatio = null,
  }) {
    return _then(
      _$ReportsSummaryImpl(
        totalRevenue: null == totalRevenue
            ? _value.totalRevenue
            : totalRevenue // ignore: cast_nullable_to_non_nullable
                  as double,
        totalOrders: null == totalOrders
            ? _value.totalOrders
            : totalOrders // ignore: cast_nullable_to_non_nullable
                  as int,
        totalProducts: null == totalProducts
            ? _value.totalProducts
            : totalProducts // ignore: cast_nullable_to_non_nullable
                  as int,
        cancelledRatio: null == cancelledRatio
            ? _value.cancelledRatio
            : cancelledRatio // ignore: cast_nullable_to_non_nullable
                  as double,
      ),
    );
  }
}

/// @nodoc
@JsonSerializable()
class _$ReportsSummaryImpl implements _ReportsSummary {
  const _$ReportsSummaryImpl({
    required this.totalRevenue,
    required this.totalOrders,
    required this.totalProducts,
    required this.cancelledRatio,
  });

  factory _$ReportsSummaryImpl.fromJson(Map<String, dynamic> json) =>
      _$$ReportsSummaryImplFromJson(json);

  @override
  final double totalRevenue;
  @override
  final int totalOrders;
  @override
  final int totalProducts;
  @override
  final double cancelledRatio;

  @override
  String toString() {
    return 'ReportsSummary(totalRevenue: $totalRevenue, totalOrders: $totalOrders, totalProducts: $totalProducts, cancelledRatio: $cancelledRatio)';
  }

  @override
  bool operator ==(Object other) {
    return identical(this, other) ||
        (other.runtimeType == runtimeType &&
            other is _$ReportsSummaryImpl &&
            (identical(other.totalRevenue, totalRevenue) ||
                other.totalRevenue == totalRevenue) &&
            (identical(other.totalOrders, totalOrders) ||
                other.totalOrders == totalOrders) &&
            (identical(other.totalProducts, totalProducts) ||
                other.totalProducts == totalProducts) &&
            (identical(other.cancelledRatio, cancelledRatio) ||
                other.cancelledRatio == cancelledRatio));
  }

  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  int get hashCode => Object.hash(
    runtimeType,
    totalRevenue,
    totalOrders,
    totalProducts,
    cancelledRatio,
  );

  /// Create a copy of ReportsSummary
  /// with the given fields replaced by the non-null parameter values.
  @JsonKey(includeFromJson: false, includeToJson: false)
  @override
  @pragma('vm:prefer-inline')
  _$$ReportsSummaryImplCopyWith<_$ReportsSummaryImpl> get copyWith =>
      __$$ReportsSummaryImplCopyWithImpl<_$ReportsSummaryImpl>(
        this,
        _$identity,
      );

  @override
  Map<String, dynamic> toJson() {
    return _$$ReportsSummaryImplToJson(this);
  }
}

abstract class _ReportsSummary implements ReportsSummary {
  const factory _ReportsSummary({
    required final double totalRevenue,
    required final int totalOrders,
    required final int totalProducts,
    required final double cancelledRatio,
  }) = _$ReportsSummaryImpl;

  factory _ReportsSummary.fromJson(Map<String, dynamic> json) =
      _$ReportsSummaryImpl.fromJson;

  @override
  double get totalRevenue;
  @override
  int get totalOrders;
  @override
  int get totalProducts;
  @override
  double get cancelledRatio;

  /// Create a copy of ReportsSummary
  /// with the given fields replaced by the non-null parameter values.
  @override
  @JsonKey(includeFromJson: false, includeToJson: false)
  _$$ReportsSummaryImplCopyWith<_$ReportsSummaryImpl> get copyWith =>
      throw _privateConstructorUsedError;
}

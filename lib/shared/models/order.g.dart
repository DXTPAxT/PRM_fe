// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'order.dart';

// **************************************************************************
// JsonSerializableGenerator
// **************************************************************************

_$OrderImpl _$$OrderImplFromJson(Map<String, dynamic> json) => _$OrderImpl(
  id: json['id'] as String,
  userId: json['user_id'] as String,
  addressId: json['address_id'] as String,
  voucherId: json['voucher_id'] as String?,
  total: (json['total'] as num).toDouble(),
  status: json['status'] as String,
  items:
      (json['items'] as List<dynamic>?)
          ?.map((e) => OrderItem.fromJson(e as Map<String, dynamic>))
          .toList() ??
      const [],
);

Map<String, dynamic> _$$OrderImplToJson(_$OrderImpl instance) =>
    <String, dynamic>{
      'id': instance.id,
      'user_id': instance.userId,
      'address_id': instance.addressId,
      'voucher_id': instance.voucherId,
      'total': instance.total,
      'status': instance.status,
      'items': instance.items,
    };

import 'package:freezed_annotation/freezed_annotation.dart';

part 'address.freezed.dart';
part 'address.g.dart';

@freezed
class Address with _$Address {
  const factory Address({
    required String id,
    required String userId,
    required String fullName,
    required String phone,
    required String detail,
    @JsonKey(defaultValue: false) @Default(false) bool isDefault,
    DateTime? createdAt,
  }) = _Address;

  factory Address.fromJson(Map<String, dynamic> json) =>
      _$AddressFromJson(json);
}

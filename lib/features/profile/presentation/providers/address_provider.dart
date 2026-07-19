import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/address.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class AddressState {
  final List<Address> addresses;
  final bool isLoading;
  final String? errorMessage;

  const AddressState({
    this.addresses = const [],
    this.isLoading = false,
    this.errorMessage,
  });

  AddressState copyWith({
    List<Address>? addresses,
    bool? isLoading,
    String? errorMessage,
    bool clearError = false,
  }) {
    return AddressState(
      addresses: addresses ?? this.addresses,
      isLoading: isLoading ?? this.isLoading,
      errorMessage: clearError ? null : errorMessage ?? this.errorMessage,
    );
  }
}

class AddressNotifier extends StateNotifier<AddressState> {
  final Ref _ref;

  AddressNotifier(this._ref) : super(const AddressState()) {
    load();
  }

  Future<void> load() async {
    state = state.copyWith(isLoading: true, clearError: true);
    try {
      final addresses = await _ref.read(authRepositoryProvider).getAddresses();
      state = AddressState(addresses: addresses);
    } catch (error) {
      state = state.copyWith(isLoading: false, errorMessage: error.toString());
    }
  }

  Future<void> create({
    required String fullName,
    required String phone,
    required String detail,
    required bool isDefault,
  }) async {
    try {
      await _ref
          .read(authRepositoryProvider)
          .createAddress(
            fullName: fullName,
            phone: phone,
            detail: detail,
            isDefault: isDefault,
          );
      await load();
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
      rethrow;
    }
  }

  Future<void> updateAddress({
    required String id,
    required String fullName,
    required String phone,
    required String detail,
  }) async {
    try {
      await _ref
          .read(authRepositoryProvider)
          .updateAddress(
            id: id,
            fullName: fullName,
            phone: phone,
            detail: detail,
          );
      await load();
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
      rethrow;
    }
  }

  Future<void> deleteAddress(String id) async {
    try {
      await _ref.read(authRepositoryProvider).deleteAddress(id: id);
      await load();
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
      rethrow;
    }
  }

  Future<void> setDefaultAddress(String id) async {
    try {
      await _ref.read(authRepositoryProvider).setDefaultAddress(id: id);
      await load();
    } catch (error) {
      state = state.copyWith(errorMessage: error.toString());
      rethrow;
    }
  }
}

final addressProvider =
    StateNotifierProvider.autoDispose<AddressNotifier, AddressState>((ref) {
      return AddressNotifier(ref);
    });

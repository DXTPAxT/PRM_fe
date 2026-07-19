import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/address.dart';
import '../providers/address_provider.dart';

class AddressBookScreen extends ConsumerWidget {
  const AddressBookScreen({super.key});

  Future<void> _openForm(
    BuildContext context,
    WidgetRef ref, {
    Address? address,
  }) async {
    final result = await showDialog<AddressFormData>(
      context: context,
      builder: (_) => AddressFormDialog(address: address),
    );
    if (result == null || !context.mounted) return;

    try {
      if (address == null) {
        await ref
            .read(addressProvider.notifier)
            .create(
              fullName: result.fullName,
              phone: result.phone,
              detail: result.detail,
              isDefault: result.isDefault,
            );
      } else {
        await ref
            .read(addressProvider.notifier)
            .updateAddress(
              id: address.id,
              fullName: result.fullName,
              phone: result.phone,
              detail: result.detail,
            );
      }
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              address == null
                  ? 'Thêm địa chỉ thành công.'
                  : 'Cập nhật địa chỉ thành công.',
            ),
          ),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _delete(
    BuildContext context,
    WidgetRef ref,
    Address address,
  ) async {
    final confirmed = await showDialog<bool>(
      context: context,
      builder: (dialogContext) => AlertDialog(
        title: const Text('Xóa địa chỉ?'),
        content: Text('Bạn có chắc muốn xóa địa chỉ của ${address.fullName}?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(dialogContext, false),
            child: const Text('Hủy'),
          ),
          FilledButton(
            onPressed: () => Navigator.pop(dialogContext, true),
            child: const Text('Xóa'),
          ),
        ],
      ),
    );
    if (confirmed != true || !context.mounted) return;

    try {
      await ref.read(addressProvider.notifier).deleteAddress(address.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Xóa địa chỉ thành công.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  Future<void> _setDefault(
    BuildContext context,
    WidgetRef ref,
    Address address,
  ) async {
    try {
      await ref.read(addressProvider.notifier).setDefaultAddress(address.id);
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(content: Text('Đã đặt địa chỉ mặc định.')),
        );
      }
    } catch (error) {
      if (context.mounted) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(error.toString()),
            backgroundColor: Colors.red,
          ),
        );
      }
    }
  }

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(addressProvider);
    return Scaffold(
      appBar: AppBar(
        title: const Text('Sổ địa chỉ'),
        actions: [
          IconButton(
            onPressed: state.isLoading
                ? null
                : () => ref.read(addressProvider.notifier).load(),
            icon: const Icon(Icons.refresh),
          ),
        ],
      ),
      floatingActionButton: FloatingActionButton.extended(
        onPressed: state.isLoading
            ? null
            : () => _openForm(context, ref, address: null),
        icon: const Icon(Icons.add),
        label: const Text('Thêm địa chỉ'),
      ),
      body: state.isLoading && state.addresses.isEmpty
          ? const Center(child: CircularProgressIndicator())
          : state.addresses.isEmpty
          ? const Center(child: Text('Bạn chưa có địa chỉ giao hàng nào.'))
          : ListView.separated(
              padding: const EdgeInsets.fromLTRB(16, 16, 16, 96),
              itemCount: state.addresses.length,
              separatorBuilder: (_, __) => const SizedBox(height: 12),
              itemBuilder: (context, index) {
                final address = state.addresses[index];
                return Card(
                  child: Padding(
                    padding: const EdgeInsets.all(12),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.stretch,
                      children: [
                        Row(
                          children: [
                            Expanded(
                              child: Text(
                                address.fullName,
                                style: const TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                ),
                              ),
                            ),
                            if (address.isDefault)
                              const Chip(
                                avatar: Icon(Icons.check, size: 16),
                                label: Text('Mặc định'),
                              ),
                          ],
                        ),
                        const SizedBox(height: 6),
                        Text(address.phone),
                        const SizedBox(height: 4),
                        Text(address.detail),
                        const Divider(height: 20),
                        Wrap(
                          spacing: 8,
                          children: [
                            if (!address.isDefault)
                              TextButton.icon(
                                onPressed: () =>
                                    _setDefault(context, ref, address),
                                icon: const Icon(Icons.star_border),
                                label: const Text('Đặt mặc định'),
                              ),
                            TextButton.icon(
                              onPressed: () =>
                                  _openForm(context, ref, address: address),
                              icon: const Icon(Icons.edit_outlined),
                              label: const Text('Sửa'),
                            ),
                            TextButton.icon(
                              onPressed: () => _delete(context, ref, address),
                              style: TextButton.styleFrom(
                                foregroundColor: Colors.red,
                              ),
                              icon: const Icon(Icons.delete_outline),
                              label: const Text('Xóa'),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
    );
  }
}

class AddressFormData {
  final String fullName;
  final String phone;
  final String detail;
  final bool isDefault;

  const AddressFormData({
    required this.fullName,
    required this.phone,
    required this.detail,
    required this.isDefault,
  });
}

class AddressFormDialog extends StatefulWidget {
  final Address? address;

  const AddressFormDialog({super.key, this.address});

  @override
  State<AddressFormDialog> createState() => _AddressFormDialogState();
}

class _AddressFormDialogState extends State<AddressFormDialog> {
  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _fullNameController;
  late final TextEditingController _phoneController;
  late final TextEditingController _detailController;
  late bool _isDefault;

  @override
  void initState() {
    super.initState();
    final address = widget.address;
    _fullNameController = TextEditingController(text: address?.fullName ?? '');
    _phoneController = TextEditingController(text: address?.phone ?? '');
    _detailController = TextEditingController(text: address?.detail ?? '');
    _isDefault = address?.isDefault ?? false;
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _phoneController.dispose();
    _detailController.dispose();
    super.dispose();
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    Navigator.pop(
      context,
      AddressFormData(
        fullName: _fullNameController.text.trim(),
        phone: _phoneController.text.trim(),
        detail: _detailController.text.trim(),
        isDefault: _isDefault,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(widget.address == null ? 'Thêm địa chỉ' : 'Sửa địa chỉ'),
      content: Form(
        key: _formKey,
        child: SingleChildScrollView(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Họ tên người nhận',
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  return text.length >= 2 && text.length <= 100
                      ? null
                      : 'Họ tên phải từ 2 đến 100 ký tự';
                },
              ),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(labelText: 'Số điện thoại'),
                validator: (value) =>
                    RegExp(r'^0[35789]\d{8}$').hasMatch(value?.trim() ?? '')
                    ? null
                    : 'Số điện thoại không hợp lệ',
              ),
              TextFormField(
                controller: _detailController,
                maxLines: 3,
                decoration: const InputDecoration(
                  labelText: 'Địa chỉ chi tiết',
                ),
                validator: (value) {
                  final text = value?.trim() ?? '';
                  return text.length >= 5 && text.length <= 255
                      ? null
                      : 'Địa chỉ phải từ 5 đến 255 ký tự';
                },
              ),
              if (widget.address == null)
                CheckboxListTile(
                  contentPadding: EdgeInsets.zero,
                  value: _isDefault,
                  onChanged: (value) =>
                      setState(() => _isDefault = value ?? false),
                  title: const Text('Đặt làm địa chỉ mặc định'),
                  controlAffinity: ListTileControlAffinity.leading,
                ),
            ],
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Hủy'),
        ),
        FilledButton(onPressed: _submit, child: const Text('Lưu')),
      ],
    );
  }
}

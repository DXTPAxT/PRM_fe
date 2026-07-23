import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';
import '../../../../shared/models/user.dart';

class ProfileScreen extends ConsumerStatefulWidget {
  const ProfileScreen({super.key});

  @override
  ConsumerState<ProfileScreen> createState() => _ProfileScreenState();
}

class _ProfileScreenState extends ConsumerState<ProfileScreen> {
  final _profileFormKey = GlobalKey<FormState>();
  final _passwordFormKey = GlobalKey<FormState>();
  final _fullNameController = TextEditingController();
  final _emailController = TextEditingController();
  final _phoneController = TextEditingController();
  final _currentPasswordController = TextEditingController();
  final _newPasswordController = TextEditingController();
  final _confirmPasswordController = TextEditingController();

  bool _loadingProfile = false;
  bool _savingProfile = false;
  bool _changingPassword = false;

  @override
  void initState() {
    super.initState();
    _fillForm(ref.read(authProvider).user);
    Future<void>.microtask(_loadProfile);
  }

  @override
  void dispose() {
    _fullNameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _currentPasswordController.dispose();
    _newPasswordController.dispose();
    _confirmPasswordController.dispose();
    super.dispose();
  }

  void _fillForm(User? user) {
    if (user == null) return;
    _fullNameController.text = user.fullName;
    _emailController.text = user.email ?? '';
    _phoneController.text = user.phone ?? '';
  }

  Future<void> _loadProfile() async {
    if (!mounted) return;
    setState(() => _loadingProfile = true);
    try {
      final user = await ref.read(authProvider.notifier).refreshCurrentUser();
      if (mounted) _fillForm(user);
    } catch (error) {
      if (mounted) _showMessage(error.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _loadingProfile = false);
    }
  }

  Future<void> _saveProfile() async {
    if (!_profileFormKey.currentState!.validate()) return;
    setState(() => _savingProfile = true);
    try {
      final user = await ref
          .read(authProvider.notifier)
          .updateProfile(
            fullName: _fullNameController.text.trim(),
            email: _emailController.text.trim().isEmpty
                ? null
                : _emailController.text.trim(),
            phone: _phoneController.text.trim().isEmpty
                ? null
                : _phoneController.text.trim(),
          );
      _fillForm(user);
      if (mounted) _showMessage('Cập nhật hồ sơ thành công.');
    } catch (error) {
      if (mounted) _showMessage(error.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _savingProfile = false);
    }
  }

  Future<void> _changePassword() async {
    if (!_passwordFormKey.currentState!.validate()) return;
    setState(() => _changingPassword = true);
    try {
      await ref
          .read(authProvider.notifier)
          .changePassword(
            currentPassword: _currentPasswordController.text,
            newPassword: _newPasswordController.text,
          );
      if (mounted) {
        _showMessage('Đổi mật khẩu thành công. Vui lòng đăng nhập lại.');
        context.go('/login');
      }
    } catch (error) {
      if (mounted) _showMessage(error.toString(), isError: true);
    } finally {
      if (mounted) setState(() => _changingPassword = false);
    }
  }

  void _showMessage(String message, {bool isError = false}) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(message),
        backgroundColor: isError ? Colors.red : Colors.green,
      ),
    );
  }

  String? _validateEmail(String? value) {
    final email = value?.trim() ?? '';
    if (email.isEmpty) return null;
    return RegExp(r'^[\w.+-]+@([\w-]+\.)+[\w-]{2,}$').hasMatch(email)
        ? null
        : 'Email không hợp lệ';
  }

  String? _validatePhone(String? value) {
    final phone = value?.trim() ?? '';
    if (phone.isEmpty) return null;
    return RegExp(r'^0[35789]\d{8}$').hasMatch(phone)
        ? null
        : 'Số điện thoại không hợp lệ';
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isAdmin = user?.role == 'admin';
    final initial = user != null && user.fullName.isNotEmpty
        ? user.fullName.substring(0, 1).toUpperCase()
        : 'U';

    return Scaffold(
      appBar: AppBar(
        title: const Text('Hồ sơ cá nhân'),
        actions: [
          IconButton(
            onPressed: _loadingProfile ? null : _loadProfile,
            icon: const Icon(Icons.refresh),
            tooltip: 'Tải lại hồ sơ',
          ),
        ],
      ),
      body: user == null
          ? const Center(child: Text('Không tìm thấy thông tin tài khoản.'))
          : SingleChildScrollView(
              padding: const EdgeInsets.all(16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  Card(
                    child: ListTile(
                      leading: CircleAvatar(child: Text(initial)),
                      title: Text(user.fullName),
                      subtitle: Text(user.email ?? user.phone ?? ''),
                      trailing: Chip(label: Text(user.role.toUpperCase())),
                    ),
                  ),
                  const SizedBox(height: 16),
                  _buildProfileForm(),
                  const SizedBox(height: 16),
                  _buildPasswordForm(),
                  if (isAdmin) ...[
                    const SizedBox(height: 16),
                    Card(
                      color: Theme.of(context).colorScheme.primaryContainer,
                      child: ListTile(
                        leading: const Icon(Icons.admin_panel_settings),
                        title: const Text('Trang Quản Trị'),
                        trailing: const Icon(Icons.chevron_right),
                        onTap: () => context.push('/admin'),
                      ),
                    ),
                  ],
                  const SizedBox(height: 16),
                  Card(
                    child: Column(
                      children: [
                        ListTile(
                          leading: const Icon(Icons.favorite_outline),
                          title: const Text('Sản phẩm yêu thích'),
                          subtitle: const Text('Danh sách sản phẩm đã lưu'),
                          onTap: () => context.push('/wishlist'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.notifications_outlined),
                          title: const Text('Thông báo'),
                          subtitle: const Text('Xem lịch sử thông báo'),
                          onTap: () => context.push('/notifications'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.location_on_outlined),
                          title: const Text('Sổ địa chỉ'),
                          subtitle: const Text('Quản lý địa chỉ giao hàng'),
                          onTap: () => context.push('/addresses'),
                        ),
                        const Divider(height: 1),
                        ListTile(
                          leading: const Icon(Icons.logout, color: Colors.red),
                          title: const Text(
                            'Đăng xuất',
                            style: TextStyle(color: Colors.red),
                          ),
                          onTap: () => ref.read(authProvider.notifier).logout(),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
            ),
    );
  }

  Widget _buildProfileForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _profileFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Thông tin cá nhân',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _fullNameController,
                decoration: const InputDecoration(
                  labelText: 'Họ và tên',
                  prefixIcon: Icon(Icons.person_outline),
                ),
                validator: (value) {
                  final name = value?.trim() ?? '';
                  if (name.length < 2 || name.length > 100) {
                    return 'Họ tên phải từ 2 đến 100 ký tự';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: _validateEmail,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _phoneController,
                keyboardType: TextInputType.phone,
                decoration: const InputDecoration(
                  labelText: 'Số điện thoại',
                  prefixIcon: Icon(Icons.phone_outlined),
                ),
                validator: _validatePhone,
              ),
              const SizedBox(height: 16),
              FilledButton(
                onPressed: _savingProfile ? null : _saveProfile,
                child: _savingProfile
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Lưu thay đổi'),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildPasswordForm() {
    return Card(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _passwordFormKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Đổi mật khẩu',
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _currentPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu hiện tại',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: (value) => value == null || value.isEmpty
                    ? 'Vui lòng nhập mật khẩu hiện tại'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _newPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu mới',
                  prefixIcon: Icon(Icons.lock_reset_outlined),
                ),
                validator: (value) => value == null || value.length < 8
                    ? 'Mật khẩu mới phải từ 8 ký tự'
                    : null,
              ),
              const SizedBox(height: 12),
              TextFormField(
                controller: _confirmPasswordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Xác nhận mật khẩu mới',
                  prefixIcon: Icon(Icons.lock_person_outlined),
                ),
                validator: (value) => value != _newPasswordController.text
                    ? 'Mật khẩu xác nhận không khớp'
                    : null,
              ),
              const SizedBox(height: 16),
              OutlinedButton(
                onPressed: _changingPassword ? null : _changePassword,
                child: _changingPassword
                    ? const SizedBox(
                        height: 20,
                        width: 20,
                        child: CircularProgressIndicator(strokeWidth: 2),
                      )
                    : const Text('Đổi mật khẩu và đăng xuất các phiên cũ'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

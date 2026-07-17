import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../auth/presentation/providers/auth_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final authState = ref.watch(authProvider);
    final user = authState.user;
    final isAdmin = user?.role == 'admin';

    return Scaffold(
      appBar: AppBar(title: const Text('Tài khoản')),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            Card(
              child: ListTile(
                leading: CircleAvatar(
                  child: Text(user?.fullName.substring(0, 1).toUpperCase() ?? 'U'),
                ),
                title: Text(user?.fullName ?? 'Người dùng'),
                subtitle: Text(user?.email ?? ''),
                trailing: Chip(
                  label: Text(user?.role.toUpperCase() ?? 'CUSTOMER'),
                ),
              ),
            ),
            const SizedBox(height: 16),
            if (isAdmin)
              Card(
                color: Theme.of(context).colorScheme.primaryContainer,
                child: ListTile(
                  leading: const Icon(Icons.admin_panel_settings, color: Colors.indigo),
                  title: const Text('Trang Quản Trị (Admin Panel)'),
                  subtitle: const Text('Quản lý sản phẩm, đơn hàng & voucher'),
                  trailing: const Icon(Icons.chevron_right),
                  onTap: () {
                    context.push('/admin');
                  },
                ),
              ),
            const SizedBox(height: 16),
            Card(
              child: Column(
                children: [
                  const ListTile(
                    leading: Icon(Icons.location_on_outlined),
                    title: Text('Sổ địa chỉ'),
                    subtitle: Text('Tính năng đang được phát triển bởi Member 1'),
                  ),
                  const Divider(height: 1),
                  const ListTile(
                    leading: Icon(Icons.favorite_border),
                    title: Text('Wishlist yêu thích'),
                    subtitle: Text('Tính năng đang được phát triển bởi Member 1'),
                  ),
                  const Divider(height: 1),
                  ListTile(
                    leading: const Icon(Icons.logout, color: Colors.red),
                    title: const Text('Đăng xuất', style: TextStyle(color: Colors.red)),
                    onTap: () {
                      ref.read(authProvider.notifier).logout();
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

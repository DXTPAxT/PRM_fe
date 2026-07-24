import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../../shared/models/admin/admin_user.dart';
import '../providers/admin_provider.dart';

class AdminUsersTab extends ConsumerWidget {
  const AdminUsersTab({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final usersState = ref.watch(adminUsersProvider);
    return _buildBody(context, ref, usersState);
  }

  Widget _buildBody(BuildContext context, WidgetRef ref, AdminUsersState state) {
    if (state.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (state.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Icon(Icons.error_outline, size: 64, color: Colors.red),
            const SizedBox(height: 16),
            Text('Lỗi: ${state.error}'),
            const SizedBox(height: 16),
            ElevatedButton(
              onPressed: () => ref.read(adminUsersProvider.notifier).loadUsers(),
              child: const Text('Thử lại'),
            ),
          ],
        ),
      );
    }

    final users = state.users;
    if (users.isEmpty) {
      return const Center(child: Text('Không có người dùng nào'));
    }

    return RefreshIndicator(
      onRefresh: () => ref.read(adminUsersProvider.notifier).loadUsers(),
      child: ListView.builder(
        padding: const EdgeInsets.all(16),
        itemCount: users.length,
        itemBuilder: (context, index) {
          final user = users[index];
          return Card(
            margin: const EdgeInsets.only(bottom: 12),
            child: ListTile(
              leading: CircleAvatar(
                backgroundColor: user.isActive ? Colors.green : Colors.grey,
                child: Text(
                  user.fullName.isNotEmpty ? user.fullName[0].toUpperCase() : '?',
                  style: const TextStyle(color: Colors.white),
                ),
              ),
              title: Text(user.fullName),
              subtitle: Text(user.email ?? user.phone ?? 'N/A'),
              trailing: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  // Role chip
                  Chip(
                    label: Text(
                      user.role,
                      style: TextStyle(
                        fontSize: 11,
                        color: user.role == 'ADMIN' ? Colors.white : null,
                      ),
                    ),
                    backgroundColor: user.role == 'ADMIN'
                        ? Colors.deepPurple
                        : Colors.grey.shade200,
                  ),
                  const SizedBox(width: 4),
                  // Toggle active
                  IconButton(
                    icon: Icon(
                      user.isActive ? Icons.toggle_on : Icons.toggle_off,
                      color: user.isActive ? Colors.green : Colors.grey,
                      size: 32,
                    ),
                    tooltip: user.isActive ? 'Vô hiệu hóa' : 'Kích hoạt',
                    onPressed: () => _confirmToggleActive(context, ref, user),
                  ),
                  // Change role
                  PopupMenuButton<String>(
                    icon: const Icon(Icons.more_vert),
                    onSelected: (role) {
                      ref.read(adminUsersProvider.notifier).updateUserRole(user.id, role);
                    },
                    itemBuilder: (_) => [
                      const PopupMenuItem(value: 'CUSTOMER', child: Text('Customer')),
                      const PopupMenuItem(value: 'ADMIN', child: Text('Admin')),
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

  void _confirmToggleActive(BuildContext context, WidgetRef ref, AdminUser user) {
    final action = user.isActive ? 'vô hiệu hóa' : 'kích hoạt';
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text('Xác nhận $action'),
        content: Text('Bạn có chắc chắn muốn $action tài khoản "${user.fullName}"?'),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(ctx),
            child: const Text('Hủy'),
          ),
          ElevatedButton(
            onPressed: () {
              ref.read(adminUsersProvider.notifier).toggleUserActive(user.id);
              Navigator.pop(ctx);
            },
            child: Text(action.substring(0, 1).toUpperCase() + action.substring(1)),
          ),
        ],
      ),
    );
  }
}
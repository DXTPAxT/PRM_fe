import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../../../core/utils/password_validator.dart';
import '../providers/auth_provider.dart';

class ResetPasswordScreen extends ConsumerStatefulWidget {
  const ResetPasswordScreen({super.key});

  @override
  ConsumerState<ResetPasswordScreen> createState() =>
      _ResetPasswordScreenState();
}

class _ResetPasswordScreenState extends ConsumerState<ResetPasswordScreen> {
  final _formKey = GlobalKey<FormState>();
  final _emailController = TextEditingController();
  final _otpController = TextEditingController();
  final _passwordController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _emailController.text = ref.read(authProvider).pendingIdentifier ?? '';
  }

  @override
  void dispose() {
    _emailController.dispose();
    _otpController.dispose();
    _passwordController.dispose();
    super.dispose();
  }

  Future<void> _submit() async {
    if (!_formKey.currentState!.validate()) return;

    FocusScope.of(context).unfocus();
    final result = await ref
        .read(authProvider.notifier)
        .resetPassword(
          _emailController.text.trim(),
          _otpController.text.trim(),
          _passwordController.text,
        );
    if (!mounted) return;

    ScaffoldMessenger.of(context)
      ..hideCurrentSnackBar()
      ..showSnackBar(
        SnackBar(
          content: Text(result.message),
          backgroundColor: result.isSuccess ? Colors.green : Colors.red,
        ),
      );

    if (result.isSuccess) {
      context.go('/login');
    }
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);

    return Scaffold(
      appBar: AppBar(title: const Text('Đặt lại mật khẩu')),
      body: Padding(
        padding: const EdgeInsets.all(24.0),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Đặt mật khẩu mới',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text(
                'Xác nhận lại email, mã OTP và nhập mật khẩu mới.',
                style: TextStyle(color: Colors.grey, fontSize: 13),
              ),
              const SizedBox(height: 24),
              TextFormField(
                controller: _emailController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email',
                  hintText: 'Xác nhận lại email',
                  prefixIcon: Icon(Icons.email_outlined),
                ),
                validator: (value) {
                  if (value == null || value.trim().isEmpty) {
                    return 'Vui lòng nhập email';
                  }
                  return null;
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                decoration: const InputDecoration(
                  labelText: 'Mã OTP',
                  hintText: 'Nhập mã OTP',
                  prefixIcon: Icon(Icons.pin_outlined),
                ),
                validator: (value) {
                  return value != null &&
                          RegExp(r'^\d{6}$').hasMatch(value.trim())
                      ? null
                      : 'OTP phải gồm đúng 6 chữ số';
                },
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _passwordController,
                obscureText: true,
                decoration: const InputDecoration(
                  labelText: 'Mật khẩu mới',
                  hintText: 'Nhập mật khẩu mới',
                  prefixIcon: Icon(Icons.lock_outline),
                ),
                validator: validateStrongPassword,
              ),
              const SizedBox(height: 32),
              if (authState.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Cập nhật mật khẩu'),
                ),
            ],
          ),
        ),
      ),
    );
  }
}

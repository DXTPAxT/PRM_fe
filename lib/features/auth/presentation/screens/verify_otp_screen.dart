import 'dart:async';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:go_router/go_router.dart';
import '../../data/models/otp_models.dart';
import '../providers/auth_provider.dart';

class VerifyOtpScreen extends ConsumerStatefulWidget {
  const VerifyOtpScreen({super.key});

  @override
  ConsumerState<VerifyOtpScreen> createState() => _VerifyOtpScreenState();
}

class _VerifyOtpScreenState extends ConsumerState<VerifyOtpScreen> {
  final _formKey = GlobalKey<FormState>();
  final _identifierController = TextEditingController();
  final _otpController = TextEditingController();
  Timer? _timer;
  int _resendSeconds = 0;

  @override
  void initState() {
    super.initState();
    final authState = ref.read(authProvider);
    _identifierController.text = authState.pendingIdentifier ?? '';
    final challenge = authState.otpChallenge;
    if (challenge != null) {
      _setChallenge(challenge);
      if (challenge.debugOtp != null) _otpController.text = challenge.debugOtp!;
    }
  }

  @override
  void dispose() {
    _timer?.cancel();
    _identifierController.dispose();
    _otpController.dispose();
    super.dispose();
  }

  void _setChallenge(RegisterChallenge challenge) {
    final seconds = challenge.resendAvailableAt
        .difference(DateTime.now())
        .inSeconds;
    _timer?.cancel();
    if (seconds <= 0) {
      if (mounted) {
        setState(() => _resendSeconds = 0);
      } else {
        _resendSeconds = 0;
      }
      return;
    }
    if (mounted) {
      setState(() => _resendSeconds = seconds);
    } else {
      _resendSeconds = seconds;
    }
    _timer = Timer.periodic(const Duration(seconds: 1), (_) {
      if (!mounted) return;
      setState(() {
        if (_resendSeconds > 0) _resendSeconds--;
      });
      if (_resendSeconds == 0) _timer?.cancel();
    });
  }

  void _submit() {
    if (!_formKey.currentState!.validate()) return;
    ref
        .read(authProvider.notifier)
        .verifyOtp(
          _identifierController.text.trim(),
          _otpController.text.trim(),
        );
  }

  void _resend() {
    ref
        .read(authProvider.notifier)
        .resendOtp(_identifierController.text.trim());
  }

  @override
  Widget build(BuildContext context) {
    final authState = ref.watch(authProvider);
    ref.listen<AuthState>(authProvider, (previous, next) {
      if (!mounted) return;
      final challenge = next.otpChallenge;
      if (challenge != null && challenge != previous?.otpChallenge) {
        _identifierController.text = challenge.identifier;
        _setChallenge(challenge);
        if (challenge.debugOtp != null) {
          _otpController.text = challenge.debugOtp!;
        }
      }
      if (next.status == AuthStatus.authenticated) {
        ScaffoldMessenger.of(context).showSnackBar(
          const SnackBar(
            content: Text('Xác thực thành công. Bạn đã được đăng nhập.'),
          ),
        );
        context.go('/');
      } else if (next.errorMessage != null &&
          next.errorMessage!.isNotEmpty &&
          next.errorMessage != previous?.errorMessage &&
          !next.isLoading) {
        final resendSucceeded = next.errorMessage!.startsWith('OTP mới');
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(next.errorMessage!),
            backgroundColor: resendSucceeded ? Colors.green : Colors.red,
          ),
        );
      }
    });

    final challenge = authState.otpChallenge;
    return Scaffold(
      appBar: AppBar(title: const Text('Xác thực OTP')),
      body: Padding(
        padding: const EdgeInsets.all(24),
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              const Text(
                'Nhập mã OTP 6 chữ số',
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              const Text('Mã OTP có hiệu lực trong 10 phút.'),
              const SizedBox(height: 24),
              TextFormField(
                controller: _identifierController,
                keyboardType: TextInputType.emailAddress,
                decoration: const InputDecoration(
                  labelText: 'Email hoặc số điện thoại',
                  prefixIcon: Icon(Icons.alternate_email),
                ),
                validator: (value) => value == null || value.trim().isEmpty
                    ? 'Vui lòng nhập email hoặc số điện thoại'
                    : null,
              ),
              const SizedBox(height: 16),
              TextFormField(
                controller: _otpController,
                keyboardType: TextInputType.number,
                maxLength: 6,
                decoration: const InputDecoration(
                  labelText: 'Mã OTP',
                  prefixIcon: Icon(Icons.pin_outlined),
                  counterText: '',
                ),
                validator: (value) =>
                    value == null || !RegExp(r'^\d{6}$').hasMatch(value.trim())
                    ? 'OTP phải gồm đúng 6 chữ số'
                    : null,
              ),
              if (challenge?.debugOtp != null) ...[
                const SizedBox(height: 12),
                Text(
                  'OTP môi trường phát triển: ${challenge!.debugOtp}',
                  style: const TextStyle(color: Colors.orange),
                ),
              ],
              const SizedBox(height: 24),
              if (authState.isLoading)
                const Center(child: CircularProgressIndicator())
              else
                ElevatedButton(
                  onPressed: _submit,
                  child: const Text('Xác nhận và đăng nhập'),
                ),
              const SizedBox(height: 12),
              TextButton(
                onPressed:
                    (_resendSeconds > 0 ||
                        authState.isLoading ||
                        (challenge?.remainingResends ?? 0) <= 0)
                    ? null
                    : _resend,
                child: Text(
                  _resendSeconds > 0
                      ? 'Gửi lại OTP sau ${_resendSeconds}s'
                      : 'Gửi lại OTP (${challenge?.remainingResends ?? 0} lần còn lại)',
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

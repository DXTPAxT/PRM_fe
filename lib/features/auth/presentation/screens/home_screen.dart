import 'package:flutter/material.dart';

class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text('Trang chủ')),
      body: const Center(
        child: Text('Ứng dụng Bán Quần Áo - Flutter Scaffold'),
      ),
    );
  }
}

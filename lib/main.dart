import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'core/storage/hive_cache.dart';
import 'core/theme/app_theme.dart';
import 'core/router/app_router.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();

  // 1. Initialize local caching boxes (Hive)
  await HiveCache.init();

  // 2. Setup Firebase Notifications scaffolding
  try {
    // In a live environment, uncomment after connecting to Firebase:
    // await Firebase.initializeApp();
    // await NotificationService().initialize();
    print('Firebase Messaging setup scaffolding loaded.');
  } catch (e) {
    print('Firebase init bypassed: $e');
  }

  runApp(
    const ProviderScope(
      child: ClothingApp(),
    ),
  );
}

class ClothingApp extends ConsumerWidget {
  const ClothingApp({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final router = ref.watch(routerProvider);

    return MaterialApp.router(
      title: 'Clothing Store App',
      debugShowCheckedModeBanner: false,
      theme: AppTheme.lightTheme,
      darkTheme: AppTheme.darkTheme,
      themeMode: ThemeMode.system, 
      routerConfig: router,
    );
  }
}

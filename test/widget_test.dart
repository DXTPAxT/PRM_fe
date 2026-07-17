import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:clothing_store_app/main.dart';

void main() {
  testWidgets('Smoke test - App boots to Splash Screen', (WidgetTester tester) async {
    // Build our app inside ProviderScope
    await tester.pumpWidget(
      const ProviderScope(
        child: ClothingApp(),
      ),
    );

    // Verify that we see the Splash screen loading indicator and branding
    expect(find.byType(CircularProgressIndicator), findsOneWidget);
    expect(find.text('CLOTHING STORE'), findsOneWidget);
  });
}

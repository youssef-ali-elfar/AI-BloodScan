// This is a basic Flutter widget test.

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:provider/provider.dart';
import 'package:app_nn/main.dart';

void main() {
  testWidgets('App smoke test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      ChangeNotifierProvider<AppState>(
        create: (_) => AppState(),
        child: const AIBloodScanApp(),
      ),
    );

    // Wait for first frame
    await tester.pump();

    // Verify that the Splash Screen appears with the app title.
    expect(find.text('AI BloodScan'), findsOneWidget);
  });
}

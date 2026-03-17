// Basic Flutter widget test for Smart Umbrella app.

import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:usmart/main.dart';

void main() {
  testWidgets('SmartUmbrellaApp renders', (WidgetTester tester) async {
    // Build our app and trigger a frame
    await tester.pumpWidget(
      const ProviderScope(
        child: SmartUmbrellaApp(),
      ),
    );

    // Verify that the app renders without error
    expect(find.byType(SmartUmbrellaApp), findsOneWidget);
  });
}

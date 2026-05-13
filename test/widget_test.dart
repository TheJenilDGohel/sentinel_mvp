import 'package:flutter_test/flutter_test.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:sentinel_mvp/app.dart';

void main() {
  testWidgets('App renders test', (WidgetTester tester) async {
    // Build our app and trigger a frame.
    await tester.pumpWidget(
      const ProviderScope(
        child: SentinelApp(),
      ),
    );

    // Verify that the app is initialized.
    expect(find.byType(SentinelApp), findsOneWidget);
  });
}

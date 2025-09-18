import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:loto_ro/screens/home/glass_error_message.dart';

void main() {
  testWidgets('GlassErrorMessage displays title, details, and retry button', (
    WidgetTester tester,
  ) async {
    bool retried = false;
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: GlassErrorMessage(
            title: 'Eroare',
            details: 'Detalii eroare',
            onRetry: () => retried = true,
          ),
        ),
      ),
    );

    expect(find.text('Eroare'), findsOneWidget);
    expect(find.text('Detalii eroare'), findsOneWidget);
    expect(find.byType(IconButton), findsNothing);
    expect(find.text('Reîncearcă'), findsOneWidget);

    await tester.tap(find.text('Reîncearcă'));
    expect(retried, isTrue);
  });
}

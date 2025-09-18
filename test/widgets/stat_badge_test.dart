import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:loto_ro/screens/home/stat_badge.dart';

void main() {
  testWidgets('StatBadge displays icon, label, and value', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(
        home: Scaffold(
          body: StatBadge(icon: Icons.star, label: 'Test', value: '123'),
        ),
      ),
    );

    expect(find.byIcon(Icons.star), findsOneWidget);
    expect(find.text('Test:'), findsOneWidget);
    expect(find.text('123'), findsOneWidget);
  });
}

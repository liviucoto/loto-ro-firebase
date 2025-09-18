import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:loto_ro/screens/home/joker_badge.dart';

void main() {
  testWidgets('JokerBadge displays icon, label, and joker value', (
    WidgetTester tester,
  ) async {
    await tester.pumpWidget(
      MaterialApp(home: Scaffold(body: JokerBadge(joker: 7))),
    );

    expect(find.byIcon(Icons.stars), findsOneWidget);
    expect(find.text('Joker:'), findsOneWidget);
    expect(find.text('7'), findsOneWidget);
  });
}

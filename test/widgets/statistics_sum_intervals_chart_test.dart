import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loto_ro/widgets/statistics_sum_intervals_chart.dart';
import 'package:loto_ro/models/loto_draw.dart';

void main() {
  group('StatisticsSumIntervalsChart - Protecții și validări', () {
    testWidgets('Ar trebui să gestioneze intervalul 0 sau negativ', (WidgetTester tester) async {
      final draws = [
        LotoDraw(
          date: DateTime.now(),
          mainNumbers: [1, 2, 3, 4, 5, 6],
          gameType: '6din49',
        ),
        LotoDraw(
          date: DateTime.now(),
          mainNumbers: [7, 8, 9, 10, 11, 12],
          gameType: '6din49',
        ),
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatisticsSumIntervalsChart(
              draws: draws,
              interval: 0, // Interval invalid
            ),
          ),
        ),
      );
      
      // Ar trebui să nu crape și să afișeze un mesaj de eroare sau să folosească intervalul default
      expect(find.byType(StatisticsSumIntervalsChart), findsOneWidget);
    });

    testWidgets('Ar trebui să gestioneze intervalul prea mare', (WidgetTester tester) async {
      final draws = [
        LotoDraw(
          date: DateTime.now(),
          mainNumbers: [1, 2, 3, 4, 5, 6],
          gameType: '6din49',
        ),
        LotoDraw(
          date: DateTime.now(),
          mainNumbers: [7, 8, 9, 10, 11, 12],
          gameType: '6din49',
        ),
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatisticsSumIntervalsChart(
              draws: draws,
              interval: 10000, // Interval prea mare
            ),
          ),
        ),
      );
      
      // Ar trebui să nu crape și să ajusteze intervalul
      expect(find.byType(StatisticsSumIntervalsChart), findsOneWidget);
    });

    testWidgets('Ar trebui să gestioneze lista goală de extrageri', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatisticsSumIntervalsChart(
              draws: [], // Listă goală
              interval: 20,
            ),
          ),
        ),
      );
      
      // Ar trebui să afișeze un mesaj pentru date lipsă
      expect(find.text('Nu există date pentru graficul de intervale de sumă.'), findsOneWidget);
    });

    testWidgets('Ar trebui să gestioneze intervalul custom valid', (WidgetTester tester) async {
      final draws = [
        LotoDraw(
          date: DateTime.now(),
          mainNumbers: [1, 2, 3, 4, 5, 6],
          gameType: '6din49',
        ),
        LotoDraw(
          date: DateTime.now(),
          mainNumbers: [7, 8, 9, 10, 11, 12],
          gameType: '6din49',
        ),
      ];
      
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatisticsSumIntervalsChart(
              draws: draws,
              interval: 50, // Interval valid
            ),
          ),
        ),
      );
      
      // Ar trebui să se afișeze normal
      expect(find.byType(StatisticsSumIntervalsChart), findsOneWidget);
    });

    testWidgets('Ar trebui să gestioneze schimbarea intervalului fără crash', (WidgetTester tester) async {
      final draws = [
        LotoDraw(
          date: DateTime.now(),
          mainNumbers: [1, 2, 3, 4, 5, 6],
          gameType: '6din49',
        ),
        LotoDraw(
          date: DateTime.now(),
          mainNumbers: [7, 8, 9, 10, 11, 12],
          gameType: '6din49',
        ),
        LotoDraw(
          date: DateTime.now(),
          mainNumbers: [13, 14, 15, 16, 17, 18],
          gameType: '6din49',
        ),
      ];
      
      // Testează cu interval 20
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatisticsSumIntervalsChart(
              draws: draws,
              interval: 20,
            ),
          ),
        ),
      );
      
      expect(find.byType(StatisticsSumIntervalsChart), findsOneWidget);
      
      // Schimbă la interval 10
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatisticsSumIntervalsChart(
              draws: draws,
              interval: 10,
            ),
          ),
        ),
      );
      
      expect(find.byType(StatisticsSumIntervalsChart), findsOneWidget);
      
      // Schimbă înapoi la interval 20
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: StatisticsSumIntervalsChart(
              draws: draws,
              interval: 20,
            ),
          ),
        ),
      );
      
      expect(find.byType(StatisticsSumIntervalsChart), findsOneWidget);
    });
  });
} 

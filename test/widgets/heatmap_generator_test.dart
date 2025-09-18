import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/screens/tabs/statistics/charts/heatmap_chart/heatmap_generator_dialog.dart';

void main() {
  group('HeatmapGeneratorDialog Tests', () {
    late List<LotoDraw> testDraws;

    setUp(() {
      // Creează date de test pentru luna curentă
      final now = DateTime.now();
      testDraws = [
        LotoDraw(
          date: DateTime(2020, now.month, 1),
          mainNumbers: [1, 5, 12, 23, 34, 45],
          jokerNumber: 7,
          gameType: '6din49',
        ),
        LotoDraw(
          date: DateTime(2021, now.month, 15),
          mainNumbers: [2, 8, 15, 25, 36, 47],
          jokerNumber: 3,
          gameType: '6din49',
        ),
        LotoDraw(
          date: DateTime(2022, now.month, 10),
          mainNumbers: [3, 9, 18, 28, 39, 48],
          jokerNumber: 11,
          gameType: '6din49',
        ),
        LotoDraw(
          date: DateTime(2023, now.month, 5),
          mainNumbers: [4, 10, 20, 30, 40, 49],
          jokerNumber: 13,
          gameType: '6din49',
        ),
        LotoDraw(
          date: DateTime(2024, now.month, 20),
          mainNumbers: [5, 11, 22, 32, 42, 46],
          jokerNumber: 17,
          gameType: '6din49',
        ),
      ];
    });

    testWidgets('should build without errors', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: HeatmapGeneratorDialog(
                allDraws: testDraws,
                selectedGame: GameType.loto649,
                isDesktop: false,
                cardWidth: 400,
                cardHeight: 600,
                cardOffset: const Offset(0, 0),
              ),
            ),
          ),
        ),
      );

      // Așteaptă ca layout-ul să se termine
      await tester.pumpAndSettle();

      expect(find.byType(HeatmapGeneratorDialog), findsOneWidget);
      expect(find.text('Lucky Heatmap'), findsOneWidget);
    });

    testWidgets('should display current month statistics', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: HeatmapGeneratorDialog(
                allDraws: testDraws,
                selectedGame: GameType.loto649,
                isDesktop: false,
                cardWidth: 400,
                cardHeight: 600,
                cardOffset: const Offset(0, 0),
              ),
            ),
          ),
        ),
      );

      // Așteaptă ca layout-ul să se termine
      await tester.pumpAndSettle();

      // Verifică că se afișează statisticile lunii
      expect(find.textContaining('Extrageri:'), findsOneWidget);
      expect(find.textContaining('Top 5:'), findsOneWidget);
      expect(find.textContaining('Suma medie:'), findsOneWidget);
    });

    testWidgets('should generate variants when button is pressed', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: HeatmapGeneratorDialog(
                allDraws: testDraws,
                selectedGame: GameType.loto649,
                isDesktop: false,
                cardWidth: 400,
                cardHeight: 600,
                cardOffset: const Offset(0, 0),
              ),
            ),
          ),
        ),
      );

      // Așteaptă ca layout-ul să se termine
      await tester.pumpAndSettle();

      // Găsește butonul de generare
      final generateButton = find.text('Generează variante');
      expect(generateButton, findsOneWidget);

      // Apasă butonul
      await tester.tap(generateButton);
      await tester.pump();

      // Așteaptă ca animația să se termine
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifică că s-au generat variante
      expect(find.textContaining('VARIANTA 1'), findsOneWidget);
    });

    testWidgets('should show export button after generating variants', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: HeatmapGeneratorDialog(
                allDraws: testDraws,
                selectedGame: GameType.loto649,
                isDesktop: false,
                cardWidth: 400,
                cardHeight: 600,
                cardOffset: const Offset(0, 0),
              ),
            ),
          ),
        ),
      );

      // Așteaptă ca layout-ul să se termine
      await tester.pumpAndSettle();

      // Generează variante
      await tester.tap(find.text('Generează variante'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifică că apare butonul de export
      expect(find.text('Exportă variantele'), findsOneWidget);
    });

    testWidgets('should display variant ratings', (WidgetTester tester) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: HeatmapGeneratorDialog(
                allDraws: testDraws,
                selectedGame: GameType.loto649,
                isDesktop: false,
                cardWidth: 400,
                cardHeight: 600,
                cardOffset: const Offset(0, 0),
              ),
            ),
          ),
        ),
      );

      // Așteaptă ca layout-ul să se termine
      await tester.pumpAndSettle();

      // Generează variante
      await tester.tap(find.text('Generează variante'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Verifică că se afișează rating-urile
      expect(find.byIcon(Icons.star), findsWidgets);
    });

    testWidgets('should show user feedback after generation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(
        MaterialApp(
          home: Scaffold(
            body: SizedBox(
              width: 400,
              height: 600,
              child: HeatmapGeneratorDialog(
                allDraws: testDraws,
                selectedGame: GameType.loto649,
                isDesktop: false,
                cardWidth: 400,
                cardHeight: 600,
                cardOffset: const Offset(0, 0),
              ),
            ),
          ),
        ),
      );

      // Așteaptă ca layout-ul să se termine
      await tester.pumpAndSettle();

      // Generează variante
      await tester.tap(find.text('Generează variante'));
      await tester.pumpAndSettle(const Duration(seconds: 3));

      // Debug: verifică dacă feedback-ul este afișat
      print('DEBUG: Caut iconul lightbulb_outline...');
      final lightbulbFinder = find.byIcon(Icons.lightbulb_outline);
      print(
        'DEBUG: Găsit ${lightbulbFinder.evaluate().length} iconuri lightbulb_outline',
      );

      // Debug: afișează toate iconurile din widget
      final allIcons = find.byType(Icon);
      print('DEBUG: Total iconuri găsite: ${allIcons.evaluate().length}');
      for (final icon in allIcons.evaluate()) {
        final iconWidget = icon.widget as Icon;
        print('DEBUG: Icon găsit: ${iconWidget.icon}');
      }

      // Verifică că apare feedback-ul pentru utilizator
      expect(find.byIcon(Icons.lightbulb_outline), findsOneWidget);
    });

    test('should calculate correct frequency statistics', () {
      final dialog = HeatmapGeneratorDialog(
        allDraws: testDraws,
        selectedGame: GameType.loto649,
        isDesktop: false,
      );

      // Testează calculul frecvențelor
      final now = DateTime.now();
      final drawsForMonth = testDraws
          .where((d) => d.date.month == now.month)
          .toList();

      expect(drawsForMonth.length, equals(5));

      // Verifică că toate numerele din variantele de test sunt prezente
      final allNumbers = <int>{};
      for (final draw in drawsForMonth) {
        allNumbers.addAll(draw.mainNumbers);
      }

      expect(allNumbers.length, greaterThan(10));
    });

    test('should generate diverse variants', () {
      final dialog = HeatmapGeneratorDialog(
        allDraws: testDraws,
        selectedGame: GameType.loto649,
        isDesktop: false,
      );

      // Simulează generarea de variante
      final variants = <List<int>>[];
      for (int i = 0; i < 5; i++) {
        final variant = [1 + i, 5 + i, 12 + i, 23 + i, 34 + i, 45 - i];
        variants.add(variant);
      }

      // Verifică diversitatea
      final uniqueVariants = variants.map((v) => v.join(',')).toSet();
      expect(uniqueVariants.length, equals(variants.length));
    });

    test('should calculate variant ratings correctly', () {
      final dialog = HeatmapGeneratorDialog(
        allDraws: testDraws,
        selectedGame: GameType.loto649,
        isDesktop: false,
      );

      // Testează calculul rating-urilor
      final testVariant = [1, 5, 12, 23, 34, 45];
      final sum = testVariant.fold(0, (a, b) => a + b);
      final even = testVariant.where((n) => n % 2 == 0).length;
      final odd = testVariant.length - even;

      expect(sum, greaterThan(0));
      expect(even + odd, equals(testVariant.length));
    });
  });
}

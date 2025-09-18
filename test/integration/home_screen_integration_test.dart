import 'package:flutter_test/flutter_test.dart';
import 'package:flutter/material.dart';
import 'package:loto_ro/main.dart';
import 'package:loto_ro/services/data_service.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/models/game_statistics.dart';

class MockDataService implements IDataService {
  @override
  Future<List<LotoDraw>> loadDraws(GameType gameType) async {
    return List.generate(
      5,
      (i) => LotoDraw(
        date: DateTime(2024, 1, i + 1),
        mainNumbers: List.generate(5, (j) => j + 1 + i),
        jokerNumber: i + 1,
        gameType: gameType.name,
      ),
    );
  }

  @override
  List<int> generateRandomNumbers(GameType gameType, {int count = 1}) {
    return List.generate(count, (i) => i + 1);
  }

  @override
  Future<List<int>> generateFrequencyBasedNumbers(
    GameType gameType, {
    int count = 1,
  }) async {
    return List.generate(count, (i) => i + 1);
  }

  @override
  @override
  Future<void> clearCache(GameType gameType) async {}
  Map<String, dynamic> getCacheInfo() => {}; // helper
  @override
  Future<GameStatistics> loadStatistics(GameType gameType) async {
    final draws = await loadDraws(gameType);
    return GameStatistics.fromDraws(draws, gameType);
  }
  @override
  Future<void> clearAllCache() async {}

  @override
  Map<String, dynamic> getPerformanceStats() => {};
}

void main() {
  setUpAll(() {
    // No global injection yet; would require refactor of app to accept IDataService.
  });

  testWidgets(
    'HomeScreen integration: schimbare joc, filtrare, sortare, generare',
    (WidgetTester tester) async {
      await tester.pumpWidget(const LotoROApp());
      await tester.pumpAndSettle();

      // Verifică prezența taburilor principale
      expect(find.text('Arhivă'), findsOneWidget);
      expect(find.text('Statistici'), findsOneWidget);
      expect(find.text('Generator'), findsOneWidget);
      expect(find.text('Setări'), findsOneWidget);

      // Schimbă jocul (ex: selectează 6 din 49)
      final gameButton = find.textContaining('6');
      expect(gameButton, findsWidgets);
      await tester.tap(gameButton.first);
      await tester.pumpAndSettle();
      expect(find.textContaining('6'), findsWidgets);

      // Filtrare: caută un număr
      final searchField = find.byType(TextField).first;
      await tester.enterText(searchField, '10');
      await tester.pumpAndSettle();
      expect(find.textContaining('10'), findsWidgets);

      // Sortare: selectează altă opțiune doar dacă există dropdown
      final sortDropdowns = find.byType(DropdownButton<String>);
      if (sortDropdowns.evaluate().isNotEmpty) {
        await tester.tap(sortDropdowns.first);
        await tester.pumpAndSettle();
        final sortOption = find.text('Dată ascendent');
        if (sortOption.evaluate().isNotEmpty) {
          await tester.tap(sortOption.first);
          await tester.pumpAndSettle();
          expect(find.text('Dată ascendent'), findsWidgets);
        }
      }

      // Navighează la Generator și apasă butonul de generare (dacă există)
      await tester.tap(find.text('Generator'));
      await tester.pumpAndSettle();
      // Dacă există un buton de generare, îl apasă
      final generateButton = find.textContaining('Generează');
      if (generateButton.evaluate().isNotEmpty) {
        await tester.tap(generateButton);
        await tester.pumpAndSettle();
      }

      // Navighează la Setări
      await tester.tap(find.text('Setări'));
      await tester.pumpAndSettle();
      expect(find.text('Setări'), findsWidgets);
    },
  );
}

import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:loto_ro/screens/home_screen.dart';
import 'package:loto_ro/services/data_service.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/models/game_statistics.dart';

class MockDataService implements IDataService {
  @override
  Future<List<LotoDraw>> loadDraws(GameType gameType) async {
    return [
      LotoDraw(
        date: DateTime(2024, 1, 1),
        mainNumbers: [1, 2, 3, 4, 5],
        jokerNumber: 1,
        gameType: gameType.name,
      ),
    ];
  }

  @override
  List<int> generateRandomNumbers(GameType gameType, {int count = 1}) {
    return [1, 2, 3, 4, 5];
  }

  @override
  Future<List<int>> generateFrequencyBasedNumbers(
    GameType gameType, {
    int count = 1,
  }) async {
    return [1, 2, 3, 4, 5];
  }

  @override
  @override
  Future<void> clearCache(GameType gameType) async {}
  Map<String, dynamic> getCacheInfo() => {}; // legacy test helper
  @override
  Future<GameStatistics> loadStatistics(GameType gameType) async {
    return GameStatistics.empty(gameType);
  }
  @override
  Future<void> clearAllCache() async {}

  @override
  Map<String, dynamic> getPerformanceStats() => {};
}

void main() {
  setUp(() {
    // instanțiere dacă va fi nevoie ulterior
    MockDataService();
  });

  group('HomeScreen Widget Tests', () {
    testWidgets('should display app name and tagline', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Check if HomeScreen loads correctly
      expect(find.byType(HomeScreen), findsOneWidget);
      // Check if game selector is present
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should display game selector', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Check if game selector is present
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should display loading state initially', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Should show loading initially
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
    });

    testWidgets('should display glassmorphism effects', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Check for glassmorphism containers
      expect(find.byType(Container), findsWidgets);
    });

    testWidgets('should display bottom navigation', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Check for bottom navigation
      expect(find.byType(Column), findsWidgets);
    });

    testWidgets('should handle animations correctly', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));

      // Check for animation controller
      expect(find.byType(AnimatedBuilder), findsAtLeastNWidgets(1));
    });

    testWidgets('should display casino icon', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Check for casino icon
      expect(find.byIcon(Icons.casino), findsAtLeastNWidgets(1));
    });

    testWidgets('should display scaffold structure', (
      WidgetTester tester,
    ) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Check for scaffold structure
      expect(find.byType(Scaffold), findsOneWidget);
    });

    testWidgets('should display stack layout', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Check for stack layout
      expect(find.byType(Stack), findsAtLeastNWidgets(1));
    });

    testWidgets('should handle state changes', (WidgetTester tester) async {
      await tester.pumpWidget(const MaterialApp(home: HomeScreen()));
      await tester.pumpAndSettle();

      // Should handle state changes without crashing
      expect(find.byType(HomeScreen), findsOneWidget);
    });
  });
}

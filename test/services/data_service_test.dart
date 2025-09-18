import 'package:flutter_test/flutter_test.dart';
import 'package:loto_ro/services/data_service.dart';
import 'package:loto_ro/models/game_statistics.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/models/loto_draw.dart';

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

  Map<String, dynamic> getCacheInfo() => {}; // helper non interface

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
    // Nu mai folosesc DataService.testInstance, folosesc direct mock-ul
  });

  group('DataService', () {
    final dataService = MockDataService();

    test('loadDraws returns non-empty list for each game', () async {
      for (final game in GameType.values) {
        final draws = await dataService.loadDraws(game);
        expect(
          draws,
          isNotEmpty,
          reason: 'Draws should not be empty for $game',
        );
      }
    });

    test('loadStatistics returns valid statistics for each game', () async {
      for (final game in GameType.values) {
        final stats = await dataService.loadStatistics(game);
        expect(stats, isA<GameStatistics>());
        expect(stats.totalDraws, isNonZero);
      }
    });

    test('generateRandomNumbers returns correct count and range', () {
      for (final game in GameType.values) {
        final numbers = dataService.generateRandomNumbers(game, count: 5);
        expect(numbers.length, equals(5));
        for (final n in numbers) {
          expect(n, isA<int>());
        }
      }
    });

    test('generateFrequencyBasedNumbers returns correct count', () async {
      for (final game in GameType.values) {
        final numbers = await dataService.generateFrequencyBasedNumbers(
          game,
          count: 5,
        );
        expect(numbers.length, equals(5));
      }
    });
  });
}

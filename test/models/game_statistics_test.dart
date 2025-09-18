import 'package:flutter_test/flutter_test.dart';
import 'package:loto_ro/models/game_statistics.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';

void main() {
  group('GameStatistics Tests', () {
    late List<LotoDraw> testDraws;

    setUp(() {
      testDraws = [
        LotoDraw(
          date: DateTime(2024, 1, 15),
          mainNumbers: [1, 15, 23, 34, 45],
          jokerNumber: 7,
          gameType: '5din40',
        ),
        LotoDraw(
          date: DateTime(2024, 1, 16),
          mainNumbers: [2, 15, 25, 34, 40],
          jokerNumber: 12,
          gameType: '5din40',
        ),
        LotoDraw(
          date: DateTime(2024, 1, 17),
          mainNumbers: [1, 10, 20, 30, 40],
          jokerNumber: 5,
          gameType: '5din40',
        ),
      ];
    });

    test('should create GameStatistics from draws', () {
      final stats = GameStatistics.fromDraws(testDraws, GameType.loto540);

      expect(stats.gameType, equals(GameType.loto540));
      expect(stats.totalDraws, equals(3));
      expect(stats.numberFrequency.isNotEmpty, isTrue);
    });

    test('should calculate correct number frequencies', () {
      final stats = GameStatistics.fromDraws(testDraws, GameType.loto540);

      // Number 1 appears in draws 1 and 3
      expect(stats.numberFrequency[1], equals(2));
      // Number 15 appears in draws 1 and 2
      expect(stats.numberFrequency[15], equals(2));
      // Number 34 appears in draws 1 and 2
      expect(stats.numberFrequency[34], equals(2));
      // Number 40 appears in draws 2 and 3
      expect(stats.numberFrequency[40], equals(2));
      // Number 23 appears only in draw 1
      expect(stats.numberFrequency[23], equals(1));
    });

    test('should calculate correct joker frequencies', () {
      final stats = GameStatistics.fromDraws(testDraws, GameType.loto540);

      // Joker 7 appears in draw 1
      expect(stats.numberFrequency[7], equals(1));
      // Joker 12 appears in draw 2
      expect(stats.numberFrequency[12], equals(1));
      // Joker 5 appears in draw 3
      expect(stats.numberFrequency[5], equals(1));
    });

    test('should get most frequent numbers', () {
      final stats = GameStatistics.fromDraws(testDraws, GameType.loto540);

      expect(stats.mostFrequent.isNotEmpty, isTrue);
      expect(stats.mostFrequent.length, lessThanOrEqualTo(10));
    });

    test('should get least frequent numbers', () {
      final stats = GameStatistics.fromDraws(testDraws, GameType.loto540);

      expect(stats.leastFrequent.isNotEmpty, isTrue);
      expect(stats.leastFrequent.length, lessThanOrEqualTo(10));
    });

    test('should handle empty draws list', () {
      final stats = GameStatistics.fromDraws([], GameType.loto540);

      expect(stats.totalDraws, equals(0));
      expect(stats.numberFrequency.isEmpty, isTrue);
    });

    test('should calculate date range correctly', () {
      final stats = GameStatistics.fromDraws(testDraws, GameType.loto540);

      expect(stats.firstDrawDate, equals(DateTime(2024, 1, 17)));
      expect(stats.lastDrawDate, equals(DateTime(2024, 1, 15)));
    });

    test('should get frequency percentage correctly', () {
      final stats = GameStatistics.fromDraws(testDraws, GameType.loto540);

      // Number 1 appears in 2 out of 3 draws = 66.67%
      final percentage = stats.getFrequencyPercentage(1);
      expect(percentage, closeTo(66.67, 0.01));
    });

    test('should get days since last draw', () {
      final stats = GameStatistics.fromDraws(testDraws, GameType.loto540);

      final daysSince = stats.getDaysSinceLastDraw();
      expect(daysSince, greaterThanOrEqualTo(0));
    });

    test('should get even odd stats', () {
      final stats = GameStatistics.fromDraws(testDraws, GameType.loto540);

      final evenOddStats = stats.getEvenOddStats();
      expect(evenOddStats.containsKey('even'), isTrue);
      expect(evenOddStats.containsKey('odd'), isTrue);
    });

    test('should get low high stats', () {
      final stats = GameStatistics.fromDraws(testDraws, GameType.loto540);

      final lowHighStats = stats.getLowHighStats();
      expect(lowHighStats.containsKey('low'), isTrue);
      expect(lowHighStats.containsKey('high'), isTrue);
    });
  });
}

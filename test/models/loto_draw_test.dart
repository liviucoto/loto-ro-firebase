import 'package:flutter_test/flutter_test.dart';
import 'package:loto_ro/models/loto_draw.dart';

void main() {
  group('LotoDraw Tests', () {
    test('should create LotoDraw from valid data', () {
      final draw = LotoDraw(
        date: DateTime(2024, 1, 15),
        mainNumbers: [1, 15, 23, 34, 45],
        jokerNumber: 7,
        gameType: '5din40',
      );

      expect(draw.date, equals(DateTime(2024, 1, 15)));
      expect(draw.mainNumbers, equals([1, 15, 23, 34, 45]));
      expect(draw.jokerNumber, equals(7));
      expect(draw.gameType, equals('5din40'));
    });

    test('should create LotoDraw without joker number', () {
      final draw = LotoDraw(
        date: DateTime(2024, 1, 15),
        mainNumbers: [1, 15, 23, 34, 45, 49],
        gameType: '6din49',
      );

      expect(draw.jokerNumber, isNull);
      expect(draw.mainNumbers.length, equals(6));
    });

    test('should get all numbers correctly', () {
      final draw = LotoDraw(
        date: DateTime(2024, 1, 15),
        mainNumbers: [1, 15, 23, 34, 45],
        jokerNumber: 7,
        gameType: '5din40',
      );

      final allNumbers = draw.getAllNumbers();
      expect(allNumbers, equals([1, 15, 23, 34, 45, 7]));
    });

    test('should get description correctly', () {
      final draw = LotoDraw(
        date: DateTime(2024, 1, 15),
        mainNumbers: [1, 15, 23, 34, 45],
        jokerNumber: 7,
        gameType: '5din40',
      );

      final description = draw.getDescription();
      expect(description, contains('5DIN40'));
      expect(description, contains('15/1/2024'));
      expect(description, contains('1, 15, 23, 34, 45'));
      expect(description, contains('Joker: 7'));
    });

    test('should get max numbers correctly', () {
      final loto5Draw = LotoDraw(
        date: DateTime(2024, 1, 15),
        mainNumbers: [1, 15, 23, 34, 45],
        gameType: '5din40',
      );

      final loto6Draw = LotoDraw(
        date: DateTime(2024, 1, 15),
        mainNumbers: [1, 15, 23, 34, 45, 49],
        gameType: '6din49',
      );

      final jokerDraw = LotoDraw(
        date: DateTime(2024, 1, 15),
        mainNumbers: [1, 15, 23, 34, 45],
        jokerNumber: 7,
        gameType: 'joker',
      );

      expect(loto5Draw.getMaxNumbers(), equals(5));
      expect(loto6Draw.getMaxNumbers(), equals(6));
      expect(jokerDraw.getMaxNumbers(), equals(5));
    });

    test('should get number range correctly', () {
      final loto5Draw = LotoDraw(
        date: DateTime(2024, 1, 15),
        mainNumbers: [1, 15, 23, 34, 45],
        gameType: '5din40',
      );

      final range = loto5Draw.getNumberRange();
      expect(range['min'], equals(1));
      expect(range['max'], equals(40));
      expect(range['jokerMax'], equals(0));
    });

    test('should check winning numbers correctly', () {
      final draw = LotoDraw(
        date: DateTime(2024, 1, 15),
        mainNumbers: [1, 15, 23, 34, 45],
        jokerNumber: 7,
        gameType: '5din40',
      );

      final userNumbers = [1, 15, 23, 50, 60];
      final result = draw.checkWinningNumbers(userNumbers);

      expect(result['mainMatches'], equals(3));
      expect(result['additionalMatches'], equals(0));
      expect(result['jokerMatch'], equals(0));
    });

    test('should handle equality correctly', () {
      final draw1 = LotoDraw(
        date: DateTime(2024, 1, 15),
        mainNumbers: [1, 15, 23, 34, 45],
        gameType: '5din40',
      );

      final draw2 = LotoDraw(
        date: DateTime(2024, 1, 15),
        mainNumbers: [1, 15, 23, 34, 45],
        gameType: '5din40',
      );

      expect(draw1, equals(draw2));
    });

    test('should create from CSV row correctly', () {
      final row = {
        'data': '2018-12-02',
        'numar_1': '1',
        'numar_2': '15',
        'numar_3': '23',
        'numar_4': '34',
        'numar_5': '45',
      };

      final draw = LotoDraw.fromCsvRow(row, '5din40');

      expect(draw.date, equals(DateTime(2018, 12, 2)));
      expect(draw.mainNumbers, equals([1, 15, 23, 34, 45]));
      expect(draw.gameType, equals('5din40'));
      expect(draw.jokerNumber, isNull);
    });

    test('should create Joker from CSV row correctly', () {
      final row = {
        'data': '2018-12-02',
        'numar_1': '1',
        'numar_2': '15',
        'numar_3': '23',
        'numar_4': '34',
        'numar_5': '45',
        'joker': '7',
      };

      final draw = LotoDraw.fromCsvRow(row, 'joker');

      expect(draw.date, equals(DateTime(2018, 12, 2)));
      expect(draw.mainNumbers, equals([1, 15, 23, 34, 45]));
      expect(draw.gameType, equals('joker'));
      expect(draw.jokerNumber, equals(7));
    });
  });
} 

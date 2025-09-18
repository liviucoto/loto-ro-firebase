import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/statistics_narrative_utils.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });
  group('Statistics Narrative Tests', () {
    late List<LotoDraw> draws;

    setUp(() {
      // Creez date de test
      draws = [
        LotoDraw.fromCsvRow({
          'data': '2024-01-01',
          'numar_1': '1',
          'numar_2': '2',
          'numar_3': '3',
          'numar_4': '4',
          'numar_5': '5',
          'joker': '10',
        }, 'joker'),
        LotoDraw.fromCsvRow({
          'data': '2024-01-02',
          'numar_1': '6',
          'numar_2': '7',
          'numar_3': '8',
          'numar_4': '9',
          'numar_5': '10',
          'joker': '15',
        }, 'joker'),
        LotoDraw.fromCsvRow({
          'data': '2024-01-03',
          'numar_1': '1',
          'numar_2': '2',
          'numar_3': '3',
          'numar_4': '4',
          'numar_5': '5',
          'joker': '20',
        }, 'joker'),
        LotoDraw.fromCsvRow({
          'data': '2024-01-04',
          'numar_1': '11',
          'numar_2': '12',
          'numar_3': '13',
          'numar_4': '14',
          'numar_5': '15',
          'joker': '5',
        }, 'joker'),
        LotoDraw.fromCsvRow({
          'data': '2024-01-05',
          'numar_1': '16',
          'numar_2': '17',
          'numar_3': '18',
          'numar_4': '19',
          'numar_5': '20',
          'joker': '8',
        }, 'joker'),
      ];
    });

    test('Sum narrative is correct for all draws', () {
      final result = calculateSumNarrative({'draws': draws});
      expect(result['empty'], isFalse);
      expect(result['maxSum'], isA<double>());
      expect(result['minSum'], isA<double>());
      expect(result['maxSum'], greaterThan(result['minSum']));
      expect(
        result['avg'],
        closeTo(
          draws.map((d) => d.sum).reduce((a, b) => a + b) / draws.length,
          0.01,
        ),
      );
      expect(result['aboveAvg'] + result['belowAvg'], equals(draws.length));
      expect(result['top5Max'].length, equals(5));
      expect(result['top5Min'].length, equals(5));
    });

    test('Frequency narrative is correct for all draws', () {
      final mainRange = 40; // Joker
      final result = calculateFrequencyAndNarrative({
        'draws': draws,
        'mainRange': mainRange,
      });
      final freq = result['freq'] as Map<int, int>;
      expect(freq.length, equals(mainRange));
      expect(freq.values.every((count) => count >= 0), isTrue);
      expect(freq.keys.every((num) => num >= 1 && num <= mainRange), isTrue);
      expect(result['narrative'], contains('5 extrageri'));
    });

    test('Dialog period filtering works correctly', () {
      final mainRange = 40;

      // Test pentru "Toate extragerile" - folosește toate datele
      final allDraws = draws;
      final resultAll = calculateFrequencyAndNarrative({
        'draws': allDraws,
        'mainRange': mainRange,
      });
      expect(resultAll['freq'].length, equals(mainRange));

      // Test pentru "Ultimele 3" - folosește doar ultimele 3
      final last3Draws = draws.take(3).toList();
      final resultLast3 = calculateFrequencyAndNarrative({
        'draws': last3Draws,
        'mainRange': mainRange,
      });
      expect(resultLast3['freq'].length, equals(mainRange));

      // Test pentru "Custom" - folosește statsDraws (deja filtrat)
      final customDraws = draws.take(2).toList(); // Simulez statsDraws
      final resultCustom = calculateFrequencyAndNarrative({
        'draws': customDraws,
        'mainRange': mainRange,
      });
      expect(resultCustom['freq'].length, equals(mainRange));

      // Verificăm că rezultatele sunt diferite pentru perioade diferite
      expect(resultAll['narrative'], isNot(equals(resultLast3['narrative'])));
      expect(
        resultLast3['narrative'],
        isNot(equals(resultCustom['narrative'])),
      );
    });

    test('Sum narrative updates correctly for different periods', () {
      // Test pentru toate extragerile
      final resultAll = calculateSumNarrative({'draws': draws});
      expect(resultAll['empty'], isFalse);
      expect(resultAll['avg'], isA<double>());
      expect(resultAll['avg'], greaterThan(0));

      // Test pentru ultimele 3 extrageri
      final last3Draws = draws.take(3).toList();
      final resultLast3 = calculateSumNarrative({'draws': last3Draws});
      expect(resultLast3['empty'], isFalse);
      expect(resultLast3['avg'], isA<double>());
      expect(resultLast3['avg'], greaterThan(0));

      // Test pentru custom (2 extrageri)
      final customDraws = draws.take(2).toList();
      final resultCustom = calculateSumNarrative({'draws': customDraws});
      expect(resultCustom['empty'], isFalse);
      expect(resultCustom['avg'], isA<double>());
      expect(resultCustom['avg'], greaterThan(0));

      // Verificăm că rezultatele sunt diferite pentru seturi diferite de date
      expect(resultAll['avg'], isNot(equals(resultLast3['avg'])));
      expect(resultLast3['avg'], isNot(equals(resultCustom['avg'])));
    });
  });
}

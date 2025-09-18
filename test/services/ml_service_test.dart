import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loto_ro/services/ml_service.dart';
import 'package:loto_ro/utils/constants.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();
  setUpAll(() async {
    // Evită MissingPluginException pentru shared_preferences
    SharedPreferences.setMockInitialValues({});
  });

  group('MLService Tests', () {
    late MLService mlService;

    setUp(() async {
      mlService = MLService();
      await mlService.initialize();
    });

    test('should initialize MLService successfully', () async {
      expect(mlService, isNotNull);
    });

    test('should train model for Loto 6 din 49', () async {
      final result = await mlService.trainModel(GameType.loto649);

      expect(result, isA<Map<String, dynamic>>());
      expect(result['status'], isA<String>());
      expect(result['patterns'], isA<int>());
      expect(result['frequencies'], isA<int>());
      expect(result['correlations'], isA<int>());
    });

    test('should generate predictions for Loto 6 din 49', () async {
      // Antrenează modelul mai întâi
      await mlService.trainModel(GameType.loto649);

      final params = {
        'strategy': 'balanced',
        'preferRareNumbers': false,
        'avoidRecentDraws': true,
      };

      final predictions = await mlService.generatePredictions(
        GameType.loto649,
        3,
        params,
      );

      expect(predictions, isA<List<Map<String, dynamic>>>());
      expect(predictions.length, equals(3));

      for (final prediction in predictions) {
        expect(prediction['numbers'], isA<List<int>>());
        expect(prediction['score'], isA<double>());
        expect(prediction['strategy'], isA<String>());
        expect(prediction['confidence'], isA<double>());

        final numbers = prediction['numbers'] as List<int>;
        expect(numbers.length, equals(6)); // 6 numere pentru Loto 6 din 49
        expect(numbers.every((n) => n >= 1 && n <= 49), isTrue);
      }
    });

    test('should generate predictions for Loto 5 din 40', () async {
      // Antrenează modelul mai întâi
      await mlService.trainModel(GameType.loto540);

      final params = {'strategy': 'frequency_based', 'preferRareNumbers': true};

      final predictions = await mlService.generatePredictions(
        GameType.loto540,
        2,
        params,
      );

      expect(predictions, isA<List<Map<String, dynamic>>>());
      expect(predictions.length, equals(2));

      for (final prediction in predictions) {
        final numbers = prediction['numbers'] as List<int>;
        expect(numbers.length, equals(5)); // 5 numere pentru Loto 5 din 40
        expect(numbers.every((n) => n >= 1 && n <= 40), isTrue);
      }
    });

    test('should generate predictions for Joker', () async {
      // Antrenează modelul mai întâi
      await mlService.trainModel(GameType.joker);

      final params = {'strategy': 'pattern_based', 'balanceEvenOdd': true};

      final predictions = await mlService.generatePredictions(
        GameType.joker,
        1,
        params,
      );

      expect(predictions, isA<List<Map<String, dynamic>>>());
      expect(predictions.length, equals(1));

      final prediction = predictions.first;
      final numbers = prediction['numbers'] as List<int>;
      expect(numbers.length, equals(5)); // 5 numere pentru Joker
      expect(numbers.every((n) => n >= 1 && n <= 40), isTrue);
    });

    test('should get model status', () {
      final status = mlService.getModelStatus(GameType.loto649);

      expect(status, isA<Map<String, dynamic>>());
      expect(status['trained'], isA<bool>());
      expect(status['gameType'], isA<String>());
      expect(status['patterns'], isA<int>());
      expect(status['frequencies'], isA<int>());
      expect(status['correlations'], isA<int>());
    });

    test('should clear model', () async {
      // Antrenează modelul mai întâi
      await mlService.trainModel(GameType.loto649);

      // Verifică că modelul este antrenat
      var status = mlService.getModelStatus(GameType.loto649);
      expect(status['trained'], isTrue);

      // Șterge modelul
      await mlService.clearModel();

      // Verifică că modelul a fost șters
      status = mlService.getModelStatus(GameType.loto649);
      expect(status['trained'], isFalse);
    });

    test('should handle different strategies', () async {
      await mlService.trainModel(GameType.loto649);

      final strategies = [
        'balanced',
        'frequency_based',
        'pattern_based',
        'correlation_based',
      ];

      for (final strategy in strategies) {
        final predictions = await mlService.generatePredictions(
          GameType.loto649,
          1,
          {'strategy': strategy},
        );

        expect(predictions.length, equals(1));
        expect(predictions.first['strategy'], equals(strategy));
      }
    });

    test('should handle empty predictions gracefully', () async {
      // Testează cazul când nu sunt date disponibile
      final predictions = await mlService.generatePredictions(
        GameType.loto649,
        1,
        {'strategy': 'invalid_strategy'},
      );

      // Ar trebui să returneze o listă goală sau să folosească fallback
      expect(predictions, isA<List<Map<String, dynamic>>>());
    });
  });
}

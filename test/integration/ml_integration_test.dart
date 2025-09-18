import 'package:flutter_test/flutter_test.dart';
import 'package:loto_ro/services/ml_service.dart';
import 'package:loto_ro/services/storage_service.dart';
import 'package:loto_ro/utils/constants.dart';

void main() {
  group('ML Integration Tests', () {
    late MLService mlService;
    late StorageService storageService;

    setUp(() async {
      mlService = MLService();
      storageService = StorageService();

      // Inițializează serviciile
      await storageService.initialize();
      await mlService.initialize();
    });

    test('should train model and generate predictions', () async {
      // Antrenează modelul
      final trainResult = await mlService.trainModel(GameType.loto649);
      expect(trainResult['status'], equals('trained'));

      // Generează predicții
      final predictions = await mlService.generatePredictions(
        GameType.loto649,
        2,
        {'strategy': 'balanced'},
      );

      expect(predictions.length, equals(2));
      for (final prediction in predictions) {
        expect(prediction['numbers'], isA<List<int>>());
        expect(prediction['numbers'].length, equals(6));
        expect(prediction['score'], isA<double>());
        expect(prediction['strategy'], equals('balanced'));
      }
    });

    test('should save and load variants with storage', () async {
      // Generează niște variante de test
      final testVariants = [
        {
          'variant': {
            'numbers': [1, 2, 3, 4, 5, 6],
          },
          'score': 85.5,
          'justification': 'Test variant 1',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'game': 'loto649',
        },
        {
          'variant': {
            'numbers': [7, 8, 9, 10, 11, 12],
          },
          'score': 92.3,
          'justification': 'Test variant 2',
          'timestamp': DateTime.now().millisecondsSinceEpoch,
          'game': 'loto649',
        },
      ];

      // Salvează variantele
      await storageService.saveVariants(testVariants);

      // Încarcă variantele
      final loadedVariants = await storageService.loadVariants();
      expect(loadedVariants.length, equals(2));
      expect(
        loadedVariants[0]['variant']['numbers'],
        equals([1, 2, 3, 4, 5, 6]),
      );
    });

    test('should handle different game types', () async {
      final gameTypes = [GameType.loto649, GameType.loto540, GameType.joker];

      for (final gameType in gameTypes) {
        // Antrenează modelul pentru fiecare tip de joc
        final trainResult = await mlService.trainModel(gameType);
        expect(trainResult['status'], equals('trained'));

        // Generează predicții
        final predictions = await mlService.generatePredictions(gameType, 1, {
          'strategy': 'frequency_based',
        });

        expect(predictions.length, equals(1));
        final prediction = predictions.first;
        expect(prediction['numbers'], isA<List<int>>());

        // Verifică numărul corect de numere pentru fiecare tip de joc
        switch (gameType) {
          case GameType.loto649:
            expect(prediction['numbers'].length, equals(6));
            break;
          case GameType.loto540:
          case GameType.joker:
            expect(prediction['numbers'].length, equals(5));
            break;
        }
      }
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

    test('should get model status', () {
      final status = mlService.getModelStatus(GameType.loto649);

      expect(status, isA<Map<String, dynamic>>());
      expect(status['trained'], isA<bool>());
      expect(status['gameType'], isA<String>());
      expect(status['patterns'], isA<int>());
      expect(status['frequencies'], isA<int>());
      expect(status['correlations'], isA<int>());
    });

    test('should clear model and cache', () async {
      // Antrenează modelul
      await mlService.trainModel(GameType.loto649);

      // Salvează niște cache
      await storageService.saveAICache('test_model', {'data': 'test'});

      // Verifică că există
      final cache = await storageService.loadAICache('test_model');
      expect(cache, isNotNull);

      // Șterge modelul și cache-ul
      await mlService.clearModel();
      await storageService.clearAICache();

      // Verifică că au fost șterse
      final status = mlService.getModelStatus(GameType.loto649);
      expect(status['trained'], isFalse);

      final cacheAfter = await storageService.loadAICache('test_model');
      expect(cacheAfter, isNull);
    });

    test('should handle logging', () {
      // Testează diferite tipuri de loguri
      storageService.logAI('Test AI message', data: {'test': 'data'});
      storageService.logGeneration('loto649', 3, {'param': 'value'}, []);
      storageService.logError('Test error', context: 'test_context');

      // Obține logurile
      final aiLogs = storageService.getLogs('ai');
      final generationLogs = storageService.getLogs('generation');
      final errorLogs = storageService.getLogs('error');

      expect(aiLogs, isA<List<Map<String, dynamic>>>());
      expect(generationLogs, isA<List<Map<String, dynamic>>>());
      expect(errorLogs, isA<List<Map<String, dynamic>>>());
    });

    test('should export and import data', () async {
      // Salvează niște date de test
      await storageService.saveVariants([
        {'test': 'variant1'},
        {'test': 'variant2'},
      ]);
      await storageService.saveFavorites([1, 2, 3]);
      await storageService.saveUserSettings({'test': 'setting'});

      // Exportă datele
      final exportedData = await storageService.exportData();
      expect(exportedData, isA<Map<String, dynamic>>());
      expect(exportedData.isNotEmpty, isTrue);

      // Șterge toate datele
      await storageService.clearAICache();
      await storageService.saveVariants([]);
      await storageService.saveFavorites([]);

      // Importă datele
      await storageService.importData(exportedData);

      // Verifică că datele au fost importate
      final loadedVariants = await storageService.loadVariants();
      final loadedFavorites = await storageService.loadFavorites();
      final loadedSettings = await storageService.loadUserSettings();

      expect(loadedVariants.length, equals(2));
      expect(loadedFavorites.length, equals(3));
      expect(loadedSettings['test'], equals('setting'));
    });
  });
}

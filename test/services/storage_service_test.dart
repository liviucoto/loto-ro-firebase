import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loto_ro/services/storage_service.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });
  TestWidgetsFlutterBinding.ensureInitialized();
  group('StorageService Tests', () {
    late StorageService storageService;

    setUp(() async {
      storageService = StorageService();
      await storageService.initialize();
    });

    test('should initialize StorageService successfully', () async {
      expect(storageService, isNotNull);
    });

    test('should save and load variants', () async {
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

      expect(loadedVariants, isA<List<Map<String, dynamic>>>());
      expect(loadedVariants.length, equals(2));
      expect(
        loadedVariants[0]['variant']['numbers'],
        equals([1, 2, 3, 4, 5, 6]),
      );
      expect(loadedVariants[0]['score'], equals(85.5));
      expect(
        loadedVariants[1]['variant']['numbers'],
        equals([7, 8, 9, 10, 11, 12]),
      );
      expect(loadedVariants[1]['score'], equals(92.3));
    });

    test('should save and load favorites', () async {
      final testFavorites = [1, 3, 5, 7];

      // Salvează favoritele
      await storageService.saveFavorites(testFavorites);

      // Încarcă favoritele
      final loadedFavorites = await storageService.loadFavorites();

      expect(loadedFavorites, isA<List<int>>());
      expect(loadedFavorites.length, equals(4));
      expect(loadedFavorites, equals(testFavorites));
    });

    test('should save and load user settings', () async {
      final testSettings = {
        'theme': 'dark',
        'language': 'ro',
        'notifications': true,
        'autoSave': false,
      };

      // Salvează setările
      await storageService.saveUserSettings(testSettings);

      // Încarcă setările
      final loadedSettings = await storageService.loadUserSettings();

      expect(loadedSettings, isA<Map<String, dynamic>>());
      expect(loadedSettings['theme'], equals('dark'));
      expect(loadedSettings['language'], equals('ro'));
      expect(loadedSettings['notifications'], equals(true));
      expect(loadedSettings['autoSave'], equals(false));
    });

    test('should save and load AI cache', () async {
      final testCache = {
        'model_data': {'layers': 3, 'neurons': 100},
        'predictions': [1, 2, 3, 4, 5, 6],
        'accuracy': 0.85,
      };

      // Salvează cache-ul
      await storageService.saveAICache('test_model', testCache);

      // Încarcă cache-ul
      final loadedCache = await storageService.loadAICache('test_model');

      expect(loadedCache, isA<Map<String, dynamic>>());
      expect(loadedCache!['model_data']['layers'], equals(3));
  expect(loadedCache['model_data']['neurons'], equals(100));
  expect(loadedCache['predictions'], equals([1, 2, 3, 4, 5, 6]));
  expect(loadedCache['accuracy'], equals(0.85));
    });

    test('should clear AI cache', () async {
      // Salvează niște cache-uri
      await storageService.saveAICache('test1', {'data': 'value1'});
      await storageService.saveAICache('test2', {'data': 'value2'});

      // Verifică că există
      final cache1 = await storageService.loadAICache('test1');
      final cache2 = await storageService.loadAICache('test2');
      expect(cache1, isNotNull);
      expect(cache2, isNotNull);

      // Șterge cache-ul
      await storageService.clearAICache();

      // Verifică că au fost șterse
      final cache1After = await storageService.loadAICache('test1');
      final cache2After = await storageService.loadAICache('test2');
      expect(cache1After, isNull);
      expect(cache2After, isNull);
    });

    test('should get storage stats', () {
      final stats = storageService.getStorageStats();

      expect(stats, isA<Map<String, dynamic>>());
      expect(stats['total_keys'], isA<int>());
      expect(stats['saved_variants'], isA<int>());
      expect(stats['favorites'], isA<int>());
      expect(stats['ai_cache_keys'], isA<int>());
      expect(stats['log_types'], isA<List<String>>());
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

      // Verifică că logurile conțin informațiile corecte
      if (aiLogs.isNotEmpty) {
        expect(aiLogs.first['message'], equals('Test AI message'));
        expect(aiLogs.first['data']['test'], equals('data'));
      }

      if (generationLogs.isNotEmpty) {
        expect(generationLogs.first['gameType'], equals('loto649'));
        expect(generationLogs.first['nVariants'], equals(3));
      }

      if (errorLogs.isNotEmpty) {
        expect(errorLogs.first['error'], equals('Test error'));
        expect(errorLogs.first['context'], equals('test_context'));
      }
    });

    test('should clear logs', () async {
      // Adaugă niște loguri
      storageService.logAI('Test message');
      storageService.logError('Test error');

      // Verifică că există loguri
      final aiLogsBefore = storageService.getLogs('ai');
      final errorLogsBefore = storageService.getLogs('error');
      expect(aiLogsBefore.isNotEmpty, isTrue);
      expect(errorLogsBefore.isNotEmpty, isTrue);

      // Șterge logurile
      await storageService.clearLogs();

      // Verifică că au fost șterse
      final aiLogsAfter = storageService.getLogs('ai');
      final errorLogsAfter = storageService.getLogs('error');
      expect(aiLogsAfter.isEmpty, isTrue);
      expect(errorLogsAfter.isEmpty, isTrue);
    });
  });
}

import 'package:flutter_test/flutter_test.dart';
import 'package:loto_ro/services/cache_service.dart';

void main() {
  group('CacheService Tests', () {
    late CacheService cacheService;

    setUp(() {
      cacheService = CacheService();
    });

    tearDown(() async {
      await cacheService.clear();
    });

    test('should set and get value from cache', () async {
      // Arrange
      const key = 'test_key';
      const value = 'test_value';

      // Act
      await cacheService.set(key, value);
      final result = await cacheService.get<String>(key);

      // Assert
      expect(result, equals(value));
    });

    test('should return null for non-existent key', () async {
      // Act
      final result = await cacheService.get<String>('non_existent');

      // Assert
      expect(result, isNull);
    });

    test('should handle different data types', () async {
      // Arrange
      const stringKey = 'string_key';
      const stringValue = 'test_string';
      const intKey = 'int_key';
      const intValue = 42;
      const listKey = 'list_key';
      const listValue = [1, 2, 3, 4, 5];

      // Act
      await cacheService.set(stringKey, stringValue);
      await cacheService.set(intKey, intValue);
      await cacheService.set(listKey, listValue);

      final stringResult = await cacheService.get<String>(stringKey);
      final intResult = await cacheService.get<int>(intKey);
      final listResult = await cacheService.get<List<int>>(listKey);

      // Assert
      expect(stringResult, equals(stringValue));
      expect(intResult, equals(intValue));
      expect(listResult, equals(listValue));
    });

    test('should handle statistics cache', () async {
      // Arrange
      const gameType = 'Loto_6_49';
      const statType = 'frequency';
      const data = {'1': 10, '2': 15, '3': 8};

      // Act
      await cacheService.setStatistics(gameType, statType, data);
      final result = await cacheService.getStatistics<Map<String, int>>(
        gameType,
        statType,
      );

      // Assert
      expect(result, equals(data));
    });

    test('should handle prediction cache', () async {
      // Arrange
      const gameType = 'Loto_6_49';
      final prediction = {
        'numbers': [1, 2, 3, 4, 5, 6],
        'score': 0.85,
        'strategy': 'frequency_based',
      };

      // Act
      await cacheService.setPrediction(gameType, prediction);
      final stats = cacheService.getStats();

      // Assert
      expect(stats['memoryItems'], greaterThan(0));
    });

    test('should handle generated variants cache', () async {
      // Arrange
      const gameType = 'Loto_6_49';
      final variants = [
        {
          'numbers': [1, 2, 3, 4, 5, 6],
          'score': 0.8,
          'justification': 'Test variant',
        },
        {
          'numbers': [7, 8, 9, 10, 11, 12],
          'score': 0.7,
          'justification': 'Test variant 2',
        },
      ];

      // Act
      await cacheService.setGeneratedVariants(gameType, variants);
      final stats = cacheService.getStats();

      // Assert
      expect(stats['memoryItems'], greaterThan(0));
    });

    test('should handle base data cache', () async {
      // Arrange
      const gameType = 'Loto_6_49';
      const dataType = 'frequencies';
      final data = {'1': 100, '2': 95, '3': 90};

      // Act
      await cacheService.setBaseData(gameType, dataType, data);
      final stats = cacheService.getStats();

      // Assert
      expect(stats['memoryItems'], greaterThan(0));
    });

    test('should remove specific key', () async {
      // Arrange
      const key = 'test_key';
      const value = 'test_value';
      await cacheService.set(key, value);

      // Act
      await cacheService.remove(key);
      final result = await cacheService.get<String>(key);

      // Assert
      expect(result, isNull);
    });

    test('should clear all cache', () async {
      // Arrange
      await cacheService.set('key1', 'value1');
      await cacheService.set('key2', 'value2');

      // Act
      await cacheService.clear();
      final stats = cacheService.getStats();

      // Assert
      expect(stats['memoryItems'], equals(0));
    });

    test('should handle cache expiry', () async {
      // Arrange
      const key = 'expiry_test';
      const value = 'test_value';
      const shortExpiry = Duration(milliseconds: 100);

      // Act
      await cacheService.set(key, value, expiry: shortExpiry);

      // Wait for expiry
      await Future.delayed(const Duration(milliseconds: 200));

      final result = await cacheService.get<String>(key);

      // Assert
      expect(result, isNull);
    });

    test('should optimize cache when too many items', () async {
      // Arrange
      for (int i = 0; i < 150; i++) {
        await cacheService.set('key_$i', 'value_$i');
      }

      // Act
      await cacheService.optimize();
      final stats = cacheService.getStats();

      // Assert
      expect(stats['memoryItems'], lessThanOrEqualTo(100));
    });

    test('should return cache statistics', () async {
      // Arrange
      await cacheService.set('key1', 'value1');
      await cacheService.set('key2', 'value2');
      await cacheService.get<String>('key1'); // Hit
      await cacheService.get<String>('key2'); // Hit
      await cacheService.get<String>('non_existent'); // Miss

      // Act
      final stats = cacheService.getStats();

      // Assert
      expect(stats['memoryItems'], equals(2));
      expect(stats['hits'], equals(2));
      expect(stats['misses'], equals(1));
      expect(stats['totalRequests'], equals(3));
      expect(stats['hitRate'], isA<String>());
    });

    test('should handle expensive operations with cache', () async {
      // Arrange
      const key = 'expensive_operation';
      int operationCount = 0;

      Future<String> expensiveOperation() async {
        operationCount++;
        await Future.delayed(const Duration(milliseconds: 50));
        return 'expensive_result';
      }

      // Act
      final result1 = await cacheService.cacheExpensiveOperation(
        key,
        expensiveOperation,
      );
      final result2 = await cacheService.cacheExpensiveOperation(
        key,
        expensiveOperation,
      );

      // Assert
      expect(result1, equals('expensive_result'));
      expect(result2, equals('expensive_result'));
      expect(operationCount, equals(1)); // Should only execute once
    });

    test('should preload important data', () async {
      // Act
      await cacheService.preloadImportantData();
      final stats = cacheService.getStats();

      // Assert
      expect(stats['memoryItems'], greaterThan(0));
    });
  });
}

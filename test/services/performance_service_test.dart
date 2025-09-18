import 'package:flutter_test/flutter_test.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:loto_ro/services/performance_service.dart';

void main() {
  setUpAll(() async {
    SharedPreferences.setMockInitialValues({});
  });
  group('PerformanceService Tests', () {
    late PerformanceService performanceService;

    setUp(() {
      performanceService = PerformanceService();
    });

    tearDown(() {
      performanceService.clearHistory();
    });

    test('should measure async operation', () async {
      // Arrange
      const operationName = 'test_async_operation';
      const expectedResult = 'test_result';

      Future<String> testOperation() async {
        await Future.delayed(const Duration(milliseconds: 50));
        return expectedResult;
      }

      // Act
      final result = await performanceService.measureOperation(
        operationName,
        testOperation,
      );

      // Assert
      expect(result, equals(expectedResult));

      final stats = performanceService.getPerformanceStats();
      expect(stats[operationName], isNotNull);
      expect(stats[operationName]['count'], equals(1));
    });

    test('should measure sync operation', () {
      // Arrange
      const operationName = 'test_sync_operation';
      const expectedResult = 42;

      int testOperation() {
        // Simulate some work
        // Operație trivială pentru a consuma timp; nu avem nevoie de rezultat
        for (int i = 0; i < 1000; i++) {
          // no-op
        }
        return expectedResult;
      }

      // Act
      final result = performanceService.measureSyncOperation(
        operationName,
        testOperation,
      );

      // Assert
      expect(result, equals(expectedResult));

      final stats = performanceService.getPerformanceStats();
      expect(stats[operationName], isNotNull);
      expect(stats[operationName]['count'], equals(1));
    });

    test('should handle operation errors', () async {
      // Arrange
      const operationName = 'test_error_operation';

      Future<String> failingOperation() async {
        await Future.delayed(const Duration(milliseconds: 10));
        throw Exception('Test error');
      }

      // Act & Assert
      expect(
        () => performanceService.measureOperation(
          operationName,
          failingOperation,
        ),
        throwsException,
      );

      final stats = performanceService.getPerformanceStats();
      expect(stats['${operationName}_error'], isNotNull);
    });

    test('should measure memory usage', () async {
      // Act
      final memoryUsage = await performanceService.measureMemoryUsage();

      // Assert
      expect(memoryUsage, isA<double>());
      expect(memoryUsage, greaterThanOrEqualTo(0));
    });

    test('should return performance statistics', () {
      // Arrange
      performanceService.measureSyncOperation('test_op', () => 42);
      performanceService.measureSyncOperation('test_op', () => 42);

      // Act
      final stats = performanceService.getPerformanceStats();

      // Assert
      expect(stats, isA<Map<String, dynamic>>());
      expect(stats['test_op'], isNotNull);
      expect(stats['test_op']['count'], equals(2));
      expect(stats['test_op']['averageTime'], isA<int>());
      expect(stats['test_op']['minTime'], isA<int>());
      expect(stats['test_op']['maxTime'], isA<int>());
    });

    test('should identify slow operations', () async {
      // Arrange
      const slowOperationName = 'slow_operation';

      Future<String> slowOperation() async {
        await Future.delayed(
          const Duration(milliseconds: 600),
        ); // > 500ms threshold
        return 'slow_result';
      }

      // Act
      await performanceService.measureOperation(
        slowOperationName,
        slowOperation,
      );

      final slowOperations = performanceService.getSlowOperations();

      // Assert
      expect(slowOperations, isNotEmpty);
      final slowOp = slowOperations.firstWhere(
        (op) => op['operation'] == slowOperationName,
      );
      expect(slowOp['slowCount'], equals(1));
      expect(slowOp['verySlowCount'], equals(0));
    });

    test('should identify very slow operations', () async {
      // Arrange
      const verySlowOperationName = 'very_slow_operation';

      Future<String> verySlowOperation() async {
        await Future.delayed(
          const Duration(milliseconds: 2500),
        ); // > 2s threshold
        return 'very_slow_result';
      }

      // Act
      await performanceService.measureOperation(
        verySlowOperationName,
        verySlowOperation,
      );

      final slowOperations = performanceService.getSlowOperations();

      // Assert
      expect(slowOperations, isNotEmpty);
      final slowOp = slowOperations.firstWhere(
        (op) => op['operation'] == verySlowOperationName,
      );
      expect(slowOp['slowCount'], equals(1));
      expect(slowOp['verySlowCount'], equals(1));
    });

    test('should clear performance history', () {
      // Arrange
      performanceService.measureSyncOperation('test_op', () => 42);

      // Act
      performanceService.clearHistory();
      final stats = performanceService.getPerformanceStats();

      // Assert
      expect(stats, isEmpty);
    });

    test('should export performance data', () {
      // Arrange
      performanceService.measureSyncOperation('test_op', () => 42);

      // Act
      final exportData = performanceService.exportPerformanceData();

      // Assert
      expect(exportData, isA<Map<String, dynamic>>());
      expect(exportData['timestamp'], isA<String>());
      expect(exportData['stats'], isA<Map<String, dynamic>>());
      expect(exportData['slowOperations'], isA<List>());
      expect(exportData['memoryHistory'], isA<List>());
      expect(exportData['memoryTimestamps'], isA<List>());
    });

    test('should benchmark operations', () async {
      // Arrange
      const operationName = 'benchmark_test';
      int callCount = 0;

      Future<String> testOperation() async {
        callCount++;
        await Future.delayed(const Duration(milliseconds: 10));
        return 'benchmark_result';
      }

      // Act
      final benchmarkResult = await performanceService.benchmarkOperation(
        operationName,
        testOperation,
        iterations: 5,
      );

      // Assert
      expect(benchmarkResult['operation'], equals(operationName));
      expect(benchmarkResult['iterations'], equals(5));
      expect(benchmarkResult['totalTime'], isA<int>());
      expect(benchmarkResult['averageTime'], isA<int>());
      expect(benchmarkResult['minTime'], isA<int>());
      expect(benchmarkResult['maxTime'], isA<int>());
      expect(benchmarkResult['throughput'], isA<String>());
      expect(callCount, equals(5));
    });

    test('should start and stop monitoring', () {
      // Act
      performanceService.startMonitoring();
      performanceService.stopMonitoring();

      // Assert - should not throw any exceptions
      expect(true, isTrue);
    });

    test('should handle multiple operations with different timings', () async {
      // Arrange
      const fastOp = 'fast_operation';
      const slowOp = 'slow_operation';

      Future<String> fastOperation() async {
        await Future.delayed(const Duration(milliseconds: 10));
        return 'fast';
      }

      Future<String> slowOperation() async {
        await Future.delayed(const Duration(milliseconds: 600));
        return 'slow';
      }

      // Act
      await performanceService.measureOperation(fastOp, fastOperation);
      await performanceService.measureOperation(slowOp, slowOperation);

      final stats = performanceService.getPerformanceStats();
      final slowOperations = performanceService.getSlowOperations();

      // Assert
      expect(stats[fastOp], isNotNull);
      expect(stats[slowOp], isNotNull);
      expect(slowOperations.length, equals(1));
      expect(slowOperations.first['operation'], equals(slowOp));
    });

    test('should track operation counts correctly', () {
      // Arrange
      const operationName = 'count_test';

      // Act
      for (int i = 0; i < 5; i++) {
        performanceService.measureSyncOperation(operationName, () => i);
      }

      final stats = performanceService.getPerformanceStats();

      // Assert
      expect(stats[operationName]['count'], equals(5));
      expect(stats[operationName]['totalTime'], isA<int>());
    });

    test('should handle memory tracking over time', () async {
      // Act
      final memory1 = await performanceService.measureMemoryUsage();
      await Future.delayed(const Duration(milliseconds: 100));
      final memory2 = await performanceService.measureMemoryUsage();

      final stats = performanceService.getPerformanceStats();

      // Assert
      expect(memory1, isA<double>());
      expect(memory2, isA<double>());
      expect(stats['memory'], isNotNull);
    });
  });
}

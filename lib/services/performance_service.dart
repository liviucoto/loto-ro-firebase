import 'dart:async';
import 'dart:developer' as developer;
import 'package:flutter/foundation.dart';

/// Serviciu pentru monitorizarea performanței în timp real
/// Oferă metrics detaliate pentru debugging și optimizare
class PerformanceService {
  static final PerformanceService _instance = PerformanceService._internal();
  factory PerformanceService() => _instance;
  PerformanceService._internal();

  // Metrics pentru tracking
  final Map<String, List<Duration>> _operationTimings = {};
  final Map<String, int> _operationCounts = {};
  final Map<String, double> _averageTimings = {};

  // Memory tracking
  final List<double> _memoryUsage = [];
  final List<DateTime> _memoryTimestamps = [];

  // Performance thresholds
  static const Duration _slowOperationThreshold = Duration(milliseconds: 500);
  static const Duration _verySlowOperationThreshold = Duration(seconds: 2);

  // Monitoring state
  bool _isMonitoring = false;
  Timer? _monitoringTimer;

  /// Începe monitorizarea performanței
  void startMonitoring() {
    if (_isMonitoring) return;

    _isMonitoring = true;
    _monitoringTimer = Timer.periodic(const Duration(seconds: 5), (timer) {
      _collectMetrics();
    });

    if (kDebugMode) {
      print('Performance monitoring started');
    }
  }

  /// Oprește monitorizarea performanței
  void stopMonitoring() {
    _isMonitoring = false;
    _monitoringTimer?.cancel();

    if (kDebugMode) {
      print('Performance monitoring stopped');
    }
  }

  /// Măsoară timpul de execuție pentru o operație
  Future<T> measureOperation<T>(
    String operationName,
    Future<T> Function() operation, {
    bool logSlowOperations = true,
  }) async {
    final stopwatch = Stopwatch()..start();

    try {
      final result = await operation();
      stopwatch.stop();

      _recordTiming(operationName, stopwatch.elapsed);

      if (logSlowOperations) {
        _logSlowOperation(operationName, stopwatch.elapsed);
      }

      return result;
    } catch (e) {
      stopwatch.stop();
      _recordError(operationName, e, stopwatch.elapsed);
      rethrow;
    }
  }

  /// Măsoară o operație sincronă
  T measureSyncOperation<T>(
    String operationName,
    T Function() operation, {
    bool logSlowOperations = true,
  }) {
    final stopwatch = Stopwatch()..start();

    try {
      final result = operation();
      stopwatch.stop();

      _recordTiming(operationName, stopwatch.elapsed);

      if (logSlowOperations) {
        _logSlowOperation(operationName, stopwatch.elapsed);
      }

      return result;
    } catch (e) {
      stopwatch.stop();
      _recordError(operationName, e, stopwatch.elapsed);
      rethrow;
    }
  }

  /// Măsoară utilizarea memoriei
  Future<double> measureMemoryUsage() async {
    try {
      // În Flutter web, nu avem acces direct la memory info
      // Vom folosi o aproximare bazată pe numărul de obiecte
      final estimatedMemory = _estimateMemoryUsage();

      _memoryUsage.add(estimatedMemory);
      _memoryTimestamps.add(DateTime.now());

      // Păstrează doar ultimele 100 măsurători
      if (_memoryUsage.length > 100) {
        _memoryUsage.removeAt(0);
        _memoryTimestamps.removeAt(0);
      }

      return estimatedMemory;
    } catch (e) {
      if (kDebugMode) {
        print('Memory measurement error: $e');
      }
      return 0.0;
    }
  }

  /// Returnează statistici de performanță
  Map<String, dynamic> getPerformanceStats() {
    final stats = <String, dynamic>{};

    // Statistici per operație
    for (final entry in _operationTimings.entries) {
      final operationName = entry.key;
      final timings = entry.value;

      if (timings.isNotEmpty) {
        final totalTime = timings.fold<Duration>(
          Duration.zero,
          (sum, timing) => sum + timing,
        );

        final averageTime = Duration(
          microseconds: totalTime.inMicroseconds ~/ timings.length,
        );

        final minTime = timings.reduce((a, b) => a < b ? a : b);
        final maxTime = timings.reduce((a, b) => a > b ? a : b);

        stats[operationName] = {
          'count': _operationCounts[operationName] ?? 0,
          'averageTime': averageTime.inMilliseconds,
          'minTime': minTime.inMilliseconds,
          'maxTime': maxTime.inMilliseconds,
          'totalTime': totalTime.inMilliseconds,
          'slowOperations': timings
              .where((t) => t > _slowOperationThreshold)
              .length,
          'verySlowOperations': timings
              .where((t) => t > _verySlowOperationThreshold)
              .length,
        };
      }
    }

    // Statistici memorie
    if (_memoryUsage.isNotEmpty) {
      final avgMemory =
          _memoryUsage.reduce((a, b) => a + b) / _memoryUsage.length;
      final maxMemory = _memoryUsage.reduce((a, b) => a > b ? a : b);
      final minMemory = _memoryUsage.reduce((a, b) => a < b ? a : b);

      stats['memory'] = {
        'average': avgMemory,
        'max': maxMemory,
        'min': minMemory,
        'current': _memoryUsage.isNotEmpty ? _memoryUsage.last : 0.0,
        'samples': _memoryUsage.length,
      };
    }

    return stats;
  }

  /// Returnează operațiile lente
  List<Map<String, dynamic>> getSlowOperations() {
    final slowOperations = <Map<String, dynamic>>[];

    for (final entry in _operationTimings.entries) {
      final operationName = entry.key;
      final timings = entry.value;

      final slowCount = timings
          .where((t) => t > _slowOperationThreshold)
          .length;
      final verySlowCount = timings
          .where((t) => t > _verySlowOperationThreshold)
          .length;

      if (slowCount > 0) {
        slowOperations.add({
          'operation': operationName,
          'slowCount': slowCount,
          'verySlowCount': verySlowCount,
          'totalCount': timings.length,
          'slowPercentage': (slowCount / timings.length * 100).toStringAsFixed(
            1,
          ),
        });
      }
    }

    return slowOperations;
  }

  /// Curăță istoricul de performanță
  void clearHistory() {
    _operationTimings.clear();
    _operationCounts.clear();
    _averageTimings.clear();
    _memoryUsage.clear();
    _memoryTimestamps.clear();
  }

  /// Exportă datele de performanță
  Map<String, dynamic> exportPerformanceData() {
    return {
      'timestamp': DateTime.now().toIso8601String(),
      'stats': getPerformanceStats(),
      'slowOperations': getSlowOperations(),
      'memoryHistory': _memoryUsage,
      'memoryTimestamps': _memoryTimestamps
          .map((dt) => dt.toIso8601String())
          .toList(),
    };
  }

  /// Înregistrează timpul pentru o operație
  void _recordTiming(String operationName, Duration timing) {
    if (!_operationTimings.containsKey(operationName)) {
      _operationTimings[operationName] = [];
    }

    _operationTimings[operationName]!.add(timing);
    _operationCounts[operationName] =
        (_operationCounts[operationName] ?? 0) + 1;

    // Păstrează doar ultimele 100 măsurători per operație
    if (_operationTimings[operationName]!.length > 100) {
      _operationTimings[operationName]!.removeAt(0);
    }
  }

  /// Înregistrează o eroare
  void _recordError(String operationName, dynamic error, Duration timing) {
    if (kDebugMode) {
      print(
        'Performance error in $operationName: $error (${timing.inMilliseconds}ms)',
      );
    }

    // Înregistrează și erorile în timing
    _recordTiming('${operationName}_error', timing);
  }

  /// Loghează operațiile lente
  void _logSlowOperation(String operationName, Duration timing) {
    if (timing > _verySlowOperationThreshold) {
      developer.log(
        'VERY SLOW OPERATION: $operationName took ${timing.inMilliseconds}ms',
        name: 'PerformanceService',
        level: 900, // Error level
      );
    } else if (timing > _slowOperationThreshold) {
      developer.log(
        'SLOW OPERATION: $operationName took ${timing.inMilliseconds}ms',
        name: 'PerformanceService',
        level: 800, // Warning level
      );
    }
  }

  /// Colectează metrics în background
  void _collectMetrics() {
    measureMemoryUsage();

    // Log periodic stats în debug mode
    if (kDebugMode && _operationCounts.isNotEmpty) {
      final stats = getPerformanceStats();
      final slowOps = getSlowOperations();

      if (slowOps.isNotEmpty) {
        print('Performance Alert: ${slowOps.length} slow operations detected');
        for (final op in slowOps.take(3)) {
          print(
            '  - ${op['operation']}: ${op['slowCount']} slow, ${op['slowPercentage']}%',
          );
        }
      }
    }
  }

  /// Estimează utilizarea memoriei
  double _estimateMemoryUsage() {
    // Estimare bazată pe numărul de obiecte în cache și timing history
    final cacheSize = _operationTimings.length * 100; // Estimare pentru cache
    final timingHistorySize = _operationTimings.values.fold<int>(
      0,
      (sum, timings) => sum + timings.length,
    );

    // Estimare aproximativă în MB
    return (cacheSize + timingHistorySize) / 1000.0;
  }

  /// Benchmark pentru o operație
  Future<Map<String, dynamic>> benchmarkOperation(
    String operationName,
    Future<dynamic> Function() operation, {
    int iterations = 10,
  }) async {
    final timings = <Duration>[];

    for (int i = 0; i < iterations; i++) {
      final stopwatch = Stopwatch()..start();
      await operation();
      stopwatch.stop();
      timings.add(stopwatch.elapsed);
    }

    final totalTime = timings.fold<Duration>(
      Duration.zero,
      (sum, timing) => sum + timing,
    );

    final averageTime = Duration(
      microseconds: totalTime.inMicroseconds ~/ timings.length,
    );

    final minTime = timings.reduce((a, b) => a < b ? a : b);
    final maxTime = timings.reduce((a, b) => a > b ? a : b);

    return {
      'operation': operationName,
      'iterations': iterations,
      'totalTime': totalTime.inMilliseconds,
      'averageTime': averageTime.inMilliseconds,
      'minTime': minTime.inMilliseconds,
      'maxTime': maxTime.inMilliseconds,
      'throughput': (iterations / (totalTime.inMilliseconds / 1000))
          .toStringAsFixed(2),
    };
  }
}

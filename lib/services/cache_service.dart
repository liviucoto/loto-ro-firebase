import 'dart:async';
import 'dart:convert';
import 'package:flutter/foundation.dart';
import 'package:shared_preferences/shared_preferences.dart';

/// Serviciu avansat pentru managementul cache-ului
/// Optimizează performanța prin caching inteligent
class CacheService {
  static final CacheService _instance = CacheService._internal();
  factory CacheService() => _instance;
  CacheService._internal();

  // Cache în memorie pentru acces rapid
  final Map<String, dynamic> _memoryCache = {};
  final Map<String, DateTime> _cacheTimestamps = {};
  final Map<String, int> _accessCount = {};

  // Configurații cache
  static const int _maxMemoryItems = 100;
  static const Duration _defaultExpiry = Duration(hours: 1);
  static const Duration _statisticsExpiry = Duration(hours: 24);

  // Metrics pentru monitoring
  int _hits = 0;
  int _misses = 0;
  int _evictions = 0;

  /// Adaugă o valoare în cache
  Future<void> set(String key, dynamic value, {Duration? expiry}) async {
    final expiryTime = DateTime.now().add(expiry ?? _defaultExpiry);

    _memoryCache[key] = value;
    _cacheTimestamps[key] = expiryTime;
    _accessCount[key] = 0;

    // Salvează în storage pentru persistență
    await _saveToStorage(key, value, expiryTime);

    // Cleanup dacă cache-ul este prea mare
    await _cleanupIfNeeded();
  }

  /// Obține o valoare din cache
  Future<T?> get<T>(String key) async {
    // Verifică cache-ul din memorie
    if (_memoryCache.containsKey(key)) {
      final expiry = _cacheTimestamps[key];
      if (expiry != null && DateTime.now().isBefore(expiry)) {
        _accessCount[key] = (_accessCount[key] ?? 0) + 1;
        _hits++;
        return _memoryCache[key] as T;
      } else {
        // Expirat, șterge din memorie
        _memoryCache.remove(key);
        _cacheTimestamps.remove(key);
        _accessCount.remove(key);
      }
    }

    // Încearcă din storage
    final stored = await _getFromStorage(key);
    if (stored != null) {
      _memoryCache[key] = stored['value'];
      _cacheTimestamps[key] = DateTime.parse(stored['expiry']);
      _accessCount[key] = 1;
      _hits++;
      return stored['value'] as T;
    }

    _misses++;
    return null;
  }

  /// Cache specializat pentru statistici
  Future<void> setStatistics(
    String gameType,
    String statType,
    dynamic data,
  ) async {
    final key = 'stats_${gameType}_$statType';
    await set(key, data, expiry: _statisticsExpiry);
  }

  /// Obține statistici din cache
  Future<T?> getStatistics<T>(String gameType, String statType) async {
    final key = 'stats_${gameType}_$statType';
    return get<T>(key);
  }

  /// Cache pentru predicții ML
  Future<void> setPrediction(
    String gameType,
    Map<String, dynamic> prediction,
  ) async {
    final key =
        'prediction_${gameType}_${DateTime.now().millisecondsSinceEpoch}';
    await set(key, prediction, expiry: Duration(minutes: 30));
  }

  /// Cache pentru variante generate
  Future<void> setGeneratedVariants(
    String gameType,
    List<Map<String, dynamic>> variants,
  ) async {
    final key = 'variants_${gameType}_${DateTime.now().millisecondsSinceEpoch}';
    await set(key, variants, expiry: Duration(hours: 2));
  }

  /// Cache pentru date de bază (frecvențe, pattern-uri)
  Future<void> setBaseData(
    String gameType,
    String dataType,
    dynamic data,
  ) async {
    final key = 'base_${gameType}_$dataType';
    await set(key, data, expiry: Duration(days: 7));
  }

  /// Șterge un element din cache
  Future<void> remove(String key) async {
    _memoryCache.remove(key);
    _cacheTimestamps.remove(key);
    _accessCount.remove(key);

    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('cache_$key');
  }

  /// Șterge toate elementele din cache
  Future<void> clear() async {
    _memoryCache.clear();
    _cacheTimestamps.clear();
    _accessCount.clear();

    final prefs = await SharedPreferences.getInstance();
    final keys = prefs.getKeys();
    for (final key in keys) {
      if (key.startsWith('cache_')) {
        await prefs.remove(key);
      }
    }
  }

  /// Curăță elementele expirate
  Future<void> cleanup() async {
    final now = DateTime.now();
    final expiredKeys = <String>[];

    for (final entry in _cacheTimestamps.entries) {
      if (now.isAfter(entry.value)) {
        expiredKeys.add(entry.key);
      }
    }

    for (final key in expiredKeys) {
      await remove(key);
    }
  }

  /// Optimizează cache-ul bazat pe frecvența de acces
  Future<void> optimize() async {
    if (_memoryCache.length <= _maxMemoryItems) return;

    // Sortează după frecvența de acces și timpul de expirare
    final items = _accessCount.entries.toList()
      ..sort((a, b) {
        final aFreq = a.value;
        final bFreq = b.value;
        final aExpiry = _cacheTimestamps[a.key];
        final bExpiry = _cacheTimestamps[b.key];

        // Prioritizează frecvența, apoi timpul de expirare
        if (aFreq != bFreq) return bFreq.compareTo(aFreq);
        if (aExpiry != null && bExpiry != null) {
          return aExpiry.compareTo(bExpiry);
        }
        return 0;
      });

    // Șterge elementele cu prioritate mică
    final toRemove = items.sublist(_maxMemoryItems);
    for (final item in toRemove) {
      await remove(item.key);
      _evictions++;
    }
  }

  /// Returnează statistici despre cache
  Map<String, dynamic> getStats() {
    final totalRequests = _hits + _misses;
    final hitRate = totalRequests > 0 ? (_hits / totalRequests) * 100 : 0;

    return {
      'memoryItems': _memoryCache.length,
      'hits': _hits,
      'misses': _misses,
      'hitRate': hitRate.toStringAsFixed(2),
      'evictions': _evictions,
      'totalRequests': totalRequests,
    };
  }

  /// Salvează în storage persistent
  Future<void> _saveToStorage(
    String key,
    dynamic value,
    DateTime expiry,
  ) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = {'value': value, 'expiry': expiry.toIso8601String()};
      await prefs.setString('cache_$key', jsonEncode(data));
    } catch (e) {
      if (kDebugMode) {
        print('Cache storage error: $e');
      }
    }
  }

  /// Obține din storage persistent
  Future<Map<String, dynamic>?> _getFromStorage(String key) async {
    try {
      final prefs = await SharedPreferences.getInstance();
      final data = prefs.getString('cache_$key');
      if (data != null) {
        final decoded = jsonDecode(data) as Map<String, dynamic>;
        final expiry = DateTime.parse(decoded['expiry']);

        if (DateTime.now().isBefore(expiry)) {
          return decoded;
        } else {
          // Expirat, șterge
          await prefs.remove('cache_$key');
        }
      }
    } catch (e) {
      if (kDebugMode) {
        print('Cache retrieval error: $e');
      }
    }
    return null;
  }

  /// Cleanup automat când cache-ul devine prea mare
  Future<void> _cleanupIfNeeded() async {
    if (_memoryCache.length > _maxMemoryItems) {
      await optimize();
    }
  }

  /// Preîncarcă datele importante
  Future<void> preloadImportantData() async {
    // Preîncarcă statisticile de bază
    await getStatistics('Loto_6_49', 'frequency');
    await getStatistics('Loto_5_40', 'frequency');
    await getStatistics('Joker', 'frequency');
  }

  /// Cache pentru operații costisitoare
  Future<T> cacheExpensiveOperation<T>(
    String key,
    Future<T> Function() operation, {
    Duration? expiry,
  }) async {
    final cached = await get<T>(key);
    if (cached != null) {
      return cached;
    }

    final result = await operation();
    await set(key, result, expiry: expiry);
    return result;
  }
}

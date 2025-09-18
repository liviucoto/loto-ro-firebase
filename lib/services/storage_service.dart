import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:logger/logger.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/models/game_statistics.dart';

/// Serviciu pentru persistența locală și logging avansat
class StorageService {
  static final StorageService _instance = StorageService._internal();
  factory StorageService() => _instance;
  StorageService._internal();

  late Logger _logger;
  late SharedPreferences _prefs;
  bool _initialized = false;

  /// Inițializează serviciul de storage
  Future<void> initialize() async {
    if (_initialized) return;

    // Inițializează logger-ul
    _logger = Logger(
      printer: PrettyPrinter(
        methodCount: 2,
        errorMethodCount: 8,
        lineLength: 120,
        colors: true,
        printEmojis: true,
        printTime: true,
      ),
    );

    // Inițializează SharedPreferences
    _prefs = await SharedPreferences.getInstance();

    _initialized = true;
    _logger.i('🚀 StorageService inițializat cu succes');
  }

  // ===== LOGGING AVANSAT =====

  /// Log pentru debugging AI (serializare robustă)
  void logAI(String message, {String? variant, dynamic data}) {
    dynamic serializedData;
    if (data is GameType) {
      serializedData = data.toJson();
    } else if (data is LotoDraw) {
      serializedData = data.toJson();
    } else if (data is GameStatistics) {
      serializedData = data.toJson();
    } else if (data is List) {
      serializedData = data.map((e) {
        if (e is GameType) return e.toJson();
        if (e is LotoDraw) return e.toJson();
        if (e is GameStatistics) return e.toJson();
        return e;
      }).toList();
    } else {
      serializedData = data;
    }
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'message': message,
      'variant': variant,
      'data': serializedData,
    };
    _logger.i('🤖 AI: $message', error: jsonEncode(serializedData));
    _saveLog('ai', logData);
  }

  /// Log pentru generare variante (serializare robustă)
  void logGeneration(
    dynamic gameType,
    int nVariants,
    Map<String, dynamic> params,
    List<dynamic> results,
  ) {
    dynamic serializedGameType = gameType;
    if (gameType is GameType) {
      serializedGameType = gameType.toJson();
    }
    final logData = {
      'timestamp': DateTime.now().toIso8601String(),
      'gameType': serializedGameType,
      'nVariants': nVariants,
      'params': params,
      'results': results.map((r) {
        if (r is LotoDraw) {
          return r.toJson();
        } else if (r is Map<String, dynamic>) {
          return r;
        } else {
          return r.toString();
        }
      }).toList(),
    };
    _logger.i(
      '🎲 Generare: ${serializedGameType is Map ? serializedGameType['gameType'] : serializedGameType} - $nVariants variante',
      error: jsonEncode(logData['results']),
    );
    _saveLog('generation', logData);
  }

  /// Log pentru erori
  void logError(String error, {String? context, StackTrace? stackTrace}) {
    _logger.e('❌ Eroare: $error', error: context, stackTrace: stackTrace);
    _saveLog('error', {
      'timestamp': DateTime.now().toIso8601String(),
      'error': error,
      'context': context,
    });
  }

  /// Salvează un log în storage
  void _saveLog(String type, Map<String, dynamic> logData) {
    try {
      final logs = _prefs.getStringList('logs_$type') ?? [];
      logs.add(jsonEncode(logData));

      // Limitează la ultimele 100 de loguri per tip
      if (logs.length > 100) {
        logs.removeRange(0, logs.length - 100);
      }

      _prefs.setStringList('logs_$type', logs);
    } catch (e) {
      _logger.e('Eroare la salvarea log-ului: $e');
    }
  }

  // ===== PERSISTENȚA LOCALĂ =====

  /// Salvează variantele în istoric
  Future<void> saveVariants(List<Map<String, dynamic>> variants) async {
    try {
      final variantsJson = variants.map((v) => jsonEncode(v)).toList();
      await _prefs.setStringList('saved_variants', variantsJson);
      _logger.i('💾 Salvate ${variants.length} variante în istoric');
    } catch (e) {
      _logger.e('Eroare la salvarea variantelor: $e');
    }
  }

  /// Încarcă variantele din istoric
  Future<List<Map<String, dynamic>>> loadVariants() async {
    try {
      final variantsJson = _prefs.getStringList('saved_variants') ?? [];
      final variants = variantsJson
          .map((json) => jsonDecode(json) as Map<String, dynamic>)
          .toList();

      _logger.i('📂 Încărcate ${variants.length} variante din istoric');
      return variants;
    } catch (e) {
      _logger.e('Eroare la încărcarea variantelor: $e');
      return [];
    }
  }

  /// Salvează favoritele
  Future<void> saveFavorites(List<int> favorites) async {
    try {
      await _prefs.setStringList(
        'favorites',
        favorites.map((f) => f.toString()).toList(),
      );
      _logger.i('❤️ Salvate ${favorites.length} favorite');
    } catch (e) {
      _logger.e('Eroare la salvarea favoritelor: $e');
    }
  }

  /// Încarcă favoritele
  Future<List<int>> loadFavorites() async {
    try {
      final favoritesJson = _prefs.getStringList('favorites') ?? [];
      final favorites = favoritesJson.map((f) => int.parse(f)).toList();

      _logger.i('📂 Încărcate ${favorites.length} favorite');
      return favorites;
    } catch (e) {
      _logger.e('Eroare la încărcarea favoritelor: $e');
      return [];
    }
  }

  /// Salvează setările utilizatorului
  Future<void> saveUserSettings(Map<String, dynamic> settings) async {
    try {
      final settingsJson = jsonEncode(settings);
      await _prefs.setString('user_settings', settingsJson);
      _logger.i('⚙️ Salvate setări utilizator');
    } catch (e) {
      _logger.e('Eroare la salvarea setărilor: $e');
    }
  }

  /// Încarcă setările utilizatorului
  Future<Map<String, dynamic>> loadUserSettings() async {
    try {
      final settingsJson = _prefs.getString('user_settings');
      if (settingsJson != null) {
        final settings = jsonDecode(settingsJson) as Map<String, dynamic>;
        _logger.i('📂 Încărcate setări utilizator');
        return settings;
      }
      return {};
    } catch (e) {
      _logger.e('Eroare la încărcarea setărilor: $e');
      return {};
    }
  }

  /// Salvează cache-ul AI
  Future<void> saveAICache(String key, Map<String, dynamic> data) async {
    try {
      final cacheJson = jsonEncode(data);
      await _prefs.setString('ai_cache_$key', cacheJson);
      _logger.i('🧠 Salvat cache AI pentru cheia: $key');
    } catch (e) {
      _logger.e('Eroare la salvarea cache-ului AI: $e');
    }
  }

  /// Încarcă cache-ul AI
  Future<Map<String, dynamic>?> loadAICache(String key) async {
    try {
      final cacheJson = _prefs.getString('ai_cache_$key');
      if (cacheJson != null) {
        final cache = jsonDecode(cacheJson) as Map<String, dynamic>;
        _logger.i('🧠 Încărcat cache AI pentru cheia: $key');
        return cache;
      }
      return null;
    } catch (e) {
      _logger.e('Eroare la încărcarea cache-ului AI: $e');
      return null;
    }
  }

  /// Șterge cache-ul AI
  Future<void> clearAICache() async {
    try {
      final keys = _prefs.getKeys();
      final aiCacheKeys = keys.where((key) => key.startsWith('ai_cache_'));

      for (final key in aiCacheKeys) {
        await _prefs.remove(key);
      }

      _logger.i('🧹 Cache AI șters');
    } catch (e) {
      _logger.e('Eroare la ștergerea cache-ului AI: $e');
    }
  }

  // ===== UTILITĂȚI =====

  /// Obține toate logurile pentru debugging
  List<Map<String, dynamic>> getLogs(String type) {
    try {
      final logs = _prefs.getStringList('logs_$type') ?? [];
      return logs
          .map((log) => jsonDecode(log) as Map<String, dynamic>)
          .toList();
    } catch (e) {
      _logger.e('Eroare la obținerea logurilor: $e');
      return [];
    }
  }

  /// Șterge toate logurile
  Future<void> clearLogs() async {
    try {
      final keys = _prefs.getKeys();
      final logKeys = keys.where((key) => key.startsWith('logs_'));

      for (final key in logKeys) {
        await _prefs.remove(key);
      }

      _logger.i('🧹 Loguri șterse');
    } catch (e) {
      _logger.e('Eroare la ștergerea logurilor: $e');
    }
  }

  /// Obține statistici despre storage
  Map<String, dynamic> getStorageStats() {
    try {
      final keys = _prefs.getKeys();
      final stats = <String, dynamic>{};

      stats['total_keys'] = keys.length;
      stats['saved_variants'] =
          _prefs.getStringList('saved_variants')?.length ?? 0;
      stats['favorites'] = _prefs.getStringList('favorites')?.length ?? 0;
      stats['ai_cache_keys'] = keys
          .where((key) => key.startsWith('ai_cache_'))
          .length;
      stats['log_types'] = keys
          .where((key) => key.startsWith('logs_'))
          .map((key) => key.replaceFirst('logs_', ''))
          .toList();

      return stats;
    } catch (e) {
      _logger.e('Eroare la obținerea statisticilor: $e');
      return {};
    }
  }

  /// Exportă datele pentru backup
  Future<Map<String, dynamic>> exportData() async {
    try {
      final data = <String, dynamic>{};
      final keys = _prefs.getKeys();

      for (final key in keys) {
        final value = _prefs.get(key);
        if (value != null) {
          data[key] = value;
        }
      }

      _logger.i('📤 Exportat ${data.length} chei de date');
      return data;
    } catch (e) {
      _logger.e('Eroare la exportul datelor: $e');
      return {};
    }
  }

  /// Importă datele din backup
  Future<void> importData(Map<String, dynamic> data) async {
    try {
      for (final entry in data.entries) {
        final key = entry.key;
        final value = entry.value;

        if (value is String) {
          await _prefs.setString(key, value);
        } else if (value is List<String>) {
          await _prefs.setStringList(key, value);
        } else if (value is bool) {
          await _prefs.setBool(key, value);
        } else if (value is int) {
          await _prefs.setInt(key, value);
        } else if (value is double) {
          await _prefs.setDouble(key, value);
        }
      }

      _logger.i('📥 Importat ${data.length} chei de date');
    } catch (e) {
      _logger.e('Eroare la importul datelor: $e');
    }
  }
}

import 'package:flutter/foundation.dart';
import 'package:flutter/services.dart';
import '../models/loto_draw.dart';
import '../models/game_statistics.dart';
import '../utils/constants.dart';
import 'cache_service.dart';
import 'performance_service.dart';

/// Interfa?a pentru serviciul de date (pentru testare / DI)
abstract class IDataService {
  Future<List<LotoDraw>> loadDraws(GameType gameType);
  Future<GameStatistics> loadStatistics(GameType gameType);
  Future<void> clearCache(GameType gameType);
  Future<void> clearAllCache();
  Map<String, dynamic> getPerformanceStats();
}

/// Serviciu pentru gestionarea datelor ?i statisticilor
/// Optimizat cu cache ?i performance monitoring
class DataService implements IDataService {
  static final DataService _instance = DataService._internal();
  factory DataService() => _instance;
  DataService._internal() {
    // Cura?am cache-ul la ini?ializare pentru a evita problemele de tip
    clearAllCache();
  }

  final CacheService _cacheService = CacheService();
  final PerformanceService _performanceService = PerformanceService();

  // (Note) Caching persistent se face prin CacheService; cache în memorie eliminat pentru simplitate.

  /// Încarca datele pentru un joc specific
  @override
  Future<List<LotoDraw>> loadDraws(GameType gameType) async {
    return _performanceService.measureOperation(
      'loadDraws_${gameType.key}',
      () async {
        // Verifica cache-ul - dar sa fie sigur ca tipul este corect
        try {
          final cached = await _cacheService.getStatistics<List<LotoDraw>>(
            gameType.key,
            'draws',
          );
          if (cached != null && cached.isNotEmpty && cached is List<LotoDraw>) {
            return cached;
          }
        } catch (e) {
          // Daca cache-ul are probleme, îl cura?am
          await _cacheService.remove('${gameType.key}_draws');
        }

        // Încarca din fi?ier
        final draws = await _loadDrawsFromFile(gameType);

        // Salveaza în cache
        await _cacheService.setStatistics(gameType.key, 'draws', draws);

        return draws;
      },
    );
  }

  /// Încarca statisticile pentru un joc specific
  @override
  Future<GameStatistics> loadStatistics(GameType gameType) async {
    return _performanceService.measureOperation(
      'loadStatistics_${gameType.key}',
      () async {
        // Verifica cache-ul
        final cached = await _cacheService.getStatistics<GameStatistics>(
          gameType.key,
          'statistics',
        );
        if (cached != null) {
          return cached;
        }

        // Încarca datele ?i calculeaza statisticile
        final draws = await loadDraws(gameType);
        final statistics = GameStatistics.fromDraws(draws, gameType);

        // Salveaza în cache
        await _cacheService.setStatistics(
          gameType.key,
          'statistics',
          statistics,
        );

        return statistics;
      },
    );
  }

  /// Încarca datele din fi?ier CSV
  Future<List<LotoDraw>> _loadDrawsFromFile(GameType gameType) async {
    return _performanceService.measureOperation(
      'loadDrawsFromFile_${gameType.key}',
      () async {
        try {
          // Încarca datele reale din fi?ierul CSV
          final String csvContent = await rootBundle.loadString(
            'assets/data/Arhiva_${_getCsvFileName(gameType)}.csv',
          );

          final draws = _parseCsvData(csvContent, gameType);

          if (kDebugMode) {
            print('? Loaded ${draws.length} real draws for ${gameType.key}');
            if (draws.isNotEmpty) {
              print(
                '?? First draw: ${draws.first.date} - ${draws.first.mainNumbers}',
              );
              print(
                '?? Last draw: ${draws.last.date} - ${draws.last.mainNumbers}',
              );
            }
          }

          return draws;
        } catch (e) {
          if (kDebugMode) {
            print('Error loading CSV for ${gameType.key}: $e');
            print('Falling back to test data');
          }
          // Fallback la date de test doar daca CSV nu exista
          return _generateTestData(gameType);
        }
      },
    );
  }

  /// Returneaza numele corect al fi?ierului CSV pentru fiecare joc
  String _getCsvFileName(GameType gameType) {
    switch (gameType) {
      case GameType.joker:
        return 'Joker';
      case GameType.loto649:
        return 'Loto_6_din_49';
      case GameType.loto540:
        return 'Loto_5_din_40';
    }
  }

  /// Parseaza datele CSV ?i le converte?te în LotoDraw
  List<LotoDraw> _parseCsvData(String csvContent, GameType gameType) {
    final lines = csvContent.split('\n');
    final draws = <LotoDraw>[];

    for (int i = 1; i < lines.length; i++) {
      // Skip header
      final line = lines[i].trim();
      if (line.isEmpty) continue;

      try {
        final values = line.split(',');
        if (values.length < 6) continue; // Skip invalid lines

        final Map<String, dynamic> rowData = {
          'data': values[0],
          'numar_1': values[1],
          'numar_2': values[2],
          'numar_3': values[3],
          'numar_4': values[4],
          'numar_5': values[5],
        };

        // Adauga numarul 6 pentru Loto 6 din 49
        if (gameType == GameType.loto649 && values.length > 6) {
          rowData['numar_6'] = values[6];
        }

        // Adauga Joker pentru Joker
        if (gameType == GameType.joker && values.length > 6) {
          rowData['joker'] = values[6];
        }

        final draw = LotoDraw.fromCsvRow(rowData, gameType.key);
        draws.add(draw);
      } catch (e) {
        if (kDebugMode) {
          print('Error parsing CSV line $i: $e');
        }
        continue; // Skip invalid lines
      }
    }

    return draws;
  }

  /// Genereaza date de test pentru demonstra?ie
  List<LotoDraw> _generateTestData(GameType gameType) {
    final draws = <LotoDraw>[];
    final now = DateTime.now();

    // Genereaza 100 de extrageri de test
    for (int i = 0; i < 100; i++) {
      final date = now.subtract(Duration(days: i * 3));
      List<int> numbers;

      switch (gameType) {
        case GameType.loto649:
          numbers = _generateRandomNumbers(6, 1, 49);
          break;
        case GameType.loto540:
          numbers = _generateRandomNumbers(5, 1, 40);
          break;
        case GameType.joker:
          // Conform config actualizat ?i testelor: Joker folose?te 40 numere principale
          numbers = _generateRandomNumbers(5, 1, 40);
          break;
      }

      draws.add(
        LotoDraw(
          date: date,
          mainNumbers: numbers,
          gameType: gameType.key,
          jokerNumber: gameType == GameType.joker
              ? _generateRandomNumbers(1, 1, 20).first
              : null,
        ),
      );
    }

    return draws;
  }

  /// Genereaza numere aleatorii
  List<int> _generateRandomNumbers(int count, int min, int max) {
    final numbers = <int>{};
    while (numbers.length < count) {
      numbers.add(
        min + (DateTime.now().millisecondsSinceEpoch % (max - min + 1)),
      );
    }
    return numbers.toList()..sort();
  }

  /// Determina sezonul pentru distribu?ia temporala

  /// Cura?a cache-ul pentru un joc specific
  @override
  Future<void> clearCache(GameType gameType) async {
    await _cacheService.remove('stats_${gameType.key}_draws');
    await _cacheService.remove('stats_${gameType.key}_statistics');
  }

  /// Cura?a tot cache-ul
  @override
  Future<void> clearAllCache() async {
    await _cacheService.clear();
  }

  /// Returneaza statistici de performan?a
  @override
  Map<String, dynamic> getPerformanceStats() {
    return _performanceService.getPerformanceStats();
  }
}

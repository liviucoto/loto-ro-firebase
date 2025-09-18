import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/services/cache_service.dart';

/// Serviciu centralizat pentru calculele de statistici
/// Elimină codul duplicat din secțiunile de chart păstrând analizele narative
class StatisticsCalculationService {
  static final StatisticsCalculationService _instance =
      StatisticsCalculationService._internal();
  factory StatisticsCalculationService() => _instance;
  StatisticsCalculationService._internal();

  final CacheService _cacheService = CacheService();

  /// Calculează statisticile de bază pentru o listă de extrageri
  /// Returnează un map cu toate statisticile necesare pentru afișare
  Map<String, dynamic> calculateBasicStatistics(List<LotoDraw> draws) {
    if (draws.isEmpty) {
      return {
        'totalDraws': 0,
        'avgFreq': 0.0,
        'maxFreq': 0,
        'minFreq': 0,
        'avgSum': 0.0,
        'minSum': 0.0,
        'maxSum': 0.0,
        'avgSmall': 0.0,
        'avgLarge': 0.0,
        'periods': 0,
        'numbers': 0,
        'empty': true,
      };
    }

    // Calculez frecvența numerelor
    final Map<int, int> freqMap = {};
    for (final draw in draws) {
      for (final n in draw.mainNumbers) {
        freqMap[n] = (freqMap[n] ?? 0) + 1;
      }
    }

    // Statistici frecvență
    final allFreqs = freqMap.values.toList();
    final avgFreq = allFreqs.isNotEmpty
        ? allFreqs.reduce((a, b) => a + b) / allFreqs.length
        : 0.0;
    final maxFreq = allFreqs.isNotEmpty
        ? allFreqs.reduce((a, b) => a > b ? a : b)
        : 0;
    final minFreq = allFreqs.isNotEmpty
        ? allFreqs.reduce((a, b) => a < b ? a : b)
        : 0;

    // Statistici sumă
    final List<double> sums = draws.map((d) => d.sum.toDouble()).toList();
    final avgSum = sums.isNotEmpty
        ? sums.reduce((a, b) => a + b) / sums.length
        : 0.0;
    final minSum = sums.isNotEmpty ? sums.reduce((a, b) => a < b ? a : b) : 0.0;
    final maxSum = sums.isNotEmpty ? sums.reduce((a, b) => a > b ? a : b) : 0.0;

    // Statistici sumă mică/mare
    final smallSums = sums.where((s) => s < avgSum).toList();
    final largeSums = sums.where((s) => s >= avgSum).toList();
    final avgSmall = smallSums.isNotEmpty
        ? smallSums.reduce((a, b) => a + b) / smallSums.length
        : 0.0;
    final avgLarge = largeSums.isNotEmpty
        ? largeSums.reduce((a, b) => a + b) / largeSums.length
        : 0.0;

    // Statistici perioade și numere
    final periods = draws.map((d) => d.date).toSet().length;
    final numbers = draws.expand((d) => d.mainNumbers).toSet().length;

    return {
      'totalDraws': draws.length,
      'avgFreq': avgFreq,
      'maxFreq': maxFreq,
      'minFreq': minFreq,
      'avgSum': avgSum,
      'minSum': minSum,
      'maxSum': maxSum,
      'avgSmall': avgSmall,
      'avgLarge': avgLarge,
      'periods': periods,
      'numbers': numbers,
      'empty': false,
    };
  }

  /// Calculează statisticile pentru numerele Joker
  Map<String, dynamic> calculateJokerStatistics(List<LotoDraw> draws) {
    if (draws.isEmpty) {
      return {
        'totalDraws': 0,
        'avgFreq': 0.0,
        'maxFreq': 0,
        'minFreq': 0,
        'empty': true,
      };
    }

    final Map<int, int> jokerFreq = {};
    for (final draw in draws) {
      if (draw.jokerNumber != null) {
        jokerFreq[draw.jokerNumber!] = (jokerFreq[draw.jokerNumber!] ?? 0) + 1;
      }
    }

    if (jokerFreq.isEmpty) {
      return {
        'totalDraws': 0,
        'avgFreq': 0.0,
        'maxFreq': 0,
        'minFreq': 0,
        'empty': true,
      };
    }

    final allFreqs = jokerFreq.values.toList();
    final avgFreq = allFreqs.isNotEmpty
        ? allFreqs.reduce((a, b) => a + b) / allFreqs.length
        : 0.0;
    final maxFreq = allFreqs.isNotEmpty
        ? allFreqs.reduce((a, b) => a > b ? a : b)
        : 0;
    final minFreq = allFreqs.isNotEmpty
        ? allFreqs.reduce((a, b) => a < b ? a : b)
        : 0;

    return {
      'totalDraws': draws.length,
      'avgFreq': avgFreq,
      'maxFreq': maxFreq,
      'minFreq': minFreq,
      'empty': false,
    };
  }

  /// Calculează statisticile anotimpurilor
  Map<String, dynamic> calculateSeasonStatistics(List<LotoDraw> draws) {
    if (draws.isEmpty) {
      return {
        'spring': 0,
        'summer': 0,
        'autumn': 0,
        'winter': 0,
        'springPct': '0',
        'summerPct': '0',
        'autumnPct': '0',
        'winterPct': '0',
        'empty': true,
      };
    }

    Map<String, int> seasonCount = {
      'Primăvară': 0,
      'Vară': 0,
      'Toamnă': 0,
      'Iarnă': 0,
    };

    for (final draw in draws) {
      final m = draw.date.month;
      if ([3, 4, 5].contains(m)) {
        seasonCount['Primăvară'] = seasonCount['Primăvară']! + 1;
      } else if ([6, 7, 8].contains(m)) {
        seasonCount['Vară'] = seasonCount['Vară']! + 1;
      } else if ([9, 10, 11].contains(m)) {
        seasonCount['Toamnă'] = seasonCount['Toamnă']! + 1;
      } else {
        seasonCount['Iarnă'] = seasonCount['Iarnă']! + 1;
      }
    }

    final totalSeasons = seasonCount.values.reduce((a, b) => a + b);
    final springPct = totalSeasons > 0
        ? (seasonCount['Primăvară']! * 100 / totalSeasons).toStringAsFixed(1)
        : '0';
    final summerPct = totalSeasons > 0
        ? (seasonCount['Vară']! * 100 / totalSeasons).toStringAsFixed(1)
        : '0';
    final autumnPct = totalSeasons > 0
        ? (seasonCount['Toamnă']! * 100 / totalSeasons).toStringAsFixed(1)
        : '0';
    final winterPct = totalSeasons > 0
        ? (seasonCount['Iarnă']! * 100 / totalSeasons).toStringAsFixed(1)
        : '0';

    return {
      'spring': seasonCount['Primăvară']!,
      'summer': seasonCount['Vară']!,
      'autumn': seasonCount['Toamnă']!,
      'winter': seasonCount['Iarnă']!,
      'springPct': springPct,
      'summerPct': summerPct,
      'autumnPct': autumnPct,
      'winterPct': winterPct,
      'empty': false,
    };
  }

  /// Calculează statisticile pentru numerele Joker cu anotimpuri
  Map<String, dynamic> calculateJokerSeasonStatistics(List<LotoDraw> draws) {
    if (draws.isEmpty) {
      return {
        'spring': 0,
        'summer': 0,
        'autumn': 0,
        'winter': 0,
        'springPct': '0',
        'summerPct': '0',
        'autumnPct': '0',
        'winterPct': '0',
        'empty': true,
      };
    }

    final drawsWithJoker = draws.where((d) => d.jokerNumber != null).toList();
    if (drawsWithJoker.isEmpty) {
      return {
        'spring': 0,
        'summer': 0,
        'autumn': 0,
        'winter': 0,
        'springPct': '0',
        'summerPct': '0',
        'autumnPct': '0',
        'winterPct': '0',
        'empty': true,
      };
    }

    Map<String, int> jokerSeasonCount = {
      'Primăvară': 0,
      'Vară': 0,
      'Toamnă': 0,
      'Iarnă': 0,
    };

    for (final draw in drawsWithJoker) {
      final m = draw.date.month;
      if ([3, 4, 5].contains(m)) {
        jokerSeasonCount['Primăvară'] = jokerSeasonCount['Primăvară']! + 1;
      } else if ([6, 7, 8].contains(m)) {
        jokerSeasonCount['Vară'] = jokerSeasonCount['Vară']! + 1;
      } else if ([9, 10, 11].contains(m)) {
        jokerSeasonCount['Toamnă'] = jokerSeasonCount['Toamnă']! + 1;
      } else {
        jokerSeasonCount['Iarnă'] = jokerSeasonCount['Iarnă']! + 1;
      }
    }

    final totalJokerSeasons = jokerSeasonCount.values.reduce((a, b) => a + b);
    final jokerSpringPct = totalJokerSeasons > 0
        ? (jokerSeasonCount['Primăvară']! * 100 / totalJokerSeasons)
              .toStringAsFixed(1)
        : '0';
    final jokerSummerPct = totalJokerSeasons > 0
        ? (jokerSeasonCount['Vară']! * 100 / totalJokerSeasons).toStringAsFixed(
            1,
          )
        : '0';
    final jokerAutumnPct = totalJokerSeasons > 0
        ? (jokerSeasonCount['Toamnă']! * 100 / totalJokerSeasons)
              .toStringAsFixed(1)
        : '0';
    final jokerWinterPct = totalJokerSeasons > 0
        ? (jokerSeasonCount['Iarnă']! * 100 / totalJokerSeasons)
              .toStringAsFixed(1)
        : '0';

    return {
      'spring': jokerSeasonCount['Primăvară']!,
      'summer': jokerSeasonCount['Vară']!,
      'autumn': jokerSeasonCount['Toamnă']!,
      'winter': jokerSeasonCount['Iarnă']!,
      'springPct': jokerSpringPct,
      'summerPct': jokerSummerPct,
      'autumnPct': jokerAutumnPct,
      'winterPct': jokerWinterPct,
      'empty': false,
    };
  }

  /// Calculează frecvența numerelor cu caching
  Future<Map<int, int>> calculateFrequencyWithCache(
    List<LotoDraw> draws,
    int mainRange,
  ) async {
    final cacheKey =
        'freq_${draws.length}_${mainRange}_${draws.isNotEmpty ? draws.first.date.millisecondsSinceEpoch : 0}';

    // Încearcă să recuperezi din cache
    final cached = await _cacheService.get<Map>(cacheKey);
    if (cached != null) {
      return Map<int, int>.from(cached);
    }

    // Calculează frecvența
    final Map<int, int> freq = {for (var i = 1; i <= mainRange; i++) i: 0};
    for (final draw in draws) {
      for (final n in draw.mainNumbers) {
        if (n >= 1 && n <= mainRange) {
          freq[n] = (freq[n] ?? 0) + 1;
        }
      }
    }

    // Salvează în cache ca Map<String, int> pentru serializare
    final serializableFreq = freq.map((k, v) => MapEntry(k.toString(), v));
    await _cacheService.set(
      cacheKey,
      serializableFreq,
      expiry: Duration(hours: 1),
    );

    return freq;
  }

  /// Calculează frecvența numerelor Joker cu caching
  Future<Map<int, int>> calculateJokerFrequencyWithCache(
    List<LotoDraw> draws,
    int jokerRange,
  ) async {
    final cacheKey =
        'joker_freq_${draws.length}_${jokerRange}_${draws.isNotEmpty ? draws.first.date.millisecondsSinceEpoch : 0}';

    // Încearcă să recuperezi din cache
    final cached = await _cacheService.get<Map>(cacheKey);
    if (cached != null) {
      return Map<int, int>.from(cached);
    }

    // Calculează frecvența Joker
    final Map<int, int> freq = {for (int n = 1; n <= jokerRange; n++) n: 0};
    for (final draw in draws) {
      if (draw.jokerNumber != null &&
          draw.jokerNumber! >= 1 &&
          draw.jokerNumber! <= jokerRange) {
        freq[draw.jokerNumber!] = (freq[draw.jokerNumber!] ?? 0) + 1;
      }
    }

    // Salvează în cache ca Map<String, int> pentru serializare
    final serializableFreq = freq.map((k, v) => MapEntry(k.toString(), v));
    await _cacheService.set(
      cacheKey,
      serializableFreq,
      expiry: Duration(hours: 1),
    );

    return freq;
  }

  /// Calculează statisticile complete pentru o secțiune de chart
  /// Această metodă combină toate calculele de mai sus într-un singur apel
  Map<String, dynamic> calculateCompleteStatistics(
    List<LotoDraw> draws,
    GameType gameType,
  ) {
    final basicStats = calculateBasicStatistics(draws);
    final seasonStats = calculateSeasonStatistics(draws);

    Map<String, dynamic> result = {...basicStats, 'seasonStats': seasonStats};

    // Adaugă statisticile Joker dacă este cazul
    if (gameType == GameType.joker) {
      final jokerStats = calculateJokerStatistics(draws);
      final jokerSeasonStats = calculateJokerSeasonStatistics(draws);
      result['jokerStats'] = jokerStats;
      result['jokerSeasonStats'] = jokerSeasonStats;
    }

    return result;
  }

  /// Curăță cache-ul pentru statistici
  void clearStatisticsCache() {
    _cacheService.clear();
  }
}

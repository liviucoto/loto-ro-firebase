import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/widgets/glass_card.dart';
import '../../../../../widgets/period_selector_glass.dart';
import '../../../../../widgets/statistics_temporal_chart.dart';
import 'dart:math';
import 'temporal_narrative.dart';
import '../../../../../services/statistics_calculation_service.dart';

// Funcții de top-level pentru dialog și calcul narativ
Map<String, dynamic> calculateTemporalChartNarrative(List<LotoDraw> draws) {
  if (draws.isEmpty) {
    return {
      'mostVariableNumber': '-',
      'leastVariableNumber': '-',
      'top3Variable': [],
      'top3Stable': [],
      'temporalPattern': '-',
      'mostFrequentPeriod': '-',
      'leastFrequentPeriod': '-',
      'trend': '-',
      'dominantSeason': '-',
      'drawCount': 0,
      'periodCount': 0,
      'numberCount': 0,
      // Statistici Joker
      'jokerMostVariableNumber': '-',
      'jokerLeastVariableNumber': '-',
      'jokerTop3Variable': [],
      'jokerTop3Stable': [],
      'jokerTemporalPattern': '-',
      'jokerMostFrequentPeriod': '-',
      'jokerLeastFrequentPeriod': '-',
      'jokerTrend': '-',
      'jokerDominantSeason': '-',
      'jokerDrawCount': 0,
      'jokerPeriodCount': 0,
      'jokerNumberCount': 0,
    };
  }

  // OPTIMIZARE: Agregare rapidă pe o singură trecere
  final Map<String, Map<int, int>> freqPerPeriod =
      {}; // perioada -> numar -> count
  final Map<String, Map<int, int>> jokerFreqPerPeriod =
      {}; // perioada -> joker -> count
  final Map<String, int> periodTotals =
      {}; // perioada -> total numere principale
  final Map<String, int> jokerPeriodTotals = {}; // perioada -> total joker
  final Map<String, int> seasonCount = {
    'Primăvară': 0,
    'Vară': 0,
    'Toamnă': 0,
    'Iarnă': 0,
  };
  final Map<String, int> jokerSeasonCount = {
    'Primăvară': 0,
    'Vară': 0,
    'Toamnă': 0,
    'Iarnă': 0,
  };
  final Set<int> mainNumbers = {};
  final Set<int> jokerNumbers = {};
  final Set<String> periodKeys = {};

  for (final d in draws) {
    final period = '${d.date.year}-${d.date.month.toString().padLeft(2, '0')}';
    periodKeys.add(period);
    // principale
    if (!freqPerPeriod.containsKey(period)) freqPerPeriod[period] = {};
    if (!periodTotals.containsKey(period)) periodTotals[period] = 0;
    for (final n in d.mainNumbers) {
      freqPerPeriod[period]![n] = (freqPerPeriod[period]![n] ?? 0) + 1;
      periodTotals[period] = periodTotals[period]! + 1;
      mainNumbers.add(n);
    }
    // anotimp principal
    final m = d.date.month;
    if ([3, 4, 5].contains(m)) {
      seasonCount['Primăvară'] = seasonCount['Primăvară']! + 1;
    } else if ([6, 7, 8].contains(m))
      seasonCount['Vară'] = seasonCount['Vară']! + 1;
    else if ([9, 10, 11].contains(m))
      seasonCount['Toamnă'] = seasonCount['Toamnă']! + 1;
    else
      seasonCount['Iarnă'] = seasonCount['Iarnă']! + 1;
    // Joker
    if (d.jokerNumber != null) {
      jokerNumbers.add(d.jokerNumber!);
      if (!jokerFreqPerPeriod.containsKey(period)) {
        jokerFreqPerPeriod[period] = {};
      }
      jokerFreqPerPeriod[period]![d.jokerNumber!] =
          (jokerFreqPerPeriod[period]![d.jokerNumber!] ?? 0) + 1;
      jokerPeriodTotals[period] = (jokerPeriodTotals[period] ?? 0) + 1;
      // anotimp joker
      if ([3, 4, 5].contains(m)) {
        jokerSeasonCount['Primăvară'] = jokerSeasonCount['Primăvară']! + 1;
      } else if ([6, 7, 8].contains(m))
        jokerSeasonCount['Vară'] = jokerSeasonCount['Vară']! + 1;
      else if ([9, 10, 11].contains(m))
        jokerSeasonCount['Toamnă'] = jokerSeasonCount['Toamnă']! + 1;
      else
        jokerSeasonCount['Iarnă'] = jokerSeasonCount['Iarnă']! + 1;
    }
  }
  final sortedPeriods = periodKeys.toList()..sort();

  // === Statistici principale ===
  // Variabilitate pe număr
  Map<int, List<int>> numarPePerioada = {for (var n in mainNumbers) n: []};
  for (final p in sortedPeriods) {
    for (final n in mainNumbers) {
      numarPePerioada[n]!.add(freqPerPeriod[p]?[n] ?? 0);
    }
  }
  Map<int, num> variations = {};
  for (final n in mainNumbers) {
    final values = numarPePerioada[n]!;
    if (values.length > 1) {
      final mean = values.reduce((a, b) => a + b) / values.length;
      final variance =
          values.map((f) => (f - mean) * (f - mean)).reduce((a, b) => a + b) /
          values.length;
      final num stdDev = mean > 0 ? sqrt(variance.abs()) : 0;
      final cv = mean > 0 ? (stdDev.toDouble() / mean) * 100 : 0;
      variations[n] = cv;
    }
  }
  int? mostVar = variations.isNotEmpty
      ? variations.entries.reduce((a, b) => a.value > b.value ? a : b).key
      : null;
  int? leastVar = variations.isNotEmpty
      ? variations.entries.reduce((a, b) => a.value < b.value ? a : b).key
      : null;
  final sortedVar = variations.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final sortedStable = variations.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value));
  final top3Var = sortedVar.take(3).map((e) => e.key).toList();
  final top3Stable = sortedStable.take(3).map((e) => e.key).toList();
  String mostFreqPeriod = periodTotals.isNotEmpty
      ? periodTotals.entries.reduce((a, b) => a.value > b.value ? a : b).key
      : '-';
  String leastFreqPeriod = periodTotals.isNotEmpty
      ? periodTotals.entries.reduce((a, b) => a.value < b.value ? a : b).key
      : '-';
  final periodTotalVals = periodTotals.values.toList();
  String trend = '-';
  if (periodTotalVals.length > 1) {
    final firstHalf = periodTotalVals
        .take((periodTotalVals.length / 2).floor())
        .toList();
    final secondHalf = periodTotalVals
        .skip((periodTotalVals.length / 2).floor())
        .toList();
    if (firstHalf.isNotEmpty && secondHalf.isNotEmpty) {
      final firstSum = firstHalf.reduce((a, b) => a + b);
      final secondSum = secondHalf.reduce((a, b) => a + b);
      trend = (secondSum > firstSum) ? 'Crescător' : 'Descrescător';
    }
  }
  String dominantSeason = seasonCount.values.any((v) => v > 0)
      ? seasonCount.entries.reduce((a, b) => a.value > b.value ? a : b).key
      : '-';

  // === Statistici Joker ===
  Map<int, List<int>> jokerNumarPePerioada = {
    for (var n in jokerNumbers) n: [],
  };
  for (final p in sortedPeriods) {
    for (final n in jokerNumbers) {
      jokerNumarPePerioada[n]!.add(jokerFreqPerPeriod[p]?[n] ?? 0);
    }
  }
  Map<int, num> jokerVariations = {};
  for (final n in jokerNumbers) {
    final values = jokerNumarPePerioada[n]!;
    if (values.length > 1) {
      final mean = values.reduce((a, b) => a + b) / values.length;
      final variance =
          values.map((f) => (f - mean) * (f - mean)).reduce((a, b) => a + b) /
          values.length;
      final num stdDev = mean > 0 ? sqrt(variance.abs()) : 0;
      final cv = mean > 0 ? (stdDev.toDouble() / mean) * 100 : 0;
      jokerVariations[n] = cv;
    }
  }
  int? jokerMostVar = jokerVariations.isNotEmpty
      ? jokerVariations.entries.reduce((a, b) => a.value > b.value ? a : b).key
      : null;
  int? jokerLeastVar = jokerVariations.isNotEmpty
      ? jokerVariations.entries.reduce((a, b) => a.value < b.value ? a : b).key
      : null;
  final jokerSortedVar = jokerVariations.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final jokerSortedStable = jokerVariations.entries.toList()
    ..sort((a, b) => a.value.compareTo(b.value));
  final jokerTop3Var = jokerSortedVar.take(3).map((e) => e.key).toList();
  final jokerTop3Stable = jokerSortedStable.take(3).map((e) => e.key).toList();
  String jokerMostFreqPeriod = jokerPeriodTotals.isNotEmpty
      ? jokerPeriodTotals.entries
            .reduce((a, b) => a.value > b.value ? a : b)
            .key
      : '-';
  String jokerLeastFreqPeriod = jokerPeriodTotals.isNotEmpty
      ? jokerPeriodTotals.entries
            .reduce((a, b) => a.value < b.value ? a : b)
            .key
      : '-';
  final jokerPeriodTotalVals = jokerPeriodTotals.values.toList();
  String jokerTrend = '-';
  if (jokerPeriodTotalVals.length > 1) {
    final firstHalf = jokerPeriodTotalVals
        .take((jokerPeriodTotalVals.length / 2).floor())
        .toList();
    final secondHalf = jokerPeriodTotalVals
        .skip((jokerPeriodTotalVals.length / 2).floor())
        .toList();
    if (firstHalf.isNotEmpty && secondHalf.isNotEmpty) {
      final firstSum = firstHalf.reduce((a, b) => a + b);
      final secondSum = secondHalf.reduce((a, b) => a + b);
      jokerTrend = (secondSum > firstSum) ? 'Crescător' : 'Descrescător';
    }
  }
  String jokerDominantSeason = jokerSeasonCount.values.any((v) => v > 0)
      ? jokerSeasonCount.entries.reduce((a, b) => a.value > b.value ? a : b).key
      : '-';

  return {
    'mostVariableNumber': mostVar?.toString() ?? '-',
    'leastVariableNumber': leastVar?.toString() ?? '-',
    'top3Variable': top3Var,
    'top3Stable': top3Stable,
    'temporalPattern': variations.isNotEmpty && mostVar != null
        ? 'variabilitate ${(variations[mostVar]!.toDouble()).toStringAsFixed(1)}%'
        : '-',
    'mostFrequentPeriod': mostFreqPeriod,
    'leastFrequentPeriod': leastFreqPeriod,
    'trend': trend,
    'dominantSeason': dominantSeason,
    'drawCount': draws.length,
    'periodCount': sortedPeriods.length,
    'numberCount': mainNumbers.length,
    // Statistici Joker
    'jokerMostVariableNumber': jokerMostVar?.toString() ?? '-',
    'jokerLeastVariableNumber': jokerLeastVar?.toString() ?? '-',
    'jokerTop3Variable': jokerTop3Var,
    'jokerTop3Stable': jokerTop3Stable,
    'jokerTemporalPattern': jokerVariations.isNotEmpty && jokerMostVar != null
        ? 'variabilitate ${(jokerVariations[jokerMostVar]!.toDouble()).toStringAsFixed(1)}%'
        : '-',
    'jokerMostFrequentPeriod': jokerMostFreqPeriod,
    'jokerLeastFrequentPeriod': jokerLeastFreqPeriod,
    'jokerTrend': jokerTrend,
    'jokerDominantSeason': jokerDominantSeason,
    'jokerDrawCount': jokerNumbers.isEmpty
        ? 0
        : jokerPeriodTotalVals.reduce((a, b) => a + b),
    'jokerPeriodCount': sortedPeriods.length,
    'jokerNumberCount': jokerNumbers.length,
  };
}

/// Secțiunea completă pentru graficul temporal
class TemporalChartSection extends StatelessWidget {
  final List<LotoDraw> statsDraws;
  final List<LotoDraw> allDraws; // Datele complete pentru dialog
  final String selectedPeriod;
  final List<String> periodOptions;
  final Function(String) onPeriodChanged;
  final ValueChanged<String>? onCustomPeriod;
  final bool isDesktop;
  final GameType selectedGame;
  final Map<String, dynamic>? temporalNarrative;
  final bool isProcessingTemporal;

  const TemporalChartSection({
    super.key,
    required this.statsDraws,
    required this.allDraws,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.onPeriodChanged,
    required this.onCustomPeriod,
    required this.isDesktop,
    required this.selectedGame,
    required this.temporalNarrative,
    required this.isProcessingTemporal,
  });

  @override
  Widget build(BuildContext context) {
    final chartHeight = isDesktop ? 370.0 : 260.0; // Same as frequency chart
    return GlassCard(
      padding: EdgeInsets.symmetric(
        horizontal: isDesktop ? 32 : 10,
        vertical: isDesktop ? 28 : 10,
      ),
      borderRadius: BorderRadius.circular(24),
      child: Container(
        constraints: BoxConstraints(minHeight: isDesktop ? 0 : 520),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            // HEADER
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Row(
                children: [
                  Text(
                    'Evoluție temporală',
                    style: AppFonts.titleStyle.copyWith(
                      fontSize: isDesktop ? 19 : 16,
                    ),
                  ),
                  const Spacer(),
                  PeriodSelectorGlass(
                    value: selectedPeriod,
                    options: periodOptions,
                    onChanged: onPeriodChanged,
                    onCustom: onCustomPeriod ?? (_) {},
                    fontSize: 15,
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                  ),
                ],
              ),
            ),
            // BODY SCROLLABIL (chart + legendă)
            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.stretch,
                  children: [
                    // SECȚIUNEA PENTRU NUMERELE PRINCIPALE
                    SizedBox(
                      height: chartHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: StatisticsTemporalChart(
                          draws: statsDraws,
                          mainRange:
                              AppGameTypes.gameConfigs[selectedGame
                                      .csvName]!['mainRange']
                                  as int,
                          getNumbers: (draw) => draw.mainNumbers,
                        ),
                      ),
                    ),
                    // LEGENDA PENTRU NUMERELE PRINCIPALE
                    Builder(
                      builder: (context) {
                        if (statsDraws.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final stats = StatisticsCalculationService()
                            .calculateBasicStatistics(statsDraws);
                        return Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 0),
                          child: Text(
                            'Total extrageri: ${stats['totalDraws']} | Perioade: ${stats['periods']} | Numere: ${stats['numbers']} | Medie frecvență: ${(stats['avgFreq'] as double).toStringAsFixed(1)} | Cel mai frecvent: ${stats['maxFreq']} | Cel mai rar: ${stats['minFreq']}',
                            style: AppFonts.captionStyle.copyWith(
                              fontSize: isDesktop ? 10.5 : 8.0,
                              color: Colors.black.withValues(alpha: 0.53),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                    // LEGENDA CU ANOTIMPURILE PENTRU NUMERELE PRINCIPALE
                    Builder(
                      builder: (context) {
                        if (statsDraws.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final seasonStats = StatisticsCalculationService()
                            .calculateSeasonStatistics(statsDraws);
                        return Padding(
                          padding: const EdgeInsets.only(top: 4, bottom: 0),
                          child: Text(
                            'Anotimpuri: Primăvară ${seasonStats['spring']} (${seasonStats['springPct']}%) | Vară ${seasonStats['summer']} (${seasonStats['summerPct']}%) | Toamnă ${seasonStats['autumn']} (${seasonStats['autumnPct']}%) | Iarnă ${seasonStats['winter']} (${seasonStats['winterPct']}%)',
                            style: AppFonts.captionStyle.copyWith(
                              fontSize: isDesktop ? 10.5 : 8.0,
                              color: Colors.black.withValues(alpha: 0.53),
                            ),
                            textAlign: TextAlign.center,
                          ),
                        );
                      },
                    ),
                    // SECȚIUNEA PENTRU NUMERELE JOKER (doar pentru jocul Joker)
                    if (selectedGame == GameType.joker) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 2),
                        child: Text(
                          'Evoluție temporală Joker',
                          style: AppFonts.subtitleStyle.copyWith(
                            fontSize: isDesktop ? 15 : 13,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: chartHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: StatisticsTemporalChart(
                            draws: statsDraws
                                .where((d) => d.jokerNumber != null)
                                .toList(),
                            mainRange: 99, // Range pentru Joker (1-99)
                            getNumbers: (draw) => draw.jokerNumber != null
                                ? [draw.jokerNumber!]
                                : [],
                          ),
                        ),
                      ),
                      // LEGENDA PENTRU NUMERELE JOKER
                      Builder(
                        builder: (context) {
                          if (statsDraws.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          final drawsWithJoker = statsDraws
                              .where((d) => d.jokerNumber != null)
                              .toList();
                          if (drawsWithJoker.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          final jokerStats = StatisticsCalculationService()
                              .calculateJokerStatistics(drawsWithJoker);
                          final jokerNumbers = drawsWithJoker
                              .map((d) => d.jokerNumber!)
                              .toSet();

                          return Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Text(
                              'Joker: Total extrageri: ${drawsWithJoker.length} | Numere: ${jokerNumbers.length} | Medie frecvență: ${(jokerStats['avgFreq'] as double).toStringAsFixed(1)} | Cel mai frecvent: ${jokerStats['maxFreq']} | Cel mai rar: ${jokerStats['minFreq']}',
                              style: AppFonts.captionStyle.copyWith(
                                fontSize: isDesktop ? 10.5 : 8.0,
                                color: Colors.black.withValues(alpha: 0.53),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      // LEGENDA CU ANOTIMPURILE PENTRU NUMERELE JOKER
                      Builder(
                        builder: (context) {
                          if (statsDraws.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          final drawsWithJoker = statsDraws
                              .where((d) => d.jokerNumber != null)
                              .toList();
                          if (drawsWithJoker.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          final jokerSeasonStats =
                              StatisticsCalculationService()
                                  .calculateJokerSeasonStatistics(
                                    drawsWithJoker,
                                  );

                          return Padding(
                            padding: const EdgeInsets.only(top: 4, bottom: 0),
                            child: Text(
                              'Joker Anotimpuri: Primăvară ${jokerSeasonStats['spring']} (${jokerSeasonStats['springPct']}%) | Vară ${jokerSeasonStats['summer']} (${jokerSeasonStats['summerPct']}%) | Toamnă ${jokerSeasonStats['autumn']} (${jokerSeasonStats['autumnPct']}%) | Iarnă ${jokerSeasonStats['winter']} (${jokerSeasonStats['winterPct']}%)',
                              style: AppFonts.captionStyle.copyWith(
                                fontSize: isDesktop ? 10.5 : 8.0,
                                color: Colors.black.withValues(alpha: 0.53),
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ],
                  ],
                ),
              ),
            ),
            // FOOTER FIX
            SizedBox(height: isDesktop ? 32 : 20),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                    backgroundColor: Colors.white.withValues(alpha: 0.13),
                    padding: isDesktop
                        ? EdgeInsets.symmetric(horizontal: 10, vertical: 6)
                        : EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isDesktop ? 12.0 : 10.0,
                      ),
                      side: BorderSide(
                        color: Colors.black.withValues(alpha: 0.13),
                        width: 1.0,
                      ),
                    ),
                    textStyle: TextStyle(fontSize: isDesktop ? 13.0 : 11.0),
                  ),
                  icon: Icon(Icons.auto_mode, size: isDesktop ? 18.0 : 15.0),
                  label: const Text('Generator Temporal'),
                  onPressed: () {
                    // TODO: Implementare generator temporal
                  },
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                    backgroundColor: Colors.white.withValues(alpha: 0.13),
                    padding: isDesktop
                        ? EdgeInsets.symmetric(horizontal: 10, vertical: 6)
                        : EdgeInsets.symmetric(horizontal: 7, vertical: 4),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(
                        isDesktop ? 12.0 : 10.0,
                      ),
                      side: BorderSide(
                        color: Colors.black.withValues(alpha: 0.13),
                        width: 1.0,
                      ),
                    ),
                    textStyle: TextStyle(fontSize: isDesktop ? 13.0 : 11.0),
                  ),
                  icon: Icon(Icons.info_outline, size: isDesktop ? 18.0 : 15.0),
                  label: const Text('Analiză narativă'),
                  onPressed: () {
                    // Narrative analysis button pressed
                    final periodNotifier = ValueNotifier<String>(
                      selectedPeriod,
                    );
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withValues(alpha: 0.10),
                      builder: (ctx) => ValueListenableBuilder<String>(
                        valueListenable: periodNotifier,
                        builder: (ctx, currentPeriod, child) {
                          // Recalculez draws pentru perioada curentă
                          List<LotoDraw> localDraws = statsDraws;
                          if (currentPeriod == 'Toate extragerile') {
                            localDraws = allDraws;
                          } else if (currentPeriod.startsWith('Ultimele')) {
                            final n =
                                int.tryParse(
                                  currentPeriod.replaceAll(
                                    RegExp(r'[^0-9]'),
                                    '',
                                  ),
                                ) ??
                                statsDraws.length;
                            localDraws = allDraws.take(n).toList();
                          }
                          final narrative = calculateTemporalChartNarrative(
                            localDraws,
                          );

                          void updatePeriod(String newPeriod) {
                            periodNotifier.value = newPeriod;
                            onPeriodChanged(newPeriod);
                          }

                          return Center(
                            child: Material(
                              color: Colors.transparent,
                              child: ClipRRect(
                                borderRadius: BorderRadius.circular(24),
                                child: BackdropFilter(
                                  filter: ImageFilter.blur(
                                    sigmaX: 18,
                                    sigmaY: 18,
                                  ),
                                  child: Container(
                                    constraints: BoxConstraints(
                                      maxWidth: isDesktop
                                          ? 600
                                          : MediaQuery.of(context).size.width *
                                                0.98,
                                      maxHeight:
                                          MediaQuery.of(context).size.height *
                                          0.85,
                                    ),
                                    margin: EdgeInsets.symmetric(
                                      horizontal: isDesktop ? 0 : 8,
                                      vertical: isDesktop ? 0 : 12,
                                    ),
                                    padding: const EdgeInsets.all(24),
                                    decoration: BoxDecoration(
                                      color: Colors.white.withValues(alpha: 0.58),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Colors.white.withValues(alpha: 0.28),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(alpha: 0.10),
                                          blurRadius: 24,
                                          offset: Offset(0, 8),
                                        ),
                                      ],
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.analytics_outlined,
                                              color: AppColors.primaryGreenDark,
                                              size: isDesktop ? 24 : 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Analiză narativă temporală',
                                              style: AppFonts.titleStyle
                                                  .copyWith(
                                                    fontSize: isDesktop
                                                        ? 18
                                                        : 16,
                                                  ),
                                            ),
                                            const Spacer(),
                                            PeriodSelectorGlass(
                                              value: currentPeriod,
                                              options: periodOptions,
                                              onChanged: updatePeriod,
                                              onCustom: (String customPeriod) {
                                                periodNotifier.value =
                                                    customPeriod;
                                                onPeriodChanged(customPeriod);
                                              },
                                              fontSize: 15,
                                              iconSize: 18,
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        TemporalNarrative(
                                          narrative: narrative,
                                          isDesktop: isDesktop,
                                        ),
                                        const SizedBox(height: 18),
                                        Align(
                                          alignment: Alignment.bottomRight,
                                          child: TextButton(
                                            onPressed: () =>
                                                Navigator.of(ctx).pop(),
                                            child: const Text('Închide'),
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          );
                        },
                      ),
                    );
                  },
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

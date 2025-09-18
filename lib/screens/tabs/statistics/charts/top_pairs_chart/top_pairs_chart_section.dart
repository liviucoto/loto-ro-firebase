import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/widgets/glass_card.dart';
import 'package:loto_ro/widgets/period_selector_glass.dart';
import 'package:loto_ro/widgets/statistics_top_pairs_chart.dart';
import 'package:loto_ro/services/statistics_calculation_service.dart';
import 'top_pairs_narrative.dart';
import 'package:fl_chart/fl_chart.dart';

/// Secțiunea completă pentru graficul de top perechi
class TopPairsChartSection extends StatelessWidget {
  final List<LotoDraw> statsDraws;
  final List<LotoDraw> allDraws;
  final String selectedPeriod;
  final List<String> periodOptions;
  final Function(String) onPeriodChanged;
  final ValueChanged<String>? onCustomPeriod;
  final bool isDesktop;
  final GameType selectedGame;

  const TopPairsChartSection({
    super.key,
    required this.statsDraws,
    required this.allDraws,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.onPeriodChanged,
    required this.onCustomPeriod,
    required this.isDesktop,
    required this.selectedGame,
  });

  @override
  Widget build(BuildContext context) {
    final chartHeight = isDesktop ? 370.0 : 260.0;
    final legendFont = isDesktop ? 10.5 : 8.0;
    final legendColor = Colors.black.withValues(alpha: 0.53);
    final buttonFont = isDesktop ? 13.0 : 11.0;
    final buttonIcon = isDesktop ? 18.0 : 15.0;
    final buttonPadding = isDesktop
        ? EdgeInsets.symmetric(horizontal: 10, vertical: 6)
        : EdgeInsets.symmetric(horizontal: 7, vertical: 4);
    final borderRadius = isDesktop ? 12.0 : 10.0;
    final borderColor = Colors.black.withValues(alpha: 0.13);
    final borderWidth = 1.0;

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
                    'Top Perechi',
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
                    if (selectedGame == GameType.joker) ...[
                      // Secțiune pentru principale
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 2),
                        child: Text(
                          'Numere principale',
                          style: AppFonts.subtitleStyle.copyWith(
                            fontSize: isDesktop ? 15 : 13,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: chartHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: StatisticsTopPairsChart(
                            draws: statsDraws,
                            mainRange:
                                AppGameTypes.gameConfigs[selectedGame
                                        .csvName]!['mainRange']
                                    as int,
                          ),
                        ),
                      ),
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
                              'Total extrageri: ${stats['totalDraws']} | Total perechi: ${stats['pairs']} | Medie frecvență: ${(stats['avgFreq'] as double).toStringAsFixed(1)} | Cel mai frecvent: ${stats['maxFreq']} | Cel mai rar: ${stats['minFreq']}',
                              style: AppFonts.captionStyle.copyWith(
                                fontSize: legendFont,
                                color: legendColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 2),
                        child: Text(
                          'Correlații Joker-Principale',
                          style: AppFonts.subtitleStyle.copyWith(
                            fontSize: isDesktop ? 15 : 13,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: chartHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: _JokerCorrelationChart(
                            draws: statsDraws,
                            isDesktop: isDesktop,
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          if (statsDraws.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          // Calculez statistici pentru legendă Joker
                          final Map<String, int> jokerCorrFreq = {};
                          for (final draw in statsDraws) {
                            if (draw.jokerNumber != null) {
                              for (final mainNum in draw.mainNumbers) {
                                final pair = '$mainNum-J${draw.jokerNumber}';
                                jokerCorrFreq[pair] =
                                    (jokerCorrFreq[pair] ?? 0) + 1;
                              }
                            }
                          }
                          final totalJokerDraws = jokerCorrFreq.isNotEmpty
                              ? statsDraws
                                    .where((d) => d.jokerNumber != null)
                                    .length
                              : 0;
                          final totalJokerPairs = jokerCorrFreq.length;
                          final sortedJokerPairs =
                              jokerCorrFreq.entries.toList()
                                ..sort((a, b) => b.value.compareTo(a.value));
                          final maxJokerFreq = sortedJokerPairs.isNotEmpty
                              ? sortedJokerPairs.first.value
                              : 0;
                          final minJokerFreq = sortedJokerPairs.isNotEmpty
                              ? sortedJokerPairs.last.value
                              : 0;
                          final avgJokerFreq = jokerCorrFreq.isNotEmpty
                              ? (jokerCorrFreq.values.reduce((a, b) => a + b) /
                                        jokerCorrFreq.length)
                                    .toStringAsFixed(1)
                              : '0';
                          return Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Text(
                              'Joker: Total extrageri: $totalJokerDraws | Total perechi: $totalJokerPairs | Medie frecvență: $avgJokerFreq | Cel mai frecvent: $maxJokerFreq | Cel mai rar: $minJokerFreq',
                              style: AppFonts.captionStyle.copyWith(
                                fontSize: legendFont,
                                color: legendColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ] else ...[
                      // fallback: stil vechi pentru alte jocuri
                      SizedBox(
                        height: chartHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: StatisticsTopPairsChart(
                            draws: statsDraws,
                            mainRange:
                                AppGameTypes.gameConfigs[selectedGame
                                        .csvName]!['mainRange']
                                    as int,
                          ),
                        ),
                      ),
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
                              'Total extrageri: ${stats['totalDraws']} | Total perechi: ${stats['pairs']} | Medie frecvență: ${(stats['avgFreq'] as double).toStringAsFixed(1)} | Cel mai frecvent: ${stats['maxFreq']} | Cel mai rar: ${stats['minFreq']}',
                              style: AppFonts.captionStyle.copyWith(
                                fontSize: legendFont,
                                color: legendColor,
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
                    padding: buttonPadding,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      side: BorderSide(color: borderColor, width: borderWidth),
                    ),
                    textStyle: TextStyle(fontSize: buttonFont),
                  ),
                  icon: Icon(Icons.auto_mode, size: buttonIcon),
                  label: const Text('Generator Perechi'),
                  onPressed: () {},
                ),
                TextButton.icon(
                  style: TextButton.styleFrom(
                    foregroundColor: Colors.blueGrey,
                    backgroundColor: Colors.white.withValues(alpha: 0.13),
                    padding: buttonPadding,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(borderRadius),
                      side: BorderSide(color: borderColor, width: borderWidth),
                    ),
                    textStyle: TextStyle(fontSize: buttonFont),
                  ),
                  icon: Icon(Icons.info_outline, size: buttonIcon),
                  label: const Text('Analiză narativă'),
                  onPressed: () {
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
                            final n = int.tryParse(
                              currentPeriod.replaceAll(RegExp(r'[^0-9]'), ''),
                            );
                            if (n != null && n > 0 && n <= allDraws.length) {
                              localDraws = allDraws.take(n).toList();
                            }
                          }
                          // Calculez narativa pentru dialog cu insighturi suplimentare
                          final Map<String, int> pairFreq = {};
                          for (final draw in localDraws) {
                            final numbers = draw.mainNumbers;
                            for (int i = 0; i < numbers.length; i++) {
                              for (int j = i + 1; j < numbers.length; j++) {
                                final pair = '${numbers[i]}-${numbers[j]}';
                                pairFreq[pair] = (pairFreq[pair] ?? 0) + 1;
                              }
                            }
                          }
                          final sortedPairs = pairFreq.entries.toList()
                            ..sort((a, b) => b.value.compareTo(a.value));
                          final top5 = sortedPairs.take(5).toList();
                          final top10 = sortedPairs.take(10).toList();
                          final rarePairs = sortedPairs.reversed
                              .take(5)
                              .toList();

                          final maxFreq = sortedPairs.isNotEmpty
                              ? sortedPairs.first.value
                              : 0;
                          final minFreq = sortedPairs.isNotEmpty
                              ? sortedPairs.last.value
                              : 0;
                          final avgFreq = pairFreq.isNotEmpty
                              ? (pairFreq.values.reduce((a, b) => a + b) /
                                        pairFreq.length)
                                    .toStringAsFixed(2)
                              : '-';
                          final aboveAvg = pairFreq.values
                              .where(
                                (v) =>
                                    v >
                                    (pairFreq.isNotEmpty
                                        ? pairFreq.values.reduce(
                                                (a, b) => a + b,
                                              ) /
                                              pairFreq.length
                                        : 0),
                              )
                              .length;
                          final singlePairs = pairFreq.values
                              .where((v) => v == 1)
                              .length;
                          final top3Sum = top5.length >= 3
                              ? top5
                                    .take(3)
                                    .map((e) => e.value)
                                    .reduce((a, b) => a + b)
                              : 0;
                          final totalOccur = pairFreq.values.fold(
                            0,
                            (a, b) => a + b,
                          );
                          final top3Pct = totalOccur > 0
                              ? (top3Sum * 100 / totalOccur).toStringAsFixed(1)
                              : '-';
                          String narrative =
                              'Top 5 perechi: ${top5.isNotEmpty ? top5.map((e) => '${e.key} (${e.value}x)').join(', ') : '-'}\nTop 10 perechi: ${top10.isNotEmpty ? top10.map((e) => '${e.key} (${e.value}x)').join(', ') : '-'}\nCele mai rare perechi: ${rarePairs.isNotEmpty ? rarePairs.map((e) => '${e.key} (${e.value}x)').join(', ') : '-'}\nFrecvență maximă: $maxFreq, minimă: $minFreq, medie: $avgFreq\nPerechi peste medie: $aboveAvg, unice: $singlePairs\nTop 3 perechi acoperă $top3Pct% din totalul aparițiilor perechilor.';

                          // Calculez narativa pentru Joker (doar pentru jocul Joker)
                          Map<String, dynamic>? jokerNarrative;
                          if (selectedGame == GameType.joker) {
                            final Map<String, int> jokerCorrFreq = {};
                            for (final draw in localDraws) {
                              if (draw.jokerNumber != null) {
                                for (final mainNum in draw.mainNumbers) {
                                  final pair = '$mainNum-J${draw.jokerNumber}';
                                  jokerCorrFreq[pair] =
                                      (jokerCorrFreq[pair] ?? 0) + 1;
                                }
                              }
                            }
                            final sortedJokerPairs =
                                jokerCorrFreq.entries.toList()
                                  ..sort((a, b) => b.value.compareTo(a.value));
                            final top5Joker = sortedJokerPairs.take(5).toList();
                            final top10Joker = sortedJokerPairs
                                .take(10)
                                .toList();
                            final rareJokerPairs = sortedJokerPairs.reversed
                                .take(5)
                                .toList();

                            final maxJokerFreq = sortedJokerPairs.isNotEmpty
                                ? sortedJokerPairs.first.value
                                : 0;
                            final minJokerFreq = sortedJokerPairs.isNotEmpty
                                ? sortedJokerPairs.last.value
                                : 0;
                            final avgJokerFreq = jokerCorrFreq.isNotEmpty
                                ? (jokerCorrFreq.values.reduce(
                                            (a, b) => a + b,
                                          ) /
                                          jokerCorrFreq.length)
                                      .toStringAsFixed(2)
                                : '-';
                            final aboveAvgJoker = jokerCorrFreq.values
                                .where(
                                  (v) =>
                                      v >
                                      (jokerCorrFreq.isNotEmpty
                                          ? jokerCorrFreq.values.reduce(
                                                  (a, b) => a + b,
                                                ) /
                                                jokerCorrFreq.length
                                          : 0),
                                )
                                .length;
                            final singleJokerPairs = jokerCorrFreq.values
                                .where((v) => v == 1)
                                .length;
                            final top3JokerSum = top5Joker.length >= 3
                                ? top5Joker
                                      .take(3)
                                      .map((e) => e.value)
                                      .reduce((a, b) => a + b)
                                : 0;
                            final totalJokerOccur = jokerCorrFreq.values.fold(
                              0,
                              (a, b) => a + b,
                            );
                            final top3JokerPct = totalJokerOccur > 0
                                ? (top3JokerSum * 100 / totalJokerOccur)
                                      .toStringAsFixed(1)
                                : '-';

                            jokerNarrative = {
                              'top5Joker': top5Joker.isNotEmpty
                                  ? top5Joker
                                        .map((e) => '${e.key} (${e.value}x)')
                                        .join(', ')
                                  : '-',
                              'top10Joker': top10Joker.isNotEmpty
                                  ? top10Joker
                                        .map((e) => '${e.key} (${e.value}x)')
                                        .join(', ')
                                  : '-',
                              'rareJokerPairs': rareJokerPairs.isNotEmpty
                                  ? rareJokerPairs
                                        .map((e) => '${e.key} (${e.value}x)')
                                        .join(', ')
                                  : '-',
                              'maxJokerFreq': maxJokerFreq,
                              'minJokerFreq': minJokerFreq,
                              'avgJokerFreq': avgJokerFreq,
                              'aboveAvgJoker': aboveAvgJoker,
                              'singleJokerPairs': singleJokerPairs,
                              'top3JokerPct': top3JokerPct,
                              'totalJokerPairs': jokerCorrFreq.length,
                              'totalJokerDraws': localDraws
                                  .where((d) => d.jokerNumber != null)
                                  .length,
                            };
                          }

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
                                      color: Colors.white.withValues(
                                        alpha: 0.58,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.28,
                                        ),
                                        width: 1.5,
                                      ),
                                    ),
                                    child: Column(
                                      mainAxisSize: MainAxisSize.min,
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Icon(
                                              Icons.info_outline,
                                              color: Colors.blueGrey,
                                              size: 22,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Analiză narativă',
                                              style: AppFonts.titleStyle
                                                  .copyWith(
                                                    fontSize: isDesktop
                                                        ? 19
                                                        : 16,
                                                  ),
                                            ),
                                            const Spacer(),
                                            PeriodSelectorGlass(
                                              value: currentPeriod,
                                              options: periodOptions,
                                              onChanged: (val) {
                                                updatePeriod(val);
                                              },
                                              onCustom: (String customPeriod) {
                                                updatePeriod(customPeriod);
                                              },
                                              fontSize: 15,
                                              iconSize: 18,
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        TopPairsNarrative(
                                          narrative: narrative,
                                          isDesktop: isDesktop,
                                        ),
                                        if (selectedGame == GameType.joker &&
                                            jokerNarrative != null) ...[
                                          const SizedBox(height: 16),
                                          JokerCorrelationNarrative(
                                            narrative: jokerNarrative,
                                            isDesktop: isDesktop,
                                          ),
                                        ],
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

/// Widget pentru graficul de corelații Joker-principale
class _JokerCorrelationChart extends StatelessWidget {
  final List<LotoDraw> draws;
  final bool isDesktop;

  const _JokerCorrelationChart({required this.draws, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    final Map<String, int> jokerCorrFreq = {};

    for (final draw in draws) {
      if (draw.jokerNumber != null) {
        for (final mainNum in draw.mainNumbers) {
          final pair = '$mainNum-J${draw.jokerNumber}';
          jokerCorrFreq[pair] = (jokerCorrFreq[pair] ?? 0) + 1;
        }
      }
    }

    if (jokerCorrFreq.isEmpty) {
      return Center(
        child: Text(
          'Nu există date pentru corelațiile Joker-principale.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    final sortedPairs = jokerCorrFreq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topPairs = sortedPairs.take(10).toList();
    final maxFreq = topPairs.isNotEmpty ? topPairs.first.value : 0;

    return SizedBox(
      height: isDesktop ? 180 : 120,
      child: BarChart(
        BarChartData(
          alignment: BarChartAlignment.spaceAround,
          maxY: (maxFreq + 2).toDouble(),
          minY: 0,
          barTouchData: BarTouchData(
            enabled: true,
            touchTooltipData: BarTouchTooltipData(
              fitInsideHorizontally: true,
              fitInsideVertically: true,
              tooltipPadding: const EdgeInsets.symmetric(
                horizontal: 14,
                vertical: 8,
              ),
              getTooltipItem: (group, groupIndex, rod, rodIndex) {
                final pair = topPairs[group.x];
                return BarTooltipItem(
                  '${pair.key}\nExtrageri: ${rod.toY.toInt()}',
                  TextStyle(
                    color: Colors.black87,
                    fontWeight: FontWeight.w500,
                    fontSize: isDesktop ? 12 : 9,
                    shadows: [
                      Shadow(
                        color: Colors.white.withValues(alpha: 0.18),
                        blurRadius: 4,
                      ),
                    ],
                  ),
                );
              },
            ),
          ),
          titlesData: FlTitlesData(
            leftTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: maxFreq > 100 ? 40 : 28,
                getTitlesWidget: (v, m) {
                  int val = v.toInt();
                  if (val < 0 || val > maxFreq + 2) {
                    return const SizedBox.shrink();
                  }
                  if (maxFreq > 1000) {
                    if (val % 100 != 0 && val != 0 && val != maxFreq) {
                      return const SizedBox.shrink();
                    }
                  } else if (maxFreq > 500) {
                    if (val % 50 != 0 && val != 0 && val != maxFreq) {
                      return const SizedBox.shrink();
                    }
                  } else if (maxFreq > 100) {
                    if (val % 20 != 0 && val != 0 && val != maxFreq) {
                      return const SizedBox.shrink();
                    }
                  } else if (maxFreq > 50) {
                    if (val % 10 != 0 && val != 0 && val != maxFreq) {
                      return const SizedBox.shrink();
                    }
                  }
                  return Text(
                    val.toString(),
                    style: TextStyle(
                      fontSize: maxFreq > 100
                          ? (isDesktop ? 10 : 7)
                          : (isDesktop ? 12 : 8),
                      color: Colors.black54,
                    ),
                  );
                },
              ),
            ),
            bottomTitles: AxisTitles(
              sideTitles: SideTitles(
                showTitles: true,
                reservedSize: 22,
                getTitlesWidget: (v, m) {
                  int val = v.toInt();
                  if (val < 0 || val >= topPairs.length) {
                    return const SizedBox.shrink();
                  }
                  final pair = topPairs[val].key;
                  final parts = pair.split('-');
                  if (parts.length == 2) {
                    return Text(
                      '${parts[0]}-J${parts[1]}',
                      style: TextStyle(
                        fontSize: isDesktop ? 10 : 7,
                        color: Colors.black87,
                      ),
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
            rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
            topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          ),
          borderData: FlBorderData(show: false),
          gridData: FlGridData(
            show: true,
            drawVerticalLine: false,
            horizontalInterval: (maxFreq / 5).clamp(1, 20),
            getDrawingHorizontalLine: (v) =>
                FlLine(color: Colors.black12, strokeWidth: 1),
          ),
          barGroups: List.generate(
            topPairs.length,
            (index) => BarChartGroupData(
              x: index,
              barRods: [
                BarChartRodData(
                  toY: topPairs[index].value.toDouble(),
                  color: index < 3
                      ? AppColors.primaryGreenDark
                      : AppColors.secondaryBlue,
                  width: isDesktop ? 20 : 15,
                  borderRadius: BorderRadius.circular(4),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: (maxFreq + 2).toDouble(),
                    color: AppColors.secondaryBlue.withValues(alpha: 0.13),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

/// Widget pentru narativa corelațiilor Joker-principale
class JokerCorrelationNarrative extends StatelessWidget {
  final Map<String, dynamic> narrative;
  final bool isDesktop;

  const JokerCorrelationNarrative({
    super.key,
    required this.narrative,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.link, color: Colors.purple[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Corelațiile Joker-principale arată ce numere principale apar cel mai des împreună cu numărul Joker.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.orange[700], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Top 5 corelații: ${narrative['top5Joker']}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.trending_up, color: Colors.green, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Frecvență maximă: ${narrative['maxJokerFreq']}, minimă: ${narrative['minJokerFreq']}, medie: ${narrative['avgJokerFreq']}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.show_chart, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Corelații peste medie: ${narrative['aboveAvgJoker']}, unice: ${narrative['singleJokerPairs']}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Top 3 corelații acoperă ${narrative['top3JokerPct']}% din totalul aparițiilor.',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

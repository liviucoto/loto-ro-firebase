import 'package:flutter/material.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/widgets/statistics_frequency_chart.dart';
import 'frequency_narrative.dart';
import 'frequency_generator_dialog.dart';
import 'dart:ui';
import '../../../../../../widgets/period_selector_glass.dart';
import 'package:loto_ro/utils/statistics_narrative_utils.dart';
import 'package:loto_ro/widgets/glass_card.dart';
import '../../../../../../services/statistics_calculation_service.dart';

import 'package:fl_chart/fl_chart.dart';

/// Secțiunea completă pentru graficul de frecvență
class FrequencyChartSection extends StatelessWidget {
  final List<LotoDraw> statsDraws;
  final List<LotoDraw> allDraws; // Datele complete pentru dialog
  final String selectedPeriod;
  final List<String> periodOptions;
  final Function(String) onPeriodChanged;
  final ValueChanged<String> onCustomPeriod;
  final bool isDesktop;
  final GameType selectedGame;
  final Map<int, int>? asyncFreq;
  final String? freqNarrative;

  const FrequencyChartSection({
    super.key,
    required this.statsDraws,
    required this.allDraws,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.onPeriodChanged,
    required this.onCustomPeriod,
    required this.isDesktop,
    required this.selectedGame,
    required this.asyncFreq,
    required this.freqNarrative,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    final mainRange = statsDraws.isNotEmpty
        ? statsDraws.first.getNumberRange()['max'] ?? 49
        : 49;
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
            // HEADER FIX
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Row(
                children: [
                  Text(
                    'Graficul frecvenței',
                    style: AppFonts.titleStyle.copyWith(
                      fontSize: isDesktop ? 19 : 16,
                    ),
                  ),
                  const Spacer(),
                  PeriodSelectorGlass(
                    value: selectedPeriod,
                    options: periodOptions,
                    onChanged: onPeriodChanged,
                    onCustom: onCustomPeriod,
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
                          child: StatisticsFrequencyChart(
                            draws: statsDraws,
                            mainRange: 45,
                            title: 'Frecvența numerelor principale',
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
                              'Total extrageri: ${stats['totalDraws']} | Medie frecvență: ${(stats['avgFreq'] as double).toStringAsFixed(1)} | Cel mai frecvent: ${stats['maxFreq']} | Cel mai rar: ${stats['minFreq']}',
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
                          'Numere Joker',
                          style: AppFonts.subtitleStyle.copyWith(
                            fontSize: isDesktop ? 15 : 13,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: chartHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: _JokerFrequencyChart(draws: statsDraws),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          if (statsDraws.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          final jokerStats = StatisticsCalculationService()
                              .calculateJokerStatistics(statsDraws);
                          return Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Text(
                              'Joker: Medie frecvență: ${(jokerStats['avgFreq'] as double).toStringAsFixed(1)} | Cel mai frecvent: ${jokerStats['maxFreq']} | Cel mai rar: ${jokerStats['minFreq']}',
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
                      SizedBox(
                        height: chartHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: StatisticsFrequencyChart(
                            draws: statsDraws,
                            mainRange: mainRange,
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
                              'Total extrageri: ${stats['totalDraws']} | Medie frecvență: ${(stats['avgFreq'] as double).toStringAsFixed(1)} | Cel mai frecvent: ${stats['maxFreq']} | Cel mai rar: ${stats['minFreq']}',
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
            SizedBox(
              height: isDesktop ? 32 : 20,
            ), // spațiu generos între legendă și butoane
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
                  label: const Text('Generator Frecvență'),
                  onPressed: () {
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withValues(alpha: 0.10),
                      builder: (ctx) => FrequencyGeneratorDialog(
                        allDraws: allDraws,
                        statsDraws: statsDraws,
                        selectedGame: selectedGame,
                        isDesktop: isDesktop,
                        onClose: () => Navigator.of(ctx).pop(),
                      ),
                    );
                  },
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
                          final result = calculateFrequencyAndNarrative({
                            'draws': localDraws,
                            'mainRange': mainRange,
                          });
                          final Map<int, int> localFreq =
                              result['freq'] as Map<int, int>;
                          final String? localNarrative =
                              result['narrative'] as String?;
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
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.10,
                                          ),
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
                                              Icons.info_outline,
                                              color: Colors.blueGrey,
                                            ),
                                            SizedBox(width: 8),
                                            Text(
                                              'Analiză narativă',
                                              style: AppFonts.titleStyle
                                                  .copyWith(fontSize: 18),
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
                                        FrequencyNarrative(
                                          narrative: localNarrative,
                                          freq: localFreq,
                                          mainRange: mainRange,
                                        ),
                                        // Adaug narativă pentru Joker dacă există date Joker
                                        FutureBuilder<Map<int, int>>(
                                          future: StatisticsCalculationService()
                                              .calculateJokerFrequencyWithCache(
                                                localDraws,
                                                20,
                                              ),
                                          builder: (context, snapshot) {
                                            if (snapshot.hasData &&
                                                snapshot.data!.isNotEmpty) {
                                              return Column(
                                                children: [
                                                  const SizedBox(height: 16),
                                                  JokerFrequencyNarrative(
                                                    freq: snapshot.data!,
                                                    mainRange: 20,
                                                  ),
                                                ],
                                              );
                                            }
                                            return const SizedBox.shrink();
                                          },
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

// Adaug un widget privat pentru graficul Joker
class _JokerFrequencyChart extends StatelessWidget {
  final List<LotoDraw> draws;
  const _JokerFrequencyChart({required this.draws});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    final int mainRange = 20;
    final Map<int, int> freq = {for (int n = 1; n <= mainRange; n++) n: 0};
    for (final d in draws) {
      if (d.jokerNumber != null) {
        freq[d.jokerNumber!] = (freq[d.jokerNumber!] ?? 0) + 1;
      }
    }
    final maxFreq = freq.values.isNotEmpty
        ? freq.values.reduce((a, b) => a > b ? a : b)
        : 0;
    final minFreq = freq.values.isNotEmpty
        ? freq.values.reduce((a, b) => a < b ? a : b)
        : 0;
    if (maxFreq == 0) {
      return Center(
        child: Text(
          'Nu există date pentru graficul Joker.',
          style: AppFonts.bodyStyle,
        ),
      );
    }
    int xLabelStep = 1;
    if (mainRange > 15) xLabelStep = 2;
    double fontSize = isDesktop ? 12 : 7;
    double bottomFontSize = isDesktop ? 12 : 7;
    final mostFreqNum = freq.entries.isNotEmpty
        ? freq.entries.firstWhere((e) => e.value == maxFreq).key
        : 0;
    final leastFreqNum = freq.entries.isNotEmpty
        ? freq.entries.firstWhere((e) => e.value == minFreq).key
        : 0;
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
                final num = group.x.toInt();
                if (num < 1 || num > mainRange) return null;
                return BarTooltipItem(
                  'Joker: $num\nFrecvență: ${rod.toY.toInt()}',
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

                  // Pentru valori foarte mari (1000+), afișează la fiecare 100
                  if (maxFreq > 1000) {
                    if (val % 100 != 0 && val != 0 && val != maxFreq) {
                      return const SizedBox.shrink();
                    }
                  }
                  // Pentru valori mari (500-1000), afișează la fiecare 50
                  else if (maxFreq > 500) {
                    if (val % 50 != 0 && val != 0 && val != maxFreq) {
                      return const SizedBox.shrink();
                    }
                  }
                  // Pentru valori mari (100-500), afișează la fiecare 20
                  else if (maxFreq > 100) {
                    if (val % 20 != 0 && val != 0 && val != maxFreq) {
                      return const SizedBox.shrink();
                    }
                  }
                  // Pentru valori medii (50-100), afișează la fiecare 10
                  else if (maxFreq > 50) {
                    if (val % 10 != 0 && val != 0 && val != maxFreq) {
                      return const SizedBox.shrink();
                    }
                  }
                  // Pentru valori mici, afișează toate

                  return Text(
                    val.toString(),
                    style: TextStyle(
                      fontSize: maxFreq > 100 ? (fontSize * 0.8) : fontSize,
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
                  if (val < 1 || val > mainRange) {
                    return const SizedBox.shrink();
                  }
                  if (xLabelStep > 1 &&
                      val % xLabelStep != 0 &&
                      val != 1 &&
                      val != mainRange) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    val.toString().padLeft(2, '0'),
                    style: TextStyle(
                      fontSize: bottomFontSize,
                      color: Colors.black87,
                    ),
                  );
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
          barGroups: freq.entries.map((e) {
            final isMost = e.key == mostFreqNum;
            final isLeast = e.key == leastFreqNum;
            return BarChartGroupData(
              x: e.key,
              barRods: [
                BarChartRodData(
                  toY: e.value.toDouble(),
                  color: isMost
                      ? AppColors.primaryGreenDark
                      : isLeast
                      ? AppColors.errorRedMedium
                      : const Color(0xFF3B82F6),
                  width: isDesktop ? 6 : 3,
                  borderRadius: BorderRadius.circular(6),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: (maxFreq + 2).toDouble(),
                    color: AppColors.secondaryBlue.withValues(alpha: 0.13),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
  }
}

// Narativă pentru Joker (folosită în dialogul Analiză narativă)
class JokerFrequencyNarrative extends StatelessWidget {
  final Map<int, int> freq;
  final int mainRange;
  const JokerFrequencyNarrative({
    super.key,
    required this.freq,
    required this.mainRange,
  });

  @override
  Widget build(BuildContext context) {
    if (freq.isEmpty) return const SizedBox.shrink();
    final values = freq.values.toList();
    final maxFreq = values.reduce((a, b) => a > b ? a : b);
    final minFreq = values.reduce((a, b) => a < b ? a : b);
    final avgFreq = values.reduce((a, b) => a + b) / values.length;
    final sortedFreq = freq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top3 = sortedFreq.take(3).toList();
    final rare = sortedFreq.skip(sortedFreq.length - 3).take(3).toList();
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.casino, color: Colors.deepPurple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Joker: Top 3 cele mai frecvente: ${top3.map((e) => "${e.key} (${e.value})").join(", ")}.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.casino, color: Colors.deepPurple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Joker: Top 3 cele mai rare: ${rare.map((e) => "${e.key} (${e.value})").join(", ")}.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Row(
          children: [
            Icon(Icons.casino, color: Colors.deepPurple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Joker: Medie: ${avgFreq.toStringAsFixed(1)}, maxim: $maxFreq, minim: $minFreq.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

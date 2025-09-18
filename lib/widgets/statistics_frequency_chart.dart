import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/constants.dart';
import '../models/loto_draw.dart';
import '../screens/tabs/statistics/charts/frequency_chart/frequency_narrative.dart';
import '../screens/tabs/statistics/charts/frequency_chart/frequency_chart_section.dart'
    show JokerFrequencyNarrative;
import '../widgets/period_selector_glass.dart';
import '../utils/statistics_narrative_utils.dart';
import 'dart:ui';

class StatisticsFrequencyChartTitle extends StatelessWidget {
  final List<LotoDraw> draws;
  final int mainRange;
  final String selectedPeriod;
  final List<String> periodOptions;
  final List<LotoDraw> statsDraws;

  const StatisticsFrequencyChartTitle({
    super.key,
    required this.draws,
    required this.mainRange,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.statsDraws,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          'Graficul frecven?ei',
          style: AppFonts.titleStyle.copyWith(fontSize: 19),
        ),
        const SizedBox(height: 6),
        SizedBox(
          child: TextButton.icon(
            style: TextButton.styleFrom(
              foregroundColor: Colors.blueGrey,
              padding: const EdgeInsets.symmetric(horizontal: 8, vertical: 4),
              minimumSize: Size(0, 0),
              tapTargetSize: MaterialTapTargetSize.shrinkWrap,
              textStyle: const TextStyle(fontSize: 13),
            ),
            icon: const Icon(Icons.info_outline, size: 18),
            label: const Text('Analiza narativa'),
            onPressed: () {
              final String initialPeriod = selectedPeriod;
              final List<String> initialOptions = periodOptions;
              showDialog(
                context: context,
                barrierColor: Colors.black.withValues(alpha: 0.10),
                builder: (ctx) => StatefulBuilder(
                  builder: (ctx, setState) {
                    String localPeriod = initialPeriod;
                    List<String> localOptions = initialOptions;
                    List<LotoDraw> localDraws = statsDraws;
                    Map<int, int> localFreq = {};
                    String? localNarrative;

                    void updatePeriod(String newPeriod) {
                      localPeriod = newPeriod;
                      if (newPeriod == 'Toate extragerile') {
                        localDraws = statsDraws;
                      } else if (newPeriod.startsWith('Ultimele')) {
                        final n =
                            int.tryParse(
                              newPeriod.replaceAll(RegExp(r'[^0-9]'), ''),
                            ) ??
                            statsDraws.length;
                        localDraws = statsDraws.take(n).toList();
                      }
                      final result = calculateFrequencyAndNarrative({
                        'draws': localDraws,
                        'mainRange': mainRange,
                      });
                      localFreq = result['freq'] as Map<int, int>;
                      localNarrative = result['narrative'] as String?;
                      setState(() {});
                    }

                    // Ini?ializez cu datele curente
                    if (localFreq.isEmpty) {
                      final result = calculateFrequencyAndNarrative({
                        'draws': localDraws,
                        'mainRange': mainRange,
                      });
                      localFreq = result['freq'] as Map<int, int>;
                      localNarrative = result['narrative'] as String?;
                    }

                    return Center(
                      child: Material(
                        color: Colors.transparent,
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(24),
                          child: BackdropFilter(
                            filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                            child: Container(
                              constraints: BoxConstraints(
                                maxWidth: isDesktop
                                    ? 500
                                    : MediaQuery.of(context).size.width * 0.98,
                                maxHeight:
                                    MediaQuery.of(context).size.height * 0.75,
                              ),
                              margin: EdgeInsets.symmetric(
                                horizontal: isDesktop ? 0 : 8,
                                vertical: isDesktop ? 0 : 24,
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
                              child: SingleChildScrollView(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Row(
                                      children: [
                                        Icon(
                                          Icons.info_outline,
                                          color: Colors.blueGrey,
                                        ),
                                        SizedBox(width: 8),
                                        Text(
                                          'Analiza narativa',
                                          style: AppFonts.titleStyle.copyWith(
                                            fontSize: 18,
                                          ),
                                        ),
                                        const Spacer(),
                                        PeriodSelectorGlass(
                                          value: localPeriod,
                                          options: localOptions,
                                          onChanged: (val) => updatePeriod(val),
                                        ),
                                      ],
                                    ),
                                    const SizedBox(height: 16),
                                    FrequencyNarrative(
                                      narrative: localNarrative,
                                      freq: localFreq,
                                      mainRange: mainRange,
                                    ),
                                    // Display joker draws count
                                    Builder(
                                      builder: (context) {
                                        final jokerDraws = localDraws
                                            .where((d) => d.jokerNumber != null)
                                            .toList();
                                        return Column(
                                          crossAxisAlignment:
                                              CrossAxisAlignment.start,
                                          children: [
                                            Text(
                                              'Extrageri cu jokerNumber: ${jokerDraws.length}',
                                              style: TextStyle(
                                                color: Colors.red,
                                                fontWeight: FontWeight.bold,
                                              ),
                                            ),
                                            ...jokerDraws
                                                .take(3)
                                                .map(
                                                  (d) => Text(
                                                    d.toString(),
                                                    style: TextStyle(
                                                      fontSize: 10,
                                                      color: Colors.red,
                                                    ),
                                                  ),
                                                ),
                                          ],
                                        );
                                      },
                                    ),
                                    // Display message if Joker data exists
                                    if (localDraws.any(
                                      (d) => d.jokerNumber != null,
                                    )) ...[
                                      Text(
                                        'Avem date Joker!',
                                        style: TextStyle(
                                          color: Colors.red,
                                          fontWeight: FontWeight.bold,
                                        ),
                                      ),
                                      SizedBox(height: 16),
                                      Builder(
                                        builder: (context) {
                                          final Map<int, int> jokerFreq = {
                                            for (int n = 1; n <= 20; n++) n: 0,
                                          };
                                          for (final d in localDraws) {
                                            if (d.jokerNumber != null) {
                                              jokerFreq[d.jokerNumber!] =
                                                  (jokerFreq[d.jokerNumber!] ??
                                                      0) +
                                                  1;
                                            }
                                          }
                                          return JokerFrequencyNarrative(
                                            freq: jokerFreq,
                                            mainRange: 20,
                                          );
                                        },
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
                      ),
                    );
                  },
                ),
              );
            },
          ),
        ),
      ],
    );
  }
}

class StatisticsFrequencyChart extends StatelessWidget {
  final List<LotoDraw> draws;
  final int mainRange;
  final String title;
  const StatisticsFrequencyChart({
    super.key,
    required this.draws,
    required this.mainRange,
    this.title = 'Frecven?a numerelor',
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    if (draws.isEmpty || mainRange <= 0) {
      return Center(
        child: Text(
          'Nu exista date pentru graficul de frecven?a.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    // OPTIMIZARE: Limitez numarul de extrageri pentru perioade mari
    final int maxDrawsForFrequency = 3000;
    final List<LotoDraw> optimizedDraws = draws.length > maxDrawsForFrequency
        ? draws.sublist(0, maxDrawsForFrequency)
        : draws;

    // Calculez frecven?a pentru fiecare numar
    final Map<int, int> freq = {for (var i = 1; i <= mainRange; i++) i: 0};
    for (final draw in optimizedDraws) {
      for (final n in draw.mainNumbers) {
        if (n >= 1 && n <= mainRange) {
          freq[n] = (freq[n] ?? 0) + 1;
        }
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
          'Nu exista date valide pentru graficul de frecven?a.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    final mostFreqNum = freq.entries.isNotEmpty
        ? freq.entries.firstWhere((e) => e.value == maxFreq).key
        : 0;
    final leastFreqNum = freq.entries.isNotEmpty
        ? freq.entries.firstWhere((e) => e.value == minFreq).key
        : 0;
    final avgFreq = freq.values.isNotEmpty
        ? (freq.values.reduce((a, b) => a + b) / freq.length).toStringAsFixed(2)
        : '0';

    // Etichete X rare daca sunt multe bare
    int xLabelStep = 1;
    if (mainRange > 60) {
      xLabelStep = 10;
    } else if (mainRange > 40) {
      xLabelStep = 5;
    } else if (mainRange > 25) {
      xLabelStep = 2;
    }

    double fontSize = isDesktop ? 12 : 7;
    double bottomFontSize = isDesktop ? 12 : 7;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
          return const SizedBox.shrink();
        }
        final isMobile = !isDesktop;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            const SizedBox(height: 8),
            // Chart-ul ocupa tot spa?iul ramas
            Expanded(
              child: RepaintBoundary(
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
                            'Numar: $num\nFrecven?a: ${rod.toY.toInt()}',
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

                            // Pentru valori foarte mari (1000+), afi?eaza la fiecare 100
                            if (maxFreq > 1000) {
                              if (val % 100 != 0 &&
                                  val != 0 &&
                                  val != maxFreq) {
                                return const SizedBox.shrink();
                              }
                            }
                            // Pentru valori mari (500-1000), afi?eaza la fiecare 50
                            else if (maxFreq > 500) {
                              if (val % 50 != 0 && val != 0 && val != maxFreq) {
                                return const SizedBox.shrink();
                              }
                            }
                            // Pentru valori mari (100-500), afi?eaza la fiecare 20
                            else if (maxFreq > 100) {
                              if (val % 20 != 0 && val != 0 && val != maxFreq) {
                                return const SizedBox.shrink();
                              }
                            }
                            // Pentru valori medii (50-100), afi?eaza la fiecare 10
                            else if (maxFreq > 50) {
                              if (val % 10 != 0 && val != 0 && val != maxFreq) {
                                return const SizedBox.shrink();
                              }
                            }
                            // Pentru valori mici, afi?eaza toate

                            return Text(
                              val.toString(),
                              style: TextStyle(
                                fontSize: maxFreq > 100
                                    ? (fontSize * 0.8)
                                    : fontSize,
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
                      rightTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
                      topTitles: AxisTitles(
                        sideTitles: SideTitles(showTitles: false),
                      ),
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
                            width: isMobile ? 3 : 6,
                            borderRadius: BorderRadius.circular(6),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: (maxFreq + 2).toDouble(),
                              color: AppColors.secondaryBlue.withValues(
                                alpha: 0.13,
                              ),
                            ),
                          ),
                        ],
                      );
                    }).toList(),
                  ),
                ),
              ),
            ),
            const SizedBox(height: 6),
          ],
        );
      },
    );
  }
}

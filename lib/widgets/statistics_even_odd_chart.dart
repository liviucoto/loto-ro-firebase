import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/loto_draw.dart';
import '../utils/constants.dart';
import 'dart:math';

class StatisticsEvenOddChart extends StatelessWidget {
  final List<LotoDraw> draws;
  const StatisticsEvenOddChart({super.key, required this.draws});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    if (draws.isEmpty) {
      return Center(
        child: Text(
          'Nu exista date pentru graficul par/impar.',
          style: AppFonts.bodyStyle,
        ),
      );
    }
    final nNumbers = draws.first.mainNumbers.length;
    // Calculez distribu?ia: pentru fiecare extragere, câte pare ?i câte impare
    final Map<int, int> evenCountDist = {
      for (int i = 0; i <= nNumbers; i++) i: 0,
    };
    int totalEven = 0, totalOdd = 0;
    for (final draw in draws) {
      int even = draw.mainNumbers.where((n) => n % 2 == 0).length;
      int odd = nNumbers - even;
      evenCountDist[even] = (evenCountDist[even] ?? 0) + 1;
      totalEven += even;
      totalOdd += odd;
    }
    final maxFreq = evenCountDist.values.reduce(max);
    final minFreq = evenCountDist.values.reduce(min);
    // Pregatesc datele pentru chart
    final List<String> xLabels = [
      for (int i = 0; i <= nNumbers; i++) '$i pare\n${nNumbers - i} impare',
    ];
    final double barWidth = isDesktop ? 24 : 14;
    final double barSpacing = isDesktop ? 8 : 4;
    final double chartWidth = xLabels.length * (barWidth + barSpacing) + 40;
    final bool enableScroll =
        !isDesktop && chartWidth > MediaQuery.of(context).size.width;
    final chartWidget = isDesktop
        ? SizedBox(
            width: double.infinity,
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
                      final idx = group.x.toInt();
                      return BarTooltipItem(
                        '${xLabels[idx].replaceAll("\n", " ")}\nExtrageri: ${rod.toY.toInt()}',
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
                          if (val % 100 != 0 && val != 0 && val != maxFreq) {
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
                      reservedSize: 60,
                      getTitlesWidget: (v, m) {
                        int idx = v.toInt();
                        if (idx < 0 || idx >= xLabels.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          xLabels[idx],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isDesktop ? 10 : 7,
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
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: Colors.black12.withValues(alpha: 0.08),
                    strokeWidth: 1,
                  ),
                ),
                barGroups: List.generate(xLabels.length, (idx) {
                  final isAllEven = idx == nNumbers;
                  final isAllOdd = idx == 0;
                  final isMax = evenCountDist[idx] == maxFreq;
                  final isMin = evenCountDist[idx] == minFreq;
                  return BarChartGroupData(
                    x: idx,
                    barRods: [
                      BarChartRodData(
                        toY: evenCountDist[idx]?.toDouble() ?? 0,
                        color: isAllEven
                            ? AppColors.primaryGreenDark
                            : isAllOdd
                            ? AppColors.errorRedMedium
                            : isMax
                            ? AppColors.secondaryBlueMedium
                            : AppColors.secondaryBlue,
                        width: barWidth,
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
                }),
              ),
            ),
          )
        : SizedBox(
            width: enableScroll ? chartWidth : double.infinity,
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
                      final idx = group.x.toInt();
                      return BarTooltipItem(
                        '${xLabels[idx].replaceAll("\n", " ")}\nExtrageri: ${rod.toY.toInt()}',
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
                          if (val % 100 != 0 && val != 0 && val != maxFreq) {
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
                      reservedSize: 60,
                      getTitlesWidget: (v, m) {
                        int idx = v.toInt();
                        if (idx < 0 || idx >= xLabels.length) {
                          return const SizedBox.shrink();
                        }
                        return Text(
                          xLabels[idx],
                          textAlign: TextAlign.center,
                          style: TextStyle(
                            fontSize: isDesktop ? 10 : 7,
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
                  getDrawingHorizontalLine: (v) => FlLine(
                    color: Colors.black12.withValues(alpha: 0.08),
                    strokeWidth: 1,
                  ),
                ),
                barGroups: List.generate(xLabels.length, (idx) {
                  final isAllEven = idx == nNumbers;
                  final isAllOdd = idx == 0;
                  final isMax = evenCountDist[idx] == maxFreq;
                  final isMin = evenCountDist[idx] == minFreq;
                  return BarChartGroupData(
                    x: idx,
                    barRods: [
                      BarChartRodData(
                        toY: evenCountDist[idx]?.toDouble() ?? 0,
                        color: isAllEven
                            ? AppColors.primaryGreenDark
                            : isAllOdd
                            ? AppColors.errorRedMedium
                            : isMax
                            ? AppColors.secondaryBlueMedium
                            : AppColors.secondaryBlue,
                        width: barWidth,
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
                }),
              ),
            ),
          );
    return SizedBox.expand(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Expanded(
            child: enableScroll
                ? SingleChildScrollView(
                    scrollDirection: Axis.horizontal,
                    child: chartWidget,
                  )
                : chartWidget,
          ),
        ],
      ),
    );
  }
}

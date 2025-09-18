import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';
import 'dart:math';

class StatisticsDecadeChart extends StatelessWidget {
  final List<LotoDraw> draws;
  final int mainRange;
  const StatisticsDecadeChart({
    super.key,
    required this.draws,
    required this.mainRange,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    if (draws.isEmpty || mainRange <= 0) {
      return Center(
        child: Text(
          'Nu exista date pentru graficul de decade.',
          style: AppFonts.bodyStyle,
        ),
      );
    }
    // Construiesc decadele: 1-10, 11-20, ...
    final List<String> decadeLabels = [];
    final List<List<int>> decadeRanges = [];
    for (int start = 1; start <= mainRange; start += 10) {
      int end = min(start + 9, mainRange);
      decadeLabels.add('$start-$end');
      decadeRanges.add([start, end]);
    }
    // Calculez frecven?a pe decade
    final List<int> decadeFreq = List.filled(decadeLabels.length, 0);
    for (final draw in draws) {
      for (final n in draw.mainNumbers) {
        for (int i = 0; i < decadeRanges.length; i++) {
          if (n >= decadeRanges[i][0] && n <= decadeRanges[i][1]) {
            decadeFreq[i]++;
            break;
          }
        }
      }
    }
    final maxFreq = decadeFreq.reduce(max);
    final minFreq = decadeFreq.reduce(min);
    double fontSize = isDesktop ? 12 : 8;
    double bottomFontSize = isDesktop ? 10 : 7;
    // Scroll orizontal pe mobil daca sunt multe decade
    final double barWidth = isDesktop ? 24 : 14;
    final double barSpacing = isDesktop ? 8 : 4;
    final double chartWidth =
        decadeLabels.length * (barWidth + barSpacing) + 40;
    final bool enableScroll =
        !isDesktop && chartWidth > MediaQuery.of(context).size.width;
    final chartWidget = SizedBox(
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
                  'Decada: ${decadeLabels[idx]}\nApari?ii: ${rod.toY.toInt()}',
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
                reservedSize: 50,
                getTitlesWidget: (v, m) {
                  int idx = v.toInt();
                  if (idx < 0 || idx >= decadeLabels.length) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    decadeLabels[idx],
                    style: TextStyle(
                      fontSize: bottomFontSize,
                      color: Colors.black87,
                    ),
                    textAlign: TextAlign.center,
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
            getDrawingHorizontalLine: (v) => FlLine(
              color: Colors.black12.withValues(alpha: 0.08),
              strokeWidth: 1,
            ),
          ),
          barGroups: List.generate(decadeLabels.length, (idx) {
            final isMax = decadeFreq[idx] == maxFreq;
            final isMin = decadeFreq[idx] == minFreq;
            return BarChartGroupData(
              x: idx,
              barRods: [
                BarChartRodData(
                  toY: decadeFreq[idx].toDouble(),
                  color: isMax
                      ? AppColors.primaryGreenDark
                      : isMin
                      ? AppColors.errorRedMedium
                      : AppColors.secondaryBlueMedium,
                  width: barWidth,
                  borderRadius: BorderRadius.circular(6),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: (maxFreq + 2).toDouble(),
                    color: AppColors.secondaryBlue.withValues(alpha: 0.13),
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

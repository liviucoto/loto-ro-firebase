import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';

class StatisticsTopPairsChart extends StatelessWidget {
  final List<LotoDraw> draws;
  final int mainRange;
  const StatisticsTopPairsChart({
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
          'Nu exista date pentru graficul de top perechi.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    // OPTIMIZARE: Limitez numarul de extrageri pentru perioade mari
    final int maxDrawsForPairs = 3000;
    final List<LotoDraw> optimizedDraws = draws.length > maxDrawsForPairs
        ? draws.sublist(0, maxDrawsForPairs)
        : draws;

    // Calculez frecven?a perechilor
    final Map<String, int> pairFreq = {};
    for (final draw in optimizedDraws) {
      final numbers = draw.mainNumbers
          .where((n) => n >= 1 && n <= mainRange)
          .toList();
      for (int i = 0; i < numbers.length; i++) {
        for (int j = i + 1; j < numbers.length; j++) {
          final pair = '${numbers[i]}-${numbers[j]}';
          pairFreq[pair] = (pairFreq[pair] ?? 0) + 1;
        }
      }
    }

    if (pairFreq.isEmpty) {
      return Center(
        child: Text(
          'Nu exista date valide pentru graficul de top perechi.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    // Sortez perechile dupa frecven?a ?i iau top 20
    final sortedPairs = pairFreq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final topPairs = sortedPairs.take(20).toList();

    final maxFreq = topPairs.isNotEmpty ? topPairs.first.value : 0;
    final minFreq = topPairs.isNotEmpty ? topPairs.last.value : 0;

    if (maxFreq == 0) {
      return Center(
        child: Text(
          'Nu exista date valide pentru graficul de top perechi.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    double fontSize = isDesktop ? 12 : 8;
    double bottomFontSize = isDesktop ? 10 : 7;

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
          return const SizedBox.shrink();
        }

        // Calculez dimensiunile barelor
        double availableWidth = constraints.maxWidth.clamp(200, 1200);
        int barCount = topPairs.length;
        double minBarWidth = isDesktop ? 8 : 3;
        double maxBarWidth = isDesktop ? 14 : 6;
        double barSpacing = isDesktop ? 2 : 1;
        double barWidth =
            (availableWidth - (barCount - 1) * barSpacing) / barCount;
        if (barWidth > maxBarWidth) barWidth = maxBarWidth;
        if (barWidth < minBarWidth) barWidth = minBarWidth;

        // Daca pe mobil barele ar depa?i spa?iul, activez scroll orizontal
        final double chartWidth = barCount * (barWidth + barSpacing) + 40;
        final bool enableScroll =
            !isDesktop && chartWidth > constraints.maxWidth;

        final BarChartAlignment alignment = isDesktop
            ? BarChartAlignment.spaceBetween
            : BarChartAlignment.center;
        final chartWidget = SizedBox(
          width: enableScroll ? chartWidth : double.infinity,
          child: BarChart(
            BarChartData(
              alignment: alignment,
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
                    final pair = topPairs[group.x.toInt()];
                    return BarTooltipItem(
                      'Pereche: ${pair.key}\nApari?ii: ${rod.toY.toInt()}',
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

                      // Pentru valori mari, afi?eaza doar la intervale, dar mai multe
                      if (maxFreq > 100) {
                        int step = (maxFreq / 6)
                            .ceil(); // Reduc step-ul pentru mai multe etichete
                        if (val % step != 0 &&
                            val != 0 &&
                            val != maxFreq &&
                            val != maxFreq ~/ 2) {
                          return const SizedBox.shrink();
                        }
                      } else if (maxFreq > 50) {
                        // Pentru valori medii, afi?eaza la fiecare 5
                        if (val % 5 != 0 && val != 0 && val != maxFreq) {
                          return const SizedBox.shrink();
                        }
                      }

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
                    getTitlesWidget: (value, meta) {
                      int idx = value.round();
                      if ((value - idx).abs() > 0.1 ||
                          idx < 0 ||
                          idx >= topPairs.length) {
                        return const SizedBox.shrink();
                      }
                      final pairParts = topPairs[idx].key.split('-');
                      return Text(
                        pairParts.length == 2
                            ? '${pairParts[0]}\n${pairParts[1]}'
                            : topPairs[idx].key,
                        textAlign: TextAlign.center,
                        style: TextStyle(
                          fontSize: 10,
                          color: Colors.black87,
                          height: 1.1,
                        ),
                        maxLines: 2,
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
              barGroups: topPairs.asMap().entries.map((entry) {
                final idx = entry.key;
                final pair = entry.value;
                final isTop3 = idx < 3;
                final isTop5 = idx < 5;
                return BarChartGroupData(
                  x: idx,
                  barRods: [
                    BarChartRodData(
                      toY: pair.value.toDouble(),
                      color: isTop3
                          ? AppColors.primaryGreenDark
                          : isTop5
                          ? AppColors.secondaryBlueMedium
                          : const Color(0xFF3B82F6),
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
              }).toList(),
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
      },
    );
  }
}

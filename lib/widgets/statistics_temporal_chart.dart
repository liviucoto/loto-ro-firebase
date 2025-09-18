import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'dart:math';

class StatisticsTemporalChart extends StatefulWidget {
  final List<LotoDraw> draws;
  final int mainRange;
  final String timeUnit; // 'month', 'quarter', 'year'
  final List<int> Function(LotoDraw draw) getNumbers;

  const StatisticsTemporalChart({
    super.key,
    required this.draws,
    required this.mainRange,
    this.timeUnit = 'month',
    required this.getNumbers,
  });

  @override
  State<StatisticsTemporalChart> createState() =>
      _StatisticsTemporalChartState();
}

class _StatisticsTemporalChartState extends State<StatisticsTemporalChart> {
  final bool _showInfo = false;

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    final draws = widget.draws;
    final mainRange = widget.mainRange;
    final timeUnit = widget.timeUnit;
    if (draws.isEmpty || mainRange <= 0) {
      return Center(
        child: Text(
          'Nu există date pentru graficul temporal.',
          style: AppFonts.bodyStyle,
        ),
      );
    }
    // OPTIMIZARE: Pentru perioade mari, folosesc toate datele dar optimizez afișarea
    final List<LotoDraw> optimizedDraws = draws;
    // Calculez frecvențele pe perioade de timp
    final Map<String, Map<int, int>> temporalFreq = _calculateTemporalFrequency(
      optimizedDraws,
      mainRange,
      timeUnit,
      widget.getNumbers,
    );
    if (temporalFreq.isEmpty) {
      return Center(
        child: Text(
          'Nu există date valide pentru graficul temporal.',
          style: AppFonts.bodyStyle,
        ),
      );
    }
    // Găsesc numerele cu cele mai interesante tendințe
    final List<int> topNumbers = _findTopTrendingNumbers(
      temporalFreq,
      mainRange,
    );
    return Stack(
      children: [
        Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(bottom: 8.0),
                child: LayoutBuilder(
                  builder: (context, constraints) {
                    final chartWidth = constraints.maxWidth;
                    final chartHeight = constraints.maxHeight;
                    final periods = temporalFreq.keys.toList();
                    List<int> summerIdx = [];
                    List<int> winterIdx = [];
                    for (int i = 0; i < periods.length; i++) {
                      final p = periods[i];
                      final parts = p.split('-');
                      if (parts.length == 2) {
                        final m = int.tryParse(parts[1]) ?? 0;
                        if ([6, 7, 8].contains(m)) summerIdx.add(i);
                        if ([12, 1, 2].contains(m)) winterIdx.add(i);
                      }
                    }
                    return Stack(
                      children: [
                        ...summerIdx.map(
                          (i) => Positioned(
                            left: chartWidth * i / periods.length,
                            top: 0,
                            width: chartWidth / periods.length,
                            height: chartHeight,
                            child: Container(
                              color: Colors.yellow.withValues(alpha: 0.13),
                            ),
                          ),
                        ),
                        ...winterIdx.map(
                          (i) => Positioned(
                            left: chartWidth * i / periods.length,
                            top: 0,
                            width: chartWidth / periods.length,
                            height: chartHeight,
                            child: Container(
                              color: Colors.blue.withValues(alpha: 0.10),
                            ),
                          ),
                        ),
                        LineChart(
                          LineChartData(
                            minY: -1,
                            gridData: FlGridData(
                              show: true,
                              horizontalInterval: 1,
                            ),
                            borderData: FlBorderData(show: false),
                            titlesData: FlTitlesData(
                              leftTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 35,
                                  interval: 1,
                                  getTitlesWidget: (v, m) {
                                    int val = v.toInt();
                                    if (val < 0) return const SizedBox.shrink();

                                    // Afișez doar etichetele importante pentru axa Y
                                    final maxY = temporalFreq.values
                                        .expand((period) => period.values)
                                        .reduce((a, b) => a > b ? a : b);
                                    final step = (maxY / 4).ceil();
                                    if (val % step != 0 &&
                                        val != 0 &&
                                        val != maxY) {
                                      return const SizedBox.shrink();
                                    }

                                    return Text(
                                      val.toString(),
                                      style: TextStyle(
                                        fontSize: isDesktop ? 11 : 8,
                                        color: Colors.black54,
                                        fontWeight: FontWeight.w500,
                                      ),
                                    );
                                  },
                                ),
                              ),
                              bottomTitles: AxisTitles(
                                sideTitles: SideTitles(
                                  showTitles: true,
                                  reservedSize: 30,
                                  getTitlesWidget: (v, m) {
                                    int idx = v.toInt();
                                    if (idx < 0 || idx >= temporalFreq.length) {
                                      return const SizedBox.shrink();
                                    }

                                    final periods = temporalFreq.keys.toList();
                                    final period = periods[idx];
                                    final total = periods.length;

                                    // Calcul adaptiv pentru numărul de etichete - foarte agresiv pentru perioade mari
                                    int maxLabels;
                                    if (total <= 12) {
                                      maxLabels = total;
                                    } else if (total <= 30) {
                                      maxLabels = 15;
                                    } else if (total <= 60) {
                                      maxLabels = 20;
                                    } else if (total <= 100) {
                                      maxLabels = 25;
                                    } else if (total <= 200) {
                                      maxLabels = 35;
                                    } else if (total <= 500) {
                                      maxLabels = 40;
                                    } else if (total <= 1000) {
                                      maxLabels = 45;
                                    } else {
                                      maxLabels = 50;
                                    }

                                    // Calculez pozițiile labelurilor de afișat - distribuție îmbunătățită
                                    List<int> labelPositions = [];
                                    if (total <= maxLabels) {
                                      labelPositions = List.generate(
                                        total,
                                        (i) => i,
                                      );
                                    } else {
                                      // Prima și ultima etichetă mereu
                                      labelPositions = [0, total - 1];

                                      // Pentru perioade foarte mari, adaug etichete la intervale regulate
                                      if (total > 100) {
                                        // Pentru perioade mari, adaug etichete la intervale de 10%
                                        for (int i = 1; i <= 9; i++) {
                                          final position = (total * i / 10)
                                              .round();
                                          if (!labelPositions.contains(
                                            position,
                                          )) {
                                            labelPositions.add(position);
                                          }
                                        }
                                      } else if (total > 50) {
                                        // Pentru perioade medii, adaug etichete la 25%, 50%, 75%
                                        labelPositions.addAll([
                                          (total * 0.25).round(),
                                          (total * 0.5).round(),
                                          (total * 0.75).round(),
                                        ]);
                                      }

                                      // Etichetele intermediare - distribuție mai uniformă
                                      final remainingSlots =
                                          maxLabels - labelPositions.length;
                                      if (remainingSlots > 0) {
                                        // Pentru perioade foarte mari, distribuie etichetele mai dens
                                        if (total > 200) {
                                          final step =
                                              (total - 1) /
                                              (remainingSlots + 1);
                                          for (
                                            int i = 1;
                                            i <= remainingSlots;
                                            i++
                                          ) {
                                            final position = (step * i).round();
                                            if (!labelPositions.contains(
                                                  position,
                                                ) &&
                                                position > 0 &&
                                                position < total - 1) {
                                              labelPositions.add(position);
                                            }
                                          }
                                        } else {
                                          // Pentru perioade mai mici, distribuie uniform
                                          final step =
                                              (total - 1) /
                                              (remainingSlots + 1);
                                          for (
                                            int i = 1;
                                            i <= remainingSlots;
                                            i++
                                          ) {
                                            final position = (step * i).round();
                                            if (!labelPositions.contains(
                                                  position,
                                                ) &&
                                                position > 0 &&
                                                position < total - 1) {
                                              labelPositions.add(position);
                                            }
                                          }
                                        }
                                      }
                                      labelPositions.sort();
                                    }

                                    if (!labelPositions.contains(idx)) {
                                      return const SizedBox.shrink();
                                    }

                                    // Ajustez dimensiunea fontului în funcție de numărul de etichete
                                    double fontSize;
                                    if (total <= 20) {
                                      fontSize = isDesktop ? 10 : 7;
                                    } else if (total <= 40) {
                                      fontSize = isDesktop ? 9 : 6;
                                    } else if (total <= 100) {
                                      fontSize = isDesktop ? 8 : 5;
                                    } else if (total <= 500) {
                                      fontSize = isDesktop ? 7 : 4;
                                    } else {
                                      fontSize = isDesktop ? 6 : 3;
                                    }

                                    return Padding(
                                      padding: const EdgeInsets.only(top: 4.0),
                                      child: Text(
                                        formatPeriod(period),
                                        style: TextStyle(
                                          fontSize: fontSize,
                                          color: Colors.black87,
                                          fontWeight: FontWeight.w500,
                                        ),
                                        textAlign: TextAlign.center,
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
                            lineBarsData: _buildLineBarsData(
                              temporalFreq,
                              topNumbers,
                              isDesktop,
                            ),
                            lineTouchData: LineTouchData(
                              enabled: true,
                              touchTooltipData: LineTouchTooltipData(
                                fitInsideVertically: true,
                                fitInsideHorizontally: true,
                                maxContentWidth: 240,
                                tooltipPadding: const EdgeInsets.symmetric(
                                  horizontal: 14,
                                  vertical: 8,
                                ),
                                getTooltipItems: (touchedSpots) {
                                  return touchedSpots.map((spot) {
                                    final number = topNumbers[spot.barIndex];
                                    final periods = temporalFreq.keys.toList();
                                    final period = periods[spot.x.toInt()];
                                    final formattedPeriod = formatPeriod(
                                      period,
                                    );
                                    return LineTooltipItem(
                                      'Număr: $number\nPerioadă: $formattedPeriod\nApariții: ${spot.y.toInt()}',
                                      TextStyle(
                                        fontWeight: FontWeight.w500,
                                        color: Colors.black87,
                                        fontSize: isDesktop ? 12 : 9,
                                        shadows: [
                                          Shadow(
                                            color: Colors.white.withValues(alpha: 
                                              0.18,
                                            ),
                                            blurRadius: 4,
                                          ),
                                        ],
                                      ),
                                    );
                                  }).toList();
                                },
                              ),
                            ),
                          ),
                        ),
                      ],
                    );
                  },
                ),
              ),
            ),
            const SizedBox(height: 10),
            _buildLegend(topNumbers, isDesktop),
          ],
        ),
      ],
    );
  }

  Map<String, Map<int, int>> _calculateTemporalFrequency(
    List<LotoDraw> draws,
    int mainRange,
    String timeUnit,
    List<int> Function(LotoDraw draw) getNumbers,
  ) {
    Map<String, Map<int, int>> temporalFreq = {};
    for (LotoDraw draw in draws) {
      String period = _getPeriodKey(draw.date, timeUnit);
      if (!temporalFreq.containsKey(period)) {
        temporalFreq[period] = {for (var i = 1; i <= mainRange; i++) i: 0};
      }
      for (int number in getNumbers(draw)) {
        if (number >= 1 && number <= mainRange) {
          temporalFreq[period]![number] =
              (temporalFreq[period]![number] ?? 0) + 1;
        }
      }
    }
    // Sortează perioadele cronologic
    List<String> sortedPeriods = temporalFreq.keys.toList()..sort();
    Map<String, Map<int, int>> sortedTemporalFreq = {};
    for (String period in sortedPeriods) {
      sortedTemporalFreq[period] = temporalFreq[period]!;
    }
    return sortedTemporalFreq;
  }

  List<int> _findTopTrendingNumbers(
    Map<String, Map<int, int>> temporalFreq,
    int mainRange,
  ) {
    if (temporalFreq.isEmpty) return [];
    Map<int, double> variations = {};
    for (int number = 1; number <= mainRange; number++) {
      List<int> frequencies = [];
      for (Map<int, int> periodFreq in temporalFreq.values) {
        frequencies.add(periodFreq[number] ?? 0);
      }
      if (frequencies.length > 1) {
        double mean = frequencies.reduce((a, b) => a + b) / frequencies.length;
        double variance =
            frequencies
                .map((f) => (f - mean) * (f - mean))
                .reduce((a, b) => a + b) /
            frequencies.length;
        double stdDev = sqrt(variance);
        double cv = mean > 0 ? (stdDev / mean) * 100 : 0;
        variations[number] = cv;
      }
    }
    List<MapEntry<int, double>> sortedVariations = variations.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    return sortedVariations.take(5).map((e) => e.key).toList();
  }

  List<LineChartBarData> _buildLineBarsData(
    Map<String, Map<int, int>> temporalFreq,
    List<int> topNumbers,
    bool isDesktop,
  ) {
    List<LineChartBarData> lineBars = [];
    List<Color> colors = [
      AppColors.primaryGreenDark,
      AppColors.errorRedMedium,
      const Color(0xFF3B82F6),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
    ];
    for (int i = 0; i < topNumbers.length; i++) {
      int number = topNumbers[i];
      List<FlSpot> spots = [];
      int spotIndex = 0;
      for (Map<int, int> periodFreq in temporalFreq.values) {
        double y = (periodFreq[number] ?? 0).toDouble();
        if (y < 0) y = 0;
        spots.add(FlSpot(spotIndex.toDouble(), y));
        spotIndex++;
      }
      lineBars.add(
        LineChartBarData(
          spots: spots,
          isCurved: true,
          color: colors[i % colors.length],
          barWidth: isDesktop ? 1.0 : 0.8,
          isStrokeCapRound: true,
          dotData: FlDotData(
            show: true,
            getDotPainter: (spot, percent, barData, index) {
              return FlDotCirclePainter(
                radius: 4,
                color: colors[i % colors.length],
                strokeWidth: 2,
                strokeColor: Colors.white,
              );
            },
          ),
          belowBarData: BarAreaData(
            show: true,
            color: colors[i % colors.length].withValues(alpha: 0.1),
          ),
        ),
      );
    }
    return lineBars;
  }

  Widget _buildLegend(List<int> topNumbers, bool isDesktop) {
    List<Color> colors = [
      AppColors.primaryGreenDark,
      AppColors.errorRedMedium,
      const Color(0xFF3B82F6),
      const Color(0xFFF59E0B),
      const Color(0xFF8B5CF6),
    ];
    final legendFontSize = isDesktop ? 10.0 : 8.0;
    final iconSize = isDesktop ? 12.0 : 8.0;
    final paddingH = isDesktop ? 8.0 : 4.0;
    final paddingV = isDesktop ? 4.0 : 2.0;
    final spacing = isDesktop ? 8.0 : 3.0;
    final minRunSpacing = 4.0;
    return Wrap(
      alignment: WrapAlignment.center,
      spacing: spacing,
      runSpacing: minRunSpacing,
      children: topNumbers.asMap().entries.map((entry) {
        int index = entry.key;
        int number = entry.value;
        Color color = colors[index % colors.length];
        return Container(
          padding: EdgeInsets.symmetric(
            horizontal: paddingH,
            vertical: paddingV,
          ),
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.13),
            borderRadius: BorderRadius.circular(isDesktop ? 8 : 5),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Container(
                width: iconSize,
                height: iconSize,
                decoration: BoxDecoration(color: color, shape: BoxShape.circle),
              ),
              SizedBox(width: isDesktop ? 6 : 3),
              Text(
                'Număr $number',
                style: AppFonts.captionStyle.copyWith(
                  color: color,
                  fontWeight: FontWeight.bold,
                  fontSize: legendFontSize,
                ),
              ),
            ],
          ),
        );
      }).toList(),
    );
  }

  String _getPeriodKey(DateTime date, String timeUnit) {
    switch (timeUnit) {
      case 'month':
        return '${date.year}-${date.month.toString().padLeft(2, '0')}';
      case 'quarter':
        int quarter = ((date.month - 1) / 3).floor() + 1;
        return '${date.year}-Q$quarter';
      case 'year':
        return date.year.toString();
      default:
        return '${date.year}-${date.month.toString().padLeft(2, '0')}';
    }
  }

  String formatPeriod(String period) {
    // Format pentru luni: YYYY-MM -> MM-YY
    final monthReg = RegExp(r'^(\d{4})-(\d{2})$');
    final monthMatch = monthReg.firstMatch(period);
    if (monthMatch != null) {
      final year = monthMatch.group(1)!.substring(2, 4);
      final month = monthMatch.group(2);
      return '$month/$year';
    }

    // Format pentru trimestre: YYYY-QN -> QN-YY
    final quarterReg = RegExp(r'^(\d{4})-Q(\d)$');
    final quarterMatch = quarterReg.firstMatch(period);
    if (quarterMatch != null) {
      final year = quarterMatch.group(1)!.substring(2, 4);
      final quarter = quarterMatch.group(2);
      return 'Q$quarter/$year';
    }

    // Format pentru ani: YYYY -> YY
    final yearReg = RegExp(r'^(\d{4})$');
    final yearMatch = yearReg.firstMatch(period);
    if (yearMatch != null) {
      final year = yearMatch.group(1)!.substring(2, 4);
      return year;
    }

    return period;
  }
}

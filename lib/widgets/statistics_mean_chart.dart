import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/loto_draw.dart';
import '../utils/constants.dart';
import 'dart:math';

class StatisticsMeanChart extends StatelessWidget {
  final List<LotoDraw> draws;
  const StatisticsMeanChart({super.key, required this.draws});

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    final draws = this.draws;

    if (draws.isEmpty) {
      return Center(
        child: Text(
          'Nu exista date pentru graficul de medie.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    final List<LotoDraw> optimizedDraws = draws;
    final List<double> means = optimizedDraws.map((d) => d.average).toList();
    final double avg = means.isNotEmpty
        ? means.reduce((a, b) => a + b) / means.length
        : 0;
    final double minMean = means.isNotEmpty
        ? means.reduce((a, b) => a < b ? a : b)
        : 0;
    final double maxMean = means.isNotEmpty
        ? means.reduce((a, b) => a > b ? a : b)
        : 0;

    if (minMean == maxMean || means.isEmpty || minMean.isNaN || maxMean.isNaN) {
      return Center(
        child: Text(
          'Nu exista date suficiente pentru graficul de medie.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    double fontSize = isDesktop ? 12 : 8;
    double dotSize = isDesktop ? 4 : 2.5;
    int maxLabels = 10;
    int step = 1;
    if (draws.length > maxLabels) {
      step = (draws.length / maxLabels).ceil();
    }

    // Calcul pentru interval Y (ca la Sum)
    double yInterval = (maxMean - minMean) / 5;
    if (yInterval < 1) yInterval = 1;
    // Step pentru etichete Y (max 8-10)
    int maxYLabels = 8;
    double yStep = ((maxMean - minMean) / maxYLabels).ceilToDouble();
    if (yStep < 1) yStep = 1;

    int maxXLabels = 15;
    int stepX = (draws.length / maxXLabels).ceil();
    double lastLabelValue = double.negativeInfinity;
    return LineChart(
      LineChartData(
        minY: minMean - 2,
        maxY: maxMean + 2,
        gridData: FlGridData(show: true, horizontalInterval: yInterval),
        borderData: FlBorderData(show: false),
        titlesData: FlTitlesData(
          leftTitles: AxisTitles(
            sideTitles: SideTitles(
              showTitles: true,
              reservedSize: (maxMean - minMean) > 50 ? 40 : 32,
              getTitlesWidget: (v, m) {
                if (v < minMean - 2 || v > maxMean + 2) {
                  return const SizedBox.shrink();
                }
                if ((v - lastLabelValue).abs() < 1) {
                  return const SizedBox.shrink();
                }
                lastLabelValue = v;
                return Text(
                  v.toStringAsFixed(1),
                  style: TextStyle(
                    fontSize: (maxMean - minMean) > 50
                        ? (fontSize * 0.85)
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
                int idx = v.toInt();
                if (idx < 0 || idx >= draws.length) {
                  return const SizedBox.shrink();
                }
                if (draws.length <= maxXLabels) {
                  // Pentru intervale mici, afi?eaza fiecare eticheta o singura data, doar pentru valori întregi
                  if (v % 1 == 0) {
                    return Text(
                      (idx + 1).toString(),
                      style: TextStyle(
                        fontSize: fontSize,
                        color: Colors.black87,
                      ),
                    );
                  } else {
                    return const SizedBox.shrink();
                  }
                } else {
                  // Pentru intervale mari, stepX
                  if ((idx % stepX != 0) &&
                      idx != 0 &&
                      idx != draws.length - 1) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    (idx + 1).toString(),
                    style: TextStyle(fontSize: fontSize, color: Colors.black87),
                  );
                }
              },
            ),
          ),
          rightTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
          topTitles: AxisTitles(sideTitles: SideTitles(showTitles: false)),
        ),
        lineBarsData: [
          LineChartBarData(
            spots: [
              for (int i = 0; i < means.length; i++)
                FlSpot(i.toDouble(), means[i]),
            ],
            isCurved: true,
            color: AppColors.secondaryBlueMedium,
            barWidth: isDesktop ? 1.2 : 0.8,
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
          LineChartBarData(
            spots: [FlSpot(0, avg), FlSpot(means.length - 1.0, avg)],
            isCurved: false,
            color: AppColors.primaryGreenDark,
            barWidth: isDesktop ? 1.6 : 1.1,
            dashArray: [8, 6],
            dotData: FlDotData(show: false),
            belowBarData: BarAreaData(show: false),
          ),
        ],
        lineTouchData: LineTouchData(
          enabled: true,
          touchTooltipData: LineTouchTooltipData(
            tooltipPadding: const EdgeInsets.symmetric(
              horizontal: 14,
              vertical: 8,
            ),
            fitInsideHorizontally: true,
            fitInsideVertically: true,
            tooltipBorder: BorderSide(color: Color(0xFFFFA726), width: 1.2),
            tooltipHorizontalAlignment: FLHorizontalAlignment.center,
            tooltipMargin: 8,
            getTooltipItems: (touchedSpots) {
              return touchedSpots.map((spot) {
                if (spot.barIndex != 0) {
                  // Tooltip gol pentru liniile secundare
                  return LineTooltipItem('', TextStyle());
                }
                int idx = spot.x.toInt();
                if (idx < 0 || idx >= draws.length) {
                  return LineTooltipItem('', TextStyle());
                }
                final draw = draws[idx];
                String dateStr =
                    "${draw.date.day.toString().padLeft(2, '0')}.${draw.date.month.toString().padLeft(2, '0')}.${draw.date.year}";
                return LineTooltipItem(
                  'Extragere:  \t${draws.length - idx}\nData: $dateStr\nMedia: ${means[idx].toStringAsFixed(2)}',
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
              }).toList();
            },
          ),
          getTouchedSpotIndicator: (barData, indicators) {
            return indicators.map((indicator) {
              return TouchedSpotIndicatorData(
                FlLine(color: Color(0xFFFFA726), strokeWidth: 2),
                FlDotData(
                  getDotPainter: (spot, percent, barData, index) {
                    return FlDotCirclePainter(
                      radius: dotSize,
                      color: barData.color ?? Colors.blue,
                      strokeWidth: 2,
                      strokeColor: Colors.white,
                    );
                  },
                ),
              );
            }).toList();
          },
        ),
      ),
    );
  }

  // Narativa moderna cu iconi?e ?i spa?iere uniforma
  Widget _buildMeanNarrativeModern(
    List<LotoDraw> draws,
    double avg,
    double minMean,
    double maxMean,
    bool isDesktop,
  ) {
    if (draws.isEmpty) return const SizedBox.shrink();
    final List<double> means = draws.map((d) => d.average).toList();
    final double range = maxMean - minMean;
    final aboveAvg = means.where((m) => m > avg).length;
    final belowAvg = means.where((m) => m < avg).length;
    int maxConsecutiveAbove = 0, currentConsecutiveAbove = 0;
    int maxConsecutiveBelow = 0, currentConsecutiveBelow = 0;
    for (final mean in means) {
      if (mean > avg) {
        currentConsecutiveAbove++;
        currentConsecutiveBelow = 0;
        if (currentConsecutiveAbove > maxConsecutiveAbove) {
          maxConsecutiveAbove = currentConsecutiveAbove;
        }
      } else if (mean < avg) {
        currentConsecutiveBelow++;
        currentConsecutiveAbove = 0;
        if (currentConsecutiveBelow > maxConsecutiveBelow) {
          maxConsecutiveBelow = currentConsecutiveBelow;
        }
      } else {
        currentConsecutiveAbove = 0;
        currentConsecutiveBelow = 0;
      }
    }
    final variance =
        means.map((m) => (m - avg) * (m - avg)).reduce((a, b) => a + b) /
        means.length;
    final stdDev = sqrt(variance);
    final cv = (stdDev / avg) * 100;
    final stability = 100 - cv;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.green[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Graficul de mai sus arata media numerelor extrase la fiecare extragere. Linia verde reprezinta media generala.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.trending_up, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Media maxima întâlnita: ${maxMean.toStringAsFixed(1)}.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.trending_down, color: Colors.red, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Media minima întâlnita: ${minMean.toStringAsFixed(1)}.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.arrow_upward, color: Colors.green, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '$aboveAvg extrageri au avut media peste media generala (${avg.toStringAsFixed(2)}).',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.arrow_downward, color: Colors.orange, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '$belowAvg extrageri au avut media sub media generala.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.show_chart, color: Colors.purple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cea mai lunga serie de extrageri peste medie: $maxConsecutiveAbove.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.show_chart, color: Colors.indigo, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cea mai lunga serie de extrageri sub medie: $maxConsecutiveBelow.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.analytics, color: Colors.teal, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Stabilitatea mediilor: ${stability.toStringAsFixed(1)}%.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.straighten, color: Colors.amber[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Amplitudinea mediilor: ${range.toStringAsFixed(1)}.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  static Widget _buildMeanNarrativeModernStatic(List<LotoDraw> draws) {
    if (draws.isEmpty) return const SizedBox.shrink();
    final means = draws.map((d) => d.average).toList();
    final avg = means.isNotEmpty
        ? means.reduce((a, b) => a + b) / means.length
        : 0;
    final minMean = means.isNotEmpty
        ? means.reduce((a, b) => a < b ? a : b)
        : 0;
    final maxMean = means.isNotEmpty
        ? means.reduce((a, b) => a > b ? a : b)
        : 0;
    final range = maxMean - minMean;
    final aboveAvg = means.where((m) => m > avg).length;
    final belowAvg = means.where((m) => m < avg).length;
    int maxConsecutiveAbove = 0, currentConsecutiveAbove = 0;
    int maxConsecutiveBelow = 0, currentConsecutiveBelow = 0;
    for (final mean in means) {
      if (mean > avg) {
        currentConsecutiveAbove++;
        currentConsecutiveBelow = 0;
        if (currentConsecutiveAbove > maxConsecutiveAbove) {
          maxConsecutiveAbove = currentConsecutiveAbove;
        }
      } else if (mean < avg) {
        currentConsecutiveBelow++;
        currentConsecutiveAbove = 0;
        if (currentConsecutiveBelow > maxConsecutiveBelow) {
          maxConsecutiveBelow = currentConsecutiveBelow;
        }
      } else {
        currentConsecutiveAbove = 0;
        currentConsecutiveBelow = 0;
      }
    }
    final variance =
        means.map((m) => (m - avg) * (m - avg)).reduce((a, b) => a + b) /
        means.length;
    final stdDev = sqrt(variance);
    final cv = (stdDev / avg) * 100;
    final stability = 100 - cv;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.green[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Graficul de mai sus arata media numerelor extrase la fiecare extragere. Linia verde reprezinta media generala.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.trending_up, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Media maxima întâlnita: ${maxMean.toStringAsFixed(1)}.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.trending_down, color: Colors.red, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Media minima întâlnita: ${minMean.toStringAsFixed(1)}.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.arrow_upward, color: Colors.green, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '$aboveAvg extrageri au avut media peste media generala (${avg.toStringAsFixed(2)}).',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.arrow_downward, color: Colors.orange, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '$belowAvg extrageri au avut media sub media generala.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.show_chart, color: Colors.purple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cea mai lunga serie de extrageri peste medie: $maxConsecutiveAbove.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.show_chart, color: Colors.indigo, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cea mai lunga serie de extrageri sub medie: $maxConsecutiveBelow.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.analytics, color: Colors.teal, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Stabilitatea mediilor: ${stability.toStringAsFixed(1)}%.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.straighten, color: Colors.amber[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Amplitudinea mediilor: ${range.toStringAsFixed(1)}.',
                style: TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

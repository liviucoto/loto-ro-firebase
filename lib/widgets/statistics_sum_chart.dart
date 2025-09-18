import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../utils/constants.dart';
import '../models/loto_draw.dart';

class StatisticsSumChart extends StatefulWidget {
  final List<LotoDraw> draws;
  final bool hideLegendAndButton;
  const StatisticsSumChart({
    super.key,
    required this.draws,
    this.hideLegendAndButton = false,
  });

  @override
  State<StatisticsSumChart> createState() => _StatisticsSumChartState();
}

class _StatisticsSumChartState extends State<StatisticsSumChart> {
  // Vizibilitate linii
  bool showAvg = true;
  bool showSmall = true;
  bool showLarge = true;

  double? _lastTouchX; // Salvez ultima pozi?ie de touch X

  Widget _buildBadge(
    String text,
    IconData icon,
    Color color, {
    Color? textColor,
    double? fontSize,
    double? iconSize,
    double? opacity,
  }) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 6, vertical: 4),
      decoration: BoxDecoration(
        color: color.withValues(alpha: opacity ?? 0.22),
        borderRadius: BorderRadius.circular(10),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: iconSize ?? 10),
          const SizedBox(width: 4),
          Text(
            text,
            style: TextStyle(
              color: textColor ?? color,
              fontWeight: FontWeight.w700,
              fontSize: fontSize ?? 9,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildSumLegend(
    double avg,
    double avgSmall,
    double avgLarge,
    bool isDesktop,
  ) {
    final double legendFont = isDesktop ? 10 : 9;
    final double legendIcon = isDesktop ? 11 : 10;
    return Padding(
      padding: const EdgeInsets.only(top: 8, bottom: 2),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          _buildBadge(
            'Media  ${avg.toStringAsFixed(2)}',
            Icons.horizontal_rule,
            AppColors.secondaryBlueMedium,
            textColor: Colors.blue[900],
            fontSize: legendFont,
            iconSize: legendIcon,
          ),
          const SizedBox(width: 4),
          _buildBadge(
            'Media mica  ${avgSmall.toStringAsFixed(2)}',
            Icons.horizontal_rule,
            AppColors.accentPurple,
            textColor: Colors.purple[900],
            fontSize: legendFont,
            iconSize: legendIcon,
          ),
          const SizedBox(width: 4),
          _buildBadge(
            'Media mare  ${avgLarge.toStringAsFixed(2)}',
            Icons.horizontal_rule,
            AppColors.primaryGreenDark,
            textColor: Colors.green[900],
            fontSize: legendFont,
            iconSize: legendIcon,
            opacity: 0.32,
          ),
        ],
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    final draws = widget.draws;

    if (draws.isEmpty) {
      return Center(
        child: Text(
          'Nu exista date pentru graficul de sume.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    // Determin daca e selectat "Toate extragerile" (nu limitez la 500)
    final bool allDrawsSelected =
        ModalRoute.of(context)?.settings.arguments == 'Toate extragerile' ||
        widget.draws.length == draws.length;
    final int maxPoints = isDesktop ? 500 : 300;
    final List<LotoDraw> optimizedDraws = (allDrawsSelected)
        ? draws
        : (draws.length > maxPoints ? draws.sublist(0, maxPoints) : draws);

    // Pregatesc datele pentru grafic
    final List<double> sums = optimizedDraws
        .map((d) => d.sum.toDouble())
        .toList();

    final double avg = sums.isNotEmpty
        ? sums.reduce((a, b) => a + b) / sums.length
        : 0;

    final List<double> smallSums = sums.where((s) => s < avg).toList();
    final List<double> largeSums = sums.where((s) => s >= avg).toList();

    final double avgSmall = smallSums.isNotEmpty
        ? smallSums.reduce((a, b) => a + b) / smallSums.length
        : 0;
    final double avgLarge = largeSums.isNotEmpty
        ? largeSums.reduce((a, b) => a + b) / largeSums.length
        : 0;
    final double minSum = sums.isNotEmpty
        ? sums.reduce((a, b) => a < b ? a : b)
        : 0;
    final double maxSum = sums.isNotEmpty
        ? sums.reduce((a, b) => a > b ? a : b)
        : 0;

    if (minSum == maxSum || sums.isEmpty || minSum.isNaN || maxSum.isNaN) {
      return Center(
        child: Text(
          'Nu exista date suficiente pentru graficul de sume.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    double fontSize = isDesktop ? 12 : 8;
    double dotSize = isDesktop ? 4 : 2.5;

    // Step dinamic pentru etichete X, max 15 etichete
    int maxLabels = 15;
    int step = 1;
    if (optimizedDraws.length > maxLabels) {
      step = (optimizedDraws.length / maxLabels).ceil();
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
          return const SizedBox.shrink();
        }
        final isMobile = !isDesktop;
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            if (!widget.hideLegendAndButton) ...[
              Row(
                children: [
                  InkWell(
                    borderRadius: BorderRadius.circular(16),
                    onTap: () {
                      showDialog(
                        context: context,
                        builder: (ctx) => AlertDialog(
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20),
                          ),
                          backgroundColor: Colors.white.withValues(alpha: 0.85),
                          title: Row(
                            children: [
                              Icon(Icons.info_outline, color: Colors.blueGrey),
                              SizedBox(width: 8),
                              Text(
                                'Analiza narativa',
                                style: AppFonts.titleStyle.copyWith(
                                  fontSize: 18,
                                ),
                              ),
                            ],
                          ),
                          actions: [
                            TextButton(
                              onPressed: () => Navigator.of(ctx).pop(),
                              child: Text('Închide'),
                            ),
                          ],
                        ),
                      );
                    },
                    child: Row(
                      children: [
                        Icon(
                          Icons.info_outline,
                          size: 20,
                          color: Colors.blueGrey,
                        ),
                        SizedBox(width: 4),
                        Text(
                          'Analiza narativa',
                          style: TextStyle(
                            fontSize: 13,
                            color: Colors.blueGrey,
                          ),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 8),
            ],
            // Chart-ul ocupa tot spa?iul ramas
            Expanded(
              child: RepaintBoundary(
                child: LineChart(
                  LineChartData(
                    minY: minSum - 2,
                    maxY: maxSum + 2,
                    gridData: FlGridData(
                      show: true,
                      horizontalInterval: (maxSum - minSum) / 5,
                    ),
                    borderData: FlBorderData(show: false),
                    titlesData: FlTitlesData(
                      leftTitles: AxisTitles(
                        sideTitles: SideTitles(
                          showTitles: true,
                          reservedSize: maxSum > 200 ? 45 : 32,
                          getTitlesWidget: (v, m) {
                            int val = v.toInt();
                            if (val < 0 || val > maxSum + 2) {
                              return const SizedBox.shrink();
                            }

                            // Pentru valori mari, afi?eaza doar la intervale, dar mai multe
                            if (maxSum > 200) {
                              int step = (maxSum / 6)
                                  .ceil(); // Reduc step-ul pentru mai multe etichete
                              if (val % step != 0 &&
                                  val != 0 &&
                                  val != maxSum &&
                                  val != maxSum ~/ 2) {
                                return const SizedBox.shrink();
                              }
                            } else if (maxSum > 100) {
                              // Pentru valori medii, afi?eaza la fiecare 10
                              if (val % 10 != 0 && val != 0 && val != maxSum) {
                                return const SizedBox.shrink();
                              }
                            }

                            return Text(
                              val.toString(),
                              style: TextStyle(
                                fontSize: maxSum > 200
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
                            if (idx < 0 || idx >= optimizedDraws.length) {
                              return const SizedBox.shrink();
                            }
                            if (optimizedDraws.length <= maxLabels) {
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
                              // Step logic pentru intervale mari
                              if (step > 1 &&
                                  idx % step != 0 &&
                                  idx != 0 &&
                                  idx != optimizedDraws.length - 1) {
                                return const SizedBox.shrink();
                              }
                              return Text(
                                (idx + 1).toString(),
                                style: TextStyle(
                                  fontSize: fontSize,
                                  color: Colors.black87,
                                ),
                              );
                            }
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
                    lineBarsData: [
                      // Suma per extragere
                      LineChartBarData(
                        spots: [
                          for (int i = 0; i < sums.length; i++)
                            FlSpot(i.toDouble(), sums[i]),
                        ],
                        isCurved: true,
                        color: const Color(0xFF3B82F6),
                        barWidth: isDesktop ? 1.5 : 1.1, // sub?ire
                        dotData: FlDotData(show: false),
                        belowBarData: BarAreaData(show: false),
                      ),
                      // Media generala
                      if (showAvg)
                        LineChartBarData(
                          spots: [
                            FlSpot(0, avg),
                            FlSpot(sums.length - 1.0, avg),
                          ],
                          isCurved: false,
                          color: AppColors.secondaryBlueMedium.withValues(
                            alpha: showAvg ? 1 : 0.2,
                          ),
                          barWidth: isDesktop ? 1.5 : 1.1, // sub?ire
                          dashArray: [8, 6],
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      if (showSmall)
                        LineChartBarData(
                          spots: [
                            FlSpot(0, avgSmall),
                            FlSpot(sums.length - 1.0, avgSmall),
                          ],
                          isCurved: false,
                          color: AppColors.accentPurple.withValues(
                            alpha: showSmall ? 1 : 0.2,
                          ),
                          barWidth: isDesktop ? 1.5 : 1.1, // sub?ire
                          dashArray: [4, 6],
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                      if (showLarge)
                        LineChartBarData(
                          spots: [
                            FlSpot(0, avgLarge),
                            FlSpot(sums.length - 1.0, avgLarge),
                          ],
                          isCurved: false,
                          color: AppColors.primaryGreen.withValues(
                            alpha: showLarge ? 1 : 0.2,
                          ),
                          barWidth: isDesktop ? 1.5 : 1.1, // sub?ire
                          dashArray: [4, 6],
                          dotData: FlDotData(show: false),
                          belowBarData: BarAreaData(show: false),
                        ),
                    ],
                    lineTouchData: LineTouchData(
                      enabled: true,
                      touchCallback:
                          (FlTouchEvent event, LineTouchResponse? response) {
                            if (event is FlTapUpEvent ||
                                event is FlPanUpdateEvent) {
                              _lastTouchX = event.localPosition?.dx;
                            }
                          },
                      touchTooltipData: LineTouchTooltipData(
                        tooltipPadding: const EdgeInsets.symmetric(
                          horizontal: 14,
                          vertical: 8,
                        ),
                        fitInsideHorizontally: true,
                        fitInsideVertically: true,
                        getTooltipItems: (touchedSpots) {
                          if (touchedSpots.isEmpty) return [];
                          return touchedSpots.map((spot) {
                            if (spot.barIndex != 0) {
                              return null; // Doar linia principala
                            }
                            int idx = spot.x.toInt();
                            if (idx < 0 || idx >= optimizedDraws.length) {
                              idx = idx < 0 ? 0 : optimizedDraws.length - 1;
                            }
                            final draw = optimizedDraws[idx];
                            String dateStr =
                                "${draw.date.day.toString().padLeft(2, '0')}.${draw.date.month.toString().padLeft(2, '0')}.${draw.date.year}";
                            return LineTooltipItem(
                              'Extragere: ${optimizedDraws.length - idx}\nData: $dateStr\nSuma: ${draw.sum}\nMedia: ${avg.toStringAsFixed(2)}\nMedia mica: ${avgSmall.toStringAsFixed(2)}\nMedia mare: ${avgLarge.toStringAsFixed(2)}',
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
                        tooltipBorder: BorderSide(
                          color: Color(0xFFFFA726),
                          width: 1.2,
                        ),
                        tooltipHorizontalAlignment:
                            FLHorizontalAlignment.center,
                        tooltipMargin: 8,
                      ),
                      getTouchedSpotIndicator: (barData, indicators) {
                        // Folose?te portocaliu pentru linia de tracking
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
                ),
              ),
            ),
            const SizedBox(height: 6),
            if (!widget.hideLegendAndButton)
              _buildSumLegend(avg, avgSmall, avgLarge, isDesktop),
            const SizedBox(height: 6),
          ],
        );
      },
    );
  }
}

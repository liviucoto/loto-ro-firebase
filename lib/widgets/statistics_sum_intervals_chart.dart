import 'package:flutter/material.dart';
import 'package:fl_chart/fl_chart.dart';
import '../models/loto_draw.dart';
import '../utils/constants.dart';

class StatisticsSumIntervalsChart extends StatefulWidget {
  final List<LotoDraw> draws;
  final int interval;
  final void Function(Map<String, dynamic> stats)? onStatsChanged;
  const StatisticsSumIntervalsChart({
    super.key,
    required this.draws,
    required this.interval,
    this.onStatsChanged,
  });

  // Metoda publica pentru a accesa narativa
  Widget buildIntervalNarrative(List<LotoDraw> draws, bool isDesktop) {
    return _StatisticsSumIntervalsChartState()._buildIntervalNarrative(
      draws,
      isDesktop,
    );
  }

  @override
  State<StatisticsSumIntervalsChart> createState() =>
      _StatisticsSumIntervalsChartState();
}

class _StatisticsSumIntervalsChartState
    extends State<StatisticsSumIntervalsChart> {
  // Removed customMode and customController as interval selection is now handled externally.
  Map<String, dynamic>? _lastStats;

  List<Map<String, dynamic>> _calculateHistogram(int interval) {
    if (widget.draws.isEmpty) return [];

    // Validare interval - protec?ie împotriva valorilor invalide
    if (interval <= 0) {
      // Daca intervalul este invalid, folose?te o valoare default sigura
      interval = 20;
    }

    final sums = widget.draws.map((d) => d.sum).toList();
    if (sums.isEmpty) return [];

    final minSum = sums.reduce((a, b) => a < b ? a : b);
    final maxSum = sums.reduce((a, b) => a > b ? a : b);

    // Protec?ie împotriva intervalelor prea mari care ar crea prea multe bare
    final maxBars = 50; // Limita maxima pentru numarul de bare
    final range = maxSum - minSum + 1;
    if (interval > range) {
      interval = range; // Ajusteaza intervalul daca este prea mare
    }

    // Protec?ie împotriva intervalelor prea mici care ar crea prea multe bare
    final estimatedBins = range ~/ interval;
    if (estimatedBins > maxBars) {
      interval = (range / maxBars)
          .ceil(); // Ajusteaza intervalul pentru a avea maxim maxBars
    }

    List<Map<String, dynamic>> bins = [];
    for (
      int start = (minSum ~/ interval) * interval;
      start <= maxSum;
      start += interval
    ) {
      int end = start + interval - 1;
      int freq = sums.where((s) => s >= start && s <= end).length;
      bins.add({'start': start, 'end': end, 'freq': freq});

      // Protec?ie împotriva prea multor bare
      if (bins.length >= maxBars) break;
    }
    return bins;
  }

  List<Map<String, dynamic>> _calculateHistogramOptimized(
    List<LotoDraw> draws,
    int interval,
  ) {
    if (draws.isEmpty) return [];

    // Validare interval - protec?ie împotriva valorilor invalide
    if (interval <= 0) {
      interval = 20;
    }

    final sums = draws.map((d) => d.sum).toList();
    if (sums.isEmpty) return [];

    final minSum = sums.reduce((a, b) => a < b ? a : b);
    final maxSum = sums.reduce((a, b) => a > b ? a : b);

    // Protec?ie împotriva intervalelor prea mari care ar crea prea multe bare
    final maxBars = 50; // Limita maxima pentru numarul de bare
    final range = maxSum - minSum + 1;
    if (interval > range) {
      interval = range; // Ajusteaza intervalul daca este prea mare
    }

    // Protec?ie împotriva intervalelor prea mici care ar crea prea multe bare
    final estimatedBins = range ~/ interval;
    if (estimatedBins > maxBars) {
      interval = (range / maxBars)
          .ceil(); // Ajusteaza intervalul pentru a avea maxim maxBars
    }

    List<Map<String, dynamic>> bins = [];
    for (
      int start = (minSum ~/ interval) * interval;
      start <= maxSum;
      start += interval
    ) {
      int end = start + interval - 1;
      int freq = sums.where((s) => s >= start && s <= end).length;
      bins.add({'start': start, 'end': end, 'freq': freq});

      // Protec?ie împotriva prea multor bare
      if (bins.length >= maxBars) break;
    }
    return bins;
  }

  // No need to dispose customController, as it is no longer used.

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    final draws = widget.draws;

    if (draws.isEmpty) {
      return Center(
        child: Text(
          'Nu exista date pentru graficul de intervale de suma.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    // OPTIMIZARE: Limitez numarul de extrageri pentru perioade mari
    final int maxDrawsForIntervals = 2000;
    final List<LotoDraw> optimizedDraws = draws.length > maxDrawsForIntervals
        ? draws.sublist(0, maxDrawsForIntervals)
        : draws;

    // Validare interval înainte de calcul
    int safeInterval = widget.interval;
    if (safeInterval <= 0) {
      safeInterval = 20; // Valoare default sigura
    }

    // Reset _lastStats daca intervalul s-a schimbat
    if (_lastStats != null && _lastStats!['interval'] != safeInterval) {
      _lastStats = null;
    }

    // Calculez histograma folosind datele optimizate
    final bins = _calculateHistogramOptimized(optimizedDraws, safeInterval);
    if (bins.isEmpty) {
      return Center(
        child: Text(
          'Nu exista date suficiente pentru graficul de intervale de suma.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    // Protec?ie împotriva datelor invalide pentru statistici
    if (bins.isEmpty) {
      return Center(
        child: Text(
          'Date insuficiente pentru calculul statisticilor.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    double fontSize = isDesktop ? 12 : 8;
    final int maxBars = 30;
    final bool tooManyBars = bins.length > maxBars;

    // Statistici pentru eviden?iere - cu protec?ii
    final maxFreq = bins
        .map((b) => b['freq'] as int)
        .reduce((a, b) => a > b ? a : b);
    final minFreq = bins
        .map((b) => b['freq'] as int)
        .reduce((a, b) => a < b ? a : b);
    final maxIdx = bins.indexWhere((b) => b['freq'] == maxFreq);
    final minIdx = bins.indexWhere((b) => b['freq'] == minFreq);
    final avgFreq =
        (bins.map((b) => b['freq'] as int).reduce((a, b) => a + b) /
                bins.length)
            .toStringAsFixed(2);
    final totalDraws = optimizedDraws.length;

    // Top 5 intervale frecvente - cu protec?ie
    final top5 = bins.toList()
      ..sort((a, b) => (b['freq'] as int).compareTo(a['freq'] as int));
    final top5Frequent = top5.take(5).toList();

    // Trimite datele pentru legenda daca e nevoie
    final stats = {
      'maxIdx': maxIdx >= 0 ? maxIdx : null, // Protec?ie pentru index invalid
      'minIdx': minIdx >= 0 ? minIdx : null, // Protec?ie pentru index invalid
      'maxFreq': maxFreq,
      'minFreq': minFreq,
      'avgFreq': avgFreq,
      'totalDraws': totalDraws,
      'top5Frequent': top5Frequent,
      'bins': bins,
      'interval': safeInterval, // Folose?te intervalul validat
    };
    if (_lastStats == null || !_mapEquals(stats, _lastStats!)) {
      WidgetsBinding.instance.addPostFrameCallback((_) {
        if (mounted) widget.onStatsChanged?.call(stats);
      });
      _lastStats = Map<String, dynamic>.from(stats);
    }

    // Step dinamic pentru etichete X
    int xLabelStep = 1;
    if (bins.length > 30) {
      xLabelStep = 5;
    } else if (bins.length > 15) {
      xLabelStep = 2;
    }

    final int totalBins = bins.length;
    final int zeroBins = bins.where((b) => (b['freq'] as int) == 0).length;
    final double avgFreqNum = bins.isNotEmpty
        ? bins.map((b) => b['freq'] as int).reduce((a, b) => a + b) /
              bins.length
        : 0;
    final int aboveAvg = bins
        .where((b) => (b['freq'] as int) > avgFreqNum)
        .length;
    final int belowAvg = bins
        .where((b) => (b['freq'] as int) < avgFreqNum)
        .length;
    final List<Map<String, dynamic>> sortedBins = bins.toList()
      ..sort((a, b) => (b['freq'] as int).compareTo(a['freq'] as int));
    final int top3Total = sortedBins
        .take(3)
        .fold(0, (sum, b) => sum + (b['freq'] as int));
    final double top3Percent = totalDraws > 0
        ? (top3Total / totalDraws * 100)
        : 0;
    // Gap maxim între intervale nenule
    int maxGap = 0, currentGap = 0;
    for (final b in bins) {
      if ((b['freq'] as int) == 0) {
        currentGap++;
        if (currentGap > maxGap) maxGap = currentGap;
      } else {
        currentGap = 0;
      }
    }
    // Peak/valley
    int maxDiff = 0;
    String peakInterval = '';
    for (int i = 1; i < bins.length - 1; i++) {
      int prev = bins[i - 1]['freq'] as int;
      int curr = bins[i]['freq'] as int;
      int next = bins[i + 1]['freq'] as int;
      int diff = (curr - prev).abs() + (curr - next).abs();
      if (diff > maxDiff) {
        maxDiff = diff;
        peakInterval = '${bins[i]['start']}-${bins[i]['end']}';
      }
    }

    return LayoutBuilder(
      builder: (context, constraints) {
        if (constraints.maxWidth <= 0 || constraints.maxHeight <= 0) {
          return const SizedBox.shrink();
        }
        double aspectRatio = isDesktop
            ? 2.2
            : (constraints.maxWidth < 400 ? 2.0 : 1.7);
        double minChartHeight = isDesktop ? 220 : 120; // înal?ime minima fixa
        double chartHeight = constraints.maxHeight.clamp(minChartHeight, 600);
        double chartWidth = chartHeight * aspectRatio;
        // La?ime minima per bara
        final double minBarWidth = isDesktop ? 8 : 4;
        final double maxBarWidth = isDesktop ? 14 : 8;
        final double barSpacing = isDesktop ? 2.0 : 1.0;
        double barWidth = isDesktop ? 10 : 6;
        // Calculeaza barWidth dinamic, dar nu mai mic de minBarWidth
        double availableWidth =
            constraints.maxWidth - 60; // 60 pentru padding/margini/scroll
        if (bins.isNotEmpty) {
          double computedWidth =
              (availableWidth - (bins.length - 1) * barSpacing) / bins.length;
          if (computedWidth < minBarWidth) {
            barWidth = minBarWidth;
          } else if (computedWidth > maxBarWidth)
            barWidth = maxBarWidth;
          else
            barWidth = computedWidth;
        }
        final double horizontalInterval = (maxFreq / 5).clamp(1, 20).toDouble();

        Widget chart = RepaintBoundary(
          child: SizedBox(
            height: isDesktop ? 320 : 220,
            child: BarChart(
              BarChartData(
                alignment: BarChartAlignment.spaceAround,
                maxY: (maxFreq + 1).toDouble(),
                minY: 0,
                barTouchData: BarTouchData(
                  enabled: bins
                      .isNotEmpty, // Dezactiveaza touch-ul daca nu sunt date
                  touchTooltipData: BarTouchTooltipData(
                    fitInsideHorizontally: true,
                    fitInsideVertically: true,
                    tooltipPadding: const EdgeInsets.symmetric(
                      horizontal: 14,
                      vertical: 8,
                    ),
                    getTooltipItem: (group, groupIndex, rod, rodIndex) {
                      final idx = group.x.toInt();
                      // Protec?ie împotriva index out of range
                      if (idx < 0 || idx >= bins.length) return null;

                      final bin = bins[idx];
                      // Protec?ie suplimentara pentru datele din bin
                      if (!bin.containsKey('start') ||
                          !bin.containsKey('end') ||
                          !bin.containsKey('freq')) {
                        return null;
                      }

                      final isMost = maxIdx >= 0 && idx == maxIdx;
                      final isLeast = minIdx >= 0 && idx == minIdx;
                      return BarTooltipItem(
                        '${bin['start']}-${bin['end']}',
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
                        children: [
                          TextSpan(
                            text: '\nFrecven?a: ${bin['freq']}',
                            style: TextStyle(
                              fontWeight: FontWeight.normal,
                              fontSize: isDesktop ? 11 : 8,
                              color: Colors.black87,
                            ),
                          ),
                          if (isMost)
                            TextSpan(
                              text: '  (max)',
                              style: TextStyle(
                                color: AppColors.primaryGreenDark,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                          if (isLeast)
                            TextSpan(
                              text: '  (min)',
                              style: TextStyle(
                                color: AppColors.errorRedMedium,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                        ],
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
                        if (val < 0 || val > maxFreq + 1) {
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
                      reservedSize: 28,
                      getTitlesWidget: (v, m) {
                        int idx = v.toInt();
                        if (idx < 0 || idx >= bins.length) {
                          return const SizedBox.shrink();
                        }
                        if (xLabelStep > 1 &&
                            idx % xLabelStep != 0 &&
                            idx != 0 &&
                            idx != bins.length - 1) {
                          return const SizedBox.shrink();
                        }
                        final bin = bins[idx];
                        return Text(
                          '${bin['start']}-${bin['end']}',
                          style: TextStyle(
                            fontSize: fontSize,
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
                  horizontalInterval: horizontalInterval,
                  getDrawingHorizontalLine: (v) =>
                      FlLine(color: Colors.black12, strokeWidth: 1),
                ),
                barGroups: bins
                    .asMap()
                    .entries
                    .map((e) {
                      final idx = e.key;
                      // Protec?ie împotriva index out of range
                      if (idx < 0 || idx >= bins.length) return null;

                      final bin = e.value;
                      // Protec?ie pentru datele din bin
                      if (!bin.containsKey('freq')) return null;

                      final isMost = maxIdx >= 0 && idx == maxIdx;
                      final isLeast = minIdx >= 0 && idx == minIdx;
                      return BarChartGroupData(
                        x: idx,
                        barRods: [
                          BarChartRodData(
                            toY: (bin['freq'] as int).toDouble(),
                            color: isMost
                                ? AppColors.primaryGreenDark
                                : isLeast
                                ? AppColors.errorRedMedium
                                : AppColors.secondaryBlueMedium,
                            width: barWidth,
                            borderRadius: BorderRadius.circular(8),
                            backDrawRodData: BackgroundBarChartRodData(
                              show: true,
                              toY: maxFreq.toDouble(),
                              color: AppColors.secondaryBlue.withValues(
                                alpha: 0.13,
                              ),
                            ),
                          ),
                        ],
                      );
                    })
                    .whereType<BarChartGroupData>()
                    .toList(),
              ),
              key: ValueKey('interval_${safeInterval}_${bins.length}'),
            ),
          ),
        );
        if (bins.length > 30) {
          // La?ime totala pentru scroll: barWidth * bins + spa?iu între bare + padding
          double scrollWidth =
              barWidth * bins.length + barSpacing * (bins.length - 1) + 60;
          chart = SingleChildScrollView(
            scrollDirection: Axis.horizontal,
            child: SizedBox(
              width: scrollWidth,
              height: chartHeight, // pastreaza înal?imea fixa
              child: chart,
            ),
          );
        }
        return Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [const SizedBox(height: 8), chart],
        );
      },
    );
  }

  // _buildIntervalSelectorGlass and related state have been removed; IntervalSelectorGlass is now used externally.

  bool _mapEquals(Map a, Map b) {
    if (a.length != b.length) return false;
    for (final k in a.keys) {
      if (!b.containsKey(k) || a[k] != b[k]) return false;
    }
    return true;
  }

  Widget _buildIntervalNarrative(List<LotoDraw> draws, bool isDesktop) {
    if (draws.isEmpty) {
      return const Text(
        'Nu exista date pentru analiza narativa.',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    }

    // Recupereaza bins pentru intervalul curent
    final bins = _calculateHistogramOptimized(draws, widget.interval);
    if (bins.isEmpty) {
      return const Text(
        'Nu exista date suficiente pentru analiza narativa.',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    }

    final int totalDraws = draws.length;
    final int totalBins = bins.length;
    final int zeroBins = bins.where((b) => (b['freq'] as int) == 0).length;
    final double avgFreqNum = bins.isNotEmpty
        ? bins.map((b) => b['freq'] as int).reduce((a, b) => a + b) /
              bins.length
        : 0;
    final int aboveAvg = bins
        .where((b) => (b['freq'] as int) > avgFreqNum)
        .length;
    final int belowAvg = bins
        .where((b) => (b['freq'] as int) < avgFreqNum)
        .length;
    final List<Map<String, dynamic>> sortedBins = bins.toList()
      ..sort((a, b) => (b['freq'] as int).compareTo(a['freq'] as int));
    final int top3Total = sortedBins
        .take(3)
        .fold(0, (sum, b) => sum + (b['freq'] as int));
    final double top3Percent = totalDraws > 0
        ? (top3Total / totalDraws * 100)
        : 0;
    // Gap maxim între intervale nenule
    int maxGap = 0, currentGap = 0;
    for (final b in bins) {
      if ((b['freq'] as int) == 0) {
        currentGap++;
        if (currentGap > maxGap) maxGap = currentGap;
      } else {
        currentGap = 0;
      }
    }
    // Peak/valley
    int maxDiff = 0;
    String peakInterval = '';
    for (int i = 1; i < bins.length - 1; i++) {
      int prev = bins[i - 1]['freq'] as int;
      int curr = bins[i]['freq'] as int;
      int next = bins[i + 1]['freq'] as int;
      int diff = (curr - prev).abs() + (curr - next).abs();
      if (diff > maxDiff) {
        maxDiff = diff;
        peakInterval = '${bins[i]['start']}-${bins[i]['end']}';
      }
    }
    final sums = draws.map((d) => d.sum).toList();
    if (sums.isEmpty) {
      return const Text(
        'Nu exista date de suma pentru analiza narativa.',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    }
    final minSum = sums.reduce((a, b) => a < b ? a : b);
    final maxSum = sums.reduce((a, b) => a > b ? a : b);
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Wrap(
          spacing: 10,
          runSpacing: 6,
          children: [
            _buildBadge(
              'Intervale cu frecven?a zero: $zeroBins',
              Icons.block,
              Colors.red,
            ),
            _buildBadge(
              'Peste medie: $aboveAvg',
              Icons.trending_up,
              Colors.green,
            ),
            _buildBadge(
              'Sub medie: $belowAvg',
              Icons.trending_down,
              Colors.orange,
            ),
            _buildBadge(
              'Top 3 intervale acopera: ${top3Percent.toStringAsFixed(1)}%',
              Icons.star,
              Colors.blue,
            ),
          ],
        ),
        const SizedBox(height: 12),
        Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.horizontal_rule, color: Colors.purple, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cel mai lung ?ir de intervale consecutive fara extrageri este de $maxGap.',
                    style: TextStyle(
                      color: Colors.purple,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            if (peakInterval.isNotEmpty) ...[
              const SizedBox(height: 6),
              Row(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Icon(Icons.show_chart, color: Colors.teal, size: 18),
                  const SizedBox(width: 8),
                  Expanded(
                    child: Text(
                      'Intervalul cu cea mai mare diferen?a de frecven?a fa?a de vecini este $peakInterval.',
                      style: TextStyle(
                        color: Colors.teal,
                        fontWeight: FontWeight.w600,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ],
              ),
            ],
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_downward, color: Colors.red, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cea mai mica suma întâlnita într-un interval este $minSum.',
                    style: TextStyle(
                      color: Colors.red,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.arrow_upward, color: Colors.green, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Cea mai mare suma întâlnita într-un interval este $maxSum.',
                    style: TextStyle(
                      color: Colors.green,
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 6),
            Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Icon(Icons.straighten, color: Colors.amber, size: 18),
                const SizedBox(width: 8),
                Expanded(
                  child: Text(
                    'Analiza a fost realizata folosind intervale de ${widget.interval}.',
                    style: TextStyle(
                      color: Colors.amber[800],
                      fontWeight: FontWeight.w600,
                      fontSize: 13,
                    ),
                  ),
                ),
              ],
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }

  Widget _buildBadge(String text, IconData icon, Color color) {
    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
      decoration: BoxDecoration(
        color: color.withValues(alpha: 0.13),
        borderRadius: BorderRadius.circular(12),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
          Icon(icon, color: color, size: 16),
          const SizedBox(width: 5),
          Text(
            text,
            style: TextStyle(
              color: color,
              fontWeight: FontWeight.w600,
              fontSize: 12,
            ),
          ),
        ],
      ),
    );
  }
}

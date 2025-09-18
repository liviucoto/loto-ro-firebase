import 'package:flutter/material.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/widgets/statistics_sum_intervals_chart.dart';
import 'package:loto_ro/widgets/glass_card.dart';
import '../../../../../../widgets/period_selector_glass.dart';
import 'package:loto_ro/utils/constants.dart';
import '../../../../../../services/statistics_calculation_service.dart';
import 'dart:ui';

/// Secțiunea completă pentru graficul de interval
class IntervalChartSection extends StatelessWidget {
  final List<LotoDraw> statsDraws;
  final List<LotoDraw> allDraws; // Datele complete pentru dialog
  final String selectedPeriod;
  final List<String> periodOptions;
  final Function(String) onPeriodChanged;
  final ValueChanged<String> onCustomPeriod;
  final bool isDesktop;
  final Map<String, dynamic>? intervalNarrativeData;

  const IntervalChartSection({
    super.key,
    required this.statsDraws,
    required this.allDraws,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.onPeriodChanged,
    required this.onCustomPeriod,
    required this.isDesktop,
    required this.intervalNarrativeData,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
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
                    'Graficul intervalului',
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
                    SizedBox(
                      height: chartHeight,
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: StatisticsSumIntervalsChart(
                          draws: statsDraws,
                          interval:
                              20, // default, poate fi calculat din date dacă vrei
                        ),
                      ),
                    ),
                    // Legendă
                    Builder(
                      builder: (context) {
                        if (statsDraws.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final stats = StatisticsCalculationService()
                            .calculateBasicStatistics(statsDraws);
                        final int totalIntervals =
                            (((stats['maxSum'] as double) -
                                        (stats['minSum'] as double)) /
                                    20)
                                .ceil();
                        return Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 0),
                          child: Text(
                            'Total extrageri: ${stats['totalDraws']} | Medie sumă: ${(stats['avgSum'] as double).toStringAsFixed(1)} | Min: ${(stats['minSum'] as double).toInt()} | Max: ${(stats['maxSum'] as double).toInt()} | Intervale: $totalIntervals',
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
                  label: const Text('Generator Interval'),
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
                                        _buildIntervalNarrative(
                                          localDraws,
                                          isDesktop,
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

  Widget _buildIntervalNarrative(List<LotoDraw> draws, bool isDesktop) {
    if (draws.isEmpty) {
      return const Text(
        'Nu există date pentru analiza narativă.',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    }

    final sums = draws.map((d) => d.sum).toList();
    if (sums.isEmpty) {
      return const Text(
        'Nu există date de sumă pentru analiza narativă.',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
    }

    final minSum = sums.reduce((a, b) => a < b ? a : b);
    final maxSum = sums.reduce((a, b) => a > b ? a : b);
    final int totalDraws = draws.length;

    // Calculez intervalele
    final interval = 20;
    final range = maxSum - minSum + 1;
    final estimatedBins = range ~/ interval;
    final maxBars = 50;
    final adjustedInterval = estimatedBins > maxBars
        ? (range / maxBars).ceil()
        : interval;

    List<Map<String, dynamic>> bins = [];
    for (
      int start = (minSum ~/ adjustedInterval) * adjustedInterval;
      start <= maxSum;
      start += adjustedInterval
    ) {
      int end = start + adjustedInterval - 1;
      int freq = sums.where((s) => s >= start && s <= end).length;
      bins.add({'start': start, 'end': end, 'freq': freq});
      if (bins.length >= maxBars) break;
    }

    if (bins.isEmpty) {
      return const Text(
        'Nu există date suficiente pentru analiza narativă.',
        style: TextStyle(fontSize: 14, color: Colors.grey),
      );
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
    final maxFreq = bins
        .map((b) => b['freq'] as int)
        .reduce((a, b) => a > b ? a : b);
    final dominantBin = bins.firstWhere(
      (b) => b['freq'] == maxFreq,
      orElse: () => bins.first,
    );
    final minBin = bins.where((b) => (b['freq'] as int) > 0).isNotEmpty
        ? bins
              .where((b) => (b['freq'] as int) > 0)
              .reduce((a, b) => (a['freq'] as int) < (b['freq'] as int) ? a : b)
        : bins.first;
    final top3Bins = bins.toList()
      ..sort((a, b) => (b['freq'] as int).compareTo(a['freq'] as int));
    final top3 = top3Bins.take(3).toList();

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

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.straighten, color: Colors.amber[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Graficul de mai sus arată distribuția sumelor extrase pe intervale de $adjustedInterval, pentru ultimele $totalDraws extrageri.',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.grid_view, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Număr total de intervale: $totalBins.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.block, color: Colors.red, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '$zeroBins intervale nu au avut nicio extragere.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.star, color: Colors.green, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Intervalul cu cele mai multe extrageri: ${dominantBin['start']}-${dominantBin['end']} (${dominantBin['freq']} extrageri).',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.filter_1, color: Colors.orange, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Intervalul cu cele mai puține extrageri (dar >0): ${minBin['start']}-${minBin['end']} (${minBin['freq']} extrageri).',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.leaderboard, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Top 3 intervale ca frecvență: ${top3.map((b) => "${b['start']}-${b['end']} (${b['freq']})").join(", ")}.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.trending_up, color: Colors.green, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '$aboveAvg intervale au frecvență peste medie, $belowAvg sub medie (media: ${avgFreqNum.toStringAsFixed(1)} extrageri/interval).',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.arrow_downward, color: Colors.red, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cea mai mică sumă întâlnită: $minSum.',
                style: const TextStyle(fontSize: 13),
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
                'Cea mai mare sumă întâlnită: $maxSum.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        if (maxGap > 0) ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.horizontal_rule, color: Colors.purple, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Cel mai lung șir de intervale consecutive fără extrageri: $maxGap.',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

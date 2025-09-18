import 'package:flutter/material.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/widgets/statistics_mean_chart.dart';
import 'package:loto_ro/utils/constants.dart';
import '../../../../../../widgets/period_selector_glass.dart';
import 'package:loto_ro/widgets/glass_card.dart';
import '../../../../../../services/statistics_calculation_service.dart';
import 'dart:ui';
import 'dart:math';

/// Secțiunea completă pentru graficul de medie
class MeanChartSection extends StatelessWidget {
  final List<LotoDraw> statsDraws;
  final List<LotoDraw> allDraws;
  final String selectedPeriod;
  final List<String> periodOptions;
  final Function(String) onPeriodChanged;
  final ValueChanged<String>? onCustomPeriod;
  final bool isDesktop;

  const MeanChartSection({
    super.key,
    required this.statsDraws,
    required this.allDraws,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.onPeriodChanged,
    required this.onCustomPeriod,
    required this.isDesktop,
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

    final draws = statsDraws;

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
            // HEADER
            Padding(
              padding: const EdgeInsets.only(top: 16, bottom: 8),
              child: Row(
                children: [
                  Text(
                    'Graficul mediilor',
                    style: AppFonts.titleStyle.copyWith(
                      fontSize: isDesktop ? 19 : 16,
                    ),
                  ),
                  const Spacer(),
                  PeriodSelectorGlass(
                    value: selectedPeriod,
                    options: periodOptions,
                    onChanged: onPeriodChanged,
                    onCustom: onCustomPeriod ?? (_) {},
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
                        child: StatisticsMeanChart(draws: statsDraws),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        if (draws.isEmpty) return const SizedBox.shrink();
                        final stats = StatisticsCalculationService()
                            .calculateBasicStatistics(draws);
                        return Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 0),
                          child: Text(
                            'Total extrageri: ${stats['totalDraws']} | Medie: ${(stats['avgSum'] as double).toStringAsFixed(2)} | Min: ${(stats['minSum'] as double).toStringAsFixed(1)} | Max: ${(stats['maxSum'] as double).toStringAsFixed(1)}',
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
            SizedBox(height: isDesktop ? 32 : 20),
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
                  label: const Text('Generator Medie'),
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
                                              size: 20,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Analiză narativă',
                                              style: AppFonts.titleStyle
                                                  .copyWith(fontSize: 19),
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
                                        _buildMeanNarrativeModernStatic(
                                          localDraws,
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
                'Graficul de mai sus arată media numerelor extrase la fiecare extragere. Linia verde reprezintă media generală.',
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
                'Media maximă întâlnită: ${maxMean.toStringAsFixed(1)}.',
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
                'Media minimă întâlnită: ${minMean.toStringAsFixed(1)}.',
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
                '$aboveAvg extrageri au avut media peste media generală (${avg.toStringAsFixed(2)}).',
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
                '$belowAvg extrageri au avut media sub media generală.',
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
                'Cea mai lungă serie de extrageri peste medie: $maxConsecutiveAbove.',
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
                'Cea mai lungă serie de extrageri sub medie: $maxConsecutiveBelow.',
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

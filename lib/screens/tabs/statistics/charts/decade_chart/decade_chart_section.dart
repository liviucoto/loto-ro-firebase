import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/widgets/glass_card.dart';
import '../../../../../widgets/period_selector_glass.dart';
import '../../../../../widgets/statistics_decade_chart.dart';
import '../../../../../services/statistics_calculation_service.dart';
import 'decade_narrative.dart';

/// Secțiunea completă pentru graficul de decade
class DecadeChartSection extends StatelessWidget {
  final List<LotoDraw> statsDraws;
  final List<LotoDraw> allDraws;
  final String selectedPeriod;
  final List<String> periodOptions;
  final Function(String) onPeriodChanged;
  final ValueChanged<String>? onCustomPeriod;
  final bool isDesktop;
  final GameType selectedGame;
  final Map<String, dynamic>? decadeNarrative;

  const DecadeChartSection({
    super.key,
    required this.statsDraws,
    required this.allDraws,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.onPeriodChanged,
    required this.onCustomPeriod,
    required this.isDesktop,
    required this.selectedGame,
    required this.decadeNarrative,
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

    // LEGENDĂ: exemplu simplificat, poți ajusta după logica ta de decade

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
                    'Decade',
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
                        child: StatisticsDecadeChart(
                          draws: statsDraws,
                          mainRange:
                              AppGameTypes.gameConfigs[selectedGame
                                      .csvName]!['mainRange']
                                  as int,
                        ),
                      ),
                    ),
                    Builder(
                      builder: (context) {
                        if (statsDraws.isEmpty) {
                          return const SizedBox.shrink();
                        }
                        final stats = StatisticsCalculationService()
                            .calculateBasicStatistics(statsDraws);
                        return Padding(
                          padding: const EdgeInsets.only(top: 0, bottom: 0),
                          child: Text(
                            'Total extrageri: ${stats['totalDraws']} | Total numere: ${stats['numbers']} | Medie frecvență: ${(stats['avgFreq'] as double).toStringAsFixed(1)} | Cel mai frecvent: ${stats['maxFreq']} | Cel mai rar: ${stats['minFreq']}',
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
                  label: const Text('Generator Decade'),
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
                            final n = int.tryParse(
                              currentPeriod.replaceAll(RegExp(r'[^0-9]'), ''),
                            );
                            if (n != null && n > 0 && n <= allDraws.length) {
                              localDraws = allDraws.take(n).toList();
                            }
                          }
                          // Calculez narativa pentru dialog cu insighturi suplimentare
                          final Map<int, int> decadeFreq = {};
                          for (final draw in localDraws) {
                            for (final n in draw.mainNumbers) {
                              final decade = (n / 10).floor() * 10;
                              decadeFreq[decade] =
                                  (decadeFreq[decade] ?? 0) + 1;
                            }
                          }
                          final sorted = decadeFreq.entries.toList()
                            ..sort((a, b) => b.value.compareTo(a.value));
                          final mostFrequent = sorted.isNotEmpty
                              ? sorted.first.key
                              : null;
                          final leastFrequent = sorted.isNotEmpty
                              ? sorted.last.key
                              : null;
                          final top3 = sorted.take(3).toList();
                          final emptyDecades = decadeFreq.keys
                              .where((k) => decadeFreq[k] == 0)
                              .length;
                          final avg = decadeFreq.isNotEmpty
                              ? (decadeFreq.values.reduce((a, b) => a + b) /
                                    decadeFreq.length)
                              : 0;
                          final aboveAvg = decadeFreq.values
                              .where((v) => v > avg)
                              .length;
                          int maxConsecutive = 0, current = 0;
                          int? last;
                          for (final entry in sorted) {
                            if (last != null && entry.key == last + 10) {
                              current++;
                            } else {
                              current = 1;
                            }
                            if (current > maxConsecutive) {
                              maxConsecutive = current;
                            }
                            last = entry.key;
                          }
                          final distributionType =
                              (sorted.length > 1 &&
                                  (sorted.first.value - sorted.last.value)
                                          .abs() <
                                      3)
                              ? 'echilibrată'
                              : 'inechilibrată';
                          final percentDominant = sorted.isNotEmpty && avg > 0
                              ? ((sorted.first.value * 100) /
                                        (decadeFreq.values.reduce(
                                          (a, b) => a + b,
                                        )))
                                    .toStringAsFixed(1)
                              : '-';
                          final narrative = {
                            'mostFrequentDecade': mostFrequent != null
                                ? '$mostFrequent-${mostFrequent + 9}'
                                : '-',
                            'leastFrequentDecade': leastFrequent != null
                                ? '$leastFrequent-${leastFrequent + 9}'
                                : '-',
                            'distributionType': distributionType,
                            'top3': top3
                                .map(
                                  (e) => '${e.key}-${e.key + 9} (${e.value}x)',
                                )
                                .join(', '),
                            'emptyDecades': emptyDecades,
                            'aboveAvg': aboveAvg,
                            'maxConsecutive': maxConsecutive,
                            'percentDominant': percentDominant,
                          };

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
                                      color: Colors.white.withValues(
                                        alpha: 0.58,
                                      ),
                                      borderRadius: BorderRadius.circular(24),
                                      border: Border.all(
                                        color: Colors.white.withValues(
                                          alpha: 0.28,
                                        ),
                                        width: 1.5,
                                      ),
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.black.withValues(
                                            alpha: 0.10,
                                          ),
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
                                              size: 22,
                                            ),
                                            const SizedBox(width: 8),
                                            Text(
                                              'Analiză narativă',
                                              style: AppFonts.titleStyle
                                                  .copyWith(
                                                    fontSize: isDesktop
                                                        ? 19
                                                        : 16,
                                                  ),
                                            ),
                                            const Spacer(),
                                            PeriodSelectorGlass(
                                              value: currentPeriod,
                                              options: periodOptions,
                                              onChanged: (val) {
                                                updatePeriod(val);
                                              },
                                              onCustom: (String customPeriod) {
                                                updatePeriod(customPeriod);
                                              },
                                              fontSize: 15,
                                              iconSize: 18,
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        DecadeNarrative(
                                          narrative: narrative,
                                          isDesktop: isDesktop,
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
}

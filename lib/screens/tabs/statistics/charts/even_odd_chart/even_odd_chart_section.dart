import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/widgets/statistics_even_odd_chart.dart';
import 'package:loto_ro/widgets/period_selector_glass.dart';
import 'package:loto_ro/widgets/glass_card.dart';
import 'package:loto_ro/screens/tabs/statistics/charts/even_odd_chart/even_odd_narrative.dart';
import 'package:fl_chart/fl_chart.dart';

class EvenOddChartSection extends StatelessWidget {
  final List<LotoDraw> allDraws;
  final List<LotoDraw> statsDraws;
  final GameType selectedGame;
  final bool isDesktop;
  final String selectedPeriod;
  final List<String> periodOptions;
  final Function(String) onPeriodChanged;
  final Function(String)? onCustomPeriod;

  const EvenOddChartSection({
    super.key,
    required this.allDraws,
    required this.statsDraws,
    required this.selectedGame,
    required this.isDesktop,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.onPeriodChanged,
    this.onCustomPeriod,
  });

  @override
  Widget build(BuildContext context) {
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
                    'Par/Impar',
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
                    if (selectedGame == GameType.joker) ...[
                      // Secțiune pentru principale
                      Padding(
                        padding: const EdgeInsets.only(top: 8, bottom: 2),
                        child: Text(
                          'Numere principale',
                          style: AppFonts.subtitleStyle.copyWith(
                            fontSize: isDesktop ? 15 : 13,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: chartHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: StatisticsEvenOddChart(draws: statsDraws),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          if (statsDraws.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          // Calculez statistici pentru legendă
                          int evenCount = 0, oddCount = 0;
                          for (final draw in statsDraws) {
                            for (final n in draw.mainNumbers) {
                              if (n % 2 == 0) {
                                evenCount++;
                              } else {
                                oddCount++;
                              }
                            }
                          }
                          final totalDraws = statsDraws.length;
                          final totalNumbers = evenCount + oddCount;
                          final evenPercentage = totalNumbers > 0
                              ? (evenCount * 100 / totalNumbers)
                                    .toStringAsFixed(1)
                              : '0';
                          final oddPercentage = totalNumbers > 0
                              ? (oddCount * 100 / totalNumbers).toStringAsFixed(
                                  1,
                                )
                              : '0';

                          return Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Text(
                              'Total extrageri: $totalDraws | Total numere: $totalNumbers | Pare: $evenCount ($evenPercentage%) | Impare: $oddCount ($oddPercentage%)',
                              style: AppFonts.captionStyle.copyWith(
                                fontSize: legendFont,
                                color: legendColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                      Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 2),
                        child: Text(
                          'Număr Joker',
                          style: AppFonts.subtitleStyle.copyWith(
                            fontSize: isDesktop ? 15 : 13,
                          ),
                        ),
                      ),
                      SizedBox(
                        height: chartHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: _JokerEvenOddChart(
                            draws: statsDraws,
                            isDesktop: isDesktop,
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          if (statsDraws.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          int jokerEvenCount = 0, jokerOddCount = 0;
                          for (final d in statsDraws) {
                            if (d.jokerNumber != null) {
                              if (d.jokerNumber! % 2 == 0) {
                                jokerEvenCount++;
                              } else {
                                jokerOddCount++;
                              }
                            }
                          }
                          final totalJokerDraws =
                              jokerEvenCount + jokerOddCount;
                          final jokerEvenPercentage = totalJokerDraws > 0
                              ? (jokerEvenCount * 100 / totalJokerDraws)
                                    .toStringAsFixed(1)
                              : '0';
                          final jokerOddPercentage = totalJokerDraws > 0
                              ? (jokerOddCount * 100 / totalJokerDraws)
                                    .toStringAsFixed(1)
                              : '0';
                          return Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Text(
                              'Joker: Total extrageri: $totalJokerDraws | Pare: $jokerEvenCount ($jokerEvenPercentage%) | Impare: $jokerOddCount ($jokerOddPercentage%)',
                              style: AppFonts.captionStyle.copyWith(
                                fontSize: legendFont,
                                color: legendColor,
                              ),
                              textAlign: TextAlign.center,
                            ),
                          );
                        },
                      ),
                    ] else ...[
                      // fallback: stil vechi pentru alte jocuri
                      SizedBox(
                        height: chartHeight,
                        child: Padding(
                          padding: const EdgeInsets.symmetric(vertical: 10),
                          child: StatisticsEvenOddChart(draws: statsDraws),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          if (statsDraws.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          // Calculez statistici pentru legendă
                          int evenCount = 0, oddCount = 0;
                          for (final draw in statsDraws) {
                            for (final n in draw.mainNumbers) {
                              if (n % 2 == 0) {
                                evenCount++;
                              } else {
                                oddCount++;
                              }
                            }
                          }
                          final totalDraws = statsDraws.length;
                          final totalNumbers = evenCount + oddCount;
                          final evenPercentage = totalNumbers > 0
                              ? (evenCount * 100 / totalNumbers)
                                    .toStringAsFixed(1)
                              : '0';
                          final oddPercentage = totalNumbers > 0
                              ? (oddCount * 100 / totalNumbers).toStringAsFixed(
                                  1,
                                )
                              : '0';

                          return Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: Text(
                              'Total extrageri: $totalDraws | Total numere: $totalNumbers | Pare: $evenCount ($evenPercentage%) | Impare: $oddCount ($oddPercentage%)',
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
                  label: const Text('Generator Par/Impar'),
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

                          // Calculez narativa pentru numerele principale
                          int evenCount = 0,
                              oddCount = 0,
                              maxConsecutiveEven = 0,
                              maxConsecutiveOdd = 0,
                              currentEven = 0,
                              currentOdd = 0;
                          int maxPct = 0, minPct = 100;
                          for (final draw in localDraws) {
                            int even = draw.mainNumbers
                                .where((n) => n % 2 == 0)
                                .length;
                            int odd = draw.mainNumbers.length - even;
                            evenCount += even;
                            oddCount += odd;
                            if (even > maxPct) maxPct = even;
                            if (even < minPct) minPct = even;
                            if (even == draw.mainNumbers.length) {
                              currentEven++;
                              if (currentEven > maxConsecutiveEven) {
                                maxConsecutiveEven = currentEven;
                              }
                            } else {
                              currentEven = 0;
                            }
                            if (odd == draw.mainNumbers.length) {
                              currentOdd++;
                              if (currentOdd > maxConsecutiveOdd) {
                                maxConsecutiveOdd = currentOdd;
                              }
                            } else {
                              currentOdd = 0;
                            }
                          }
                          final total = evenCount + oddCount;
                          final evenPercentage = total > 0
                              ? (evenCount * 100 / total).toStringAsFixed(1)
                              : '-';
                          final oddPercentage = total > 0
                              ? (oddCount * 100 / total).toStringAsFixed(1)
                              : '-';
                          final absDiff = (evenCount - oddCount).abs();
                          final balanceType = absDiff < 3
                              ? 'echilibrat'
                              : 'dezechilibrat';
                          final narrative = {
                            'evenCount': evenCount,
                            'evenPercentage': evenPercentage,
                            'oddCount': oddCount,
                            'oddPercentage': oddPercentage,
                            'balanceType': balanceType,
                            'absDiff': absDiff,
                            'maxConsecutive':
                                maxConsecutiveEven > maxConsecutiveOdd
                                ? maxConsecutiveEven
                                : maxConsecutiveOdd,
                            'maxPct': maxPct,
                            'minPct': minPct,
                          };

                          // Calculez narativa pentru Joker (doar pentru jocul Joker)
                          Map<String, dynamic>? jokerNarrative;
                          if (selectedGame == GameType.joker) {
                            int jokerEvenCount = 0, jokerOddCount = 0;
                            int jokerMaxConsecutiveEven = 0,
                                jokerMaxConsecutiveOdd = 0;
                            int jokerCurrentEven = 0, jokerCurrentOdd = 0;

                            for (final draw in localDraws) {
                              if (draw.jokerNumber != null) {
                                if (draw.jokerNumber! % 2 == 0) {
                                  jokerEvenCount++;
                                  jokerCurrentEven++;
                                  if (jokerCurrentEven >
                                      jokerMaxConsecutiveEven) {
                                    jokerMaxConsecutiveEven = jokerCurrentEven;
                                  }
                                  jokerCurrentOdd = 0;
                                } else {
                                  jokerOddCount++;
                                  jokerCurrentOdd++;
                                  if (jokerCurrentOdd >
                                      jokerMaxConsecutiveOdd) {
                                    jokerMaxConsecutiveOdd = jokerCurrentOdd;
                                  }
                                  jokerCurrentEven = 0;
                                }
                              }
                            }

                            final jokerTotal = jokerEvenCount + jokerOddCount;
                            final jokerEvenPercentage = jokerTotal > 0
                                ? (jokerEvenCount * 100 / jokerTotal)
                                      .toStringAsFixed(1)
                                : '-';
                            final jokerOddPercentage = jokerTotal > 0
                                ? (jokerOddCount * 100 / jokerTotal)
                                      .toStringAsFixed(1)
                                : '-';
                            final jokerAbsDiff =
                                (jokerEvenCount - jokerOddCount).abs();
                            final jokerBalanceType = jokerAbsDiff < 2
                                ? 'echilibrat'
                                : 'dezechilibrat';
                            final jokerDominance =
                                jokerEvenCount > jokerOddCount
                                ? 'Pare dominante'
                                : jokerOddCount > jokerEvenCount
                                ? 'Impare dominante'
                                : 'Echilibrat';

                            jokerNarrative = {
                              'jokerEvenCount': jokerEvenCount,
                              'jokerEvenPercentage': jokerEvenPercentage,
                              'jokerOddCount': jokerOddCount,
                              'jokerOddPercentage': jokerOddPercentage,
                              'jokerBalanceType': jokerBalanceType,
                              'jokerAbsDiff': jokerAbsDiff,
                              'jokerMaxConsecutive':
                                  jokerMaxConsecutiveEven >
                                      jokerMaxConsecutiveOdd
                                  ? jokerMaxConsecutiveEven
                                  : jokerMaxConsecutiveOdd,
                              'jokerTotalDraws': jokerTotal,
                              'jokerDominance': jokerDominance,
                            };
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

                                        // Narativă pentru numerele principale
                                        EvenOddNarrative(
                                          narrative: narrative,
                                          isDesktop: isDesktop,
                                        ),
                                        if (selectedGame == GameType.joker &&
                                            jokerNarrative != null) ...[
                                          const SizedBox(height: 16),
                                          JokerEvenOddNarrative(
                                            narrative: jokerNarrative,
                                            isDesktop: isDesktop,
                                          ),
                                        ],
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

/// Widget pentru graficul Joker par/impar
class _JokerEvenOddChart extends StatelessWidget {
  final List<LotoDraw> draws;
  final bool isDesktop;

  const _JokerEvenOddChart({required this.draws, required this.isDesktop});

  @override
  Widget build(BuildContext context) {
    int jokerEvenCount = 0, jokerOddCount = 0;

    for (final d in draws) {
      if (d.jokerNumber != null) {
        if (d.jokerNumber! % 2 == 0) {
          jokerEvenCount++;
        } else {
          jokerOddCount++;
        }
      }
    }

    if (jokerEvenCount == 0 && jokerOddCount == 0) {
      return Center(
        child: Text(
          'Nu există date pentru graficul Joker.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    final maxFreq = [
      jokerEvenCount,
      jokerOddCount,
    ].reduce((a, b) => a > b ? a : b);

    return SizedBox(
      height: isDesktop ? 180 : 120,
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
                final isEven = group.x == 0;
                return BarTooltipItem(
                  'Joker ${isEven ? "Par" : "Impar"}\nExtrageri: ${rod.toY.toInt()}',
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
                  if (maxFreq > 1000) {
                    if (val % 100 != 0 && val != 0 && val != maxFreq) {
                      return const SizedBox.shrink();
                    }
                  } else if (maxFreq > 500) {
                    if (val % 50 != 0 && val != 0 && val != maxFreq) {
                      return const SizedBox.shrink();
                    }
                  } else if (maxFreq > 100) {
                    if (val % 20 != 0 && val != 0 && val != maxFreq) {
                      return const SizedBox.shrink();
                    }
                  } else if (maxFreq > 50) {
                    if (val % 10 != 0 && val != 0 && val != maxFreq) {
                      return const SizedBox.shrink();
                    }
                  }
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
                reservedSize: 22,
                getTitlesWidget: (v, m) {
                  int val = v.toInt();
                  if (val < 0 || val > 1) {
                    return const SizedBox.shrink();
                  }
                  return Text(
                    val == 0 ? 'Par' : 'Impar',
                    style: TextStyle(
                      fontSize: isDesktop ? 12 : 9,
                      color: Colors.black87,
                    ),
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
            getDrawingHorizontalLine: (v) =>
                FlLine(color: Colors.black12, strokeWidth: 1),
          ),
          barGroups: [
            BarChartGroupData(
              x: 0, // Par
              barRods: [
                BarChartRodData(
                  toY: jokerEvenCount.toDouble(),
                  color: jokerEvenCount > jokerOddCount
                      ? AppColors.primaryGreenDark
                      : AppColors.secondaryBlue,
                  width: isDesktop ? 40 : 30,
                  borderRadius: BorderRadius.circular(6),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: (maxFreq + 2).toDouble(),
                    color: AppColors.secondaryBlue.withValues(alpha: 0.13),
                  ),
                ),
              ],
            ),
            BarChartGroupData(
              x: 1, // Impar
              barRods: [
                BarChartRodData(
                  toY: jokerOddCount.toDouble(),
                  color: jokerOddCount > jokerEvenCount
                      ? AppColors.errorRedMedium
                      : AppColors.secondaryBlue,
                  width: isDesktop ? 40 : 30,
                  borderRadius: BorderRadius.circular(6),
                  backDrawRodData: BackgroundBarChartRodData(
                    show: true,
                    toY: (maxFreq + 2).toDouble(),
                    color: AppColors.secondaryBlue.withValues(alpha: 0.13),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}

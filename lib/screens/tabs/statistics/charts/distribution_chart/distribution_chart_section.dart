import 'package:flutter/material.dart';
import 'dart:ui';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/widgets/glass_card.dart';
import '../../../../../widgets/period_selector_glass.dart';
import '../../../../../widgets/statistics_distribution_chart.dart';
import '../../../../../services/statistics_calculation_service.dart';
import 'distribution_narrative.dart';
import '../heatmap_chart/heatmap_generator_dialog.dart';
import 'dart:math';
import '../../../statistics_tab.dart';

/// Secțiunea completă pentru graficul de distribuție
class DistributionChartSection extends StatefulWidget {
  final List<LotoDraw> statsDraws;
  final List<LotoDraw> allDraws; // Datele complete pentru dialog
  final String selectedPeriod;
  final List<String> periodOptions;
  final Function(String) onPeriodChanged;
  final ValueChanged<String>? onCustomPeriod;
  final bool isDesktop;
  final GameType selectedGame;
  final Map<String, dynamic>? distributionNarrative;

  const DistributionChartSection({
    super.key,
    required this.statsDraws,
    required this.allDraws,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.onPeriodChanged,
    required this.onCustomPeriod,
    required this.isDesktop,
    required this.selectedGame,
    required this.distributionNarrative,
  });

  @override
  State<DistributionChartSection> createState() =>
      _DistributionChartSectionState();
}

class _DistributionChartSectionState extends State<DistributionChartSection> {
  String _selectedSegment = 'Luni';

  final List<String> segmentOptions = const ['Luni', 'Sezoane'];
  final GlobalKey _cardKey = GlobalKey();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    return _buildDistributionContent(context, isDesktop);
  }

  Widget _buildDistributionContent(BuildContext context, bool isDesktop) {
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

    final numberTotals = <int, int>{};
    final nNumbers = widget.selectedGame == GameType.loto649
        ? 49
        : (widget.selectedGame == GameType.loto540 ? 40 : 45);
    final numberSegmentData = _calculateNumberSegmentFrequency(
      widget.statsDraws,
      _selectedSegment,
    );
    int minFreq = 999999, maxFreq = 0;
    for (var number = 1; number <= nNumbers; number++) {
      int total = 0;
      for (var seg = 1; seg <= (_selectedSegment == 'Luni' ? 12 : 4); seg++) {
        final freq = numberSegmentData[number]?[seg] ?? 0;
        if (freq < minFreq) minFreq = freq;
        if (freq > maxFreq) maxFreq = freq;
        total += freq;
      }
      numberTotals[number] = total;
    }

    return GlassCard(
      key: _cardKey,
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
                    'Distribuție',
                    style: AppFonts.titleStyle.copyWith(
                      fontSize: isDesktop ? 19 : 16,
                    ),
                  ),
                  const Spacer(),
                  PeriodSelectorGlass(
                    value: widget.selectedPeriod,
                    options: widget.periodOptions,
                    onChanged: widget.onPeriodChanged,
                    onCustom: widget.onCustomPeriod ?? (_) {},
                    fontSize: 15,
                    iconSize: 18,
                    padding: EdgeInsets.zero,
                  ),
                  const SizedBox(width: 8),
                  ToggleButtons(
                    isSelected: segmentOptions
                        .map((seg) => _selectedSegment == seg)
                        .toList(),
                    onPressed: (idx) => _onSegmentChanged(segmentOptions[idx]),
                    borderRadius: BorderRadius.circular(10),
                    selectedColor: AppColors.primaryGreenDark,
                    fillColor: AppColors.primaryGreenDark.withValues(
                      alpha: 0.13,
                    ),
                    color: Colors.black54,
                    constraints: BoxConstraints(minHeight: 32, minWidth: 44),
                    children: segmentOptions
                        .map(
                          (seg) => Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 8),
                            child: Text(
                              seg,
                              style: TextStyle(fontSize: isDesktop ? 12 : 10),
                            ),
                          ),
                        )
                        .toList(),
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
                    if (widget.statsDraws.isEmpty)
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 40),
                        child: Center(
                          child: Text(
                            'Nu există date pentru această perioadă sau joc.',
                            style: AppFonts.bodyStyle.copyWith(
                              fontSize: isDesktop ? 16 : 13,
                            ),
                          ),
                        ),
                      )
                    else ...[
                      // Grafic principal
                      Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: isDesktop
                            ? SizedBox(
                                height: chartHeight,
                                width: double.infinity,
                                child: StatisticsDistributionChart(
                                  draws: widget.statsDraws,
                                  mainRange:
                                      AppGameTypes.gameConfigs[widget
                                              .selectedGame
                                              .csvName]!['mainRange']
                                          as int,
                                  segment: _selectedSegment,
                                  getNumbers: (draw) => draw.mainNumbers,
                                ),
                              )
                            : SizedBox(
                                height: chartHeight,
                                width: double.infinity,
                                child: StatisticsDistributionChart(
                                  draws: widget.statsDraws,
                                  mainRange:
                                      AppGameTypes.gameConfigs[widget
                                              .selectedGame
                                              .csvName]!['mainRange']
                                          as int,
                                  segment: _selectedSegment,
                                  getNumbers: (draw) => draw.mainNumbers,
                                ),
                              ),
                      ),
                      // LEGENDA PRINCIPALĂ
                      Builder(
                        builder: (context) {
                          final stats = StatisticsCalculationService()
                              .calculateBasicStatistics(widget.statsDraws);
                          return Padding(
                            padding: const EdgeInsets.symmetric(vertical: 8),
                            child: Text(
                              'Total extrageri: ${stats['totalDraws']} | Numere: $nNumbers | Medie frecvență: ${(stats['avgFreq'] as double).toStringAsFixed(1)} | Max: ${stats['maxFreq']} | Min: ${stats['minFreq']}',
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
                    // Grafic Joker (doar pentru jocul Joker)
                    if (widget.selectedGame == GameType.joker) ...[
                      Padding(
                        padding: const EdgeInsets.only(top: 18, bottom: 2),
                        child: Text(
                          'Distribuție Joker',
                          style: AppFonts.subtitleStyle.copyWith(
                            fontSize: isDesktop ? 15 : 13,
                          ),
                        ),
                      ),
                      Builder(
                        builder: (context) {
                          final drawsWithJoker = widget.statsDraws
                              .where((d) => d.jokerNumber != null)
                              .toList();
                          if (drawsWithJoker.isEmpty) {
                            return const SizedBox.shrink();
                          }
                          // Calculez automat cel mai mare număr Joker din date
                          final jokerNumbers = drawsWithJoker
                              .map((d) => d.jokerNumber!)
                              .toList();
                          final maxJoker = jokerNumbers.isNotEmpty
                              ? jokerNumbers.reduce((a, b) => a > b ? a : b)
                              : 20;
                          return Column(
                            crossAxisAlignment: CrossAxisAlignment.stretch,
                            children: [
                              isDesktop
                                  ? SizedBox(
                                      height: chartHeight,
                                      width: double.infinity,
                                      child: StatisticsDistributionChart(
                                        draws: drawsWithJoker,
                                        mainRange: maxJoker,
                                        segment: _selectedSegment,
                                        getNumbers: (draw) =>
                                            draw.jokerNumber != null
                                            ? [draw.jokerNumber!]
                                            : [],
                                      ),
                                    )
                                  : SizedBox(
                                      width: double.infinity,
                                      child: StatisticsDistributionChart(
                                        draws: drawsWithJoker,
                                        mainRange: maxJoker,
                                        segment: _selectedSegment,
                                        getNumbers: (draw) =>
                                            draw.jokerNumber != null
                                            ? [draw.jokerNumber!]
                                            : [],
                                      ),
                                    ),
                              const SizedBox(height: 8),
                              _buildJokerLegend(
                                drawsWithJoker,
                                jokerNumbers,
                                maxJoker,
                                legendFont,
                                legendColor,
                              ),
                            ],
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
                  label: const Text('Generator Heatmap'),
                  onPressed: () {
                    final mainContentKey = context
                        .findAncestorStateOfType<StatisticsTabState>()
                        ?.mainContentKey;
                    final RenderBox? mainBox =
                        mainContentKey?.currentContext?.findRenderObject()
                            as RenderBox?;
                    final Size? mainSize = mainBox?.size;
                    final Offset? mainOffset = mainBox?.localToGlobal(
                      Offset.zero,
                    );
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withValues(alpha: 0.10),
                      builder: (ctx) => HeatmapGeneratorDialog(
                        allDraws: widget.allDraws,
                        selectedGame: widget.selectedGame,
                        isDesktop: isDesktop,
                        onClose: () => Navigator.of(ctx).pop(),
                        cardWidth: mainSize?.width,
                        cardHeight: mainSize?.height,
                        cardOffset: mainOffset,
                      ),
                    );
                  },
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
                      widget.selectedPeriod,
                    );
                    showDialog(
                      context: context,
                      barrierColor: Colors.black.withValues(alpha: 0.10),
                      builder: (ctx) => ValueListenableBuilder<String>(
                        valueListenable: periodNotifier,
                        builder: (ctx, currentPeriod, child) {
                          List<LotoDraw> localDraws = widget.statsDraws;
                          if (currentPeriod == 'Toate extragerile') {
                            localDraws = widget.allDraws;
                          } else if (currentPeriod.startsWith('Ultimele')) {
                            final n =
                                int.tryParse(
                                  currentPeriod.replaceAll(
                                    RegExp(r'[^0-9]'),
                                    '',
                                  ),
                                ) ??
                                widget.statsDraws.length;
                            localDraws = widget.allDraws.take(n).toList();
                          }
                          final narrative = _generateNarrativeForSegment(
                            _selectedSegment,
                            localDraws,
                          );
                          void updatePeriod(String newPeriod) {
                            periodNotifier.value = newPeriod;
                            widget.onPeriodChanged(newPeriod);
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
                                              Icons.analytics_outlined,
                                              color: AppColors.primaryGreenDark,
                                              size: isDesktop ? 24 : 20,
                                            ),
                                            const SizedBox(width: 12),
                                            Text(
                                              'Analiză rapidă',
                                              style: AppFonts.titleStyle
                                                  .copyWith(
                                                    fontSize: isDesktop
                                                        ? 18
                                                        : 16,
                                                  ),
                                            ),
                                            const Spacer(),
                                            PeriodSelectorGlass(
                                              value: currentPeriod,
                                              options: widget.periodOptions,
                                              onChanged: updatePeriod,
                                              onCustom: (String customPeriod) {
                                                periodNotifier.value =
                                                    customPeriod;
                                                widget.onPeriodChanged(
                                                  customPeriod,
                                                );
                                              },
                                              fontSize: 15,
                                              iconSize: 18,
                                              padding: EdgeInsets.zero,
                                            ),
                                          ],
                                        ),
                                        const SizedBox(height: 16),
                                        DistributionNarrative(
                                          narrative: narrative,
                                          isDesktop: isDesktop,
                                          segment: _selectedSegment,
                                          getNumbers:
                                              widget.selectedGame ==
                                                  GameType.joker
                                              ? (draw) =>
                                                    draw.jokerNumber != null
                                                    ? [draw.jokerNumber!]
                                                    : []
                                              : (draw) => draw.mainNumbers,
                                        ),
                                        const SizedBox(height: 18),
                                        Text(
                                          'Distribuție Joker',
                                          style: AppFonts.subtitleStyle,
                                        ),
                                        DistributionNarrative(
                                          narrative:
                                              _generateNarrativeForSegment(
                                                _selectedSegment,
                                                widget.statsDraws
                                                    .where(
                                                      (d) =>
                                                          d.jokerNumber != null,
                                                    )
                                                    .toList(),
                                              ),
                                          isDesktop: isDesktop,
                                          segment: _selectedSegment,
                                          getNumbers: (draw) =>
                                              draw.jokerNumber != null
                                              ? [draw.jokerNumber!]
                                              : [],
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

  void _onSegmentChanged(String segment) {
    setState(() {
      _selectedSegment = segment;
    });
  }

  Map<String, dynamic> _generateNarrativeForSegment(
    String segment,
    List<LotoDraw> draws,
  ) {
    if (draws.isEmpty) {
      return {
        'top5': [],
        'top5Freqs': [],
        'volatility': 0.0,
        'mostStable': '-',
        'mostUnstable': '-',
        'example': 'Nu există date pentru această perioadă.',
      };
    }
    // 1. Frecvență pe segmente
    final nNumbers = widget.selectedGame == GameType.loto649
        ? 49
        : (widget.selectedGame == GameType.loto540 ? 40 : 45);
    final nSegments = segment == 'Luni' ? 12 : 4;
    Map<int, Map<int, int>> freq = {};
    for (int number = 1; number <= nNumbers; number++) {
      freq[number] = {for (int s = 1; s <= nSegments; s++) s: 0};
    }
    for (final draw in draws) {
      int segIdx = 1;
      switch (segment) {
        case 'Luni':
          segIdx = draw.date.month;
          break;
        case 'Sezoane':
          segIdx = ((draw.date.month - 1) ~/ 3) + 1;
          break;
        default:
          segIdx = draw.date.month;
      }
      for (final number in draw.mainNumbers) {
        freq[number]![segIdx] = (freq[number]![segIdx] ?? 0) + 1;
      }
    }
    // 2. Top 5 numere și frecvențele lor totale
    Map<int, int> totalFreq = {
      for (int number = 1; number <= nNumbers; number++)
        number: freq[number]!.values.reduce((a, b) => a + b),
    };
    final sorted = totalFreq.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5 = sorted.take(5).map((e) => e.key).toList();
    final top5Freqs = sorted.take(5).map((e) => e.value).toList();
    // 3. Volatilitate generală (std dev / medie pe segmente)
    List<double> allFreqs = [];
    for (int s = 1; s <= nSegments; s++) {
      int sum = 0;
      for (int n = 1; n <= nNumbers; n++) {
        sum += freq[n]![s] ?? 0;
      }
      allFreqs.add(sum.toDouble());
    }
    double mean = allFreqs.reduce((a, b) => a + b).toDouble() / allFreqs.length;
    double variance =
        allFreqs
            .map((f) => ((f - mean) * (f - mean)).toDouble())
            .reduce((a, b) => a + b) /
        allFreqs.length;
    double stdDev = mean > 0 ? sqrt(variance) : 0;
    double volatility = mean > 0 ? (stdDev / mean) * 100 : 0;
    // 4. Cel mai stabil/imprevizibil număr (coeficient de variație pe segmente)
    double minCV = double.infinity;
    double maxCV = -1.0;
    int mostStable = -1;
    int mostUnstable = -1;
    for (int n = 1; n <= nNumbers; n++) {
      final vals = freq[n]!.values.toList();
      double m =
          vals.map((e) => e.toDouble()).reduce((a, b) => a + b) / vals.length;
      double v =
          vals
              .map((f) => ((f.toDouble() - m) * (f.toDouble() - m)))
              .reduce((a, b) => a + b) /
          vals.length;
      final sd = m > 0 ? sqrt(v) : 0;
      final cv = m > 0 ? (sd / m) * 100 : 0;
      if (cv < minCV) {
        minCV = cv.toDouble();
        mostStable = n;
      }
      if (cv > maxCV) {
        maxCV = cv.toDouble();
        mostUnstable = n;
      }
    }
    // 5. Segmentul cu cele mai multe/puține apariții totale
    Map<int, int> segmentTotals = {for (int s = 1; s <= nSegments; s++) s: 0};
    for (int s = 1; s <= nSegments; s++) {
      for (int n = 1; n <= nNumbers; n++) {
        segmentTotals[s] = (segmentTotals[s] ?? 0) + (freq[n]![s] ?? 0);
      }
    }
    final maxSeg = segmentTotals.entries
        .reduce((a, b) => a.value > b.value ? a : b)
        .key;
    final minSeg = segmentTotals.entries
        .reduce((a, b) => a.value < b.value ? a : b)
        .key;
    String segNameFull(int idx) {
      if (segment == 'Luni') {
        const luni = [
          'Ianuarie',
          'Februarie',
          'Martie',
          'Aprilie',
          'Mai',
          'Iunie',
          'Iulie',
          'August',
          'Septembrie',
          'Octombrie',
          'Noiembrie',
          'Decembrie',
        ];
        return luni[idx - 1];
      } else {
        const sezoane = ['primăvară', 'vară', 'toamnă', 'iarnă'];
        return sezoane[idx - 1].capitalize();
      }
    }

    // 6. Exemplu concret
    int topNum = top5.isNotEmpty ? top5.first : 1;
    int topNumMaxSeg = 1;
    int topNumMaxVal = 0;
    for (int s = 1; s <= nSegments; s++) {
      if ((freq[topNum]![s] ?? 0) > topNumMaxVal) {
        topNumMaxVal = freq[topNum]![s] ?? 0;
        topNumMaxSeg = s;
      }
    }
    String example =
        'De exemplu, în ${segNameFull(topNumMaxSeg)}, numărul $topNum a fost extras de $topNumMaxVal ori.';
    // Narativă explicativă, clară, pe înțelesul tuturor
    String narrativeText =
        'Graficul de mai sus arată de câte ori a fost extras fiecare număr în fiecare ${segment == 'Luni' ? 'lună calendaristică' : 'sezon'} din perioada selectată. Fiecare celulă din tabel reprezintă un număr și o ${segment == 'Luni' ? 'lună' : 'sezon'}, iar valoarea din celulă arată de câte ori a apărut acel număr în ${segment == 'Luni' ? 'luna' : 'sezonul'} respectiv.'
        '\n\n'
        'Cele mai des extrase 5 numere în această perioadă sunt: ${top5.join(", ")}.'
        '\n'
        'Numărul care a apărut cel mai constant este $mostStable: acest număr a fost extras aproape același număr de ori în fiecare ${segment == 'Luni' ? 'lună' : 'sezon'}, fără diferențe mari între ele. Cu alte cuvinte, aparițiile sale au fost distribuite uniform pe tot parcursul perioadei.'
        '\n'
        'Numărul cu cele mai mari variații este $mostUnstable: acest număr a fost extras foarte des în unele ${segment == 'Luni' ? 'luni' : 'sezoane'} și foarte rar sau deloc în altele. Asta înseamnă că aparițiile sale au fost concentrate în anumite perioade.'
        '\n'
        'Cea mai norocoasă ${segment == 'Luni' ? 'lună' : 'sezon'} a fost ${segNameFull(maxSeg)}, cu ${segmentTotals[maxSeg]} apariții totale ale numerelor.'
        '\n'
        'Cea mai puțin norocoasă ${segment == 'Luni' ? 'lună' : 'sezon'} a fost ${segNameFull(minSeg)}, cu doar ${segmentTotals[minSeg]} apariții.'
        '\n'
        '$example'
        '\n'
        'Variația totală a distribuției numerelor pe ${segment == 'Luni' ? 'luni' : 'sezoane'} a fost de ${volatility.toStringAsFixed(1)}%. O variație mică înseamnă că numerele au fost extrase relativ uniform în toate ${segment == 'Luni' ? 'lunile' : 'sezoanele'}, iar o variație mare arată diferențe semnificative între ele.';
    return {
      'top5': top5,
      'top5Freqs': top5Freqs,
      'volatility': volatility,
      'mostStable': mostStable > 0 ? mostStable : '-',
      'mostUnstable': mostUnstable > 0 ? mostUnstable : '-',
      'maxSegment': segNameFull(maxSeg),
      'maxSegmentVal': segmentTotals[maxSeg],
      'minSegment': segNameFull(minSeg),
      'minSegmentVal': segmentTotals[minSeg],
      'example': example,
      'narrativeText': narrativeText,
    };
  }

  Map<int, Map<int, int>> _calculateNumberSegmentFrequency(
    List<LotoDraw> draws,
    String segment,
  ) {
    Map<int, Map<int, int>> data = {};
    for (LotoDraw draw in draws) {
      int segIdx = 1;
      switch (segment) {
        case 'Luni':
          segIdx = draw.date.month;
          break;
        case 'Sezoane':
          segIdx = ((draw.date.month - 1) ~/ 3) + 1;
          break;
        default:
          segIdx = draw.date.month;
      }
      for (int number in draw.mainNumbers) {
        if (!data.containsKey(number)) {
          data[number] = {};
        }
        data[number]![segIdx] = (data[number]![segIdx] ?? 0) + 1;
      }
    }
    return data;
  }

  Widget _buildJokerLegend(
    List<LotoDraw> drawsWithJoker,
    List<int> jokerNumbers,
    int maxJoker,
    double legendFont,
    Color legendColor,
  ) {
    if (drawsWithJoker.isEmpty) {
      return const SizedBox.shrink();
    }
    final jokerStats = StatisticsCalculationService()
        .calculateJokerStatistics(drawsWithJoker);
    return Text(
      'Joker: Total extrageri: ${drawsWithJoker.length} | Numere: ${jokerNumbers.length} | Medie frecvență: ${(jokerStats['avgFreq'] as double).toStringAsFixed(1)} | Max: ${jokerStats['maxFreq']} | Min: ${jokerStats['minFreq']}',
      style: AppFonts.captionStyle.copyWith(
        fontSize: legendFont,
        color: legendColor,
      ),
      textAlign: TextAlign.center,
    );
  }
}

extension StringCap on String {
  String capitalize() =>
      isEmpty ? this : '${this[0].toUpperCase()}${substring(1)}';
}

import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/utils/statistics_narrative_utils.dart';
// Import noile componente modulare
import 'statistics/charts/frequency_chart/frequency_chart_section.dart';
import 'statistics/charts/sum_chart/sum_chart_section.dart';
import 'statistics/charts/interval_chart/interval_chart_section.dart';
import 'statistics/charts/mean_chart/mean_chart_section.dart';
import 'statistics/charts/top_pairs_chart/top_pairs_chart_section.dart';
import 'statistics/charts/decade_chart/decade_chart_section.dart';
import 'statistics/charts/even_odd_chart/even_odd_chart_section.dart';
import 'statistics/charts/temporal_chart/temporal_chart_section.dart';
import 'statistics/charts/distribution_chart/distribution_chart_section.dart';

/// Tab-ul principal pentru afișarea statisticilor jocului selectat
class StatisticsTab extends StatefulWidget {
  final List<LotoDraw> statsDraws;
  final List<LotoDraw> allDraws; // Datele complete pentru dialog
  final String selectedPeriod;
  final List<int> periodOptions;
  final TabController statsTabController;
  final Function(String) onPeriodChanged;
  final ValueChanged<String> onCustomPeriod;
  final Function(Map<String, dynamic>) onStatsChanged;
  final GameType selectedGame;

  const StatisticsTab({
    super.key,
    required this.statsDraws,
    required this.allDraws,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.statsTabController,
    required this.onPeriodChanged,
    required this.onCustomPeriod,
    required this.onStatsChanged,
    required this.selectedGame,
  });

  @override
  State<StatisticsTab> createState() => StatisticsTabState();
}

class StatisticsTabState extends State<StatisticsTab> {
  bool _isProcessingTemporal = false;
  Map<String, dynamic>? _temporalNarrative;
  final GlobalKey mainContentKey = GlobalKey();

  @override
  Widget build(BuildContext context) {
    if (widget.statsDraws.isEmpty) {
      return const Center(
        child: Text(
          'Nu există date pentru graficul de frecvență.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    final isDesktop = MediaQuery.of(context).size.width > 700;
    final periodOptions = [
      ...widget.periodOptions.map((n) => 'Ultimele $n'),
      'Toate extragerile',
      'Custom',
    ];

    final List<String> chartTitles = [
      'Frecvență',
      'Sumă',
      'Interval',
      'Medie',
      'Top Perechi',
      'Decade',
      'Par/Impar',
      'Temporal',
      'Distribuție',
    ];

    return Center(
      child: Padding(
        padding: EdgeInsets.only(
          left: 0,
          right: 0,
          top: isDesktop ? 24 : 8,
          bottom: isDesktop ? 24 : 8,
        ),
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop ? 900 : double.infinity,
            minWidth: 0,
          ),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Transform.translate(
                offset: Offset(-52, 0),
                child: MediaQuery.removePadding(
                  context: context,
                  removeLeft: true,
                  child: TabBar(
                    controller: widget.statsTabController,
                    isScrollable: true,
                    indicatorColor: AppColors.secondaryBlueMedium,
                    labelColor: AppColors.secondaryBlueMedium,
                    unselectedLabelColor: Colors.black45,
                    labelStyle: AppFonts.subtitleStyle.copyWith(
                      fontSize: isDesktop ? 16 : 13,
                      fontWeight: FontWeight.bold,
                    ),
                    unselectedLabelStyle: AppFonts.bodyStyle.copyWith(
                      fontSize: isDesktop ? 15 : 12,
                    ),
                    tabs: chartTitles
                        .map(
                          (t) => Tab(
                            child: Text(
                              t,
                              overflow: TextOverflow.ellipsis,
                              maxLines: 1,
                            ),
                          ),
                        )
                        .toList(),
                    padding: EdgeInsets.zero,
                  ),
                ),
              ),
              SizedBox(height: isDesktop ? 18 : 8),
              Expanded(
                key: mainContentKey,
                child: TabBarView(
                  controller: widget.statsTabController,
                  children: [
                    // Frecvență
                    FrequencyChartSection(
                      statsDraws: widget.statsDraws,
                      allDraws: widget.allDraws,
                      selectedPeriod: widget.selectedPeriod,
                      periodOptions: periodOptions,
                      onPeriodChanged: widget.onPeriodChanged,
                      onCustomPeriod: (String customPeriod) {
                        widget.onPeriodChanged(customPeriod);
                      },
                      isDesktop: isDesktop,
                      selectedGame: widget.selectedGame,
                      asyncFreq: null,
                      freqNarrative: null,
                    ),
                    // Sumă
                    SumChartSection(
                      statsDraws: widget.statsDraws,
                      allDraws: widget.allDraws,
                      selectedPeriod: widget.selectedPeriod,
                      periodOptions: periodOptions,
                      onPeriodChanged: widget.onPeriodChanged,
                      onCustomPeriod: (String customPeriod) {
                        widget.onPeriodChanged(customPeriod);
                      },
                      isDesktop: isDesktop,
                      selectedGame: widget.selectedGame,
                      sumNarrativeData: calculateSumNarrative({
                        'draws': widget.statsDraws,
                      }),
                    ),
                    // Interval
                    IntervalChartSection(
                      statsDraws: widget.statsDraws,
                      allDraws: widget.allDraws,
                      selectedPeriod: widget.selectedPeriod,
                      periodOptions: periodOptions,
                      onPeriodChanged: widget.onPeriodChanged,
                      onCustomPeriod: (String customPeriod) {
                        widget.onPeriodChanged(customPeriod);
                      },
                      isDesktop: isDesktop,
                      intervalNarrativeData: null,
                    ),
                    // Medie
                    MeanChartSection(
                      statsDraws: widget.statsDraws,
                      allDraws: widget.allDraws,
                      selectedPeriod: widget.selectedPeriod,
                      periodOptions: periodOptions,
                      onPeriodChanged: widget.onPeriodChanged,
                      onCustomPeriod: (String customPeriod) {
                        widget.onPeriodChanged(customPeriod);
                      },
                      isDesktop: isDesktop,
                    ),
                    // Top Perechi
                    TopPairsChartSection(
                      statsDraws: widget.statsDraws,
                      allDraws: widget.allDraws,
                      selectedPeriod: widget.selectedPeriod,
                      periodOptions: periodOptions,
                      onPeriodChanged: widget.onPeriodChanged,
                      onCustomPeriod: widget.onCustomPeriod,
                      isDesktop: isDesktop,
                      selectedGame: widget.selectedGame,
                    ),
                    // Decade
                    DecadeChartSection(
                      statsDraws: widget.statsDraws,
                      allDraws: widget.allDraws,
                      selectedPeriod: widget.selectedPeriod,
                      periodOptions: periodOptions,
                      onPeriodChanged: widget.onPeriodChanged,
                      onCustomPeriod: widget.onCustomPeriod,
                      isDesktop: isDesktop,
                      selectedGame: widget.selectedGame,
                      decadeNarrative: null,
                    ),
                    // Par/Impar
                    EvenOddChartSection(
                      statsDraws: widget.statsDraws,
                      allDraws: widget.allDraws,
                      selectedPeriod: widget.selectedPeriod,
                      periodOptions: periodOptions,
                      onPeriodChanged: widget.onPeriodChanged,
                      onCustomPeriod: widget.onCustomPeriod,
                      isDesktop: isDesktop,
                      selectedGame: widget.selectedGame,
                    ),
                    // Temporal
                    TemporalChartSection(
                      statsDraws: _filterDrawsByPeriod(
                        widget.statsDraws,
                        widget.selectedPeriod,
                        100,
                      ),
                      allDraws: widget.allDraws,
                      selectedPeriod: widget.selectedPeriod,
                      periodOptions: periodOptions,
                      onPeriodChanged: (val) {
                        widget.onPeriodChanged(val);
                        final filtered = _filterDrawsByPeriod(
                          widget.statsDraws,
                          val,
                          100,
                        );
                        _processTemporalNarrativeAsync(filtered);
                      },
                      onCustomPeriod: (String customPeriod) {
                        widget.onPeriodChanged(customPeriod);
                        final filtered = _filterDrawsByPeriod(
                          widget.statsDraws,
                          customPeriod,
                          100,
                        );
                        _processTemporalNarrativeAsync(filtered);
                      },
                      isDesktop: isDesktop,
                      selectedGame: widget.selectedGame,
                      temporalNarrative: _temporalNarrative,
                      isProcessingTemporal: _isProcessingTemporal,
                    ),
                    // Distribuție
                    DistributionChartSection(
                      statsDraws: widget.statsDraws,
                      allDraws: widget.allDraws,
                      selectedPeriod: widget.selectedPeriod,
                      periodOptions: periodOptions,
                      onPeriodChanged: widget.onPeriodChanged,
                      onCustomPeriod: (_) {},
                      isDesktop: isDesktop,
                      selectedGame: widget.selectedGame,
                      distributionNarrative: null,
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  List<LotoDraw> _filterDrawsByPeriod(
    List<LotoDraw> draws,
    String selectedPeriod,
    int customPeriod,
  ) {
    if (selectedPeriod == 'Toate extragerile') return draws;
    if (selectedPeriod == 'Custom') {
      return draws.take(customPeriod).toList();
    }
    final match = RegExp(r'Ultimele (\d+)').firstMatch(selectedPeriod);
    if (match != null) {
      final n = int.tryParse(match.group(1) ?? '100') ?? 100;
      return draws.take(n).toList();
    }
    return draws.take(100).toList();
  }

  Future<void> _processTemporalNarrativeAsync(List<LotoDraw> draws) async {
    setState(() => _isProcessingTemporal = true);
    final result = await compute(calculateTemporalNarrative, {'draws': draws});
    setState(() {
      _temporalNarrative = result;
      _isProcessingTemporal = false;
    });
  }
}

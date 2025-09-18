import 'package:flutter/material.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'dart:ui';
import 'dart:async';

/// Grafic heatmap pentru distribuția lunară a numerelor (X = numere, Y = luni)
class StatisticsDistributionChart extends StatelessWidget {
  final List<LotoDraw> draws;
  final int mainRange;
  final String segment;
  final List<int> Function(LotoDraw draw) getNumbers;

  const StatisticsDistributionChart({
    super.key,
    required this.draws,
    required this.mainRange,
    required this.segment,
    required this.getNumbers,
  });

  @override
  Widget build(BuildContext context) {
    return _DistributionChartWithFullscreen(
      draws: draws,
      mainRange: mainRange,
      segment: segment,
      title: 'Distributie',
      getNumbers: getNumbers,
    );
  }
}

class _DistributionChartWithFullscreen extends StatefulWidget {
  final List<LotoDraw> draws;
  final int mainRange;
  final String segment;
  final String title;
  final List<int> Function(LotoDraw draw) getNumbers;
  const _DistributionChartWithFullscreen({
    required this.draws,
    required this.mainRange,
    required this.segment,
    required this.title,
    required this.getNumbers,
  });
  @override
  State<_DistributionChartWithFullscreen> createState() =>
      _DistributionChartWithFullscreenState();
}

class _DistributionChartWithFullscreenState
    extends State<_DistributionChartWithFullscreen> {
  bool _fullscreen = false;
  final ScrollController _horizontalController = ScrollController();

  void _toggleFullscreen() async {
    if (!_fullscreen) {
      setState(() => _fullscreen = true);
      await showDialog(
        context: context,
        barrierColor: Colors.black.withValues(alpha: 0.15),
        builder: (ctx) => Scaffold(
          backgroundColor: Colors.transparent,
          body: SafeArea(
            child: Stack(
              children: [
                Center(
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(24),
                    child: BackdropFilter(
                      filter: ImageFilter.blur(sigmaX: 18, sigmaY: 18),
                      child: Container(
                        margin: const EdgeInsets.all(0),
                        decoration: BoxDecoration(
                          color: Colors.white.withValues(alpha: 0.18),
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
                        child: Padding(
                          padding: const EdgeInsets.all(16.0),
                          child: _DistributionChartContent(
                            draws: widget.draws,
                            mainRange: widget.mainRange,
                            segment: widget.segment,
                            fullscreen: true,
                            onToggleFullscreen: _toggleFullscreen,
                            horizontalScrollController: _horizontalController,
                            getNumbers: widget.getNumbers,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  top: 18,
                  right: 18,
                  child: IconButton(
                    icon: const Icon(Icons.close_rounded, size: 32),
                    tooltip: 'Ieșire fullscreen',
                    onPressed: () {
                      Navigator.of(ctx).pop();
                    },
                  ),
                ),
              ],
            ),
          ),
        ),
      );
      setState(() => _fullscreen = false);
    }
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    return Stack(
      children: [
        _DistributionChartContent(
          draws: widget.draws,
          mainRange: widget.mainRange,
          segment: widget.segment,
          fullscreen: false,
          onToggleFullscreen: _toggleFullscreen,
          horizontalScrollController: _horizontalController,
          getNumbers: widget.getNumbers,
        ),
      ],
    );
  }
}

class _DistributionChartContent extends StatelessWidget {
  final List<LotoDraw> draws;
  final int mainRange;
  final String segment;
  final bool fullscreen;
  final VoidCallback onToggleFullscreen;
  final ScrollController? horizontalScrollController;
  final List<int> Function(LotoDraw draw) getNumbers;
  const _DistributionChartContent({
    required this.draws,
    required this.mainRange,
    required this.segment,
    required this.fullscreen,
    required this.onToggleFullscreen,
    this.horizontalScrollController,
    required this.getNumbers,
  });

  static List<String> getYears(List<LotoDraw> draws) {
    final years = draws.map((d) => d.date.year).toSet().toList()..sort();
    return years.map((y) => y.toString()).toList();
  }

  Color getPastelColor(int freq, int minFreq, int maxFreq) {
    if (maxFreq == minFreq) return const Color(0xFFFFF9C4); // galben pastel
    final t = ((freq - minFreq) / (maxFreq - minFreq)).clamp(0.0, 1.0);
    if (t < 0.5) {
      return Color.lerp(
        const Color(0xFFFFF9C4),
        const Color(0xFFFFCC80),
        t * 2,
      )!;
    } else {
      return Color.lerp(
        const Color(0xFFFFCC80),
        const Color(0xFFFF8A80),
        (t - 0.5) * 2,
      )!;
    }
  }

  Widget _buildSeasonLegend(String abbr, String name, Color color) {
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Container(
          width: 16,
          height: 16,
          decoration: BoxDecoration(
            color: color.withValues(alpha: 0.18),
            borderRadius: BorderRadius.circular(4),
            border: Border.all(color: color.withValues(alpha: 0.5), width: 1),
          ),
        ),
        const SizedBox(width: 4),
        Text(
          '$abbr = $name',
          style: TextStyle(fontSize: 11, color: Colors.black54),
        ),
      ],
    );
  }

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;

    if (draws.isEmpty || mainRange <= 0) {
      return Center(
        child: Text(
          'Nu există date pentru graficul de distributie.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    // Calculez aparițiile numerelor pe segmentul selectat
    final Map<int, Map<int, int>> numberSegmentData =
        _calculateNumberSegmentFrequency(draws, segment);
    if (numberSegmentData.isEmpty) {
      return Center(
        child: Text(
          'Nu există date valide pentru graficul de distributie.',
          style: AppFonts.bodyStyle,
        ),
      );
    }

    // După calculul numberSegmentData și validare:
    final totalDraws = draws.length;
    // Abrevieri pentru segmente (lunile, zilele etc.)
    final Map<String, List<String>> segmentLabelsAbbr = {
      'Luni': [
        'Ian',
        'Feb',
        'Mar',
        'Apr',
        'Mai',
        'Iun',
        'Iul',
        'Aug',
        'Sep',
        'Oct',
        'Noi',
        'Dec',
      ],
      'Sezoane': ['Q1', 'Q2', 'Q3', 'Q4'],
    };
    final labelsAbbr = segmentLabelsAbbr[segment] ?? segmentLabelsAbbr['Luni']!;
    final nSegments = labelsAbbr.length;
    final nNumbers = mainRange;

    // Calculez max/min frecvență și topNumbers
    int minFreq = 999999, maxFreq = 0;
    Map<int, int> numberTotals = {};
    for (var number = 1; number <= nNumbers; number++) {
      int total = 0;
      for (var seg = 1; seg <= nSegments; seg++) {
        int freq = numberSegmentData[number]?[seg] ?? 0;
        if (freq < minFreq) minFreq = freq;
        if (freq > maxFreq) maxFreq = freq;
        total += freq;
      }
      numberTotals[number] = total;
    }
    List<MapEntry<int, int>> sortedTotals = numberTotals.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final List<int> topNumbers = sortedTotals
        .take(5)
        .map((e) => e.key)
        .toList();

    // Dimensiuni adaptive
    final double availableWidth = MediaQuery.of(context).size.width;
    final double labelColWidth = isDesktop ? 60.0 : 50.0;
    final double usedCellWidth = isDesktop
        ? 18.0
        : 20.0; // Fixed widths for consistency
    // Micșorez înălțimea celulelor cu 20%
    final double cellHeight = isDesktop ? 28.0 : 22.0;
    final double usedCellHeight = cellHeight * 0.8;

    // Evidențiere sezoane (background colorat pe coloane pentru sezoane)
    List<Widget> seasonBackgrounds = [];
    if (segment == 'Sezoane') {
      final seasonColors = [
        Colors.greenAccent.withValues(alpha: 0.10), // Primăvară
        Colors.yellow.withValues(alpha: 0.10), // Vară
        Colors.orange.withValues(alpha: 0.10), // Toamnă
        Colors.blue.withValues(alpha: 0.10), // Iarnă
      ];
      for (int s = 0; s < nSegments; s++) {
        seasonBackgrounds.add(
          Positioned(
            left: labelColWidth,
            top: (s + 1) * usedCellHeight,
            width: nNumbers * usedCellWidth,
            height: usedCellHeight,
            child: Container(color: seasonColors[s % seasonColors.length]),
          ),
        );
      }
    }

    // Legendă pentru abrevieri segmente (ex: Q1=Primăvară etc.)
    Widget? segmentLegend;
    if (segment == 'Sezoane') {
      segmentLegend = Padding(
        padding: const EdgeInsets.only(top: 8.0, left: 8.0, right: 8.0),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            _buildSeasonLegend('Q1', 'Primăvară', Colors.greenAccent),
            const SizedBox(width: 10),
            _buildSeasonLegend('Q2', 'Vară', Colors.yellow),
            const SizedBox(width: 10),
            _buildSeasonLegend('Q3', 'Toamnă', Colors.orange),
            const SizedBox(width: 10),
            _buildSeasonLegend('Q4', 'Iarnă', Colors.blue),
          ],
        ),
      );
    }

    Widget gridDisplay;
    if (isDesktop) {
      // Desktop: Table cu FlexColumnWidth pentru distribuție automată
      gridDisplay = SizedBox(
        width: availableWidth,
        child: Table(
          columnWidths: {0: FixedColumnWidth(labelColWidth)},
          defaultColumnWidth: const FlexColumnWidth(
            1.0,
          ), // Distribuie automat lățimea
          children: List.generate(nSegments + 1, (rowIdx) {
            return TableRow(
              children: List.generate(nNumbers + 1, (colIdx) {
                if (rowIdx == 0 && colIdx == 0) {
                  // colțul stânga-sus: celulă goală
                  return Container(
                    width: labelColWidth,
                    height: usedCellHeight,
                    color: Colors.transparent,
                  );
                } else if (rowIdx == 0 && colIdx > 0) {
                  // header: numerele 1–N
                  return Container(
                    height: usedCellHeight,
                    alignment: Alignment.center,
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      '$colIdx',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: nNumbers <= 20
                            ? 11
                            : (nNumbers <= 40 ? 9 : 7),
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                } else if (rowIdx > 0 && colIdx == 0) {
                  // header: eticheta segmentului (abreviată)
                  return Container(
                    width: labelColWidth,
                    height: usedCellHeight,
                    alignment: Alignment.centerLeft,
                    padding: const EdgeInsets.symmetric(horizontal: 6),
                    decoration: BoxDecoration(
                      color: Colors.white.withValues(alpha: 0.18),
                      borderRadius: BorderRadius.circular(3),
                    ),
                    child: Text(
                      labelsAbbr[rowIdx - 1],
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: nSegments <= 12 ? 11 : 8,
                        color: Colors.black87,
                      ),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  );
                } else if (rowIdx > 0 && colIdx > 0) {
                  // celulă de date
                  int number = colIdx;
                  int segIdx = rowIdx;
                  int freq = numberSegmentData[number]?[segIdx] ?? 0;
                  Color cellColor = getPastelColor(freq, minFreq, maxFreq);
                  Widget cellContent = freq > 0
                      ? Center(
                          child: Text(
                            freq.toString(),
                            style: TextStyle(
                              fontSize: nNumbers <= 20
                                  ? 10
                                  : (nNumbers <= 40 ? 8 : 6),
                              fontWeight: FontWeight.w600,
                              color: Colors.black87,
                            ),
                          ),
                        )
                      : const SizedBox.shrink();

                  // Tooltip logic
                  final breakdown = _getBreakdownForCell(
                    draws,
                    segment,
                    segIdx,
                    number,
                  );
                  int totalDrawsInSegment = 0;
                  if (segment == 'Luni') {
                    totalDrawsInSegment = draws
                        .where((d) => d.date.month == segIdx)
                        .length;
                  } else if (segment == 'Sezoane') {
                    int season = segIdx;
                    totalDrawsInSegment = draws
                        .where((d) => ((d.date.month - 1) ~/ 3) + 1 == season)
                        .length;
                  } else {
                    totalDrawsInSegment = draws.length;
                  }
                  final percent = (totalDrawsInSegment > 0)
                      ? (100 * freq / totalDrawsInSegment).toStringAsFixed(1)
                      : '-';

                  final tooltipMsg =
                      'Nr: $number | ${labelsAbbr[segIdx - 1]}\nApariții: $freq${percent != '-' ? ' [$percent%]' : ''}\nExtrageri: $totalDrawsInSegment';

                  return GestureDetector(
                    onTapDown: (details) {
                      final renderBox =
                          context.findRenderObject() as RenderBox?;
                      final offset =
                          renderBox?.localToGlobal(Offset.zero) ?? Offset.zero;
                      final cellRect = Rect.fromLTWH(
                        offset.dx + colIdx * usedCellWidth,
                        offset.dy + rowIdx * usedCellHeight,
                        usedCellWidth,
                        usedCellHeight,
                      );
                      final gridBox = context
                          .findAncestorRenderObjectOfType<RenderBox>();
                      final gridSize = gridBox?.size;
                      DistributionChartTooltip.show(
                        context: context,
                        targetRect: cellRect,
                        message: tooltipMsg,
                        rowIdx: rowIdx,
                        colIdx: colIdx,
                        gridSize: gridSize,
                      );
                    },
                    child: Container(
                      height: usedCellHeight,
                      decoration: BoxDecoration(
                        color: cellColor,
                        borderRadius: BorderRadius.circular(3),
                        border: Border.all(
                          color: Colors.white.withAlpha(46),
                          width: 0.5,
                        ),
                      ),
                      child: cellContent,
                    ),
                  );
                } else {
                  return SizedBox(height: usedCellHeight);
                }
              }),
            );
          }),
        ),
      );
    } else {
      // Mobil: Tot gridul (header + etichete + date) scrollabil orizontal, fără sticky column
      final totalWidth = nNumbers * usedCellWidth + labelColWidth;
      List<Widget> rows = [];

      // Header row
      rows.add(
        Row(
          children: [
            Container(
              width: labelColWidth,
              height: usedCellHeight,
              alignment: Alignment.centerLeft,
              padding: const EdgeInsets.symmetric(horizontal: 6),
              decoration: BoxDecoration(
                color: Colors.white.withAlpha(46),
                borderRadius: BorderRadius.circular(3),
              ),
              child: const SizedBox.shrink(),
            ),
            ...List.generate(nNumbers, (colIdx) {
              return Container(
                width: usedCellWidth,
                height: usedCellHeight,
                alignment: Alignment.center,
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(46),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  '${colIdx + 1}',
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9.0,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              );
            }),
          ],
        ),
      );

      // Data rows
      for (int rowIdx = 1; rowIdx <= nSegments; rowIdx++) {
        rows.add(
          Row(
            children: [
              Container(
                width: labelColWidth,
                height: usedCellHeight,
                alignment: Alignment.centerLeft,
                padding: const EdgeInsets.symmetric(horizontal: 6),
                decoration: BoxDecoration(
                  color: Colors.white.withAlpha(46),
                  borderRadius: BorderRadius.circular(3),
                ),
                child: Text(
                  labelsAbbr[rowIdx - 1],
                  style: TextStyle(
                    fontWeight: FontWeight.bold,
                    fontSize: 9.0,
                    color: Colors.black87,
                  ),
                  maxLines: 1,
                  overflow: TextOverflow.ellipsis,
                ),
              ),
              ...List.generate(nNumbers, (colIdx) {
                int number = colIdx + 1;
                int segIdx = rowIdx;
                int freq = numberSegmentData[number]?[segIdx] ?? 0;
                Color cellColor = getPastelColor(freq, minFreq, maxFreq);
                Widget cellContent = freq > 0
                    ? Center(
                        child: Text(
                          freq.toString(),
                          style: TextStyle(
                            fontSize: 9.0,
                            fontWeight: FontWeight.w600,
                            color: Colors.black87,
                          ),
                        ),
                      )
                    : const SizedBox.shrink();
                return Container(
                  width: usedCellWidth,
                  height: usedCellHeight,
                  decoration: BoxDecoration(
                    color: cellColor,
                    borderRadius: BorderRadius.circular(3),
                    border: Border.all(
                      color: Colors.white.withAlpha(46),
                      width: 0.5,
                    ),
                  ),
                  child: cellContent,
                );
              }),
            ],
          ),
        );
      }

      gridDisplay = SingleChildScrollView(
        scrollDirection: Axis.horizontal,
        child: SizedBox(
          width: totalWidth,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: rows,
          ),
        ),
      );
    }

    // Înălțime maximă pentru grid pe mobil
    final double chartHeight = 234.0;
    final double gridHeight =
        nSegments * usedCellHeight + usedCellHeight + 24; // header + padding
    return isDesktop
        ? Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              Expanded(
                child: Stack(
                  children: [
                    if (seasonBackgrounds.isNotEmpty) ...seasonBackgrounds,
                    gridDisplay,
                  ],
                ),
              ),
              if (segmentLegend != null) segmentLegend,
            ],
          )
        : LayoutBuilder(
            builder: (context, constraints) {
              final double maxHeight = constraints.maxHeight;
              final double gridHeight =
                  nSegments * usedCellHeight + usedCellHeight + 24;
              return Column(
                crossAxisAlignment: CrossAxisAlignment.stretch,
                children: [
                  ConstrainedBox(
                    constraints: BoxConstraints(maxHeight: maxHeight),
                    child: Scrollbar(
                      child: SingleChildScrollView(
                        scrollDirection: Axis.vertical,
                        child: SizedBox(
                          height: gridHeight,
                          child: Stack(
                            children: [
                              if (seasonBackgrounds.isNotEmpty)
                                ...seasonBackgrounds,
                              gridDisplay,
                            ],
                          ),
                        ),
                      ),
                    ),
                  ),
                  if (segmentLegend != null) segmentLegend,
                ],
              );
            },
          );
  }

  /// Calculează frecvențele numerelor pe segmentul selectat
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
        case 'Zile săptămână':
          segIdx = draw.date.weekday;
          break;
        case 'Sezoane':
          segIdx = ((draw.date.month - 1) ~/ 3) + 1;
          break;
        case 'Ani':
          segIdx = draw.date.year;
          break;
        case 'Trimestre':
          segIdx = ((draw.date.month - 1) ~/ 3) + 1;
          break;
        default:
          segIdx = draw.date.month;
      }
      for (int number in getNumbers(draw)) {
        if (!data.containsKey(number)) {
          data[number] = {};
        }
        data[number]![segIdx] = (data[number]![segIdx] ?? 0) + 1;
      }
    }
    return data;
  }

  /// Calculează frecvențele numerelor pe luni
  Map<int, Map<int, int>> _calculateNumberMonthFrequency(List<LotoDraw> draws) {
    Map<int, Map<int, int>> numberMonthData = {};
    for (LotoDraw draw in draws) {
      int month = draw.date.month;
      for (int number in getNumbers(draw)) {
        if (!numberMonthData.containsKey(number)) {
          numberMonthData[number] = {};
        }
        numberMonthData[number]![month] =
            (numberMonthData[number]![month] ?? 0) + 1;
      }
    }
    return numberMonthData;
  }

  /// Returnează breakdown-ul pentru o celulă (ex: pe zile dacă segmentul e lună)
  Map<String, int> _getBreakdownForCell(
    List<LotoDraw> draws,
    String segment,
    int segIdx,
    int number,
  ) {
    Map<String, int> breakdown = {};
    if (segment == 'Luni') {
      // Breakdown pe zile pentru luna selectată
      final days = ['Lun', 'Mar', 'Mie', 'Joi', 'Vin', 'Sâm', 'Dum'];
      for (int i = 1; i <= 7; i++) {
        breakdown[days[i - 1]] = 0;
      }
      for (var d in draws) {
        if (d.date.month == segIdx && getNumbers(d).contains(number)) {
          breakdown[days[d.date.weekday - 1]] =
              (breakdown[days[d.date.weekday - 1]] ?? 0) + 1;
        }
      }
    } else if (segment == 'Sezoane') {
      // Breakdown pe luni pentru sezon
      final months = [
        'Ian',
        'Feb',
        'Mar',
        'Apr',
        'Mai',
        'Iun',
        'Iul',
        'Aug',
        'Sep',
        'Oct',
        'Noi',
        'Dec',
      ];
      for (int i = 1; i <= 12; i++) {
        breakdown[months[i - 1]] = 0;
      }
      for (var d in draws) {
        int season = ((d.date.month - 1) ~/ 3) + 1;
        if (season == segIdx && getNumbers(d).contains(number)) {
          breakdown[months[d.date.month - 1]] =
              (breakdown[months[d.date.month - 1]] ?? 0) + 1;
        }
      }
    }
    return breakdown;
  }

  int _calculateTotalDrawsInSegment(
    List<LotoDraw> draws,
    int segIdx,
    String segment,
  ) {
    if (segment == 'Luni') {
      return draws.where((d) => d.date.month == segIdx).length;
    } else if (segment == 'Sezoane') {
      int season = segIdx;
      return draws.where((d) => ((d.date.month - 1) ~/ 3) + 1 == season).length;
    } else {
      return draws.length;
    }
  }
}

class DistributionChartTooltip {
  static OverlayEntry? _currentEntry;
  static Timer? _hideTimer;
  static int? _activeRow;
  static int? _activeCol;

  static void show({
    required BuildContext context,
    required Rect targetRect,
    required String message,
    double maxWidth = 220,
    Size? gridSize,
    Duration duration = const Duration(milliseconds: 3500),
    int? rowIdx,
    int? colIdx,
  }) {
    if (_activeRow == rowIdx && _activeCol == colIdx && _currentEntry != null) {
      return;
    }
    hide();
    _activeRow = rowIdx;
    _activeCol = colIdx;
    final overlay = Overlay.of(context);
    final renderBox = context.findRenderObject() as RenderBox?;
    final size = gridSize ?? renderBox?.size ?? MediaQuery.of(context).size;
    final gridLeft = renderBox?.localToGlobal(Offset.zero).dx ?? 0;
    final gridTop = renderBox?.localToGlobal(Offset.zero).dy ?? 0;
    double left = targetRect.left;
    double top = targetRect.top - 54;
    // Ajustez să nu depășească gridul/cardul
    if (top < gridTop + 8) top = targetRect.bottom + 8;
    if (left + maxWidth > gridLeft + size.width - 8) {
      left = gridLeft + size.width - maxWidth - 8;
    }
    if (left < gridLeft + 8) left = gridLeft + 8;
    _currentEntry = OverlayEntry(
      builder: (ctx) => Positioned(
        left: left,
        top: top,
        width: maxWidth,
        child: Material(
          color: Colors.transparent,
          child: Container(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.92),
              borderRadius: BorderRadius.circular(12),
              border: Border.all(
                color: Colors.orange.withValues(alpha: 0.22),
                width: 1.0,
              ),
              boxShadow: [
                BoxShadow(
                  color: Colors.black.withValues(alpha: 0.10),
                  blurRadius: 10,
                  offset: Offset(0, 3),
                ),
              ],
            ),
            child: Text(
              message,
              style: const TextStyle(
                color: Colors.black87,
                fontSize: 11,
                fontWeight: FontWeight.w500,
              ),
              textAlign: TextAlign.left,
            ),
          ),
        ),
      ),
    );
    overlay.insert(_currentEntry!);
    _hideTimer = Timer(duration, hide);
  }

  static void hide() {
    _hideTimer?.cancel();
    _hideTimer = null;
    _currentEntry?.remove();
    _currentEntry = null;
    _activeRow = null;
    _activeCol = null;
  }
}

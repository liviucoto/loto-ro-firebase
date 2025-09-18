import 'package:flutter/material.dart';
import '../models/loto_draw.dart';

/// Tipuri de insight narativ pentru UI (icon, culoare, etc)
enum NarrativeInsightType {
  summary,
  sum,
  parity,
  minMax,
  average,
  decade,
  group,
  hot,
  cold,
  distance,
  lastSeen,
  info,
}

/// Model pentru un insight narativ
class NarrativeInsight {
  final String text;
  final NarrativeInsightType type;
  final IconData? icon;
  NarrativeInsight({required this.text, required this.type, this.icon});
}

class NarrativeAnalysisService {
  /// Returneaza lista de insight-uri narative pentru o extragere
  List<NarrativeInsight> getNarrativeAnalysis({
    required LotoDraw draw,
    required List<LotoDraw> allDraws,
  }) {
    final List<NarrativeInsight> insights = [];
    final numbers = draw.mainNumbers;
    final sum = draw.sum;
    final avg = draw.average;
    final even = draw.evenCount;
    final odd = draw.oddCount;
    final min = draw.minNumber;
    final max = draw.maxNumber;
    final dateStr = '${draw.date.day.toString().padLeft(2, '0')}.${draw.date.month.toString().padLeft(2, '0')}.${draw.date.year}';

    // 1. Sumar pare/impare
    insights.add(NarrativeInsight(
      text: 'Extragerea din $dateStr con?ine $even numere pare ?i $odd impare.',
      type: NarrativeInsightType.parity,
      icon: Icons.numbers,
    ));

    // 2. Suma ?i media
    insights.add(NarrativeInsight(
      text: 'Suma numerelor: $sum, media: ${avg.toStringAsFixed(1)}.',
      type: NarrativeInsightType.sum,
      icon: Icons.ssid_chart,
    ));

    // 3. Min/Max
    insights.add(NarrativeInsight(
      text: 'Cel mai mic numar: $min, cel mai mare: $max.',
      type: NarrativeInsightType.minMax,
      icon: Icons.straighten,
    ));

    // 4. Suma vs istoric
    final allSums = allDraws.map((d) => d.sum).toList();
    final historicAvg = allSums.isNotEmpty ? allSums.reduce((a, b) => a + b) / allSums.length : 0;
    if (sum > historicAvg) {
      insights.add(NarrativeInsight(
        text: 'Suma este peste media istorica (${historicAvg.toStringAsFixed(2)}).',
        type: NarrativeInsightType.info,
        icon: Icons.trending_up,
      ));
    } else {
      insights.add(NarrativeInsight(
        text: 'Suma este sub media istorica (${historicAvg.toStringAsFixed(2)}).',
        type: NarrativeInsightType.info,
        icon: Icons.trending_down,
      ));
    }

    // 5. Distribu?ie pe decade
    final Map<int, List<int>> decades = {};
    for (var n in numbers) {
      final dec = (n - 1) ~/ 10;
      decades.putIfAbsent(dec, () => []).add(n);
    }
    final decadeStr = decades.entries.map((e) => '${e.key * 10 + 1}-${(e.key + 1) * 10}: ${e.value.join(", ")}').join('; ');
    insights.add(NarrativeInsight(
      text: 'Distribu?ie pe decade: $decadeStr.',
      type: NarrativeInsightType.decade,
      icon: Icons.timeline,
    ));

    // 6. Grupuri consecutive
    final sorted = List<int>.from(numbers)..sort();
    List<List<int>> groups = [];
    List<int> current = [];
    for (var n in sorted) {
      if (current.isEmpty || n == current.last + 1) {
        current.add(n);
      } else {
        if (current.length > 1) groups.add(List.from(current));
        current = [n];
      }
    }
    if (current.length > 1) groups.add(current);
    if (groups.isNotEmpty) {
      final groupStr = groups.map((g) => g.join(", ")).join('; ');
      insights.add(NarrativeInsight(
        text: 'Grupuri consecutive: $groupStr.',
        type: NarrativeInsightType.group,
        icon: Icons.group_work,
      ));
    }

    // 7. Numere hot/cold (cele mai frecvente/rare din TOATE extragerile)
    final freqAll = <int, int>{};
    for (var d in allDraws) {
      for (var n in d.mainNumbers) {
        freqAll[n] = (freqAll[n] ?? 0) + 1;
      }
    }
    // Top 5 cele mai frecvente (hot)
    final topHotAll = freqAll.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final hotNumbersAll = topHotAll.take(5).map((e) => e.key).toSet();
    final hotPresentAll = numbers.where((n) => hotNumbersAll.contains(n)).toList();
    if (hotPresentAll.isNotEmpty) {
      insights.add(NarrativeInsight(
        text: 'Numere hot prezente: ${hotPresentAll.join(", ")}.',
        type: NarrativeInsightType.hot,
        icon: Icons.whatshot,
      ));
    }
    // Top 5 cele mai rare (cold)
    final sortedByRare = freqAll.entries.toList()
      ..sort((a, b) => a.value.compareTo(b.value));
    final coldNumbersAll = sortedByRare.take(5).map((e) => e.key).toSet();
    final coldPresentAll = numbers.where((n) => coldNumbersAll.contains(n)).toList();
    if (coldPresentAll.isNotEmpty) {
      insights.add(NarrativeInsight(
        text: 'Numere reci prezente: ${coldPresentAll.join(", ")}.',
        type: NarrativeInsightType.cold,
        icon: Icons.ac_unit,
      ));
    }

    // 8. Distan?e între numere
    final distances = <int>[];
    for (int i = 1; i < sorted.length; i++) {
      distances.add(sorted[i] - sorted[i - 1]);
    }
    if (distances.isNotEmpty) {
      insights.add(NarrativeInsight(
        text: 'Distan?e între numere: ${distances.join(", ")}.',
        type: NarrativeInsightType.distance,
        icon: Icons.swap_horiz,
      ));
    }

    // 9. Ultima apari?ie pentru fiecare numar
    for (var n in numbers) {
      int lastSeen = 0;
      for (var i = allDraws.indexOf(draw) + 1; i < allDraws.length; i++) {
        if (allDraws[i].mainNumbers.contains(n)) {
          lastSeen = i - allDraws.indexOf(draw);
          break;
        }
      }
      if (lastSeen > 0) {
        insights.add(NarrativeInsight(
          text: 'Ultima apari?ie a numarului $n a fost în urma cu $lastSeen extrageri.',
          type: NarrativeInsightType.lastSeen,
          icon: Icons.history,
        ));
      }
    }

    // 7b. Statistici pentru Joker (doar pentru jocul Joker)
    if (draw.jokerNumber != null) {
      final joker = draw.jokerNumber!;
      // 1. De câte ori a aparut acest Joker în arhiva
      int jokerCount = allDraws.where((d) => d.jokerNumber == joker).length;
      insights.add(NarrativeInsight(
        text: 'Jokerul extras ($joker) a mai aparut de $jokerCount ori în arhiva.',
        type: NarrativeInsightType.info,
        icon: Icons.stars,
      ));
      // 2. Ultima apari?ie a acestui Joker
      final drawsWithJoker = allDraws.where((d) => d.jokerNumber == joker).toList();
      drawsWithJoker.sort((a, b) => b.date.compareTo(a.date));
      LotoDraw? lastJokerDraw;
      try {
        lastJokerDraw = drawsWithJoker.firstWhere((d) => d.date.isBefore(draw.date));
      } catch (_) {
        lastJokerDraw = null;
      }
      if (lastJokerDraw != null) {
        final diff = draw.date.difference(lastJokerDraw.date).inDays ~/ 7; // presupunem o extragere pe saptamâna
        final lastDateStr = '${lastJokerDraw.date.day.toString().padLeft(2, '0')}.${lastJokerDraw.date.month.toString().padLeft(2, '0')}.${lastJokerDraw.date.year}';
        insights.add(NarrativeInsight(
          text: 'Ultima apari?ie a Jokerului $joker a fost în data de $lastDateStr (acum $diff extrageri).',
          type: NarrativeInsightType.info,
          icon: Icons.history,
        ));
      }
    }

    return insights;
  }

  String getDistributionChartNarrative(List<LotoDraw> draws, int mainRange) {
    if (draws.isEmpty || mainRange <= 0) {
      return 'Nu exista suficiente date pentru a genera o narativa a distribu?iei.';
    }
    // Calculez frecven?ele numerelor pe luni
    Map<int, Map<int, int>> numberMonthData = {};
    for (LotoDraw draw in draws) {
      int month = draw.date.month;
      for (int number in draw.mainNumbers) {
        if (!numberMonthData.containsKey(number)) {
          numberMonthData[number] = {};
        }
        numberMonthData[number]![month] = (numberMonthData[number]![month] ?? 0) + 1;
      }
    }
    // Caut numarul cu cea mai mare varia?ie între luni
    int? mostSeasonalNumber;
    int maxDiff = 0;
    for (int number = 1; number <= mainRange; number++) {
      final monthFreqs = numberMonthData[number]?.values.toList() ?? [];
      if (monthFreqs.isNotEmpty) {
        int diff = (monthFreqs.reduce((a, b) => a > b ? a : b)) - (monthFreqs.reduce((a, b) => a < b ? a : b));
        if (diff > maxDiff) {
          maxDiff = diff;
          mostSeasonalNumber = number;
        }
      }
    }
    if (mostSeasonalNumber == null) {
      return 'Distribu?ia numerelor pe luni este relativ uniforma, fara varia?ii sezoniere evidente.';
    }
    // Caut luna cu cele mai multe apari?ii pentru acest numar
    final monthMap = numberMonthData[mostSeasonalNumber]!;
    int bestMonth = monthMap.entries.reduce((a, b) => a.value > b.value ? a : b).key;
    int bestMonthCount = monthMap[bestMonth]!;
    final months = ['ianuarie', 'februarie', 'martie', 'aprilie', 'mai', 'iunie', 'iulie', 'august', 'septembrie', 'octombrie', 'noiembrie', 'decembrie'];
    return 'Numarul $mostSeasonalNumber a avut cea mai mare varia?ie sezoniera, fiind extras cel mai des în luna ${months[bestMonth-1]} ($bestMonthCount ori).';
  }
} 

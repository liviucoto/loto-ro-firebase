import '../models/loto_draw.dart';
import 'dart:math';

/// Calculeaza narativa ?i frecven?a pentru graficul de frecven?a
Map<String, dynamic> calculateFrequencyAndNarrative(
  Map<String, dynamic> params,
) {
  final List<LotoDraw> draws = List<LotoDraw>.from(params['draws'] as List);
  final int mainRange = params['mainRange'] as int;
  final Map<int, int> freq = {for (var i = 1; i <= mainRange; i++) i: 0};
  for (final draw in draws) {
    for (final n in draw.mainNumbers) {
      if (n >= 1 && n <= mainRange) {
        freq[n] = (freq[n] ?? 0) + 1;
      }
    }
  }
  final maxFreq = freq.values.isNotEmpty
      ? freq.values.reduce((a, b) => a > b ? a : b)
      : 0;
  final minFreq = freq.values.isNotEmpty
      ? freq.values.reduce((a, b) => a < b ? a : b)
      : 0;
  final narrative =
      'Frecven?a calculata pentru ${draws.length} extrageri. Max: $maxFreq, Min: $minFreq.';
  return {'freq': freq, 'narrative': narrative};
}

/// Calculeaza narativa pentru graficul de suma
Map<String, dynamic> calculateSumNarrative(Map<String, dynamic> params) {
  final List draws = params['draws'] as List;
  if (draws.isEmpty) {
    return {'empty': true};
  }
  final List<double> sums = draws
      .map(
        (d) => d is LotoDraw ? d.sum.toDouble() : (d['sum'] as num).toDouble(),
      )
      .toList();
  final double avg = sums.reduce((a, b) => a + b) / sums.length;
  final double minSum = sums.reduce((a, b) => a < b ? a : b);
  final double maxSum = sums.reduce((a, b) => a > b ? a : b);
  final double range = maxSum - minSum;
  final aboveAvg = sums.where((s) => s > avg).length;
  final belowAvg = sums.where((s) => s < avg).length;
  final sortedSums = sums.toList()..sort((a, b) => b.compareTo(a));
  final top5Max = sortedSums.take(5).toList();
  final safeSkip = sortedSums.length > 5 ? sortedSums.length - 5 : 0;
  final top5Min = sortedSums.skip(safeSkip).take(5).toList();
  int maxConsecutiveAbove = 0, currentConsecutiveAbove = 0;
  int maxConsecutiveBelow = 0, currentConsecutiveBelow = 0;
  for (final sum in sums) {
    if (sum > avg) {
      currentConsecutiveAbove++;
      currentConsecutiveBelow = 0;
      if (currentConsecutiveAbove > maxConsecutiveAbove) {
        maxConsecutiveAbove = currentConsecutiveAbove;
      }
    } else if (sum < avg) {
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
      sums.map((s) => (s - avg) * (s - avg)).reduce((a, b) => a + b) /
      sums.length;
  final stdDev = sqrt(variance);
  final cv = (stdDev / avg) * 100;
  return {
    'empty': false,
    'maxSum': maxSum,
    'minSum': minSum,
    'avg': avg,
    'range': range,
    'aboveAvg': aboveAvg,
    'belowAvg': belowAvg,
    'top5Max': top5Max,
    'top5Min': top5Min,
    'maxConsecutiveAbove': maxConsecutiveAbove,
    'maxConsecutiveBelow': maxConsecutiveBelow,
    'cv': cv,
  };
}

/// Calculeaza narativa pentru graficul de interval
Map<String, dynamic> calculateIntervalNarrative(Map<String, dynamic> params) {
  final List draws = params['draws'] as List;
  final int interval = params['interval'] as int;
  if (draws.isEmpty) {
    return {'empty': true};
  }
  final List<double> sums = draws
      .map(
        (d) => d is LotoDraw ? d.sum.toDouble() : (d['sum'] as num).toDouble(),
      )
      .toList();
  final minSum = sums.reduce((a, b) => a < b ? a : b).toInt();
  final maxSum = sums.reduce((a, b) => a > b ? a : b).toInt();
  final bins = <Map<String, dynamic>>[];
  for (
    int start = (minSum ~/ interval) * interval;
    start <= maxSum;
    start += interval
  ) {
    int end = start + interval - 1;
    int freq = sums.where((s) => s >= start && s <= end).length;
    bins.add({'start': start, 'end': end, 'freq': freq});
  }
  final int totalBins = bins.length;
  final int zeroBins = bins.where((b) => (b['freq'] as int) == 0).length;
  final double avgFreqNum = bins.isNotEmpty
      ? bins.map((b) => b['freq'] as int).reduce((a, b) => a + b) / bins.length
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
  final double top3Percent = draws.isNotEmpty
      ? (top3Total / draws.length * 100)
      : 0;
  int maxGap = 0, currentGap = 0;
  for (final b in bins) {
    if ((b['freq'] as int) == 0) {
      currentGap++;
      if (currentGap > maxGap) maxGap = currentGap;
    } else {
      currentGap = 0;
    }
  }
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
  return {
    'empty': false,
    'totalBins': totalBins,
    'zeroBins': zeroBins,
    'avgFreqNum': avgFreqNum,
    'aboveAvg': aboveAvg,
    'belowAvg': belowAvg,
    'top3Percent': top3Percent,
    'maxGap': maxGap,
    'peakInterval': peakInterval,
    'minSum': minSum,
    'maxSum': maxSum,
    'interval': interval,
  };
}

/// Calculeaza narativa pentru graficul de medie
Map<String, dynamic> calculateMeanNarrative(Map<String, dynamic> params) {
  final List<LotoDraw> draws = List<LotoDraw>.from(params['draws'] as List);
  if (draws.isEmpty) {
    return {'narrative': 'Nu exista date pentru aceasta perioada.'};
  }

  final List<double> means = draws.map((d) => d.average).toList();
  final double avg = means.isNotEmpty
      ? means.reduce((a, b) => a + b) / means.length
      : 0;
  final double minMean = means.isNotEmpty
      ? means.reduce((a, b) => a < b ? a : b)
      : 0;
  final double maxMean = means.isNotEmpty
      ? means.reduce((a, b) => a > b ? a : b)
      : 0;
  final double range = maxMean - minMean;

  // Extrageri peste/sub medie
  final aboveAvg = means.where((m) => m > avg).length;
  final belowAvg = means.where((m) => m < avg).length;
  final atAvg = means.where((m) => m == avg).length;

  // Top 5 medii maxime
  final sortedMeans = means.toList()..sort((a, b) => b.compareTo(a));
  final top5Max = sortedMeans.take(5).toList();

  // Top 5 medii minime
  final safeSkip = sortedMeans.length > 5 ? sortedMeans.length - 5 : 0;
  final top5Min = sortedMeans.skip(safeSkip).take(5).toList();

  // Serii consecutive
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

  // Varia?ia (devia?ia standard)
  final variance =
      means.map((m) => (m - avg) * (m - avg)).reduce((a, b) => a + b) /
      means.length;
  final stdDev = sqrt(variance);

  // Coeficientul de varia?ie
  final cv = (stdDev / avg) * 100;

  // Stabilitatea (inversul coeficientului de varia?ie)
  final stability = 100 - cv;

  final narrative =
      '''Graficul de mai sus arata media numerelor extrase la fiecare extragere în perioada selectata.
Media maxima întâlnita este ${maxMean.toStringAsFixed(1)}, iar cea minima ${minMean.toStringAsFixed(1)}.
Media generala a tuturor extragerilor este ${avg.toStringAsFixed(2)}.
$aboveAvg extrageri au avut media peste valoarea medie, iar $belowAvg sub medie.
Cea mai lunga serie de extrageri consecutive cu media peste medie este de $maxConsecutiveAbove.
Cea mai lunga serie de extrageri consecutive cu media sub medie este de $maxConsecutiveBelow.
Stabilitatea mediei este de ${stability.toStringAsFixed(1)}%, indicând o varia?ie ${stability > 80
          ? 'foarte mica'
          : stability > 60
          ? 'moderata'
          : 'mare'}.
Amplitudinea varia?iei mediei este de ${range.toStringAsFixed(1)} unita?i.''';

  return {'narrative': narrative};
}

/// Calculeaza narativa pentru graficul de top perechi
Map<String, dynamic> calculateTopPairsNarrative(Map<String, dynamic> params) {
  final List<LotoDraw> draws = List<LotoDraw>.from(params['draws'] as List);
  final int mainRange = params['mainRange'] as int;
  if (draws.isEmpty || mainRange <= 0) {
    return {'narrative': 'Nu exista date pentru aceasta perioada.'};
  }

  // Calculez frecven?a perechilor
  final Map<String, int> pairFreq = {};
  for (final draw in draws) {
    final numbers = draw.mainNumbers
        .where((n) => n >= 1 && n <= mainRange)
        .toList();
    for (int i = 0; i < numbers.length; i++) {
      for (int j = i + 1; j < numbers.length; j++) {
        final pair = '${numbers[i]}-${numbers[j]}';
        pairFreq[pair] = (pairFreq[pair] ?? 0) + 1;
      }
    }
  }

  if (pairFreq.isEmpty) {
    return {'narrative': 'Nu exista perechi valide pentru aceasta perioada.'};
  }

  // Sortez perechile dupa frecven?a
  final sortedPairs = pairFreq.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));

  final topPairs = sortedPairs.take(20).toList();
  final maxFreq = topPairs.isNotEmpty ? topPairs.first.value : 0;
  final minFreq = topPairs.isNotEmpty ? topPairs.last.value : 0;
  final avgFreq = topPairs.isNotEmpty
      ? topPairs.map((p) => p.value).reduce((a, b) => a + b) / topPairs.length
      : 0;

  // Top 5 perechi
  final top5Pairs = topPairs.take(5).toList();

  // Perechi cu frecven?a zero (care nu au aparut)
  final totalPossiblePairs = (mainRange * (mainRange - 1)) ~/ 2;
  final appearedPairs = pairFreq.length;
  final zeroFreqPairs = totalPossiblePairs - appearedPairs;

  // Perechi peste/sub medie
  final aboveAvg = topPairs.where((p) => p.value > avgFreq).length;
  final belowAvg = topPairs.where((p) => p.value < avgFreq).length;

  // Top 3 perechi acopera câte extrageri
  final top3Total = topPairs.take(3).fold(0, (sum, p) => sum + p.value);
  final top3Percent = draws.isNotEmpty ? (top3Total / draws.length * 100) : 0;

  // Perechi consecutive (cu numere consecutive)
  int consecutivePairs = 0;
  for (final pair in topPairs) {
    final numbers = pair.key.split('-').map((n) => int.parse(n)).toList();
    if ((numbers[1] - numbers[0]) == 1) {
      consecutivePairs++;
    }
  }

  // Perechi cu numere pare/impare
  int evenEvenPairs = 0, oddOddPairs = 0, mixedPairs = 0;
  for (final pair in topPairs) {
    final numbers = pair.key.split('-').map((n) => int.parse(n)).toList();
    final firstEven = numbers[0] % 2 == 0;
    final secondEven = numbers[1] % 2 == 0;
    if (firstEven && secondEven) {
      evenEvenPairs++;
    } else if (!firstEven && !secondEven) {
      oddOddPairs++;
    } else {
      mixedPairs++;
    }
  }

  final narrative =
      '''Graficul de mai sus arata top 20 perechile de numere cele mai frecvente în extragerile analizate.
Perechea cea mai frecventa este ${top5Pairs.isNotEmpty ? top5Pairs.first.key : 'N/A'} cu ${top5Pairs.isNotEmpty ? top5Pairs.first.value : 0} apari?ii.
Top 5 perechi: ${top5Pairs.map((p) => '${p.key} (${p.value})').join(', ')}.
$aboveAvg perechi au frecven?a peste medie, $belowAvg sub medie (media: ${avgFreq.toStringAsFixed(1)} apari?ii).
Top 3 perechi acopera ${top3Percent.toStringAsFixed(1)}% din totalul extragerilor.
$consecutivePairs perechi din top 20 con?in numere consecutive.
Distribu?ia pe tipuri: $evenEvenPairs perechi pare-pare, $oddOddPairs perechi impare-impare, $mixedPairs perechi mixte.
Din $totalPossiblePairs perechi posibile, $appearedPairs au aparut cel pu?in o data, iar $zeroFreqPairs nu au aparut deloc.
Frecven?a minima în top 20: $minFreq, maxima: $maxFreq, media generala: ${avgFreq.toStringAsFixed(1)} apari?ii per pereche.''';

  return {'narrative': narrative};
}

/// Narativa pentru decade
Map<String, dynamic> calculateDecadeNarrative(Map<String, dynamic> params) {
  final List draws = params['draws'] as List;
  final int mainRange = params['mainRange'] as int;
  if (draws.isEmpty || mainRange <= 0) {
    return {'narrative': '', 'empty': true};
  }
  // Construiesc decadele: 1-10, 11-20, ...
  final List<String> decadeLabels = [];
  final List<List<int>> decadeRanges = [];
  for (int start = 1; start <= mainRange; start += 10) {
    int end = start + 9;
    if (end > mainRange) end = mainRange;
    decadeLabels.add('$start-$end');
    decadeRanges.add([start, end]);
  }
  // Calculez frecven?a pe decade
  final List<int> decadeFreq = List.filled(decadeLabels.length, 0);
  for (final draw in draws) {
    for (final n in draw.mainNumbers) {
      for (int i = 0; i < decadeRanges.length; i++) {
        if (n >= decadeRanges[i][0] && n <= decadeRanges[i][1]) {
          decadeFreq[i]++;
          break;
        }
      }
    }
  }
  final maxFreq = decadeFreq.reduce((a, b) => a > b ? a : b);
  final minFreq = decadeFreq.reduce((a, b) => a < b ? a : b);
  final avgFreq = decadeFreq.reduce((a, b) => a + b) / decadeFreq.length;
  final maxIdx = decadeFreq.indexOf(maxFreq);
  final minIdx = decadeFreq.indexOf(minFreq);
  final top3 = List.generate(
    decadeFreq.length,
    (i) => {'label': decadeLabels[i], 'freq': decadeFreq[i]},
  )..sort((a, b) => (b['freq'] as int).compareTo(a['freq'] as int));
  final top3Labels = top3
      .take(3)
      .map((e) => '${e['label']} (${e['freq']})')
      .join(', ');
  final total = decadeFreq.reduce((a, b) => a + b);
  final aboveAvg = decadeFreq.where((f) => f > avgFreq).length;
  final belowAvg = decadeFreq.where((f) => f < avgFreq).length;
  final range = maxFreq - minFreq;
  final narrative =
      '''
<b>Distribu?ia pe decade:</b>

?? Decada cu cele mai multe apari?ii: <b>${decadeLabels[maxIdx]}</b> ($maxFreq apari?ii)
?? Decada cu cele mai pu?ine apari?ii: <b>${decadeLabels[minIdx]}</b> ($minFreq apari?ii)
?? Top 3 decade: $top3Labels
?? Media apari?iilor pe decada: <b>${avgFreq.toStringAsFixed(2)}</b>
''';
  return {
    'narrative': narrative,
    'maxIdx': maxIdx,
    'minIdx': minIdx,
    'maxFreq': maxFreq,
    'minFreq': minFreq,
    'avgFreq': avgFreq,
    'top3': top3.take(3).toList(),
    'decadeLabels': decadeLabels,
    'decadeFreq': decadeFreq,
    'total': total,
    'aboveAvg': aboveAvg,
    'belowAvg': belowAvg,
    'range': range,
    'empty': false,
  };
}

Map<String, dynamic> calculateEvenOddNarrative(Map<String, dynamic> params) {
  final List draws = params['draws'] as List;
  if (draws.isEmpty) {
    return {'narrative': '', 'empty': true};
  }
  final nNumbers = draws.first.mainNumbers.length;
  final Map<int, int> evenCountDist = {
    for (int i = 0; i <= nNumbers; i++) i: 0,
  };
  int totalEven = 0, totalOdd = 0;
  for (final draw in draws) {
    int even = draw.mainNumbers.where((n) => n % 2 == 0).length;
    int odd = nNumbers - even;
    evenCountDist[even] = (evenCountDist[even] ?? 0) + 1;
    totalEven += even;
    totalOdd += odd;
  }
  final totalDraws = draws.length;
  final maxFreq = evenCountDist.values.reduce((a, b) => a > b ? a : b);
  final minFreq = evenCountDist.values.reduce((a, b) => a < b ? a : b);
  final maxIdx = evenCountDist.entries
      .firstWhere((e) => e.value == maxFreq)
      .key;
  final minIdx = evenCountDist.entries
      .firstWhere((e) => e.value == minFreq)
      .key;
  percent(int v) => totalDraws > 0 ? (v / totalDraws * 100) : 0;
  final List<Map<String, dynamic>> distList = [
    for (int i = 0; i <= nNumbers; i++)
      {
        'even': i,
        'odd': nNumbers - i,
        'count': evenCountDist[i],
        'percent': percent(evenCountDist[i] ?? 0),
      },
  ];
  final narrative = '';
  return {
    'narrative': narrative,
    'totalEven': totalEven,
    'totalOdd': totalOdd,
    'evenCountDist': evenCountDist,
    'distList': distList,
    'maxIdx': maxIdx,
    'minIdx': minIdx,
    'maxFreq': maxFreq,
    'minFreq': minFreq,
    'totalDraws': totalDraws,
    'nNumbers': nNumbers,
    'empty': false,
  };
}

/// Calculeaza narativa pentru graficul temporal
Map<String, dynamic> calculateTemporalNarrative(Map<String, dynamic> params) {
  final List draws = params['draws'] as List;
  if (draws.isEmpty) {
    return {'empty': true};
  }
  final numbers = draws
      .expand(
        (d) => d is LotoDraw ? d.mainNumbers : (d['mainNumbers'] as List<int>),
      )
      .toList();
  final freq = <int, int>{};
  for (var n in numbers) {
    freq[n] = (freq[n] ?? 0) + 1;
  }
  final sorted = freq.entries.toList()
    ..sort((a, b) => b.value.compareTo(a.value));
  final topNumbers = sorted.take(5).map((e) => e.key).toList();
  final topFreqs = sorted.take(5).map((e) => e.value).toList();
  final totalDraws = draws.length;
  final maxFreq = sorted.isNotEmpty ? sorted.first.value : 0;
  final minFreq = sorted.isNotEmpty ? sorted.last.value : 0;
  final avgFreq = freq.isNotEmpty
      ? freq.values.reduce((a, b) => a + b) / freq.length
      : 0;
  final variance = freq.values.isNotEmpty
      ? freq.values
                .map((f) => (f - avgFreq) * (f - avgFreq))
                .reduce((a, b) => a + b) /
            freq.length
      : 0;
  final stdDev = sqrt(variance);
  final cv = avgFreq > 0 ? (stdDev / avgFreq) * 100 : 0;
  final mostStable = sorted
      .where(
        (e) =>
            (e.value - avgFreq).abs() ==
            (sorted
                .map((e) => (e.value - avgFreq).abs())
                .reduce((a, b) => a < b ? a : b)),
      )
      .map((e) => e.key)
      .toList();
  final mostUnstable = sorted
      .where(
        (e) =>
            (e.value - avgFreq).abs() ==
            (sorted
                .map((e) => (e.value - avgFreq).abs())
                .reduce((a, b) => a > b ? a : b)),
      )
      .map((e) => e.key)
      .toList();
  // Explica?ii simple pentru fiecare insight
  return {
    'empty': false,
    'totalDraws': totalDraws,
    'topNumbers': topNumbers,
    'topFreqs': topFreqs,
    'maxFreq': maxFreq,
    'minFreq': minFreq,
    'avgFreq': avgFreq,
    'cv': cv,
    'mostStable': mostStable,
    'mostUnstable': mostUnstable,
    // Explica?ii pentru UI
    'explain_top':
        'Cele mai extrase 5 numere în aceasta perioada ?i de câte ori au aparut.',
    'explain_freq':
        'Cât de des a aparut cel mai norocos ?i cel mai ghinionist numar, plus media pentru toate.',
    'explain_cv':
        'Cât de mult variaza apari?iile numerelor fa?a de media generala (cu cât e mai mic procentul, cu atât mai "echilibrata" a fost perioada).',
    'explain_stable':
        'Numerele care au aparut aproape la fel de des ca media (cele mai "constante").',
    'explain_unstable':
        'Numerele care s-au abatut cel mai mult de la medie (cele mai "imprevizibile").',
  };
}

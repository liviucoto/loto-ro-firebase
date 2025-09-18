import 'package:flutter/material.dart';

/// Componentă pentru narativa de frecvență
class FrequencyNarrative extends StatelessWidget {
  final String? narrative;
  final Map<int, int>? freq;
  final int mainRange;

  const FrequencyNarrative({
    super.key,
    required this.narrative,
    required this.freq,
    required this.mainRange,
  });

  @override
  Widget build(BuildContext context) {
    if (freq == null || freq!.isEmpty) {
      return const SizedBox.shrink();
    }

    final values = freq!.values.toList();
    final maxFreq = values.reduce((a, b) => a > b ? a : b);
    final minFreq = values.reduce((a, b) => a < b ? a : b);
    final avgFreq = values.reduce((a, b) => a + b) / values.length;
    final sortedFreq = freq!.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));
    final top5Frequent = sortedFreq.take(5).toList();
    final safeSkip = sortedFreq.length > 5 ? sortedFreq.length - 5 : 0;
    final top5Rare = sortedFreq.skip(safeSkip).take(5).toList();
    final aboveAvg = values.where((f) => f > avgFreq).length;
    final belowAvg = values.where((f) => f < avgFreq).length;
    final zeroFreq = values.where((f) => f == 0).length;
    final top3Total = top5Frequent.take(3).fold(0, (sum, e) => sum + e.value);
    final top3Percent = values.isNotEmpty
        ? (top3Total / values.reduce((a, b) => a + b) * 100)
        : 0;

    int maxGap = 0, currentGap = 0;
    for (int i = 1; i <= mainRange; i++) {
      if ((freq![i] ?? 0) == 0) {
        currentGap++;
        if (currentGap > maxGap) maxGap = currentGap;
      } else {
        currentGap = 0;
      }
    }

    int longestStreak = 0, currentStreak = 0;
    int? lastFreq;
    for (final entry in sortedFreq) {
      if (lastFreq != null && entry.value == lastFreq) {
        currentStreak++;
        if (currentStreak > longestStreak) longestStreak = currentStreak;
      } else {
        currentStreak = 1;
        lastFreq = entry.value;
      }
    }

    final neverDrawn = freq!.entries
        .where((e) => e.value == 0)
        .map((e) => e.key)
        .toList();

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.green[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Graficul de mai sus arată frecvența apariției fiecărui număr în extragerile analizate. Fiecare bară reprezintă de câte ori a apărut un număr.',
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
            Icon(Icons.star, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Top 5 cele mai frecvente numere: ${top5Frequent.map((e) => "${e.key} (${e.value})").join(", ")}.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.ac_unit, color: Colors.red, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Top 5 cele mai rare numere: ${top5Rare.map((e) => "${e.key} (${e.value})").join(", ")}.',
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
                '$aboveAvg numere au frecvență peste medie, $belowAvg sub medie (media: ${avgFreq.toStringAsFixed(1)} apariții).',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.block, color: Colors.purple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                '$zeroFreq numere nu au fost extrase niciodată în această perioadă.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        if (neverDrawn.isNotEmpty)
          Row(
            children: [
              Icon(Icons.cancel, color: Colors.red, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Numerele care nu au apărut: ${neverDrawn.join(", ")}.',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.star, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Top 3 numere acoperă ${top3Percent.toStringAsFixed(1)}% din totalul aparițiilor.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        if (maxGap > 0)
          Row(
            children: [
              Icon(Icons.horizontal_rule, color: Colors.indigo, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Cel mai lung șir de numere consecutive neextrase: $maxGap.',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.timeline, color: Colors.purple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cea mai lungă serie de frecvențe egale consecutive: $longestStreak.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.green[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Frecvența minimă: $minFreq, maximă: $maxFreq, media generală: ${avgFreq.toStringAsFixed(1)} apariții per număr.',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

import 'package:flutter/material.dart';

/// Widget pentru afișarea narativei pentru graficul de decade
class DecadeNarrative extends StatelessWidget {
  final Map<String, dynamic>? narrative;
  final bool isDesktop;

  const DecadeNarrative({
    super.key,
    required this.narrative,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    if (narrative == null || narrative!.isEmpty) {
      return const SizedBox.shrink();
    }
    final mostFreq = narrative!['mostFrequentDecade'] ?? '-';
    final leastFreq = narrative!['leastFrequentDecade'] ?? '-';
    final distributionType = narrative!['distributionType'] ?? '-';
    final aboveAvg = narrative!['aboveAvg'] ?? '-';
    final emptyDecades = narrative!['emptyDecades'] ?? '-';
    final maxConsecutive = narrative!['maxConsecutive'] ?? '-';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.indigo[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Graficul de mai sus arată distribuția numerelor pe decade (grupuri de 10).',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.orange[700], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Decada cea mai frecventă: $mostFreq.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.ac_unit, color: Colors.red[400], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Decada cea mai rară: $leastFreq.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.show_chart, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Decade peste medie: $aboveAvg.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.not_interested, color: Colors.grey[700], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Decade fără apariții: $emptyDecades.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.timeline, color: Colors.purple[700], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cea mai lungă serie de decade dominante: $maxConsecutive.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.balance, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Distribuția este $distributionType între decade.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                mostFreq != '-' ? 'Decada dominantă: $mostFreq' : '-',
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

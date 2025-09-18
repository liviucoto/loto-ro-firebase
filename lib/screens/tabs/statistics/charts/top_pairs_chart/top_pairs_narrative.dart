import 'package:flutter/material.dart';

/// Widget pentru afișarea narativei pentru graficul de top perechi
class TopPairsNarrative extends StatelessWidget {
  final String? narrative;
  final bool isDesktop;

  const TopPairsNarrative({
    super.key,
    required this.narrative,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    if (narrative == null || narrative!.isEmpty) {
      return const SizedBox.shrink();
    }
    // Parsez narativa: aștept formatul "Top 5 perechi: 1-2 (8x), ...\nMax: 8, Min: 1, Peste medie: 3, O singură apariție: 2"
    final List<String> lines = narrative!.split('\n');
    String top5 = lines.isNotEmpty ? lines[0] : '';
    String maxLine = lines.length > 1 ? lines[1] : '';
    String minLine = lines.length > 2 ? lines[2] : '';
    String aboveAvgLine = lines.length > 3 ? lines[3] : '';
    String singleLine = lines.length > 4 ? lines[4] : '';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.purple[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Graficul de mai sus arată cele mai frecvente perechi de numere extrase împreună.',
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
                top5.isNotEmpty
                    ? top5
                    : 'Nu există suficiente date pentru top 5 perechi.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        if (maxLine.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.trending_up, color: Colors.green, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(maxLine, style: const TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ],
        if (minLine.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.trending_down, color: Colors.red, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(minLine, style: const TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ],
        if (aboveAvgLine.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.show_chart, color: Colors.blue, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(aboveAvgLine, style: const TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ],
        if (singleLine.isNotEmpty) ...[
          const SizedBox(height: 8),
          Row(
            children: [
              Icon(Icons.filter_1, color: Colors.grey[700], size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(singleLine, style: const TextStyle(fontSize: 13)),
              ),
            ],
          ),
        ],
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.amber[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                top5.isNotEmpty
                    ? 'Cea mai frecventă pereche: ${top5.split(",").firstOrNull ?? "-"}'
                    : '-',
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

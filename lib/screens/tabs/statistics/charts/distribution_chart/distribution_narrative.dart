import 'package:flutter/material.dart';
import 'package:loto_ro/models/loto_draw.dart';

/// Widget pentru afișarea narativei pentru graficul de distribuție
class DistributionNarrative extends StatelessWidget {
  final Map<String, dynamic>? narrative;
  final bool isDesktop;
  final String? segment;
  final List<int> Function(LotoDraw draw)? getNumbers;

  const DistributionNarrative({
    super.key,
    required this.narrative,
    required this.isDesktop,
    this.segment,
    this.getNumbers,
  });

  @override
  Widget build(BuildContext context) {
    if (narrative == null || narrative!.isEmpty) {
      return const SizedBox.shrink();
    }
    final fontSize = isDesktop ? 13.0 : 10.0;
    final seg = segment ?? 'Luni';
    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: fontSize,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        child: _buildNarrativeWidget(narrative!, seg, fontSize),
      ),
    );
  }

  Widget _buildNarrativeWidget(
    Map<String, dynamic> narrative,
    String segment,
    double fontSize,
  ) {
    final top5 = narrative['top5'] ?? [];
    final top5Freqs = narrative['top5Freqs'] ?? [];
    final volatility = narrative['volatility'] ?? 0;
    final mostStable = narrative['mostStable'] ?? '-';
    final mostUnstable = narrative['mostUnstable'] ?? '-';
    final example = narrative['example'] ?? '';
    final maxSegment = narrative['maxSegment'] ?? '-';
    final minSegment = narrative['minSegment'] ?? '-';
    final maxSegmentVal = narrative['maxSegmentVal'] ?? '-';
    final minSegmentVal = narrative['minSegmentVal'] ?? '-';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.analytics, color: Colors.deepOrange[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                segment == 'Luni'
                    ? 'Tabelul arată de câte ori a fost extras fiecare număr în fiecare lună.'
                    : 'Tabelul arată de câte ori a fost extras fiecare număr în fiecare sezon.',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 10),
        Row(
          children: [
            Icon(Icons.emoji_events, color: Colors.green, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cele mai norocoase 5 numere au fost: ${top5.isNotEmpty ? top5.join(", ") : "-"}.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.repeat, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                segment == 'Luni'
                    ? 'Numărul care a apărut aproape la fel de des în toate lunile este: $mostStable.'
                    : 'Numărul care a apărut aproape la fel de des în toate sezoanele este: $mostStable.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.casino, color: Colors.purple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                segment == 'Luni'
                    ? 'Numărul care a avut noroc doar în unele luni, dar nu și în altele, este: $mostUnstable.'
                    : 'Numărul care a avut noroc doar în unele sezoane, dar nu și în altele, este: $mostUnstable.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.star, color: Colors.amber, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                segment == 'Luni'
                    ? 'Cea mai norocoasă lună a fost $maxSegment, cu $maxSegmentVal extrageri.'
                    : 'Cel mai norocos sezon a fost $maxSegment, cu $maxSegmentVal extrageri.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.cloud, color: Colors.blueGrey, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                segment == 'Luni'
                    ? 'Cea mai puțin norocoasă lună a fost $minSegment, cu doar $minSegmentVal extrageri.'
                    : 'Cel mai puțin norocos sezon a fost $minSegment, cu doar $minSegmentVal extrageri.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        if (example != null && example != '') ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.lightbulb, color: Colors.amber, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(example, style: TextStyle(fontSize: fontSize)),
              ),
            ],
          ),
        ],
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.teal, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                segment == 'Luni'
                    ? 'În unele luni au fost extrase mai multe numere, în altele mai puține.'
                    : 'În unele sezoane au fost extrase mai multe numere, în altele mai puține.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

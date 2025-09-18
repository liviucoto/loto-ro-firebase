import 'package:flutter/material.dart';

/// Componentă pentru narativa de interval
class IntervalNarrative extends StatelessWidget {
  final Map<String, dynamic>? data;

  const IntervalNarrative({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null || data!['empty'] == true) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.green[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Graficul de mai sus împarte sumele extragerilor în intervale de ${data!['interval']} și arată câte extrageri se încadrează în fiecare interval. Fiecare bară reprezintă un interval de sumă.',
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
            Icon(Icons.block, color: Colors.red[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Din ${data!['totalBins']} intervale, ${data!['zeroBins']} nu au avut nicio extragere (frecvență zero). Acest lucru indică zone de sumă care nu au apărut deloc în perioada analizată.',
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
                '${data!['aboveAvg']} intervale au avut frecvență peste medie, iar ${data!['belowAvg']} sub medie (media: ${(data!['avgFreqNum'] != null ? data!['avgFreqNum'].toStringAsFixed(2) : '-')} extrageri/interval). Acest raport arată distribuția extragerilor față de medie.',
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
                'Top 3 intervale acoperă ${(data!['top3Percent'] != null ? data!['top3Percent'].toStringAsFixed(1) : '-')}% din totalul extragerilor, evidențiind zonele cele mai "populate".',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.horizontal_rule, color: Colors.purple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cel mai lung șir de intervale consecutive fără extrageri este de ${data!['maxGap']}. Acest lucru poate indica "găuri" în distribuția sumelor.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        if (data!['peakInterval'] != null && data!['peakInterval'] != '') ...[
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.show_chart, color: Colors.teal, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Intervalul cu cea mai mare diferență față de vecini este ${data!['peakInterval']}, sugerând o variație bruscă în frecvență.',
                  style: const TextStyle(fontSize: 13),
                ),
              ),
            ],
          ),
        ],
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.arrow_downward, color: Colors.red, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cea mai mică sumă întâlnită într-un interval este ${data!['minSum']}. Aceasta reprezintă limita inferioară a sumelor extrase în perioada analizată.',
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
            Icon(Icons.arrow_upward, color: Colors.green, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cea mai mare sumă întâlnită într-un interval este ${data!['maxSum']}. Aceasta reprezintă limita superioară a sumelor extrase.',
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
            Icon(Icons.straighten, color: Colors.amber[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Analiza a fost realizată folosind intervale de ${data!['interval']}, ceea ce influențează gradul de detaliu al graficului.',
                style: const TextStyle(
                  fontWeight: FontWeight.bold,
                  fontSize: 13,
                ),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
      ],
    );
  }
}

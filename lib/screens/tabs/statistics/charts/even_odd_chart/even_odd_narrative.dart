import 'package:flutter/material.dart';

/// Widget pentru afișarea narativei pentru graficul de par/impar
class EvenOddNarrative extends StatelessWidget {
  final Map<String, dynamic>? narrative;
  final bool isDesktop;

  const EvenOddNarrative({
    super.key,
    required this.narrative,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    if (narrative == null || narrative!.isEmpty) {
      return const SizedBox.shrink();
    }
    final evenCount = narrative!['evenCount'] ?? '-';
    final evenPercentage = narrative!['evenPercentage'] ?? '-';
    final oddCount = narrative!['oddCount'] ?? '-';
    final oddPercentage = narrative!['oddPercentage'] ?? '-';
    final balanceType = narrative!['balanceType'] ?? '-';
    final absDiff = narrative!['absDiff'] ?? '-';
    final maxConsecutive = narrative!['maxConsecutive'] ?? '-';
    final maxPct = narrative!['maxPct'] ?? '-';
    final minPct = narrative!['minPct'] ?? '-';
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.teal[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Graficul de mai sus arată echilibrul între numerele pare și impare extrase.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.blue[700], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Numere pare: $evenCount ($evenPercentage%).',
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
                'Numere impare: $oddCount ($oddPercentage%).',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.compare_arrows, color: Colors.deepPurple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Diferență absolută pare/impare: $absDiff.',
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
                'Cea mai lungă serie de pare/impare consecutive: $maxConsecutive.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.percent, color: Colors.green[700], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Procent maxim: $maxPct%, minim: $minPct%.',
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
                'Echilibrul este $balanceType între pare și impare.',
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
                balanceType != '-' ? 'Echilibru general: $balanceType' : '-',
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

/// Widget pentru afișarea narativei pentru graficul Joker par/impar
class JokerEvenOddNarrative extends StatelessWidget {
  final Map<String, dynamic>? narrative;
  final bool isDesktop;

  const JokerEvenOddNarrative({
    super.key,
    required this.narrative,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    if (narrative == null || narrative!.isEmpty) {
      return const SizedBox.shrink();
    }
    final jokerEvenCount = narrative!['jokerEvenCount'] ?? '-';
    final jokerEvenPercentage = narrative!['jokerEvenPercentage'] ?? '-';
    final jokerOddCount = narrative!['jokerOddCount'] ?? '-';
    final jokerOddPercentage = narrative!['jokerOddPercentage'] ?? '-';
    final jokerBalanceType = narrative!['jokerBalanceType'] ?? '-';
    final jokerAbsDiff = narrative!['jokerAbsDiff'] ?? '-';
    final jokerMaxConsecutive = narrative!['jokerMaxConsecutive'] ?? '-';
    final jokerTotalDraws = narrative!['jokerTotalDraws'] ?? '-';
    final jokerDominance = narrative!['jokerDominance'] ?? '-';

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.casino, color: Colors.orange[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Graficul Joker arată echilibrul între numerele pare și impare pentru numărul Joker.',
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.star, color: Colors.blue[700], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Joker pare: $jokerEvenCount ($jokerEvenPercentage%).',
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
                'Joker impare: $jokerOddCount ($jokerOddPercentage%).',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.compare_arrows, color: Colors.deepPurple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Diferență absolută Joker pare/impare: $jokerAbsDiff.',
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
                'Cea mai lungă serie Joker pare/impare consecutive: $jokerMaxConsecutive.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.analytics, color: Colors.green[700], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Total extrageri cu Joker: $jokerTotalDraws.',
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
                'Echilibrul Joker este $jokerBalanceType între pare și impare.',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 8),
        Row(
          children: [
            Icon(Icons.trending_up, color: Colors.amber[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                jokerDominance != '-'
                    ? 'Dominanță Joker: $jokerDominance'
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

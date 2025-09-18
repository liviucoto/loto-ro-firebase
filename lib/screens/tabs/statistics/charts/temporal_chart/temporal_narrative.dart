import 'package:flutter/material.dart';

/// Widget pentru afișarea narativei pentru graficul temporal
class TemporalNarrative extends StatelessWidget {
  final Map<String, dynamic>? narrative;
  final bool isDesktop;

  const TemporalNarrative({
    super.key,
    required this.narrative,
    required this.isDesktop,
  });

  @override
  Widget build(BuildContext context) {
    if (narrative == null || narrative!.isEmpty) {
      return const SizedBox.shrink();
    }

    return AnimatedSwitcher(
      duration: const Duration(milliseconds: 700),
      child: DefaultTextStyle(
        style: TextStyle(
          fontSize: isDesktop ? 13.0 : 10.0,
          color: Colors.black87,
          fontWeight: FontWeight.w500,
        ),
        child: _buildNarrativeWidget(narrative!),
      ),
    );
  }

  Widget _buildNarrativeWidget(Map<String, dynamic> narrative) {
    String formatList(List l) => l.isEmpty ? '-' : l.join(', ');
    final fontSize = isDesktop ? 13.0 : 10.0;

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        // Secțiunea principală
        Row(
          children: [
            Icon(Icons.timeline, color: Colors.orange[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Acest grafic arată cum s-au schimbat în timp cele mai variabile numere extrase. Fiecare linie reprezintă un număr care a avut fluctuații mari sau mici de la o perioadă la alta.',
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
            Icon(Icons.trending_up, color: Colors.green, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Top 3 numere cu cele mai mari fluctuații (au apărut foarte des în unele perioade și rar în altele): ${formatList(narrative['top3Variable'] ?? [])}.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.trending_down, color: Colors.red, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Top 3 numere stabile (au avut apariții constante, fără variații mari): ${formatList(narrative['top3Stable'] ?? [])}.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.analytics, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Gradul de variabilitate arată cât de mult s-au schimbat aparițiile numerelor de la o perioadă la alta. Pentru acest interval: ${narrative['temporalPattern'] ?? "-"}.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.calendar_today, color: Colors.purple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Perioada cu cele mai multe extrageri (sau cu cele mai multe apariții de numere): ${narrative['mostFrequentPeriod'] ?? "-"}.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.calendar_today_outlined, color: Colors.brown, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Perioada cu cele mai puține extrageri (sau cu cele mai puține apariții de numere): ${narrative['leastFrequentPeriod'] ?? "-"}.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.show_chart, color: Colors.teal, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Trendul general arată dacă, în acest interval, numerele au apărut mai des spre final sau la început. Rezultat: ${narrative['trend'] ?? "-"}.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.wb_sunny, color: Colors.amber, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Anotimpul cu cele mai multe extrageri sau apariții de numere este: ${narrative['dominantSeason'] ?? "-"}.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.format_list_numbered, color: Colors.blueGrey, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Total extrageri analizate: ${narrative['drawCount'] ?? "-"}, perioade: ${narrative['periodCount'] ?? "-"}, numere diferite analizate: ${narrative['numberCount'] ?? "-"}.',
                style: TextStyle(fontSize: fontSize),
              ),
            ),
          ],
        ),
        // Secțiunea Joker, dacă există date Joker
        if ((narrative['jokerDrawCount'] ?? 0) > 0) ...[
          const SizedBox(height: 18),
          Row(
            children: [
              Icon(Icons.casino, color: Colors.deepPurple, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Analiză pentru numerele Joker (numere extrase separat la Joker):',
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
              Icon(Icons.trending_up, color: Colors.green, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Top 3 Joker cu cele mai mari fluctuații: ${formatList(narrative['jokerTop3Variable'] ?? [])}.',
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.trending_down, color: Colors.red, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Top 3 Joker stabile: ${formatList(narrative['jokerTop3Stable'] ?? [])}.',
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.analytics, color: Colors.blue, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Gradul de variabilitate Joker: ${narrative['jokerTemporalPattern'] ?? "-"}.',
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.calendar_today, color: Colors.purple, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Perioada cu cele mai multe Joker: ${narrative['jokerMostFrequentPeriod'] ?? "-"}.',
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.calendar_today_outlined,
                color: Colors.brown,
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Perioada cu cele mai puține Joker: ${narrative['jokerLeastFrequentPeriod'] ?? "-"}.',
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.show_chart, color: Colors.teal, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Trend Joker: ${narrative['jokerTrend'] ?? "-"}.',
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(Icons.wb_sunny, color: Colors.amber, size: 18),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Anotimpul cu cele mai multe Joker: ${narrative['jokerDominantSeason'] ?? "-"}.',
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ],
          ),
          const SizedBox(height: 6),
          Row(
            children: [
              Icon(
                Icons.format_list_numbered,
                color: Colors.blueGrey,
                size: 18,
              ),
              const SizedBox(width: 6),
              Expanded(
                child: Text(
                  'Total Joker analizate: ${narrative['jokerDrawCount'] ?? "-"}, perioade: ${narrative['jokerPeriodCount'] ?? "-"}, numere Joker diferite: ${narrative['jokerNumberCount'] ?? "-"}.',
                  style: TextStyle(fontSize: fontSize),
                ),
              ),
            ],
          ),
        ],
      ],
    );
  }
}

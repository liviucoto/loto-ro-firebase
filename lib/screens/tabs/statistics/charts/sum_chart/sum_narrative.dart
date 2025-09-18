import 'package:flutter/material.dart';

/// Componentă pentru narativa de sumă
class SumNarrative extends StatelessWidget {
  final Map<String, dynamic>? data;

  const SumNarrative({super.key, required this.data});

  @override
  Widget build(BuildContext context) {
    if (data == null || data!['empty'] == true) {
      return const SizedBox.shrink();
    }

    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.bar_chart, color: Colors.green[800], size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Graficul de mai sus arată distribuția sumelor extrase la fiecare tragere.',
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
            Icon(Icons.format_list_numbered, color: Colors.blue, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Număr total de extrageri: ${data!['count'] ?? '-'}',
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
                'Top 5 cele mai mari sume: ${data!['top5Max']?.join(", ") ?? "-"}',
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
                'Top 5 cele mai mici sume: ${data!['top5Min']?.join(", ") ?? "-"}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.arrow_downward, color: Colors.red, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cea mai mică sumă întâlnită: ${data!['minSum']?.toInt() ?? "-"}',
                style: const TextStyle(fontSize: 13),
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
                'Cea mai mare sumă întâlnită: ${data!['maxSum']?.toInt() ?? "-"}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.functions, color: Colors.teal, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Suma medie a tuturor extragerilor: ${data!['avg']?.toStringAsFixed(2) ?? "-"}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.stacked_line_chart, color: Colors.purple, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Deviația standard a sumelor: ${data!['cv'] != null ? "${(data!['cv'] as double).toStringAsFixed(2)}%" : "-"}',
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
                'Număr extrageri peste medie: ${data!['aboveAvg'] ?? "-"}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(Icons.trending_down, color: Colors.orange, size: 18),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Număr extrageri sub medie: ${data!['belowAvg'] ?? "-"}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
        const SizedBox(height: 6),
        Row(
          children: [
            Icon(
              Icons.format_list_numbered_rtl,
              color: Colors.indigo,
              size: 18,
            ),
            const SizedBox(width: 6),
            Expanded(
              child: Text(
                'Cea mai lungă serie de extrageri peste medie: ${data!['maxConsecutiveAbove'] ?? "-"}, sub medie: ${data!['maxConsecutiveBelow'] ?? "-"}',
                style: const TextStyle(fontSize: 13),
              ),
            ),
          ],
        ),
      ],
    );
  }
}

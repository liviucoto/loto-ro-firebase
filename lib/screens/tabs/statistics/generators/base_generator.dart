import 'package:flutter/material.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';

/// Clasă de bază pentru toate generatoarele de variante de joc
abstract class BaseGenerator {
  final GameType gameType;
  final List<LotoDraw> draws;

  const BaseGenerator({required this.gameType, required this.draws});

  /// Generează variante de joc bazate pe analiza datelor
  List<List<int>> generateVariants({
    int count = 5,
    Map<String, dynamic>? options,
  });

  /// Returnează descrierea strategiei de generare
  String getStrategyDescription();

  /// Returnează iconița pentru tipul de generator
  IconData getIcon();

  /// Returnează culoarea pentru tipul de generator
  Color getColor();

  /// Validează dacă generatorul poate funcționa cu datele disponibile
  bool canGenerate() {
    return draws.isNotEmpty;
  }

  /// Returnează numărul de numere care trebuie extrase pentru acest joc
  int getNumbersToExtract() {
    final config = AppGameTypes.gameConfigs[gameType.csvName];
    return config?['mainNumbers'] as int? ?? 6;
  }

  /// Returnează intervalul de numere pentru acest joc
  int getNumberRange() {
    final config = AppGameTypes.gameConfigs[gameType.csvName];
    return config?['mainRange'] as int? ?? 49;
  }
}

/// Generator bazat pe frecvență
class FrequencyBasedGenerator extends BaseGenerator {
  const FrequencyBasedGenerator({
    required super.gameType,
    required super.draws,
  });

  @override
  List<List<int>> generateVariants({
    int count = 5,
    Map<String, dynamic>? options,
  }) {
    if (!canGenerate()) return [];

    // Calculează frecvențele
    final Map<int, int> frequencies = {};
    final int range = getNumberRange();

    for (int i = 1; i <= range; i++) {
      frequencies[i] = 0;
    }

    for (final draw in draws) {
      for (final number in draw.mainNumbers) {
        frequencies[number] = (frequencies[number] ?? 0) + 1;
      }
    }

    // Sortează numerele după frecvență
    final sortedNumbers = frequencies.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    final List<List<int>> variants = [];
    final int numbersToExtract = getNumbersToExtract();

    for (int i = 0; i < count; i++) {
      final List<int> variant = [];
      final List<MapEntry<int, int>> availableNumbers = List.from(
        sortedNumbers,
      );

      // Adaugă numere cu frecvență mare
      for (int j = 0; j < numbersToExtract ~/ 2; j++) {
        if (availableNumbers.isNotEmpty) {
          variant.add(availableNumbers.removeAt(0).key);
        }
      }

      // Adaugă numere cu frecvență medie
      final midIndex = availableNumbers.length ~/ 2;
      for (
        int j = 0;
        j < numbersToExtract - variant.length && j < availableNumbers.length;
        j++
      ) {
        variant.add(availableNumbers[midIndex + j].key);
      }

      // Completează cu numere aleatorii dacă e necesar
      while (variant.length < numbersToExtract) {
        final randomIndex =
            (DateTime.now().millisecondsSinceEpoch + i) %
            availableNumbers.length;
        final number = availableNumbers[randomIndex].key;
        if (!variant.contains(number)) {
          variant.add(number);
        }
      }

      variant.sort();
      variants.add(variant);
    }

    return variants;
  }

  @override
  String getStrategyDescription() {
    return 'Generează variante bazate pe frecvența apariției numerelor în extragerile anterioare. Combină numere frecvente cu numere de frecvență medie pentru echilibru.';
  }

  @override
  IconData getIcon() => Icons.bar_chart;

  @override
  Color getColor() => Colors.blue;
}

/// Generator bazat pe pattern-uri
class PatternBasedGenerator extends BaseGenerator {
  const PatternBasedGenerator({required super.gameType, required super.draws});

  @override
  List<List<int>> generateVariants({
    int count = 5,
    Map<String, dynamic>? options,
  }) {
    if (!canGenerate()) return [];

    final List<List<int>> variants = [];
    final int numbersToExtract = getNumbersToExtract();
    final int range = getNumberRange();

    for (int i = 0; i < count; i++) {
      final List<int> variant = [];

      // Generează variante cu pattern-uri diferite
      switch (i % 4) {
        case 0: // Pare și impare echilibrate
          final evens = <int>[];
          final odds = <int>[];
          for (int j = 1; j <= range; j++) {
            if (j % 2 == 0) {
              evens.add(j);
            } else {
              odds.add(j);
            }
          }
          evens.shuffle();
          odds.shuffle();

          for (int j = 0; j < numbersToExtract ~/ 2; j++) {
            if (j < evens.length) variant.add(evens[j]);
            if (j < odds.length) variant.add(odds[j]);
          }
          break;

        case 1: // Numere consecutive
          final start = (i * 7) % (range - numbersToExtract + 1) + 1;
          for (int j = 0; j < numbersToExtract; j++) {
            variant.add(start + j);
          }
          break;

        case 2: // Numere din zone diferite
          final zoneSize = range ~/ 3;
          for (int j = 0; j < numbersToExtract; j++) {
            final zone = j % 3;
            final base = zone * zoneSize + 1;
            final offset = (j * 5) % zoneSize;
            variant.add(base + offset);
          }
          break;

        case 3: // Numere aleatorii cu spațiere
          int current = 1;
          for (int j = 0; j < numbersToExtract; j++) {
            variant.add(current);
            current += (j + 3) % 7 + 1;
            if (current > range) current = 1;
          }
          break;
      }

      variant.sort();
      variants.add(variant);
    }

    return variants;
  }

  @override
  String getStrategyDescription() {
    return 'Generează variante bazate pe pattern-uri matematice: pare/impare echilibrate, numere consecutive, zone diferite și spațiere aleatorie.';
  }

  @override
  IconData getIcon() => Icons.pattern;

  @override
  Color getColor() => Colors.purple;
}

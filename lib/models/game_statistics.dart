import '../utils/constants.dart';
import 'loto_draw.dart';

/// Model pentru statisticile unui joc de loterie
class GameStatistics {
  Map<String, dynamic> toJson() => {
    'gameType': gameType.key,
    'numberFrequency': numberFrequency,
    'mostFrequent': mostFrequent,
    'leastFrequent': leastFrequent,
    'overdueNumbers': overdueNumbers,
    'combinations': combinations,
    'totalDraws': totalDraws,
    'lastDrawDate': lastDrawDate.toIso8601String(),
    'firstDrawDate': firstDrawDate.toIso8601String(),
  };
  final GameType gameType;
  final Map<int, int> numberFrequency; // Frecven?a fiecarui numar
  final List<int> mostFrequent; // Top 10 cele mai frecvente
  final List<int> leastFrequent; // Top 10 cele mai rare
  final List<int> overdueNumbers; // Numere care nu au mai fost extrase recent
  final Map<String, int> combinations; // Combina?ii frecvente
  final int totalDraws; // Numarul total de extrageri
  final DateTime lastDrawDate; // Data ultimei extrageri
  final DateTime firstDrawDate; // Data primei extrageri

  const GameStatistics({
    required this.gameType,
    required this.numberFrequency,
    required this.mostFrequent,
    required this.leastFrequent,
    required this.overdueNumbers,
    required this.combinations,
    required this.totalDraws,
    required this.lastDrawDate,
    required this.firstDrawDate,
  });

  /// Factory constructor pentru crearea statisticilor din extrageri
  factory GameStatistics.fromDraws(List<LotoDraw> draws, GameType gameType) {
    if (draws.isEmpty) {
      return GameStatistics.empty(gameType);
    }

    // Calculeaza frecven?ele
    Map<int, int> frequencyMap = {};
    for (LotoDraw draw in draws) {
      for (int number in draw.mainNumbers) {
        frequencyMap[number] = (frequencyMap[number] ?? 0) + 1;
      }
      // Pentru Joker, adauga ?i numarul joker
      if (draw.jokerNumber != null) {
        frequencyMap[draw.jokerNumber!] =
            (frequencyMap[draw.jokerNumber!] ?? 0) + 1;
      }
    }

    // Calculeaza top 10 cele mai frecvente
    List<int> mostFrequent = _getTopNumbers(frequencyMap, 10, true);

    // Calculeaza top 10 cele mai rare
    List<int> leastFrequent = _getTopNumbers(frequencyMap, 10, false);

    // Calculeaza numerele care nu au mai fost extrase recent
    List<int> overdueNumbers = _calculateOverdueNumbers(draws, frequencyMap);

    // Calculeaza combina?ii frecvente
    Map<String, int> combinations = _calculateCombinations(draws);

    return GameStatistics(
      gameType: gameType,
      numberFrequency: frequencyMap,
      mostFrequent: mostFrequent,
      leastFrequent: leastFrequent,
      overdueNumbers: overdueNumbers,
      combinations: combinations,
      totalDraws: draws.length,
      lastDrawDate: draws.first.date,
      firstDrawDate: draws.last.date,
    );
  }

  /// Factory constructor pentru statistici goale
  factory GameStatistics.empty(GameType gameType) {
    return GameStatistics(
      gameType: gameType,
      numberFrequency: {},
      mostFrequent: [],
      leastFrequent: [],
      overdueNumbers: [],
      combinations: {},
      totalDraws: 0,
      lastDrawDate: DateTime.now(),
      firstDrawDate: DateTime.now(),
    );
  }

  /// Returneaza top N numere dupa frecven?a
  static List<int> _getTopNumbers(
    Map<int, int> frequencyMap,
    int count,
    bool mostFrequent,
  ) {
    List<MapEntry<int, int>> entries = frequencyMap.entries.toList();

    if (mostFrequent) {
      entries.sort((a, b) => b.value.compareTo(a.value));
    } else {
      entries.sort((a, b) => a.value.compareTo(b.value));
    }

    return entries.take(count).map((e) => e.key).toList();
  }

  /// Calculeaza numerele care nu au mai fost extrase recent
  static List<int> _calculateOverdueNumbers(
    List<LotoDraw> draws,
    Map<int, int> frequencyMap,
  ) {
    List<int> overdue = [];
    int lastDrawsToCheck = 50; // Verifica ultimele 50 extrageri

    // Pentru fiecare numar posibil
    for (int number in frequencyMap.keys) {
      bool found = false;

      // Verifica ultimele extrageri
      for (int i = 0; i < lastDrawsToCheck && i < draws.length; i++) {
        LotoDraw draw = draws[i];
        if (draw.mainNumbers.contains(number) ||
            (draw.jokerNumber != null && draw.jokerNumber == number)) {
          found = true;
          break;
        }
      }

      if (!found) {
        overdue.add(number);
      }
    }

    return overdue;
  }

  /// Calculeaza combina?ii frecvente
  static Map<String, int> _calculateCombinations(List<LotoDraw> draws) {
    Map<String, int> combinations = {};

    for (LotoDraw draw in draws) {
      // Creeaza chei pentru combina?ii de 2 numere
      for (int i = 0; i < draw.mainNumbers.length - 1; i++) {
        for (int j = i + 1; j < draw.mainNumbers.length; j++) {
          String key = '${draw.mainNumbers[i]}-${draw.mainNumbers[j]}';
          combinations[key] = (combinations[key] ?? 0) + 1;
        }
      }
    }

    return combinations;
  }

  /// Calculeaza procentul de frecven?a pentru un numar
  double getFrequencyPercentage(int number) {
    if (totalDraws == 0) return 0.0;
    return (numberFrequency[number] ?? 0) / totalDraws * 100;
  }

  /// Returneaza numarul de zile de la ultima extragere
  int getDaysSinceLastDraw() {
    return DateTime.now().difference(lastDrawDate).inDays;
  }

  /// Returneaza numarul de zile de când nu a mai fost extras un numar
  int getDaysSinceNumberDrawn(int number) {
    // Aceasta va fi implementata în serviciul de statistici
    // pentru a calcula când a fost ultima data extras numarul
    return 0; // Placeholder
  }

  /// Returneaza numerele care nu au mai fost extrase în ultimele X extrageri
  List<int> getOverdueNumbers(int lastDraws) {
    // Aceasta va fi implementata în serviciul de statistici
    return overdueNumbers;
  }

  /// Returneaza statistici pentru numere pare/impare
  Map<String, int> getEvenOddStats() {
    int evenCount = 0;
    int oddCount = 0;

    for (int number in numberFrequency.keys) {
      if (number % 2 == 0) {
        evenCount += numberFrequency[number] ?? 0;
      } else {
        oddCount += numberFrequency[number] ?? 0;
      }
    }

    return {'even': evenCount, 'odd': oddCount};
  }

  /// Returneaza statistici pentru numere mici/mari (în func?ie de joc)
  Map<String, int> getLowHighStats() {
    int lowCount = 0;
    int highCount = 0;
    int midPoint = 0;

    switch (gameType) {
      case GameType.joker:
        midPoint = 23; // 45 / 2
        break;
      case GameType.loto649:
        midPoint = 25; // 49 / 2
        break;
      case GameType.loto540:
        midPoint = 20; // 40 / 2
        break;
    }

    for (int number in numberFrequency.keys) {
      if (number <= midPoint) {
        lowCount += numberFrequency[number] ?? 0;
      } else {
        highCount += numberFrequency[number] ?? 0;
      }
    }

    return {'low': lowCount, 'high': highCount};
  }

  /// Returneaza numerele consecutive cele mai frecvente
  List<List<int>> getConsecutiveNumbers() {
    List<List<int>> consecutive = [];

    // Aceasta va fi implementata în serviciul de statistici
    // pentru a gasi numerele consecutive din extrageri

    return consecutive;
  }

  /// Returneaza numarul mediu de extrageri între apari?iile unui numar
  double getAverageDrawsBetweenAppearances(int number) {
    int frequency = numberFrequency[number] ?? 0;
    if (frequency == 0) return double.infinity;
    return totalDraws / frequency;
  }

  /// Returneaza numerele "fierbin?i" (extrase recent)
  List<int> getHotNumbers(int lastDraws) {
    // Aceasta va fi implementata în serviciul de statistici
    return [];
  }

  /// Returneaza numerele "reci" (nu extrase recent)
  List<int> getColdNumbers(int lastDraws) {
    // Aceasta va fi implementata în serviciul de statistici
    return [];
  }

  @override
  String toString() {
    return 'GameStatistics{gameType: ${gameType.displayName}, totalDraws: $totalDraws, mostFrequent: $mostFrequent}';
  }

  /// Calculeaza statistici pentru lista de extrageri data
  static GameStatistics calculate(List<LotoDraw> draws, GameType gameType) {
    if (draws.isEmpty) {
      return GameStatistics.empty(gameType);
    }
    // Folose?te logica din fromDraws
    return GameStatistics.fromDraws(draws, gameType);
  }
}

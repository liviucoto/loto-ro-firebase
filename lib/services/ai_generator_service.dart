import 'dart:math';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/services/data_service.dart';

class AIGeneratorService {
  // Singleton pattern
  static final AIGeneratorService _instance = AIGeneratorService._internal();
  factory AIGeneratorService() => _instance;
  AIGeneratorService._internal();

  // Cache pentru date și modele
  final Map<String, dynamic> _dataCache = {};
  final Map<String, Map<int, int>> _frequencyCache = {};
  final Map<String, double> _averageSumCache = {};

  // Configurații pentru fiecare joc
  static const Map<String, Map<String, int>> gameConfigs = {
    // Joker: testele și arhiva folosesc 40 ca limită principală
    'joker': {'maxNumbers': 40, 'count': 5, 'jokerMax': 20},
    'loto649': {'maxNumbers': 49, 'count': 6, 'jokerMax': 0},
    'loto540': {'maxNumbers': 40, 'count': 5, 'jokerMax': 0},
  };

  /// Generează variante folosind algoritmi AI locali
  Future<Map<String, dynamic>> generateVariants({
    required GameType game,
    required int nVariants,
    bool useAI = true,
    bool balanceEvenOdd = true,
  }) async {
    try {
      print('🚀 Generez variante pentru ${game.toString().split('.').last}');

      // Încarcă datele dacă nu sunt în cache
      await _loadGameData(game);

      final variants = <Map<String, dynamic>>[];
      final algorithm = _selectOptimalAlgorithm(game, useAI);

      for (int i = 0; i < nVariants; i++) {
        final variant = await _generateSingleVariant(
          game,
          algorithm,
          balanceEvenOdd,
          i,
        );
        variants.add(variant);
      }

      // Sortează variantele după scor
      variants.sort(
        (a, b) =>
            (b['total_score'] as double).compareTo(a['total_score'] as double),
      );

      return {
        'variants': variants,
        'algorithm_used': algorithm,
        'generation_time': DateTime.now().millisecondsSinceEpoch,
        'total_variants': variants.length,
      };
    } catch (e) {
      print('❌ Eroare la generarea variantelor: $e');
      return {
        'variants': _generateFallbackVariants(game, nVariants),
        'algorithm_used': 'fallback_local',
        'message': 'Eroare la generare, folosesc algoritm simplu',
      };
    }
  }

  /// Încarcă datele pentru un joc specific
  Future<void> _loadGameData(GameType game) async {
    final gameKey = game.toString().split('.').last.toLowerCase();

    if (_dataCache.containsKey(gameKey)) {
      return; // Datele sunt deja în cache
    }

    print('📊 Încarcă date pentru $gameKey...');

    try {
      // Folosește DataService pentru a încărca datele
      final dataService = DataService();
      final draws = await dataService.loadDraws(game);

      if (draws.isEmpty) {
        throw Exception('Nu s-au găsit date pentru $gameKey');
      }

      // Calculează statistici
      final frequency = <int, int>{};
      final sums = <int>[];

      for (final draw in draws) {
        for (final number in draw.mainNumbers) {
          frequency[number] = (frequency[number] ?? 0) + 1;
        }
        sums.add(draw.mainNumbers.fold(0, (sum, num) => sum + num));
      }

      // Calculează media sumelor
      final averageSum = sums.isNotEmpty
          ? sums.reduce((a, b) => a + b) / sums.length
          : 0.0;

      // Salvează în cache
      _dataCache[gameKey] = draws;
      _frequencyCache[gameKey] = frequency;
      _averageSumCache[gameKey] = averageSum;

      print('✅ Date încărcate pentru $gameKey: ${draws.length} extrageri');
    } catch (e) {
      print('❌ Eroare la încărcarea datelor pentru $gameKey: $e');
      rethrow;
    }
  }

  /// Selectează algoritmul optim
  String _selectOptimalAlgorithm(GameType game, bool useAI) {
    final gameKey = game.toString().split('.').last.toLowerCase();
    final draws = _dataCache[gameKey] as List?;

    if (!useAI || draws == null || draws.length < 100) {
      return 'Statistical Random';
    } else if (draws.length > 1000) {
      return 'Hybrid AI (ML + Genetic + Markov)';
    } else if (draws.length > 500) {
      return 'Genetic Algorithm + Heuristics';
    } else {
      return 'Heuristics + Markov Chain';
    }
  }

  /// Generează o singură variantă
  Future<Map<String, dynamic>> _generateSingleVariant(
    GameType game,
    String algorithm,
    bool balanceEvenOdd,
    int variantIndex,
  ) async {
    final gameKey = game.toString().split('.').last.toLowerCase();
    final config = gameConfigs[gameKey]!;
    final frequency = _frequencyCache[gameKey]!;
    final averageSum = _averageSumCache[gameKey]!;

    List<int> numbers;

    switch (algorithm) {
      case 'Hybrid AI (ML + Genetic + Markov)':
        numbers = await _hybridAIGeneration(game, frequency, variantIndex);
        break;
      case 'Genetic Algorithm + Heuristics':
        numbers = await _geneticGeneration(game, frequency, variantIndex);
        break;
      case 'Heuristics + Markov Chain':
        numbers = await _heuristicMarkovGeneration(
          game,
          frequency,
          variantIndex,
        );
        break;
      default:
        numbers = _simpleStatisticalGeneration(frequency, config['count']!);
    }

    // Balanțează pare/impare dacă este cerut
    if (balanceEvenOdd) {
      numbers = _balanceEvenOdd(numbers, config['maxNumbers']!);
    }

    // Generează Joker dacă este necesar
    int? joker;
    if (config['jokerMax']! > 0) {
      joker = _generateJokerNumber(frequency);
    }

    // Calculează scorurile
    final scores = _calculateScores(numbers, frequency, averageSum, game);
    final totalScore = scores.values.reduce((a, b) => a + b) / scores.length;

    return {
      'numbers': numbers,
      'joker': joker,
      'scores': scores,
      'total_score': totalScore,
      'justification': _generateJustification(algorithm, scores, numbers),
      'sum_value': numbers.fold(0, (sum, num) => sum + num),
      'even_count': numbers.where((n) => n % 2 == 0).length,
      'odd_count': numbers.where((n) => n % 2 == 1).length,
    };
  }

  /// Generare hibridă AI
  Future<List<int>> _hybridAIGeneration(
    GameType game,
    Map<int, int> frequency,
    int variantIndex,
  ) async {
    final gameKey = game.toString().split('.').last.toLowerCase();
    final config = gameConfigs[gameKey]!;

    // 1. Predicție ML simplificată (bazată pe frecvență)
    final mlNumbers = _mlPrediction(frequency, config['count']!);

    // 2. Algoritm genetic
    final geneticNumbers = _geneticAlgorithm(
      frequency,
      config['count']!,
      variantIndex,
    );

    // 3. Lanț Markov
    final markovNumbers = _markovChain(
      frequency,
      config['count']!,
      variantIndex,
    );

    // 4. Combină rezultatele
    final candidates = [mlNumbers, geneticNumbers, markovNumbers];
    return _selectBestCombination(candidates, frequency);
  }

  /// Predicție ML simplificată
  List<int> _mlPrediction(Map<int, int> frequency, int count) {
    final maxNumber = frequency.keys.isNotEmpty
        ? frequency.keys.reduce(max)
        : 49;
    final weights = List.generate(maxNumber, (i) => frequency[i + 1] ?? 1);
    final totalWeight = weights.reduce((a, b) => a + b);

    final numbers = <int>{};
    while (numbers.length < count) {
      final rand = Random().nextDouble() * totalWeight;
      double cumulative = 0;

      for (int i = 0; i < weights.length; i++) {
        cumulative += weights[i];
        if (cumulative >= rand) {
          final number = i + 1;
          if (!numbers.contains(number)) {
            numbers.add(number);
          }
          break;
        }
      }
    }

    return numbers.toList()..sort();
  }

  /// Algoritm genetic
  List<int> _geneticAlgorithm(
    Map<int, int> frequency,
    int count,
    int variantIndex,
  ) {
    final maxNumber = frequency.keys.isNotEmpty
        ? frequency.keys.reduce(max)
        : 49;
    final population = <List<int>>[];

    // Generează populația inițială
    for (int i = 0; i < 10; i++) {
      final individual = <int>{};
      while (individual.length < count) {
        final number = Random().nextInt(maxNumber) + 1;
        individual.add(number);
      }
      population.add(individual.toList()..sort());
    }

    // Evoluție simplificată
    for (int generation = 0; generation < 5; generation++) {
      // Evaluează fitness
      population.sort(
        (a, b) => _calculateFitness(
          b,
          frequency,
        ).compareTo(_calculateFitness(a, frequency)),
      );

      // Crossover și mutation
      final newPopulation = <List<int>>[];
      for (int i = 0; i < population.length; i += 2) {
        if (i + 1 < population.length) {
          final child = _crossover(population[i], population[i + 1]);
          newPopulation.add(_mutate(child, maxNumber));
        }
      }

      population.clear();
      population.addAll(newPopulation);
    }

    return population.isNotEmpty
        ? population.first
        : _simpleStatisticalGeneration(frequency, count);
  }

  /// Lanț Markov
  List<int> _markovChain(Map<int, int> frequency, int count, int variantIndex) {
    final maxNumber = frequency.keys.isNotEmpty
        ? frequency.keys.reduce(max)
        : 49;
    final numbers = <int>{};

    // Simulează tranziții Markov
    int currentNumber = Random().nextInt(maxNumber) + 1;

    while (numbers.length < count) {
      numbers.add(currentNumber);

      // Tranziție bazată pe frecvență
      final nextCandidates = <int>[];
      final nextWeights = <int>[];

      for (int i = 1; i <= maxNumber; i++) {
        if (!numbers.contains(i)) {
          nextCandidates.add(i);
          nextWeights.add(frequency[i] ?? 1);
        }
      }

      if (nextCandidates.isNotEmpty) {
        final totalWeight = nextWeights.reduce((a, b) => a + b);
        final rand = Random().nextDouble() * totalWeight;
        double cumulative = 0;

        for (int i = 0; i < nextCandidates.length; i++) {
          cumulative += nextWeights[i];
          if (cumulative >= rand) {
            currentNumber = nextCandidates[i];
            break;
          }
        }
      }
    }

    return numbers.toList()..sort();
  }

  /// Generare genetică
  Future<List<int>> _geneticGeneration(
    GameType game,
    Map<int, int> frequency,
    int variantIndex,
  ) async {
    final gameKey = game.toString().split('.').last.toLowerCase();
    final config = gameConfigs[gameKey]!;

    final numbers = _geneticAlgorithm(
      frequency,
      config['count']!,
      variantIndex,
    );
    return _balanceEvenOdd(numbers, config['maxNumbers']!);
  }

  /// Generare heuristică + Markov
  Future<List<int>> _heuristicMarkovGeneration(
    GameType game,
    Map<int, int> frequency,
    int variantIndex,
  ) async {
    final gameKey = game.toString().split('.').last.toLowerCase();
    final config = gameConfigs[gameKey]!;

    final numbers = _markovChain(frequency, config['count']!, variantIndex);
    return _applyHeuristics(numbers, frequency, config['maxNumber']!);
  }

  /// Generare statistică
  Future<List<int>> _statisticalGeneration(
    GameType game,
    Map<int, int> frequency,
    int variantIndex,
  ) async {
  // ignore: unused_element
    final gameKey = game.toString().split('.').last.toLowerCase();
    final config = gameConfigs[gameKey]!;

    return Future.value(
      _simpleStatisticalGeneration(frequency, config['count']!),
    );
  }

  /// Generare statistică simplă
  List<int> _simpleStatisticalGeneration(Map<int, int> frequency, int count) {
    final maxNumber = frequency.keys.isNotEmpty
        ? frequency.keys.reduce(max)
        : 49;
    final weights = List.generate(maxNumber, (i) => frequency[i + 1] ?? 1);
    final totalWeight = weights.reduce((a, b) => a + b);

    final numbers = <int>{};
    while (numbers.length < count) {
      final rand = Random().nextDouble() * totalWeight;
      double cumulative = 0;

      for (int i = 0; i < weights.length; i++) {
        cumulative += weights[i];
        if (cumulative >= rand) {
          final number = i + 1;
          if (!numbers.contains(number)) {
            numbers.add(number);
          }
          break;
        }
      }
    }

    return numbers.toList()..sort();
  }

  /// Generează numărul Joker
  int _generateJokerNumber(Map<int, int> frequency) {
    final jokerFreq = <int, int>{};
    for (int i = 1; i <= 20; i++) {
      jokerFreq[i] = frequency[i] ?? 1;
    }

    final totalWeight = jokerFreq.values.reduce((a, b) => a + b);
    final rand = Random().nextDouble() * totalWeight;
    double cumulative = 0;

    for (final entry in jokerFreq.entries) {
      cumulative += entry.value;
      if (cumulative >= rand) {
        return entry.key;
      }
    }

    return Random().nextInt(20) + 1;
  }

  /// Calculează scorurile
  Map<String, double> _calculateScores(
    List<int> numbers,
    Map<int, int> frequency,
    double averageSum,
    GameType game,
  ) {
    final scores = <String, double>{};

    // Scor frecvență
    final freqScores = numbers.map((n) => frequency[n] ?? 0).toList();
    final avgFreq = freqScores.reduce((a, b) => a + b) / freqScores.length;
    final maxFreq = frequency.values.isNotEmpty
        ? frequency.values.reduce(max)
        : 1;
    scores['frequency'] = (avgFreq / maxFreq).clamp(0.0, 3.0);

    // Scor unicitate
    scores['uniqueness'] =
        3.0; // Toate combinațiile sunt considerate unice local

    // Scor balanță pare/impare
    final evenCount = numbers.where((n) => n % 2 == 0).length;
    final oddCount = numbers.length - evenCount;
    scores['balance'] = (3.0 - (evenCount - oddCount).abs() * 0.5).clamp(
      0.0,
      3.0,
    );

    // Scor sumă
    final sumValue = numbers.fold(0, (sum, num) => sum + num);
    final sumDiff = (sumValue - averageSum).abs();
    scores['sum'] = (3.0 - sumDiff / 20.0).clamp(0.0, 3.0);

    // Scor distribuție
    scores['distribution'] = _calculateDistributionScore(numbers);

    return scores;
  }

  /// Calculează scorul pentru distribuție
  double _calculateDistributionScore(List<int> numbers) {
    final maxNumber = numbers.reduce(max);
    final intervals = List.filled(5, 0);

    for (final num in numbers) {
      final intervalIdx = ((num - 1) / (maxNumber / 5)).floor().clamp(0, 4);
      intervals[intervalIdx]++;
    }

    final idealPerInterval = numbers.length / 5;
    final variance = intervals
        .map((count) => (count - idealPerInterval) * (count - idealPerInterval))
        .reduce((a, b) => a + b);

    return (3.0 - variance / 2.0).clamp(0.0, 3.0);
  }

  /// Selectează cea mai bună combinație
  List<int> _selectBestCombination(
    List<List<int>> candidates,
    Map<int, int> frequency,
  ) {
    double bestScore = -1;
    List<int> bestCombination = candidates.isNotEmpty ? candidates.first : [];

    for (final candidate in candidates) {
      double score = 0;

      // Scor frecvență
      final freqScores = candidate.map((n) => frequency[n] ?? 0).toList();
      score += freqScores.reduce((a, b) => a + b) / freqScores.length;

      // Scor balanță
      final evenCount = candidate.where((n) => n % 2 == 0).length;
      final oddCount = candidate.length - evenCount;
      score += 3.0 - (evenCount - oddCount).abs();

      if (score > bestScore) {
        bestScore = score;
        bestCombination = candidate;
      }
    }

    return bestCombination;
  }

  /// Balanțează numerele pare și impare
  List<int> _balanceEvenOdd(List<int> numbers, int maxNumber) {
    final evenCount = numbers.where((n) => n % 2 == 0).length;
    final oddCount = numbers.length - evenCount;

    if ((evenCount - oddCount).abs() <= 1) {
      return numbers; // Deja balanțat
    }

    // Încearcă să balanțezi prin înlocuire
    final availableNumbers = List.generate(maxNumber, (i) => i + 1);

    for (int i = 0; i < numbers.length; i++) {
      if (evenCount > oddCount && numbers[i] % 2 == 0) {
        // Înlocuiește cu un număr impar
        for (final replacement in availableNumbers) {
          if (replacement % 2 == 1 && !numbers.contains(replacement)) {
            numbers[i] = replacement;
            return numbers;
          }
        }
      } else if (oddCount > evenCount && numbers[i] % 2 == 1) {
        // Înlocuiește cu un număr par
        for (final replacement in availableNumbers) {
          if (replacement % 2 == 0 && !numbers.contains(replacement)) {
            numbers[i] = replacement;
            return numbers;
          }
        }
      }
    }

    return numbers;
  }

  /// Aplică heuristici
  List<int> _applyHeuristics(
    List<int> numbers,
    Map<int, int> frequency,
    int maxNumber,
  ) {
    // Heuristică: preferă numere cu frecvență medie
    final avgFreq = frequency.values.reduce((a, b) => a + b) / frequency.length;

    for (int i = 0; i < numbers.length; i++) {
      final currentFreq = frequency[numbers[i]] ?? 0;
      if (currentFreq < avgFreq * 0.5) {
        // Înlocuiește cu un număr cu frecvență mai bună
        for (int j = 1; j <= maxNumber; j++) {
          if (!numbers.contains(j) && (frequency[j] ?? 0) > avgFreq * 0.8) {
            numbers[i] = j;
            break;
          }
        }
      }
    }

    return numbers;
  }

  /// Calculează fitness pentru algoritm genetic
  double _calculateFitness(List<int> individual, Map<int, int> frequency) {
    double score = 0;

    // Scor frecvență
    final freqScores = individual.map((n) => frequency[n] ?? 0).toList();
    score += freqScores.reduce((a, b) => a + b) / freqScores.length;

    // Scor balanță
    final evenCount = individual.where((n) => n % 2 == 0).length;
    final oddCount = individual.length - evenCount;
    score += 3.0 - (evenCount - oddCount).abs();

    return score;
  }

  /// Crossover pentru algoritm genetic
  List<int> _crossover(List<int> parent1, List<int> parent2) {
    final child = <int>{};
    final crossoverPoint = Random().nextInt(parent1.length);

    // Copiază prima parte din primul părinte
    for (int i = 0; i < crossoverPoint; i++) {
      child.add(parent1[i]);
    }

    // Completează cu numere din al doilea părinte
    for (final num in parent2) {
      if (child.length < parent1.length && !child.contains(num)) {
        child.add(num);
      }
    }

    return child.toList()..sort();
  }

  /// Mutation pentru algoritm genetic
  List<int> _mutate(List<int> individual, int maxNumber) {
    if (Random().nextDouble() < 0.1) {
      // 10% șansă de mutație
      final mutationIndex = Random().nextInt(individual.length);
      final newNumber = Random().nextInt(maxNumber) + 1;

      if (!individual.contains(newNumber)) {
        individual[mutationIndex] = newNumber;
        individual.sort();
      }
    }

    return individual;
  }

  /// Generează justificarea
  String _generateJustification(
    String algorithm,
    Map<String, double> scores,
    List<int> numbers,
  ) {
    final justifications = <String>[];

    if (scores['frequency']! > 2.0) {
      justifications.add('Frecvență optimă');
    }
    if (scores['balance']! > 2.0) {
      justifications.add('Balanță pare/impare');
    }
    if (scores['sum']! > 2.0) {
      justifications.add('Sumă aproape de medie');
    }
    if (scores['distribution']! > 2.0) {
      justifications.add('Distribuție uniformă');
    }

    return '$algorithm: ${justifications.join(', ')}';
  }

  /// Generează variante de fallback
  List<Map<String, dynamic>> _generateFallbackVariants(
    GameType game,
    int nVariants,
  ) {
    final variants = <Map<String, dynamic>>[];
    final random = Random();
    final gameKey = game.toString().split('.').last.toLowerCase();
    final config = gameConfigs[gameKey]!;

    for (int i = 0; i < nVariants; i++) {
      final numbers = <int>{};
      while (numbers.length < config['count']!) {
        numbers.add(random.nextInt(config['maxNumbers']!) + 1);
      }

      final sortedNumbers = numbers.toList()..sort();
      final jokerNumber = config['jokerMax']! > 0
          ? random.nextInt(config['jokerMax']!) + 1
          : null;

      variants.add({
        'numbers': sortedNumbers,
        'joker': jokerNumber,
        'total_score': random.nextDouble() * 100,
        'justification': 'Generat local - algoritm simplu',
      });
    }

    return variants;
  }

  /// Obține statusul modelului (simulat pentru compatibilitate)
  Future<Map<String, dynamic>> getModelStatus(GameType game) async {
    return {
      'status': 'trained',
      'message': 'Model local disponibil',
      'game': game.toString().split('.').last.toLowerCase(),
    };
  }

  /// Antrenează modelul (simulat pentru compatibilitate)
  Future<Map<String, dynamic>> trainModel({required GameType game}) async {
    await _loadGameData(game);

    return {
      'status': 'trained',
      'message': 'Model local antrenat cu succes',
      'game': game.toString().split('.').last.toLowerCase(),
    };
  }
}

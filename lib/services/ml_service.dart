import 'dart:math';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/services/storage_service.dart';
import 'package:loto_ro/services/data_service.dart';
import 'package:loto_ro/services/ai_generator_service.dart';

/// Serviciu pentru Machine Learning și învățare continuă
class MLService {
  static final MLService _instance = MLService._internal();
  factory MLService() => _instance;
  MLService._internal();

  final StorageService _storage = StorageService();
  final DataService _dataService = DataService();

  // Model simplu pentru predicții
  Map<String, dynamic> _model = {};
  bool _modelTrained = false;
  DateTime? _lastTraining;

  // Cache pentru performanță
  final Map<String, dynamic> _frequencyCache = {};
  final Map<String, dynamic> _patternCache = {};

  /// Inițializează serviciul ML
  Future<void> initialize() async {
    await _storage.initialize();
    await _loadModel();
    _storage.logAI('MLService inițializat');
  }

  // ===== MODEL SIMPLU DART =====

  /// Antrenează modelul pe datele istorice
  Future<Map<String, dynamic>> trainModel(GameType gameType) async {
    try {
      _storage.logAI('Începe antrenarea modelului pentru $gameType');

      // Încarcă datele istorice
      final draws = await _dataService.loadDraws(gameType);
      if (draws.isEmpty) {
        throw Exception('Nu sunt date disponibile pentru antrenare');
      }

      // Convertește la formatul necesar
      final drawsData = draws
          .map(
            (draw) => {
              'numbers': draw.mainNumbers,
              'joker': draw.jokerNumber,
              'date': draw.date.toIso8601String(),
            },
          )
          .toList();

      // Analizează pattern-urile
      final patterns = _analyzePatterns(drawsData, gameType);

      // Calculează frecvențele
      final frequencies = _calculateFrequencies(drawsData, gameType);

      // Calculează corelațiile
      final correlations = _calculateCorrelations(drawsData, gameType);

      // Salvează modelul
      _model = {
        'gameType': gameType.toString(),
        'patterns': patterns,
        'frequencies': frequencies,
        'correlations': correlations,
        'trainingDate': DateTime.now().toIso8601String(),
        'drawsCount': draws.length,
      };

      _modelTrained = true;
      _lastTraining = DateTime.now();

      await _saveModel();
      _storage.logAI(
        'Model antrenat cu succes',
        data: {
          'gameType': gameType.toString(),
          'patterns': patterns.length,
          'frequencies': frequencies.length,
          'correlations': correlations.length,
        },
      );

      return {
        'status': 'trained',
        'patterns': patterns.length,
        'frequencies': frequencies.length,
        'correlations': correlations.length,
      };
    } catch (e) {
      _storage.logError(
        'Eroare la antrenarea modelului: $e',
        context: 'MLService.trainModel',
      );
      return {'status': 'error', 'message': e.toString()};
    }
  }

  /// Generează predicții folosind modelul antrenat
  Future<List<Map<String, dynamic>>> generatePredictions(
    GameType gameType,
    int nVariants,
    Map<String, dynamic> params,
  ) async {
    try {
      if (!_modelTrained || _model['gameType'] != gameType.toString()) {
        await trainModel(gameType);
      }

      _storage.logAI(
        'Generează predicții',
        data: {
          'gameType': gameType.toString(),
          'nVariants': nVariants,
          'params': params,
        },
      );

      final predictions = <Map<String, dynamic>>[];
      final config = AIGeneratorService
          .gameConfigs[gameType.toString().split('.').last.toLowerCase()]!;
      // Compatibilitate: în gameConfigs cheile sunt 'maxNumbers' și 'count'
      final maxNumbers = config['maxNumbers']!;
      final numbersToPick = config['numbersToPick'] ?? config['count']!;

      for (int i = 0; i < nVariants; i++) {
        final prediction = _generateSinglePrediction(
          gameType,
          maxNumbers,
          numbersToPick,
          params,
        );
        predictions.add(prediction);
      }

      _storage.logAI(
        'Predicții generate cu succes',
        data: {
          'count': predictions.length,
          'predictions': predictions.map((p) => p['numbers']).toList(),
        },
      );

      return predictions;
    } catch (e) {
      _storage.logError(
        'Eroare la generarea predicțiilor: $e',
        context: 'MLService.generatePredictions',
      );
      return [];
    }
  }

  /// Generează o singură predicție
  Map<String, dynamic> _generateSinglePrediction(
    GameType gameType,
    int maxNumbers,
    int numbersToPick,
    Map<String, dynamic> params,
  ) {
    final numbers = <int>[];
    final frequencies = _model['frequencies'] as Map<String, dynamic>;
    final patterns = _model['patterns'] as Map<String, dynamic>;

    // Aplică strategii bazate pe model
    final strategy = params['strategy'] ?? 'balanced';

    switch (strategy) {
      case 'frequency_based':
        numbers.addAll(
          _selectByFrequency(frequencies, numbersToPick, maxNumbers),
        );
        break;
      case 'pattern_based':
        numbers.addAll(_selectByPatterns(patterns, numbersToPick, maxNumbers));
        break;
      case 'correlation_based':
        numbers.addAll(_selectByCorrelations(numbersToPick, maxNumbers));
        break;
      default:
        numbers.addAll(
          _selectBalanced(frequencies, patterns, numbersToPick, maxNumbers),
        );
    }

    // Calculează scorul
    final score = _calculatePredictionScore(numbers, frequencies, patterns);

    // Asigură lungimea corectă: completează cu numere random unice dacă strategia a produs prea puține
    if (numbers.length < numbersToPick) {
      final rand = Random();
      final used = numbers.toSet();
      while (used.length < numbersToPick) {
        final candidate = rand.nextInt(maxNumbers) + 1;
        used.add(candidate);
      }
      numbers
        ..clear()
        ..addAll(used);
    }

    // Normalizează (unicitate + sortare)
    final uniqueSorted = numbers.toSet().toList()..sort();

    return {
      'numbers': uniqueSorted,
      'score': score,
      'strategy': strategy,
      'confidence': _calculateConfidence(numbers, frequencies),
    };
  }

  // ===== ANALIZA PATTERN-URILOR =====

  /// Analizează pattern-urile din datele istorice
  Map<String, dynamic> _analyzePatterns(
    List<Map<String, dynamic>> draws,
    GameType gameType,
  ) {
    final patterns = <String, dynamic>{};

    // Pattern-uri pentru sume
    final sums = draws
        .map(
          (d) => (d['numbers'] as List<dynamic>).fold<int>(
            0,
            (a, b) => a + (b as int),
          ),
        )
        .toList();
    patterns['sum_distribution'] = _calculateDistribution(sums);

    // Pattern-uri pentru pare/impare
    final evenOddPatterns = draws.map((d) {
      final numbers = d['numbers'] as List<dynamic>;
      return numbers.where((n) => n % 2 == 0).length;
    }).toList();
    patterns['even_odd_distribution'] = _calculateDistribution(evenOddPatterns);

    // Pattern-uri pentru intervale
    final intervalPatterns = draws.map((d) {
      final numbers = d['numbers'] as List<dynamic>;
      return _calculateIntervalPattern(numbers);
    }).toList();
    patterns['interval_patterns'] = _calculateDistribution(intervalPatterns);

    return patterns;
  }

  /// Calculează distribuția pentru o listă de valori
  Map<String, dynamic> _calculateDistribution(List<dynamic> values) {
    final distribution = <String, int>{};
    for (final value in values) {
      final key = value.toString();
      distribution[key] = (distribution[key] ?? 0) + 1;
    }

    final total = values.length;
    final normalized = <String, double>{};
    for (final entry in distribution.entries) {
      normalized[entry.key] = entry.value / total;
    }

    return {'raw': distribution, 'normalized': normalized, 'total': total};
  }

  /// Calculează pattern-ul de intervale pentru o listă de numere
  String _calculateIntervalPattern(List<dynamic> numbers) {
    final sorted = List<int>.from(numbers)..sort();
    final intervals = <int>[];

    for (int i = 1; i < sorted.length; i++) {
      intervals.add(sorted[i] - sorted[i - 1]);
    }

    return intervals.join(',');
  }

  // ===== CALCULUL FRECVENȚELOR =====

  /// Calculează frecvențele numerelor
  Map<String, dynamic> _calculateFrequencies(
    List<Map<String, dynamic>> draws,
    GameType gameType,
  ) {
    final config = AIGeneratorService
        .gameConfigs[gameType.toString().split('.').last.toLowerCase()]!;
    final maxNumber = config['maxNumbers']!;

    final frequencies = <int, int>{};
    for (int i = 1; i <= maxNumber; i++) {
      frequencies[i] = 0;
    }

    for (final draw in draws) {
      final numbers = draw['numbers'] as List<dynamic>;
      for (final number in numbers) {
        frequencies[number] = (frequencies[number] ?? 0) + 1;
      }
    }

    final total = draws.length;
    final normalized = <int, double>{};
    for (final entry in frequencies.entries) {
      normalized[entry.key] = entry.value / total;
    }

    return {'raw': frequencies, 'normalized': normalized, 'total': total};
  }

  // ===== CALCULUL CORELAȚIILOR =====

  /// Calculează corelațiile între numere
  Map<String, dynamic> _calculateCorrelations(
    List<Map<String, dynamic>> draws,
    GameType gameType,
  ) {
    // Config utilizat în viitor pentru limitări suplimentare dacă va fi nevoie
    // final config = AIGeneratorService
    //     .gameConfigs[gameType.toString().split('.').last.toLowerCase()]!;

    final correlations = <String, int>{};

    for (final draw in draws) {
      final numbers = draw['numbers'] as List<dynamic>;
      for (int i = 0; i < numbers.length; i++) {
        for (int j = i + 1; j < numbers.length; j++) {
          final pair = '${numbers[i]}-${numbers[j]}';
          correlations[pair] = (correlations[pair] ?? 0) + 1;
        }
      }
    }

    return correlations;
  }

  // ===== STRATEGII DE SELECȚIE =====

  /// Selectează numere bazate pe frecvență
  List<int> _selectByFrequency(
    Map<String, dynamic> frequencies,
    int count,
    int maxNumber,
  ) {
    final normalized = _normalizedFrequencyMap(frequencies);
    final numbers = <int>[];

    // Sortează numerele după frecvență
    final sorted = normalized.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    // Selectează primele numere
    for (int i = 0; i < count && i < sorted.length; i++) {
      numbers.add(sorted[i].key);
    }

    return numbers;
  }

  /// Selectează numere bazate pe pattern-uri
  List<int> _selectByPatterns(
    Map<String, dynamic> patterns,
    int count,
    int maxNumber,
  ) {
    // Folosește pattern-ul de sume
    final sumDist = patterns['sum_distribution'] as Map<String, dynamic>;
    final normalized = sumDist['normalized'] as Map<String, double>;

    // Găsește suma medie
    double avgSum = 0;
    int total = 0;
    for (final entry in normalized.entries) {
      avgSum += double.parse(entry.key) * entry.value;
      total += sumDist['raw'][entry.key] as int;
    }
    avgSum = avgSum / total;

    // Generează numere care să dea suma medie
    final targetSum = avgSum.round();
    final numbersNeeded = count;

    // Algoritm simplu pentru a găsi numere care să dea suma dorită
    final selected = <int>{};
    while (selected.length < numbersNeeded) {
      final remaining = targetSum - selected.fold(0, (a, b) => a + b);
      final numbersLeft = numbersNeeded - selected.length;

      if (remaining <= 0 || numbersLeft <= 0) break;

      final avgRemaining = remaining / numbersLeft;
      final number = (avgRemaining + Random().nextDouble() * 10 - 5).round();

      if (number > 0 && number <= maxNumber && !selected.contains(number)) {
        selected.add(number);
      }
    }

    return selected.toList();
  }

  /// Selectează numere bazate pe corelații
  List<int> _selectByCorrelations(int count, int maxNumber) {
    final correlations = _model['correlations'] as Map<String, int>;
    final numbers = <int>{};

    // Găsește perechile cu cea mai mare corelație
    final sortedPairs = correlations.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (final pair in sortedPairs.take(count * 2)) {
      final parts = pair.key.split('-');
      if (parts.length == 2) {
        final num1 = int.parse(parts[0]);
        final num2 = int.parse(parts[1]);

        if (num1 <= maxNumber && !numbers.contains(num1)) numbers.add(num1);
        if (num2 <= maxNumber && !numbers.contains(num2)) numbers.add(num2);

        if (numbers.length >= count) break;
      }
    }

    return numbers.take(count).toList();
  }

  /// Selectează numere în mod echilibrat
  List<int> _selectBalanced(
    Map<String, dynamic> frequencies,
    Map<String, dynamic> patterns,
    int count,
    int maxNumber,
  ) {
    final numbers = <int>{};
    final normalized = _normalizedFrequencyMap(frequencies);

    // Combină frecvența cu pattern-urile
    final scores = <int, double>{};
    for (int i = 1; i <= maxNumber; i++) {
      double score = normalized[i] ?? 0;

      // Bonus pentru numere care respectă pattern-urile
      if (_respectsPatterns(i, patterns)) {
        score *= 1.2;
      }

      scores[i] = score;
    }

    // Selectează numerele cu cele mai mari scoruri
    final sorted = scores.entries.toList()
      ..sort((a, b) => b.value.compareTo(a.value));

    for (int i = 0; i < count && i < sorted.length; i++) {
      numbers.add(sorted[i].key);
    }

    return numbers.toList();
  }

  /// Verifică dacă un număr respectă pattern-urile
  bool _respectsPatterns(int number, Map<String, dynamic> patterns) {
    // Implementare simplă - poate fi extinsă
    return true;
  }

  // ===== CALCULUL SCORURILOR =====

  /// Calculează scorul pentru o predicție
  double _calculatePredictionScore(
    List<int> numbers,
    Map<String, dynamic> frequencies,
    Map<String, dynamic> patterns,
  ) {
    double score = 0;
    final normalized = _normalizedFrequencyMap(frequencies);

    // Scor bazat pe frecvență
    for (final number in numbers) {
      score += normalized[number] ?? 0;
    }

    // Scor bazat pe pattern-uri
    final sum = numbers.fold(0, (a, b) => a + b);
    final evenCount = numbers.where((n) => n % 2 == 0).length;

    // Bonus pentru pattern-uri respectate
    if (_respectsPatterns(sum, patterns)) score += 0.5;
    if (_respectsPatterns(evenCount, patterns)) score += 0.3;

    return score;
  }

  /// Calculează încrederea în predicție
  double _calculateConfidence(
    List<int> numbers,
    Map<String, dynamic> frequencies,
  ) {
    final normalized = _normalizedFrequencyMap(frequencies);
    double confidence = 0;

    for (final number in numbers) {
      confidence += normalized[number] ?? 0;
    }

    return confidence / numbers.length;
  }

  // ===== ÎNVĂȚARE CONTINUĂ =====

  /// Actualizează modelul cu date noi
  Future<void> updateModelWithNewData(
    GameType gameType,
    List<Map<String, dynamic>> newDraws,
  ) async {
    try {
      _storage.logAI(
        'Actualizează modelul cu date noi',
        data: {'gameType': gameType.toString(), 'newDraws': newDraws.length},
      );

      // Reantrenează modelul cu toate datele
      await trainModel(gameType);

      _storage.logAI('Model actualizat cu succes');
    } catch (e) {
      _storage.logError(
        'Eroare la actualizarea modelului: $e',
        context: 'MLService.updateModelWithNewData',
      );
    }
  }

  /// Evaluează performanța modelului
  Map<String, dynamic> evaluateModel(
    GameType gameType,
    List<Map<String, dynamic>> testDraws,
  ) {
    try {
      double accuracy = 0;
      double precision = 0;
      double recall = 0;

      // Implementare simplă de evaluare
      // În practică, ar trebui să compare predicțiile cu rezultatele reale

      return {
        'accuracy': accuracy,
        'precision': precision,
        'recall': recall,
        'f1_score': 2 * (precision * recall) / (precision + recall),
      };
    } catch (e) {
      _storage.logError(
        'Eroare la evaluarea modelului: $e',
        context: 'MLService.evaluateModel',
      );
      return {};
    }
  }

  // ===== PERSISTENȚA MODELULUI =====

  /// Salvează modelul
  Future<void> _saveModel() async {
    try {
      // Creăm o copie sigură pentru persistență (fără a altera tipurile din memorie)
      final modelForStorage = Map<String, dynamic>.from(_model);
      final frequencies = _model['frequencies'];
      if (frequencies is Map<String, dynamic>) {
        final raw = frequencies['raw'];
        final normalized = frequencies['normalized'];
        final rawCopy = <String, int>{};
        if (raw is Map) {
          raw.forEach((k, v) {
            rawCopy[k.toString()] = (v as num).toInt();
          });
        }
        final normalizedCopy = <String, double>{};
        if (normalized is Map) {
          normalized.forEach((k, v) {
            normalizedCopy[k.toString()] = (v as num).toDouble();
          });
        }
        modelForStorage['frequencies'] = {
          'raw': rawCopy,
          'normalized': normalizedCopy,
          'total': frequencies['total'],
        };
      }
      await _storage.saveAICache('ml_model', modelForStorage);
    } catch (e) {
      _storage.logError(
        'Eroare la salvarea modelului: $e',
        context: 'MLService._saveModel',
      );
    }
  }

  /// Încarcă modelul
  Future<void> _loadModel() async {
    try {
      final model = await _storage.loadAICache('ml_model');
      if (model != null) {
        _model = model;
        // Rehidratează cheile numerice pentru frecvențe (erau salvate ca String)
        final frequencies = _model['frequencies'];
        if (frequencies is Map<String, dynamic>) {
          final raw = frequencies['raw'];
          if (raw is Map) {
            frequencies['raw'] = raw.map((k, v) {
              final parsed = int.tryParse(k.toString());
              return MapEntry(parsed ?? k, v);
            });
          }
          final normalized = frequencies['normalized'];
          if (normalized is Map) {
            frequencies['normalized'] = normalized.map((k, v) {
              final parsed = int.tryParse(k.toString());
              return MapEntry(parsed ?? k, v);
            });
          }
        }
        _modelTrained = true;
        _lastTraining = DateTime.tryParse(model['trainingDate'] ?? '');
        _storage.logAI('Model încărcat cu succes');
      }
    } catch (e) {
      _storage.logError(
        'Eroare la încărcarea modelului: $e',
        context: 'MLService._loadModel',
      );
    }
  }

  /// Transformă mapa normalizată (chei String sau int) într-un Map<int,double>
  Map<int, double> _normalizedFrequencyMap(Map<String, dynamic> frequencies) {
    final source = frequencies['normalized'];
    final result = <int, double>{};
    if (source is Map) {
      source.forEach((k, v) {
        final keyInt = k is int ? k : int.tryParse(k.toString());
        if (keyInt != null) result[keyInt] = (v as num).toDouble();
      });
    }
    return result;
  }

  // ===== UTILITĂȚI =====

  /// Obține statusul modelului
  Map<String, dynamic> getModelStatus(GameType gameType) {
    return {
      'trained': _modelTrained,
      'gameType': _model['gameType'],
      'lastTraining': _lastTraining?.toIso8601String(),
      'patterns': (_model['patterns'] as Map<String, dynamic>?)?.length ?? 0,
      'frequencies':
          (_model['frequencies'] as Map<String, dynamic>?)?.length ?? 0,
      'correlations':
          (_model['correlations'] as Map<String, dynamic>?)?.length ?? 0,
    };
  }

  /// Șterge modelul
  Future<void> clearModel() async {
    _model = {};
    _modelTrained = false;
    _lastTraining = null;
    await _storage.clearAICache();
    _storage.logAI('Model șters');
  }
}

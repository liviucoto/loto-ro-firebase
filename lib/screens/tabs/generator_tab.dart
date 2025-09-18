import 'package:flutter/material.dart';
import 'package:loto_ro/utils/constants.dart';
import 'package:loto_ro/widgets/glass_card.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/game_selector.dart';
import 'package:confetti/confetti.dart';
import '../../services/ai_generator_service.dart';
import '../../services/storage_service.dart';
import '../../services/ml_service.dart';

// --- Moduri de generare ---
enum GenerationMode { rapid, advanced, custom }

class GeneratorTab extends StatefulWidget {
  final Animation<double> fadeAnimation;

  const GeneratorTab({super.key, required this.fadeAnimation});

  @override
  State<GeneratorTab> createState() => _GeneratorTabState();
}

class _GeneratorTabState extends State<GeneratorTab> {
  int nVariants = 5;
  bool isLoading = false;
  bool isTraining = false;
  List<dynamic> generatedVariants = [];
  List<String> variantJustifications = [];
  List<double> variantScores = [];
  GameType selectedGame = GameType.loto649;
  bool showConfetti = false;
  late ConfettiController _confettiController;
  List<bool> _variantVisible = [];
  String? errorMessage;
  String? modelStatus;
  String? userFeedback;

  // --- ETAPA 2: Noi func?ionalita?i ---
  // Istoric ?i favorite
  List<Map<String, dynamic>> _savedVariants = [];
  List<int> _favoriteVariants = [];

  // Moduri de generare
  GenerationMode _currentMode = GenerationMode.rapid;

  // Parametri avansa?i pentru AI
  bool _preferRareNumbers = false;
  bool _avoidRecentDraws = true;
  bool _balanceEvenOdd = true;
  double _frequencyWeight = 1.0;
  double _balanceWeight = 1.0;
  double _sumWeight = 1.0;
  double _distributionWeight = 1.0;

  // UI state
  bool _showAdvancedSettings = false;
  int? _selectedVariantForDetails;

  // --- ETAPA 3: Servicii noi ---
  final StorageService _storageService = StorageService();
  final MLService _mlService = MLService();

  @override
  void initState() {
    super.initState();
    _confettiController = ConfettiController(
      duration: const Duration(seconds: 2),
    );
    _initializeBackend();
    _initializeServices();
  }

  /// Ini?ializeaza serviciile noi
  Future<void> _initializeServices() async {
    await _storageService.initialize();
    await _mlService.initialize();
    await _loadSavedVariants();
  }

  /// Ini?ializeaza backend-ul automat
  Future<void> _initializeBackend() async {
    print('?? Ini?ializez backend-ul pentru tab-ul Generator...');

    // Verifica daca serviciul AI este disponibil
    final backendRunning = true; // Serviciul local este �ntotdeauna disponibil

    if (backendRunning) {
      print('? Backend-ul ruleaza deja');
      // Ini?ializare instantanee pentru serviciul local
      await Future.delayed(const Duration(milliseconds: 100));
    } else {
      print('?? Backend-ul nu ruleaza');
      setState(() {
        errorMessage = null; // Serviciul local este �ntotdeauna disponibil
      });
    }

    // Ob?ine statusul modelului
    await _fetchModelStatus();
  }

  /// Porne?te backend-ul manual
  Future<void> _startBackendManually() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
    });

    try {
      print('?? Verific backend-ul...');

      // Verifica daca serviciul AI este disponibil
      final backendRunning =
          true; // Serviciul local este �ntotdeauna disponibil

      if (backendRunning) {
        print('? Backend-ul ruleaza deja');
        setState(() {
          errorMessage = null;
        });
        // Ob?ine statusul modelului
        await _fetchModelStatus();
      } else {
        setState(() {
          errorMessage = null; // Serviciul local este �ntotdeauna disponibil
        });
      }
    } catch (e) {
      setState(() {
        errorMessage = 'Eroare la verificarea backend-ului: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  void dispose() {
    _confettiController.dispose();
    super.dispose();
  }

  Future<void> _fetchModelStatus() async {
    setState(() => modelStatus = null);
    final status = await AIGeneratorService().getModelStatus(selectedGame);
    setState(() {
      modelStatus = status['status']?.toString() ?? 'necunoscut';
    });
  }

  /// �ncarca variantele salvate din cache
  Future<void> _loadSavedVariants() async {
    try {
      final variants = await _storageService.loadVariants();
      final favorites = await _storageService.loadFavorites();

      setState(() {
        _savedVariants = variants;
        _favoriteVariants = favorites;
      });
    } catch (e) {
      _storageService.logError('Eroare la �ncarcarea variantelor: $e');
    }
  }

  /// Salveaza o varianta �n istoric
  void _saveVariant(
    Map<String, dynamic> variant,
    double score,
    String justification,
  ) {
    final savedVariant = {
      'variant': variant,
      'score': score,
      'justification': justification,
      'timestamp': DateTime.now().millisecondsSinceEpoch,
      'game': selectedGame.toString(),
    };

    setState(() {
      _savedVariants.insert(0, savedVariant);
      // Limiteaza la ultimele 50 de variante
      if (_savedVariants.length > 50) {
        _savedVariants = _savedVariants.take(50).toList();
      }
    });

    // Salvare �n cache local
    _storageService.saveVariants(_savedVariants);
  }

  /// Adauga/elimina o varianta din favorite
  void _toggleFavorite(int variantIndex) {
    setState(() {
      if (_favoriteVariants.contains(variantIndex)) {
        _favoriteVariants.remove(variantIndex);
      } else {
        _favoriteVariants.add(variantIndex);
      }
    });

    // Salveaza favoritele �n storage
    _storageService.saveFavorites(_favoriteVariants);
  }

  /// Genereaza variante �n func?ie de modul selectat
  Future<void> _generateVariants() async {
    setState(() {
      isLoading = true;
      errorMessage = null;
      generatedVariants = [];
      variantJustifications = [];
      variantScores = [];
      _variantVisible = [];
      userFeedback = null;
    });

    try {
      // Log generare cu serviciul ML
      _storageService.logAI(
        '�ncepe generarea variantelor',
        data: {
          'gameType': selectedGame.toString(),
          'nVariants': nVariants,
          'mode': _currentMode.toString(),
        },
      );

      Map<String, dynamic> params = {
        'game': selectedGame,
        'nVariants': nVariants,
        'useAI': true,
        'balanceEvenOdd': _balanceEvenOdd,
      };

      // Parametri avansa?i �n func?ie de modul selectat
      switch (_currentMode) {
        case GenerationMode.rapid:
          params['preferRareNumbers'] = false;
          params['avoidRecentDraws'] = false;
          params['strategy'] = 'balanced';
          break;
        case GenerationMode.advanced:
          params['preferRareNumbers'] = _preferRareNumbers;
          params['avoidRecentDraws'] = _avoidRecentDraws;
          params['strategy'] = _preferRareNumbers
              ? 'frequency_based'
              : 'balanced';
          break;
        case GenerationMode.custom:
          params['preferRareNumbers'] = _preferRareNumbers;
          params['avoidRecentDraws'] = _avoidRecentDraws;
          params['frequencyWeight'] = _frequencyWeight;
          params['balanceWeight'] = _balanceWeight;
          params['sumWeight'] = _sumWeight;
          params['distributionWeight'] = _distributionWeight;
          params['strategy'] = 'balanced';
          break;
      }

      // Folose?te serviciul ML pentru generare
      final mlPredictions = await _mlService.generatePredictions(
        selectedGame,
        nVariants,
        params,
      );

      if (mlPredictions.isNotEmpty) {
        // Converte?te predic?iile ML la formatul a?teptat
        final variants = mlPredictions.map((prediction) {
          final numbers = prediction['numbers'] as List<int>;
          final score = prediction['score'] as double;
          final strategy = prediction['strategy'] as String;
          final confidence = prediction['confidence'] as double;

          return {
            'numbers': numbers,
            'joker': null, // Pentru moment, nu generam joker
            'total_score': score,
            'justification': _generateMLJustification(
              strategy,
              confidence,
              numbers,
            ),
            'scores': {
              'frequency': confidence,
              'balance': _calculateBalanceScore(numbers),
              'sum': _calculateSumScore(numbers),
              'distribution': _calculateDistributionScore(numbers),
            },
          };
        }).toList();

        setState(() {
          generatedVariants = variants;
          variantJustifications = variants
              .map((v) => v['justification']?.toString() ?? '')
              .toList();
          variantScores = variants
              .map((v) => (v['total_score'] as num?)?.toDouble() ?? 0.0)
              .toList();
          _variantVisible = List.filled(variants.length, false);
          userFeedback =
              'Algoritm ML folosit: ${_getModeDisplayName()} (${mlPredictions.length} variante generate)';
        });

        // Log generare cu succes
        _storageService.logGeneration(
          selectedGame.toString(),
          nVariants,
          params,
          variants,
        );

        // Salveaza variantele �n istoric
        for (int i = 0; i < variants.length; i++) {
          _saveVariant(variants[i], variantScores[i], variantJustifications[i]);
        }

        _confettiController.play();
        await Future.delayed(const Duration(milliseconds: 800));
        for (int i = 0; i < _variantVisible.length; i++) {
          await Future.delayed(const Duration(milliseconds: 120));
          if (mounted) setState(() => _variantVisible[i] = true);
        }
        await Future.delayed(const Duration(milliseconds: 1000));
        setState(() {
          showConfetti = false;
        });
      } else {
        // Fallback la serviciul AI original
        final result = await AIGeneratorService().generateVariants(
          game: params['game'],
          nVariants: params['nVariants'],
          useAI: params['useAI'],
          balanceEvenOdd: params['balanceEvenOdd'],
        );

        if (result['variants'] != null) {
          final variants = result['variants'] as List<Map<String, dynamic>>;
          setState(() {
            generatedVariants = variants;
            variantJustifications = variants
                .map((v) => v['justification']?.toString() ?? '')
                .toList();
            variantScores = variants
                .map((v) => (v['total_score'] as num?)?.toDouble() ?? 0.0)
                .toList();
            _variantVisible = List.filled(variants.length, false);
            userFeedback = result['algorithm_used'] != null
                ? 'Algoritm folosit: ${result['algorithm_used']} (${_getModeDisplayName()})'
                : null;
          });

          // Salveaza variantele �n istoric
          for (int i = 0; i < variants.length; i++) {
            _saveVariant(
              variants[i],
              variantScores[i],
              variantJustifications[i],
            );
          }

          _confettiController.play();
          await Future.delayed(const Duration(milliseconds: 800));
          for (int i = 0; i < _variantVisible.length; i++) {
            await Future.delayed(const Duration(milliseconds: 120));
            if (mounted) setState(() => _variantVisible[i] = true);
          }
          await Future.delayed(const Duration(milliseconds: 1000));
          setState(() {
            showConfetti = false;
          });
        } else {
          setState(() {
            errorMessage = 'Nu s-au putut genera variante. �ncearca din nou!';
          });
        }
      }
    } catch (e) {
      _storageService.logError(
        'Eroare la generare: $e',
        context: 'GeneratorTab._generateVariants',
      );
      setState(() {
        errorMessage = 'Eroare la generare: $e';
      });
    } finally {
      setState(() {
        isLoading = false;
      });
    }
  }

  /// Returneaza numele de afi?are pentru modul curent
  String _getModeDisplayName() {
    switch (_currentMode) {
      case GenerationMode.rapid:
        return 'Rapid';
      case GenerationMode.advanced:
        return 'Avansat';
      case GenerationMode.custom:
        return 'Personalizat';
    }
  }

  /// Deschide dialogul cu detalii pentru o varianta
  void _showVariantDetails(int variantIndex) {
    setState(() {
      _selectedVariantForDetails = variantIndex;
    });

    showDialog(
      context: context,
      builder: (context) => _VariantDetailsDialog(
        variant: generatedVariants[variantIndex],
        score: variantScores[variantIndex],
        justification: variantJustifications[variantIndex],
        gameType: selectedGame,
      ),
    ).then((_) {
      setState(() {
        _selectedVariantForDetails = null;
      });
    });
  }

  /// Verifica diversitatea variantelor generate
  bool _checkVariantsDiversity() {
    if (generatedVariants.length < 2) return true;

    // Calculeaza similaritatea �ntre variante
    double totalSimilarity = 0;
    int comparisons = 0;

    for (int i = 0; i < generatedVariants.length; i++) {
      for (int j = i + 1; j < generatedVariants.length; j++) {
        final numbers1 = (generatedVariants[i]['numbers'] as List<dynamic>)
            .cast<int>();
        final numbers2 = (generatedVariants[j]['numbers'] as List<dynamic>)
            .cast<int>();

        int commonNumbers = numbers1.where((n) => numbers2.contains(n)).length;
        double similarity = commonNumbers / numbers1.length;
        totalSimilarity += similarity;
        comparisons++;
      }
    }

    double averageSimilarity = totalSimilarity / comparisons;
    return averageSimilarity <
        0.3; // Variantele sunt diverse daca similaritatea < 30%
  }

  /// Genereaza justificarea pentru predic?iile ML
  String _generateMLJustification(
    String strategy,
    double confidence,
    List<int> numbers,
  ) {
    final sum = numbers.fold(0, (a, b) => a + b);
    final even = numbers.where((n) => n % 2 == 0).length;
    final odd = numbers.length - even;

    String strategyName = '';
    switch (strategy) {
      case 'frequency_based':
        strategyName = 'bazat pe frecven?a';
        break;
      case 'pattern_based':
        strategyName = 'bazat pe pattern-uri';
        break;
      case 'correlation_based':
        strategyName = 'bazat pe corela?ii';
        break;
      default:
        strategyName = 'echilibrat';
    }

    return 'Predic?ie ML ($strategyName) - �ncredere: ${(confidence * 100).toStringAsFixed(1)}% | Suma: $sum | Pare/Impare: $even/$odd';
  }

  /// Calculeaza scorul de balan?a pentru numere
  double _calculateBalanceScore(List<int> numbers) {
    final even = numbers.where((n) => n % 2 == 0).length;
    final balance = even / numbers.length;
    return balance;
  }

  /// Calculeaza scorul pentru suma
  double _calculateSumScore(List<int> numbers) {
    final sum = numbers.fold(0, (a, b) => a + b);
    final avg = sum / numbers.length;
    return avg / 50.0; // Normalizat la 50
  }

  /// Calculeaza scorul pentru distribu?ie
  double _calculateDistributionScore(List<int> numbers) {
    final sorted = List<int>.from(numbers)..sort();
    double totalGap = 0;
    for (int i = 1; i < sorted.length; i++) {
      totalGap += sorted[i] - sorted[i - 1];
    }
    final avgGap = totalGap / (sorted.length - 1);
    return avgGap / 10.0; // Normalizat la 10
  }

  Future<void> _trainModel() async {
    setState(() {
      isTraining = true;
      errorMessage = null;
    });
    try {
      // Folose?te serviciul ML pentru antrenare
      final result = await _mlService.trainModel(selectedGame);
      if (result['status'] == 'trained') {
        setState(() {
          modelStatus = 'trained';
          userFeedback =
              'Modelul ML a fost antrenat cu succes! (${result['patterns']} pattern-uri, ${result['frequencies']} frecven?e, ${result['correlations']} corela?ii)';
        });

        // Log antrenare cu succes
        _storageService.logAI('Model antrenat cu succes', data: result);
      } else {
        setState(() {
          errorMessage =
              'Antrenarea modelului ML a e?uat: ${result['message']}';
        });
      }
    } catch (e) {
      _storageService.logError(
        'Eroare la antrenare: $e',
        context: 'GeneratorTab._trainModel',
      );
      setState(() {
        errorMessage = 'Eroare la antrenare: $e';
      });
    } finally {
      setState(() {
        isTraining = false;
      });
    }
  }

  void _clearGenerator() {
    setState(() {
      generatedVariants = [];
      variantJustifications = [];
      variantScores = [];
      _variantVisible = [];
      showConfetti = false;
      isLoading = false;
      errorMessage = null;
      userFeedback = null;
    });
  }

  // --- ADAUGARE: Func?ie narativa detaliata pentru fiecare varianta ---
  String _generateVariantNarrative(Map<String, dynamic> variant) {
    final mainNumbers = (variant['numbers'] as List<dynamic>? ?? [])
        .cast<int>();
    final joker = variant['joker'];
    final scores = variant['scores'] as Map<String, dynamic>? ?? {};
    final sum = mainNumbers.fold(0, (a, b) => a + b);
    final even = mainNumbers.where((n) => n % 2 == 0).length;
    final odd = mainNumbers.length - even;
    String nar = 'Suma: $sum | Pare/Impare: $even/$odd';
    if (joker != null) nar += ' | Joker: $joker';
    if (scores.isNotEmpty) {
      nar +=
          ' | Frecven?a: ${scores['frequency']?.toStringAsFixed(2) ?? '-'} | Balan?a: ${scores['balance']?.toStringAsFixed(2) ?? '-'} | Suma: ${scores['sum']?.toStringAsFixed(2) ?? '-'} | Distribu?ie: ${scores['distribution']?.toStringAsFixed(2) ?? '-'}';
    }
    return nar;
  }

  @override
  Widget build(BuildContext context) {
    return AnimatedBuilder(
      animation: widget.fadeAnimation,
      builder: (context, child) {
        return Opacity(
          opacity: widget.fadeAnimation.value,
          child: Padding(
            padding: const EdgeInsets.all(AppSizes.paddingMedium),
            child: Stack(
              children: [
                SingleChildScrollView(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      GlassCard(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            GameSelector(
                              selectedGame: selectedGame,
                              onGameChanged: (g) {
                                setState(() {
                                  selectedGame = g;
                                });
                                _clearGenerator();
                                _fetchModelStatus();
                              },
                            ),
                            const SizedBox(height: 12),
                            Column(
                              children: [
                                // Primul r�nd: Numar variante
                                Row(
                                  children: [
                                    Text(
                                      'Numar variante:',
                                      style: AppFonts.bodyStyle,
                                    ),
                                    const SizedBox(width: 8),
                                    IconButton(
                                      icon: const Icon(Icons.remove),
                                      onPressed: nVariants > 1
                                          ? () => setState(() => nVariants--)
                                          : null,
                                    ),
                                    Text(
                                      '$nVariants',
                                      style: AppFonts.bodyStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                      ),
                                    ),
                                    IconButton(
                                      icon: const Icon(Icons.add),
                                      onPressed: nVariants < 10
                                          ? () => setState(() => nVariants++)
                                          : null,
                                    ),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                // Al doilea r�nd: Status model ?i butoane
                                Row(
                                  children: [
                                    if (modelStatus != null)
                                      Expanded(
                                        child: Container(
                                          padding: const EdgeInsets.symmetric(
                                            horizontal: 10,
                                            vertical: 4,
                                          ),
                                          decoration: BoxDecoration(
                                            color: modelStatus == 'trained'
                                                ? Colors.green.withValues(
                                                    alpha: 0.18,
                                                  )
                                                : Colors.orange.withValues(
                                                    alpha: 0.18,
                                                  ),
                                            borderRadius: BorderRadius.circular(
                                              8,
                                            ),
                                          ),
                                          child: Text(
                                            'Model: $modelStatus',
                                            style: TextStyle(
                                              fontSize: 12,
                                              color: Colors.black87,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ),
                                    const SizedBox(width: 8),
                                    GlassButton(
                                      onTap: isTraining ? null : _trainModel,
                                      child: Row(
                                        mainAxisSize: MainAxisSize.min,
                                        children: [
                                          if (isTraining) ...[
                                            SizedBox(
                                              width: 16,
                                              height: 16,
                                              child: CircularProgressIndicator(
                                                strokeWidth: 2,
                                              ),
                                            ),
                                            SizedBox(width: 8),
                                            Text('Antrenez...'),
                                          ] else ...[
                                            Icon(Icons.auto_fix_high, size: 18),
                                            SizedBox(width: 8),
                                            Text('Antreneaza AI'),
                                          ],
                                        ],
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                            const SizedBox(height: 10),

                            // --- ETAPA 2: Moduri de generare ---
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text(
                                  'Mod generare:',
                                  style: AppFonts.bodyStyle.copyWith(
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                                const SizedBox(height: 8),
                                Row(
                                  children: [
                                    _GenerationModeButton(
                                      mode: GenerationMode.rapid,
                                      currentMode: _currentMode,
                                      icon: Icons.flash_on,
                                      label: 'Rapid',
                                      tooltip:
                                          'Generare rapida cu setari implicite',
                                      onTap: () => setState(
                                        () =>
                                            _currentMode = GenerationMode.rapid,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _GenerationModeButton(
                                      mode: GenerationMode.advanced,
                                      currentMode: _currentMode,
                                      icon: Icons.tune,
                                      label: 'Avansat',
                                      tooltip: 'Generare cu parametri avansa?i',
                                      onTap: () => setState(
                                        () => _currentMode =
                                            GenerationMode.advanced,
                                      ),
                                    ),
                                    const SizedBox(width: 8),
                                    _GenerationModeButton(
                                      mode: GenerationMode.custom,
                                      currentMode: _currentMode,
                                      icon: Icons.settings,
                                      label: 'Personalizat',
                                      tooltip:
                                          'Generare cu parametri personaliza?i',
                                      onTap: () => setState(
                                        () => _currentMode =
                                            GenerationMode.custom,
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),

                            // --- Parametri avansa?i ---
                            if (_currentMode == GenerationMode.advanced ||
                                _currentMode == GenerationMode.custom)
                              Padding(
                                padding: const EdgeInsets.only(top: 12),
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text(
                                          'Parametri AI:',
                                          style: AppFonts.bodyStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const Spacer(),
                                        IconButton(
                                          icon: Icon(
                                            _showAdvancedSettings
                                                ? Icons.expand_less
                                                : Icons.expand_more,
                                            size: 18,
                                          ),
                                          onPressed: () => setState(() {
                                            _showAdvancedSettings =
                                                !_showAdvancedSettings;
                                          }),
                                        ),
                                      ],
                                    ),
                                    if (_showAdvancedSettings) ...[
                                      const SizedBox(height: 8),
                                      _AdvancedParameterSwitch(
                                        label: 'Prefera numere rare',
                                        value: _preferRareNumbers,
                                        onChanged: (value) => setState(
                                          () => _preferRareNumbers = value,
                                        ),
                                        tooltip:
                                            'Genereaza numere care apar mai rar �n istoric',
                                      ),
                                      _AdvancedParameterSwitch(
                                        label: 'Evita ultimele extrageri',
                                        value: _avoidRecentDraws,
                                        onChanged: (value) => setState(
                                          () => _avoidRecentDraws = value,
                                        ),
                                        tooltip:
                                            'Evita numerele din ultimele extrageri',
                                      ),
                                      _AdvancedParameterSwitch(
                                        label: 'Balan?a pare/impare',
                                        value: _balanceEvenOdd,
                                        onChanged: (value) => setState(
                                          () => _balanceEvenOdd = value,
                                        ),
                                        tooltip:
                                            '�ncearca sa balanseze numerele pare ?i impare',
                                      ),
                                      if (_currentMode ==
                                          GenerationMode.custom) ...[
                                        const SizedBox(height: 8),
                                        Text(
                                          'Ponderi scoruri:',
                                          style: AppFonts.captionStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                          ),
                                        ),
                                        const SizedBox(height: 4),
                                        _WeightSlider(
                                          label: 'Frecven?a',
                                          value: _frequencyWeight,
                                          onChanged: (value) => setState(
                                            () => _frequencyWeight = value,
                                          ),
                                        ),
                                        _WeightSlider(
                                          label: 'Balan?a',
                                          value: _balanceWeight,
                                          onChanged: (value) => setState(
                                            () => _balanceWeight = value,
                                          ),
                                        ),
                                        _WeightSlider(
                                          label: 'Suma',
                                          value: _sumWeight,
                                          onChanged: (value) => setState(
                                            () => _sumWeight = value,
                                          ),
                                        ),
                                        _WeightSlider(
                                          label: 'Distribu?ie',
                                          value: _distributionWeight,
                                          onChanged: (value) => setState(
                                            () => _distributionWeight = value,
                                          ),
                                        ),
                                      ],
                                    ],
                                  ],
                                ),
                              ),

                            // Buton pentru verificarea serviciului AI
                            if (modelStatus == 'unavailable' ||
                                modelStatus == null)
                              Padding(
                                padding: const EdgeInsets.only(bottom: 8),
                                child: GlassButton(
                                  onTap: isLoading
                                      ? null
                                      : _startBackendManually,
                                  child: Row(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Icon(Icons.refresh, size: 18),
                                      SizedBox(width: 8),
                                      Text('Verifica AI'),
                                    ],
                                  ),
                                ),
                              ),
                            GlassButton(
                              onTap: isLoading ? null : _generateVariants,
                              child: Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  if (isLoading) ...[
                                    SizedBox(
                                      width: 16,
                                      height: 16,
                                      child: CircularProgressIndicator(
                                        strokeWidth: 2,
                                      ),
                                    ),
                                    SizedBox(width: 8),
                                    Text('Generez...'),
                                  ] else ...[
                                    Icon(Icons.auto_awesome, size: 18),
                                    SizedBox(width: 8),
                                    Text('Genereaza variante AI'),
                                  ],
                                ],
                              ),
                            ),
                            if (errorMessage != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  errorMessage!,
                                  style: TextStyle(
                                    color: Colors.red,
                                    fontWeight: FontWeight.bold,
                                  ),
                                ),
                              ),
                            if (userFeedback != null)
                              Padding(
                                padding: const EdgeInsets.only(top: 10),
                                child: Text(
                                  userFeedback!,
                                  style: TextStyle(
                                    color: Colors.blueGrey,
                                    fontWeight: FontWeight.w600,
                                  ),
                                ),
                              ),
                          ],
                        ),
                      ),
                      const SizedBox(height: 18),
                      if (generatedVariants.isNotEmpty)
                        ...List.generate(generatedVariants.length, (i) {
                          final variant = generatedVariants[i];
                          final score = variantScores.length > i
                              ? variantScores[i]
                              : 0.0;
                          final justification = variantJustifications.length > i
                              ? variantJustifications[i]
                              : '';
                          final mainNumbers =
                              variant['numbers'] as List<dynamic>? ?? [];
                          final joker = variant['joker'];
                          final scores =
                              variant['scores'] as Map<String, dynamic>? ?? {};
                          final nar = _generateVariantNarrative(variant);
                          return AnimatedOpacity(
                            opacity: _variantVisible[i] ? 1.0 : 0.0,
                            duration: const Duration(milliseconds: 500),
                            child: GlassCard(
                              margin: const EdgeInsets.symmetric(vertical: 10),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 10,
                                          vertical: 4,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.deepOrangeAccent
                                              .withValues(alpha: 0.18),
                                          borderRadius: BorderRadius.circular(
                                            8,
                                          ),
                                        ),
                                        child: Text(
                                          'VARIANTA ${i + 1}',
                                          style: AppFonts.bodyStyle.copyWith(
                                            fontWeight: FontWeight.bold,
                                            fontSize: 14,
                                            color: Colors.deepOrangeAccent,
                                          ),
                                        ),
                                      ),
                                      const Spacer(),
                                      Container(
                                        padding: const EdgeInsets.symmetric(
                                          horizontal: 7,
                                          vertical: 2,
                                        ),
                                        decoration: BoxDecoration(
                                          color: Colors.amber.withValues(
                                            alpha: 0.18,
                                          ),
                                          borderRadius: BorderRadius.circular(
                                            10,
                                          ),
                                        ),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(
                                              Icons.star,
                                              color: Colors.amber,
                                              size: 14,
                                            ),
                                            const SizedBox(width: 2),
                                            Text(
                                              score.toStringAsFixed(2),
                                              style: TextStyle(
                                                fontSize: 12,
                                                fontWeight: FontWeight.bold,
                                                color: Colors.amber,
                                              ),
                                            ),
                                          ],
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 16),
                                  SingleChildScrollView(
                                    scrollDirection: Axis.horizontal,
                                    child: Row(
                                      children: [
                                        ...mainNumbers.map(
                                          (n) => Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            child: GlassCard(
                                              backgroundColor: Colors.white
                                                  .withValues(alpha: 0.7),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12,
                                                  ),
                                              child: Text(
                                                '$n',
                                                style: AppFonts.bodyStyle
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors
                                                          .deepOrangeAccent,
                                                    ),
                                              ),
                                            ),
                                          ),
                                        ),
                                        if (joker != null)
                                          Padding(
                                            padding: const EdgeInsets.symmetric(
                                              horizontal: 4,
                                            ),
                                            child: GlassCard(
                                              backgroundColor: Colors.purple
                                                  .withValues(alpha: 0.18),
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                    vertical: 8,
                                                    horizontal: 12,
                                                  ),
                                              child: Text(
                                                'J: $joker',
                                                style: AppFonts.bodyStyle
                                                    .copyWith(
                                                      fontWeight:
                                                          FontWeight.bold,
                                                      fontSize: 18,
                                                      color: Colors.purple,
                                                    ),
                                              ),
                                            ),
                                          ),
                                      ],
                                    ),
                                  ),
                                  const SizedBox(height: 12),
                                  // --- Breakdown vizual scoruri ---
                                  if (scores.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(bottom: 8),
                                      child: Row(
                                        children: [
                                          _ScoreBar(
                                            label: 'Frecven?a',
                                            value:
                                                (scores['frequency'] ?? 0.0)
                                                    as double,
                                            icon: Icons.trending_up,
                                            color: Colors.blueAccent,
                                            tooltip:
                                                'C�t de frecvente sunt numerele generate',
                                          ),
                                          _ScoreBar(
                                            label: 'Balan?a',
                                            value:
                                                (scores['balance'] ?? 0.0)
                                                    as double,
                                            icon: Icons.balance,
                                            color: Colors.green,
                                            tooltip: 'Balan?a pare/impare',
                                          ),
                                          _ScoreBar(
                                            label: 'Suma',
                                            value:
                                                (scores['sum'] ?? 0.0)
                                                    as double,
                                            icon: Icons.summarize,
                                            color: Colors.orange,
                                            tooltip:
                                                'C�t de aproape e suma de media istorica',
                                          ),
                                          _ScoreBar(
                                            label: 'Distribu?ie',
                                            value:
                                                (scores['distribution'] ?? 0.0)
                                                    as double,
                                            icon: Icons.scatter_plot,
                                            color: Colors.purple,
                                            tooltip:
                                                'Distribu?ia numerelor pe intervale',
                                          ),
                                        ],
                                      ),
                                    ),
                                  // --- Narativa detaliata ---
                                  if (nar.isNotEmpty)
                                    Container(
                                      width: double.infinity,
                                      decoration: BoxDecoration(
                                        color: Colors.grey[100],
                                        borderRadius: BorderRadius.circular(8),
                                      ),
                                      padding: const EdgeInsets.symmetric(
                                        horizontal: 10,
                                        vertical: 8,
                                      ),
                                      child: Row(
                                        children: [
                                          Icon(
                                            Icons.info_outline,
                                            color: Colors.grey,
                                            size: 16,
                                          ),
                                          const SizedBox(width: 6),
                                          Expanded(
                                            child: Text(
                                              nar,
                                              style: AppFonts.captionStyle
                                                  .copyWith(
                                                    fontSize: 12,
                                                    color: Colors.black87,
                                                  ),
                                            ),
                                          ),
                                        ],
                                      ),
                                    ),
                                  if (justification.isNotEmpty)
                                    Padding(
                                      padding: const EdgeInsets.only(top: 4),
                                      child: Text(
                                        justification,
                                        style: AppFonts.captionStyle.copyWith(
                                          fontSize: 11,
                                          color: Colors.blueGrey,
                                        ),
                                      ),
                                    ),

                                  // --- ETAPA 2: Buton "Explica aceasta varianta" ---
                                  const SizedBox(height: 8),
                                  Row(
                                    children: [
                                      GlassButton(
                                        onTap: () => _showVariantDetails(i),
                                        child: Row(
                                          mainAxisSize: MainAxisSize.min,
                                          children: [
                                            Icon(Icons.analytics, size: 16),
                                            const SizedBox(width: 4),
                                            Text('Explica aceasta varianta'),
                                          ],
                                        ),
                                      ),
                                      const Spacer(),
                                      // Buton pentru favorite
                                      IconButton(
                                        icon: Icon(
                                          _favoriteVariants.contains(i)
                                              ? Icons.favorite
                                              : Icons.favorite_border,
                                          color: _favoriteVariants.contains(i)
                                              ? Colors.red
                                              : Colors.grey,
                                        ),
                                        onPressed: () => _toggleFavorite(i),
                                        tooltip: _favoriteVariants.contains(i)
                                            ? 'Elimina din favorite'
                                            : 'Adauga la favorite',
                                      ),
                                    ],
                                  ),
                                ],
                              ),
                            ),
                          );
                        }),
                      if (generatedVariants.isNotEmpty) ...[
                        // --- ETAPA 2: Feedback vizual pentru diversitate ---
                        if (generatedVariants.length > 1)
                          Padding(
                            padding: const EdgeInsets.only(bottom: 8),
                            child: GlassCard(
                              backgroundColor: _checkVariantsDiversity()
                                  ? Colors.green.withValues(alpha: 0.1)
                                  : Colors.orange.withValues(alpha: 0.1),
                              child: Padding(
                                padding: const EdgeInsets.all(12),
                                child: Row(
                                  children: [
                                    Icon(
                                      _checkVariantsDiversity()
                                          ? Icons.check_circle
                                          : Icons.warning,
                                      color: _checkVariantsDiversity()
                                          ? Colors.green
                                          : Colors.orange,
                                      size: 20,
                                    ),
                                    const SizedBox(width: 8),
                                    Expanded(
                                      child: Text(
                                        _checkVariantsDiversity()
                                            ? 'Variantele sunt diverse ?i bine distribuite'
                                            : 'Aten?ie: Variantele sunt prea similare',
                                        style: AppFonts.captionStyle.copyWith(
                                          fontWeight: FontWeight.w500,
                                          color: _checkVariantsDiversity()
                                              ? Colors.green
                                              : Colors.orange,
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),

                        Padding(
                          padding: const EdgeInsets.only(bottom: 16),
                          child: _GeneratedNumbersHeatmap(
                            variants: generatedVariants,
                            selectedGame: selectedGame,
                          ),
                        ),
                      ],
                    ],
                  ),
                ),
                if (isLoading) Center(child: CircularProgressIndicator()),
                Align(
                  alignment: Alignment.topCenter,
                  child: ConfettiWidget(
                    confettiController: _confettiController,
                    blastDirectionality: BlastDirectionality.explosive,
                    shouldLoop: false,
                    colors: const [
                      Colors.deepOrangeAccent,
                      Colors.amber,
                      Colors.green,
                      Colors.purple,
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}

// --- Widget breakdown scoruri ---
class _ScoreBar extends StatelessWidget {
  final String label;
  final double value;
  final IconData icon;
  final Color color;
  final String tooltip;

  const _ScoreBar({
    required this.label,
    required this.value,
    required this.icon,
    required this.color,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 4),
        child: Column(
          children: [
            Icon(icon, color: color, size: 18),
            SizedBox(
              width: 32,
              child: LinearProgressIndicator(
                value: value / 3.0,
                minHeight: 5,
                backgroundColor: color.withValues(alpha: 0.15),
                valueColor: AlwaysStoppedAnimation<Color>(color),
              ),
            ),
            Text(
              value.toStringAsFixed(1),
              style: TextStyle(fontSize: 10, color: color),
            ),
          ],
        ),
      ),
    );
  }
}

// --- Widget heatmap pentru frecven?a numerelor generate ---
class _GeneratedNumbersHeatmap extends StatelessWidget {
  final List<dynamic> variants;
  final GameType selectedGame;

  const _GeneratedNumbersHeatmap({
    required this.variants,
    required this.selectedGame,
  });

  @override
  Widget build(BuildContext context) {
    if (variants.isEmpty) return SizedBox.shrink();
    final config = AIGeneratorService
        .gameConfigs[selectedGame.toString().split('.').last.toLowerCase()]!;
    final maxNumber = config['maxNumbers']!;
    final freq = <int, int>{for (int n = 1; n <= maxNumber; n++) n: 0};
    for (final variant in variants) {
      final numbers = (variant['numbers'] as List<dynamic>? ?? []).cast<int>();
      for (final n in numbers) {
        freq[n] = (freq[n] ?? 0) + 1;
      }
    }
    final maxFreq = freq.values.isNotEmpty
        ? freq.values.reduce((a, b) => a > b ? a : b)
        : 1;
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.only(left: 4, bottom: 4),
          child: Text(
            'Heatmap frecven?a numere generate:',
            style: AppFonts.captionStyle.copyWith(
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: List.generate(maxNumber, (i) {
              final n = i + 1;
              final f = freq[n] ?? 0;
              final color = Color.lerp(
                Colors.white,
                Colors.deepOrangeAccent,
                f / (maxFreq == 0 ? 1 : maxFreq),
              )!;
              return Tooltip(
                message: 'Numarul $n: $f apari?ii',
                child: Container(
                  width: 18,
                  height: 32,
                  margin: const EdgeInsets.symmetric(horizontal: 1),
                  decoration: BoxDecoration(
                    color: color,
                    borderRadius: BorderRadius.circular(4),
                    border: Border.all(
                      color: Colors.deepOrangeAccent.withValues(alpha: 0.18),
                    ),
                  ),
                  child: Center(
                    child: Text(
                      '$n',
                      style: TextStyle(
                        fontSize: 10,
                        color: f > 0
                            ? Colors.white
                            : Colors.deepOrangeAccent.withValues(alpha: 0.5),
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ),
                ),
              );
            }),
          ),
        ),
      ],
    );
  }
}

// --- Dialog cu detalii pentru o varianta ---
class _VariantDetailsDialog extends StatelessWidget {
  final Map<String, dynamic> variant;
  final double score;
  final String justification;
  final GameType gameType;

  const _VariantDetailsDialog({
    required this.variant,
    required this.score,
    required this.justification,
    required this.gameType,
  });

  @override
  Widget build(BuildContext context) {
    final mainNumbers = (variant['numbers'] as List<dynamic>? ?? [])
        .cast<int>();
    final joker = variant['joker'];
    final scores = variant['scores'] as Map<String, dynamic>? ?? {};
    final sum = mainNumbers.fold(0, (a, b) => a + b);
    final even = mainNumbers.where((n) => n % 2 == 0).length;
    final odd = mainNumbers.length - even;

    return Dialog(
      backgroundColor: Colors.transparent,
      child: GlassCard(
        child: Padding(
          padding: const EdgeInsets.all(20),
          child: Column(
            mainAxisSize: MainAxisSize.min,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                children: [
                  Icon(Icons.analytics, color: Colors.deepOrangeAccent),
                  const SizedBox(width: 8),
                  Text(
                    'Detalii Varianta',
                    style: AppFonts.titleStyle.copyWith(
                      color: Colors.deepOrangeAccent,
                    ),
                  ),
                  const Spacer(),
                  IconButton(
                    icon: Icon(Icons.close),
                    onPressed: () => Navigator.of(context).pop(),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Numerele
              Text(
                'Numere:',
                style: AppFonts.bodyStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              Wrap(
                spacing: 8,
                children: [
                  ...mainNumbers.map(
                    (n) => GlassCard(
                      backgroundColor: Colors.white.withValues(alpha: 0.7),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Text(
                        '$n',
                        style: AppFonts.bodyStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.deepOrangeAccent,
                        ),
                      ),
                    ),
                  ),
                  if (joker != null)
                    GlassCard(
                      backgroundColor: Colors.purple.withValues(alpha: 0.18),
                      padding: const EdgeInsets.symmetric(
                        vertical: 8,
                        horizontal: 12,
                      ),
                      child: Text(
                        'J: $joker',
                        style: AppFonts.bodyStyle.copyWith(
                          fontWeight: FontWeight.bold,
                          fontSize: 18,
                          color: Colors.purple,
                        ),
                      ),
                    ),
                ],
              ),
              const SizedBox(height: 16),

              // Scorul total
              Row(
                children: [
                  Icon(Icons.star, color: Colors.amber, size: 20),
                  const SizedBox(width: 8),
                  Text(
                    'Scor total: ${score.toStringAsFixed(2)}',
                    style: AppFonts.bodyStyle.copyWith(
                      fontWeight: FontWeight.bold,
                      color: Colors.amber,
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 16),

              // Statistici
              Text(
                'Statistici:',
                style: AppFonts.bodyStyle.copyWith(fontWeight: FontWeight.bold),
              ),
              const SizedBox(height: 8),
              _DetailRow('Suma', '$sum'),
              _DetailRow('Pare/Impare', '$even/$odd'),
              if (joker != null) _DetailRow('Joker', '$joker'),
              const SizedBox(height: 16),

              // Breakdown scoruri
              if (scores.isNotEmpty) ...[
                Text(
                  'Breakdown scoruri:',
                  style: AppFonts.bodyStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                _DetailRow(
                  'Frecven?a',
                  '${(scores['frequency'] ?? 0.0).toStringAsFixed(2)}',
                ),
                _DetailRow(
                  'Balan?a',
                  '${(scores['balance'] ?? 0.0).toStringAsFixed(2)}',
                ),
                _DetailRow(
                  'Suma',
                  '${(scores['sum'] ?? 0.0).toStringAsFixed(2)}',
                ),
                _DetailRow(
                  'Distribu?ie',
                  '${(scores['distribution'] ?? 0.0).toStringAsFixed(2)}',
                ),
                const SizedBox(height: 16),
              ],

              // Justificare
              if (justification.isNotEmpty) ...[
                Text(
                  'Justificare:',
                  style: AppFonts.bodyStyle.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 8),
                Text(
                  justification,
                  style: AppFonts.captionStyle.copyWith(color: Colors.blueGrey),
                ),
              ],
            ],
          ),
        ),
      ),
    );
  }
}

// --- Widget pentru r�nd de detalii ---
class _DetailRow extends StatelessWidget {
  final String label;
  final String value;

  const _DetailRow(this.label, this.value);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 2),
      child: Row(
        children: [
          Text(
            '$label:',
            style: AppFonts.captionStyle.copyWith(fontWeight: FontWeight.w500),
          ),
          const SizedBox(width: 8),
          Text(
            value,
            style: AppFonts.captionStyle.copyWith(fontWeight: FontWeight.bold),
          ),
        ],
      ),
    );
  }
}

// --- Widget pentru butonul modului de generare ---
class _GenerationModeButton extends StatelessWidget {
  final GenerationMode mode;
  final GenerationMode currentMode;
  final IconData icon;
  final String label;
  final String tooltip;
  final VoidCallback onTap;

  const _GenerationModeButton({
    required this.mode,
    required this.currentMode,
    required this.icon,
    required this.label,
    required this.tooltip,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    final isSelected = mode == currentMode;
    return Tooltip(
      message: tooltip,
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.deepOrangeAccent.withValues(alpha: 0.18)
                : Colors.grey.withValues(alpha: 0.1),
            borderRadius: BorderRadius.circular(8),
            border: Border.all(
              color: isSelected
                  ? Colors.deepOrangeAccent
                  : Colors.grey.withValues(alpha: 0.3),
            ),
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                size: 16,
                color: isSelected ? Colors.deepOrangeAccent : Colors.grey,
              ),
              const SizedBox(width: 4),
              Text(
                label,
                style: AppFonts.captionStyle.copyWith(
                  fontWeight: isSelected ? FontWeight.bold : FontWeight.normal,
                  color: isSelected ? Colors.deepOrangeAccent : Colors.grey,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// --- Widget pentru switch-ul parametrilor avansa?i ---
class _AdvancedParameterSwitch extends StatelessWidget {
  final String label;
  final bool value;
  final ValueChanged<bool> onChanged;
  final String tooltip;

  const _AdvancedParameterSwitch({
    required this.label,
    required this.value,
    required this.onChanged,
    required this.tooltip,
  });

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: Padding(
        padding: const EdgeInsets.symmetric(vertical: 4),
        child: Row(
          children: [
            Expanded(child: Text(label, style: AppFonts.captionStyle)),
            Switch(
              value: value,
              onChanged: onChanged,
              activeThumbColor: Colors.deepOrangeAccent,
              materialTapTargetSize: MaterialTapTargetSize.shrinkWrap,
            ),
          ],
        ),
      ),
    );
  }
}

// --- Widget pentru slider-ul de ponderi ---
class _WeightSlider extends StatelessWidget {
  final String label;
  final double value;
  final ValueChanged<double> onChanged;

  const _WeightSlider({
    required this.label,
    required this.value,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
            children: [
              Text(label, style: AppFonts.captionStyle),
              const Spacer(),
              Text(
                value.toStringAsFixed(1),
                style: AppFonts.captionStyle.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
            ],
          ),
          Slider(
            value: value,
            onChanged: onChanged,
            min: 0.0,
            max: 3.0,
            divisions: 30,
            activeColor: Colors.deepOrangeAccent,
            inactiveColor: Colors.grey.withValues(alpha: 0.3),
          ),
        ],
      ),
    );
  }
}

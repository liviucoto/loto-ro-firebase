import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';

/// Dialog pentru generarea variantelor bazate pe sume (implementare curată și compactă).
class SumGeneratorDialog extends StatefulWidget {
  final List<LotoDraw> statsDraws;
  final GameType selectedGame;
  final bool isDesktop;
  final VoidCallback? onClose;
  final double? cardWidth;
  final double? cardHeight;
  final Offset? cardOffset;
  final bool fastMode;

  const SumGeneratorDialog({
    super.key,
    required this.statsDraws,
    required this.selectedGame,
    required this.isDesktop,
    this.onClose,
    this.cardWidth,
    this.cardHeight,
    this.cardOffset,
    this.fastMode = false,
  });

  @override
  State<SumGeneratorDialog> createState() => _SumGeneratorDialogState();
}

class _SumGeneratorDialogState extends State<SumGeneratorDialog> {
  int nVariants = 5;
  bool isLoading = false;
  final List<dynamic> generatedVariants = [];
  final List<String> variantNarratives = [];
  final List<double> _variantRatings = [];
  List<bool> _variantVisible = [];
  String _userFeedback = '';

  // Variabile pentru algoritmul Box-Muller
  bool _hasNextNextGaussian = false;
  double _nextNextGaussian = 0.0;

  @override
  Widget build(BuildContext context) {
    // Temporarily stubbed to resolve parser errors; will restore once analyzer is stable.
    return const SizedBox.shrink();
  }

  Widget _buildStatsCard(
    bool isMobile,
    int total,
    double avg,
    int min,
    int max
  ) {
    // Simplified temporarily to avoid parse errors while we stabilize analyzer state.
    return Padding(
      padding: const EdgeInsets.all(8),
      child: Text(
        'Extrageri: $total • Medie: ${avg.toStringAsFixed(1)} • Min: $min • Max: $max',
        style: AppFonts.captionStyle,
      ),
    );
  }

  Widget _buildVariantCountSelector(bool isMobile) {
    return Container(
      constraints: const BoxConstraints(
        minHeight: 60,
        minWidth: 140,
        maxWidth: 200,
      ),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(
        color: Colors.white.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
        border: Border.all(color: Colors.greenAccent.withValues(alpha: 0.12)),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Icon(
            Icons.format_list_numbered,
            color: Colors.greenAccent,
            size: 18,
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              'Număr variante:',
            style: AppFonts.captionStyle.copyWith(
              fontWeight: FontWeight.w600,
              ),
            ),
          ),
          const SizedBox(width: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.white.withValues(alpha: 0.18),
              borderRadius: BorderRadius.circular(8),
              border: Border.all(
                color: Colors.greenAccent.withValues(alpha: 0.12),
              ),
            ),
            child: Row(
              mainAxisSize: MainAxisSize.min,
              children: [
                IconButton(
                  icon: const Icon(Icons.remove, size: 18),
                  splashRadius: 18,
                  onPressed: nVariants > 1
                      ? () => setState(() => nVariants--)
                      : null,
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 8),
            child: Text(
              '$nVariants',
              style: AppFonts.bodyStyle.copyWith(
                      fontWeight: FontWeight.bold,
              ),
            ),
          ),
          IconButton(
                  icon: const Icon(Icons.add, size: 18),
                  splashRadius: 18,
            onPressed: nVariants < 10
                ? () => setState(() => nVariants++)
                : null,
          ),
        ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildPlaceholder() => Center(
    child: Text(
      'Generează variante pentru a le vedea aici!',
      style: AppFonts.captionStyle.copyWith(color: Colors.greenAccent),
    ),
  );

  Widget _buildVariantsGrid() {
    return SingleChildScrollView(
      child: Align(
        alignment: Alignment.topCenter,
        child: Wrap(
          spacing: 18,
          runSpacing: 18,
          children: List.generate(
            generatedVariants.length,
            (i) => ConstrainedBox(
              constraints: const BoxConstraints(maxWidth: 480),
              child: _buildVariantCard(i),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildVariantCard(int i) {
    final variant = generatedVariants[i];
    final narrative = i < variantNarratives.length ? variantNarratives[i] : '';
    final List<int> mainNumbers = (variant is Map<String, dynamic>)
        ? (variant['main'] as List<int>)
        : (variant as List<int>);
    final sum = mainNumbers.fold(0, (a, b) => a + b);
    final even = mainNumbers.where((n) => n % 2 == 0).length;
    final odd = mainNumbers.length - even;
    final rating = i < _variantRatings.length ? _variantRatings[i] : 0.0;
    final isUnique = !_isHistoricVariant(variant);
    const pastelGreen = Color(0xFF2ECC40);
    const pastelBlue = Color(0xFF007AFF);
    const pastelOrange = Color(0xFFFF8800);
    const pastelGray = Color(0xFFEDF0F2);
    const pastelYellow = Color(0xFFFFC300);
    return AnimatedOpacity(
      opacity: _variantVisible.length > i && _variantVisible[i] ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Container(
      decoration: BoxDecoration(
          color: Colors.white.withValues(alpha: 0.50),
          borderRadius: BorderRadius.circular(18),
        border: Border.all(
            color: Colors.white.withValues(alpha: 0.28),
            width: 1.5,
        ),
        boxShadow: [
          BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 18,
              offset: const Offset(0, 8),
          ),
        ],
      ),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
            child: Padding(
              padding: const EdgeInsets.all(20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Row(
                    crossAxisAlignment: CrossAxisAlignment.start,
            children: [
                      Expanded(
                        child: Container(
                padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 3,
                ),
                decoration: BoxDecoration(
                            color: pastelGreen.withValues(alpha: 0.18),
                            borderRadius: BorderRadius.circular(8),
                            border: Border.all(
                              color: pastelGreen.withValues(alpha: 0.3),
                            ),
                ),
                child: Text(
                            'VARIANTA ${i + 1}',
                  style: AppFonts.bodyStyle.copyWith(
                              fontWeight: FontWeight.bold,
                    color: pastelGreen,
                  ),
                ),
              ),
                      ),
              const SizedBox(width: 8),
                      _ratingBadge(rating, pastelYellow),
                      if (isUnique) ...[
                        const SizedBox(width: 6),
                        _uniqueBadge(pastelBlue),
                      ],
                    ],
                  ),
                  const SizedBox(height: 20),
                  Center(
                    child: SingleChildScrollView(
                      scrollDirection: Axis.horizontal,
                      child: Row(
                        children: _buildNumberRow(
                          mainNumbers,
                          variant,
                          pastelGreen,
                          18,
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(height: 20),
          Row(
            children: [
              Expanded(
                child: _miniStatCard(
                          Icons.summarize,
                          '$sum',
                  'sumă',
                  pastelGreen,
                ),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: _miniStatCard(
                  Icons.balance,
                          '$even/$odd',
                          'Pare/Impare',
                  pastelOrange,
                ),
              ),
            ],
          ),
          const SizedBox(height: 12),
          Container(
                    width: double.infinity,
            decoration: BoxDecoration(
              color: pastelGray,
              borderRadius: BorderRadius.circular(8),
            ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 8,
                    ),
            child: Row(
              children: [
                        const Icon(
                          Icons.info_outline,
                          color: Colors.grey,
                          size: 13,
                        ),
                        const SizedBox(width: 4),
                Expanded(
                  child: Text(
                            narrative,
                            style: AppFonts.captionStyle.copyWith(fontSize: 11),
                            maxLines: 2,
                            overflow: TextOverflow.ellipsis,
                  ),
                ),
              ],
            ),
          ),
        ],
              ),
            ),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNumberRow(
    List<int> mainNumbers,
    dynamic variant,
    Color accent,
    double size,
  ) {
    final joker = (variant is Map<String, dynamic>) ? variant['joker'] : null;
    final all = List<int>.from(mainNumbers);
    return [
      for (final n in all) _numberBall(n, accent, size: size),
      if (joker != null)
        Padding(
          padding: const EdgeInsets.only(left: 8),
          child: _numberBall(joker as int, Colors.purple, size: size),
        ),
    ];
  }

  Widget _numberBall(int n, Color color, {double size = 26}) {
    return Container(
      margin: const EdgeInsets.symmetric(horizontal: 3, vertical: 4),
      width: size,
      height: size,
      alignment: Alignment.center,
      decoration: BoxDecoration(
        shape: BoxShape.circle,
        gradient: LinearGradient(
          colors: [color.withValues(alpha: 0.8), color],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        boxShadow: [
          BoxShadow(
            color: color.withValues(alpha: 0.5),
            blurRadius: 6,
            offset: const Offset(0, 3),
          ),
        ],
      ),
      child: Text(
        '$n',
        style: TextStyle(
          color: Colors.white,
          fontSize: size * 0.42,
          fontWeight: FontWeight.bold,
        ),
      ),
    );
  }

  Widget _ratingBadge(double rating, Color pastelYellow) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
      decoration: BoxDecoration(
      color: pastelYellow.withValues(alpha: 0.18),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: pastelYellow.withValues(alpha: 0.5)),
      ),
      child: Row(
        mainAxisSize: MainAxisSize.min,
        children: [
        Icon(Icons.star, color: pastelYellow, size: 12),
        const SizedBox(width: 2),
          Text(
          rating.toStringAsFixed(1),
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: pastelYellow,
            ),
          ),
        ],
      ),
    );

  Widget _uniqueBadge(Color pastelBlue) => Container(
    padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
          decoration: BoxDecoration(
      color: pastelBlue.withValues(alpha: 0.25),
      borderRadius: BorderRadius.circular(10),
      border: Border.all(color: pastelBlue, width: 1.2),
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.fiber_new, color: pastelBlue, size: 12),
        const SizedBox(width: 2),
        Text(
          'Unică',
          style: TextStyle(
            fontSize: 11,
            fontWeight: FontWeight.bold,
            color: pastelBlue,
          ),
        ),
      ],
    ),
  );

  Widget _miniStatCard(
    IconData icon,
    String value,
    String label,
    Color color,
  ) => Container(
    height: 60,
      decoration: BoxDecoration(
      color: color.withValues(alpha: 0.18),
        borderRadius: BorderRadius.circular(12),
      border: Border.all(color: color.withValues(alpha: 0.18)),
      ),
      child: Column(
      mainAxisAlignment: MainAxisAlignment.center,
        children: [
        Icon(icon, color: color, size: 18),
        const SizedBox(height: 2),
          Text(
            value,
            style: AppFonts.bodyStyle.copyWith(
            fontWeight: FontWeight.bold,
              color: color,
            ),
          ),
        Text(label, style: AppFonts.captionStyle.copyWith(fontSize: 11)),
        ],
      ),
    );

  Future<void> _onGeneratePressed() async {
    setState(() => isLoading = true);
    generatedVariants.clear();
    variantNarratives.clear();
    _variantVisible = [];
    if (!widget.fastMode) {
      await Future.delayed(const Duration(milliseconds: 120));
    }
    await _generateVariantsLocal();
    if (!widget.fastMode) {
      await Future.delayed(const Duration(milliseconds: 120));
    }
    _calculateVariantRatings();
    _generateUserFeedback();
    if (widget.fastMode) {
    setState(() {
        _variantVisible = List.filled(generatedVariants.length, true);
          isLoading = false;
        });
    } else {
      // Asigură că lista este growable
      _variantVisible = List<bool>.from(_variantVisible);
      for (int i = 0; i < generatedVariants.length; i++) {
        await Future.delayed(const Duration(milliseconds: 120));
        if (!mounted) return;
        setState(() {
          if (_variantVisible.length <= i) {
            _variantVisible.add(true);
          } else {
            _variantVisible[i] = true;
          }
        });
      }
      if (mounted) setState(() => isLoading = false);
    }
  }

  Future<void> _generateVariantsLocal() async {
    final nNumbers = _maxNumberForGame(widget.selectedGame);
    final sums = widget.statsDraws
        .map((d) => d.mainNumbers.fold(0, (a, b) => a + b))
        .toList();
    final avgSum = sums.isNotEmpty
        ? sums.reduce((a, b) => a + b) / sums.length
        : 0.0;
    final minSum = sums.isNotEmpty ? sums.reduce((a, b) => a < b ? a : b) : 0;
    final maxSum = sums.isNotEmpty ? sums.reduce((a, b) => a > b ? a : b) : 0;

    final count = widget.selectedGame == GameType.loto649 ? 6 : 5;
    for (int i = 0; i < nVariants; i++) {
      final variant = _generateSmartVariant(
        nNumbers,
        count,
        avgSum,
        minSum,
        maxSum,
        i,
      );
      generatedVariants.add(variant);
      variantNarratives.add(_generateVariantNarrative(variant, avgSum));
    }
    setState(
      () => _variantVisible = List.filled(
        generatedVariants.length,
        widget.fastMode,
        ),
      );
    }

  String _generateVariantNarrative(dynamic variant, double avgSum) {
    try {
      final List<int> nums = (variant is Map<String, dynamic>)
          ? (variant['main'] as List<int>)
          : (variant as List<int>);
      final sum = nums.fold(0, (a, b) => a + b);
      final diff = (sum - avgSum).abs();
      String nar =
          'Sumă: $sum (diferență: ${diff.toStringAsFixed(1)} față de media ${avgSum.toStringAsFixed(1)})';
      if (variant is Map<String, dynamic> && variant.containsKey('joker')) {
        nar += ' | Joker: ${variant['joker']}';
      }
      return nar;
    } catch (_) {
      return 'Narativă indisponibilă';
    }
  }

  dynamic _generateSmartVariant(
    int nNumbers,
    int count,
    double avgSum,
    int minSum,
    int maxSum,
    int variantIndex,
  ) {
    final random = Random();
    final targetSum = _getTargetSum(avgSum, minSum, maxSum, variantIndex);
    final variant = <int>[];
    final used = <int>{};
    int tries = 0;

    while (variant.length < count && tries < 500) {
      final pick = 1 + random.nextInt(nNumbers);
      if (used.contains(pick)) {
        tries++;
        continue;
      }

      final temp = [...variant, pick];
      final currentSum = temp.fold(0, (a, b) => a + b);

      // Verifică dacă adăugarea acestui număr ne aduce mai aproape de suma țintă
      if (variant.isEmpty ||
          (currentSum - targetSum).abs() <=
              (variant.fold(0, (a, b) => a + b) - targetSum).abs()) {
        variant.add(pick);
        used.add(pick);
      }
      tries++;
    }

    // Completează cu numere aleatorii dacă nu am ajuns la count
    while (variant.length < count) {
      final pick = 1 + random.nextInt(nNumbers);
      if (!variant.contains(pick)) {
        variant.add(pick);
      }
    }

    variant.sort();
    if (widget.selectedGame == GameType.joker) {
      final joker = 1 + random.nextInt(20);
      return {'main': variant, 'joker': joker};
    }
    return variant;
  }

  int _getTargetSum(double avgSum, int minSum, int maxSum, int variantIndex) {
    final random = Random();
    // Variază suma țintă în jurul mediei cu o distribuție normală
    final variation = (maxSum - minSum) * 0.2; // 20% din interval
    final target = avgSum + (_nextGaussian(random) * variation);
    return target.round().clamp(minSum, maxSum);
  }

  // Implementare Box-Muller pentru distribuția normală
  double _nextGaussian(Random random) {
    if (_hasNextNextGaussian) {
      _hasNextNextGaussian = false;
      return _nextNextGaussian;
    }
    
    double v1, v2, s;
    do {
      v1 = 2 * random.nextDouble() - 1; // între -1.0 și 1.0
      v2 = 2 * random.nextDouble() - 1; // între -1.0 și 1.0
      s = v1 * v1 + v2 * v2;
    } while (s >= 1 || s == 0);
    
    double multiplier = sqrt(-2 * log(s) / s);
    _nextNextGaussian = v2 * multiplier;
    _hasNextNextGaussian = true;
    return v1 * multiplier;
  }

  void _calculateVariantRatings() {
    _variantRatings.clear();
    final sums = widget.statsDraws
        .map((d) => d.mainNumbers.fold(0, (a, b) => a + b))
        .toList();
    final avgSum = sums.isNotEmpty
        ? sums.reduce((a, b) => a + b) / sums.length
        : 0.0;

    for (final variant in generatedVariants) {
      final List<int> nums = (variant is Map<String, dynamic>)
          ? (variant['main'] as List<int>)
          : (variant as List<int>);
      double rating = 0;

      // Diversitate
      rating += (nums.toSet().length / nums.length) * 2;

      // Apropiere de suma medie
      final sum = nums.fold(0, (a, b) => a + b);
      final diff = (sum - avgSum).abs();
      if (diff < 10) {
        rating += 3;
      } else if (diff < 20) {
        rating += 2;
      } else if (diff < 30) {
        rating += 1;
      }

      // Balanță pare/impare
      final even = nums.where((n) => n % 2 == 0).length;
      final odd = nums.length - even;
      final balance = (even - odd).abs();
      if (balance <= 1) {
        rating += 2;
      } else if (balance <= 2) {
        rating += 1;
      }

      // Unicitate
      if (!_isHistoricVariant(variant)) rating += 2;

      _variantRatings.add(rating);
    }
  }

  bool _isHistoricVariant(dynamic variant) {
    final setVariant = Set.of(
      (variant is Map<String, dynamic>)
          ? variant['main'] as List<int>
          : variant as List<int>,
    );
    return widget.statsDraws.any((draw) {
      final drawSet = Set.of(draw.mainNumbers);
      return drawSet.length == setVariant.length &&
          drawSet.difference(setVariant).isEmpty;
    });
  }

  void _generateUserFeedback() {
    if (generatedVariants.isEmpty) return;
    final avg = _variantRatings.isNotEmpty
        ? _variantRatings.reduce((a, b) => a + b) / _variantRatings.length
        : 0;
    final uniqueCount = generatedVariants
        .map((v) => v.toString())
        .toSet()
        .length;
    final historicHits = _countHistoricHits(generatedVariants);
    String fb;
    if (avg >= 8) {
      fb = 'Excelent!';
    } else if (avg >= 6)
      fb = 'Bun!';
    else if (avg >= 4)
      fb = 'Decent.';
    else
      fb = 'Slab.';
    if (uniqueCount < generatedVariants.length * .8) {
      fb += ' Mai multă diversitate recomandată.';
    }
    if (historicHits > 0) fb += ' $historicHits în istoric!';
    setState(() => _userFeedback = fb);
  }

  int _countHistoricHits(List<dynamic> variants) {
    int hits = 0;
    for (final v in variants) {
      final setV = Set.of(
        (v is Map<String, dynamic>) ? v['main'] as List<int> : v as List<int>,
      );
      if (widget.statsDraws.any((draw) {
        final ds = Set.of(draw.mainNumbers);
        return ds.length == setV.length && ds.difference(setV).isEmpty;
      })) {
        hits++;
      }
    }
    return hits;
  }

  void _exportVariants() {
    final gameName = widget.selectedGame == GameType.loto649
        ? 'Loto 6/49'
        : (widget.selectedGame == GameType.loto540 ? 'Loto 5/40' : 'Joker');
    String text =
        '=== GENERATOR SUMĂ ===\nJoc: $gameName\nVariante: ${generatedVariants.length}\n\n';
    for (int i = 0; i < generatedVariants.length; i++) {
      final variant = generatedVariants[i];
      final nums = (variant is Map<String, dynamic>)
          ? variant['main'] as List<int>
          : variant as List<int>;
      final joker = (variant is Map<String, dynamic>) ? variant['joker'] : null;
      text += 'Variantă ${i + 1}: ${nums.join(' - ')}';
      if (joker != null) text += ' | Joker: $joker';
      text += '\nNarativă: ${variantNarratives[i]}\n\n';
    }
    text +=
        'Unice: ${generatedVariants.map((v) => v.toString()).toSet().length}/${generatedVariants.length}\n';
    text +=
        'Istoric: ${_countHistoricHits(generatedVariants)}/${generatedVariants.length}\n';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(
      context,
    ).showSnackBar(const SnackBar(content: Text('Variante copiate!')));
  }

  int _maxNumberForGame(GameType game) {
    switch (game) {
      case GameType.loto649:
        return 49;
      case GameType.loto540:
        return 40;
      case GameType.joker:
        return 45; // 5 din 45 + joker separat
    }
  }
}

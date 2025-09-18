import 'dart:math';
import 'dart:ui';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:loto_ro/models/loto_draw.dart';
import 'package:loto_ro/utils/constants.dart';

/// Dialog pentru generarea variantelor bazate pe frecvențe lunare (implementare curată și compactă).
class HeatmapGeneratorDialog extends StatefulWidget {
  final List<LotoDraw> allDraws;
  final GameType selectedGame;
  final bool isDesktop;
  final VoidCallback? onClose;
  final double? cardWidth;
  final double? cardHeight;
  final Offset? cardOffset;
  final bool fastMode;

  const HeatmapGeneratorDialog({
    super.key,
    required this.allDraws,
    required this.selectedGame,
    required this.isDesktop,
    this.onClose,
    this.cardWidth,
    this.cardHeight,
    this.cardOffset,
    this.fastMode = false,
  });

  @override
  State<HeatmapGeneratorDialog> createState() => _HeatmapGeneratorDialogState();
}

class _HeatmapGeneratorDialogState extends State<HeatmapGeneratorDialog> {
  int nVariants = 5;
  bool isLoading = false;
  final List<dynamic> generatedVariants = [];
  final List<String> variantNarratives = [];
  final List<double> _variantRatings = [];
  List<bool> _variantVisible = [];
  String _userFeedback = '';

  @override
  Widget build(BuildContext context) {
    final now = DateTime.now();
    final month = now.month;
    final monthName = const [
      'Ianuarie','Februarie','Martie','Aprilie','Mai','Iunie','Iulie','August','Septembrie','Octombrie','Noiembrie','Decembrie'
    ][month-1];
    final drawsForMonth = widget.allDraws.where((d)=> d.date.month == month).toList();
    final nNumbers = _maxNumberForGame(widget.selectedGame);
    final freq = <int,int>{ for (int n=1;n<=nNumbers;n++) n:0 };
    final sums = <int>[];
    for (final d in drawsForMonth){
      for (final n in d.mainNumbers){ freq[n] = (freq[n] ?? 0) + 1; }
      sums.add(d.mainNumbers.fold(0,(a,b)=>a+b));
    }
    final totalDraws = drawsForMonth.length;
    final topNumbers = (freq.entries.toList()..sort((a,b)=> b.value.compareTo(a.value)))
        .take(5).map((e)=> e.key).toList();
    final avgSum = sums.isNotEmpty ? sums.reduce((a,b)=>a+b)/sums.length : 0.0;

    return Stack(children:[
      Positioned(
        left: widget.isDesktop ? MediaQuery.of(context).size.width * 0.15 : 0,
        right: widget.isDesktop ? MediaQuery.of(context).size.width * 0.15 : 0,
        top: 0,
        bottom: 0,
        child: Material(
          color: Colors.transparent,
          child: ClipRRect(
            borderRadius: BorderRadius.circular(24),
            child: Container(
              decoration: BoxDecoration(
                color: Colors.white.withValues(alpha: 0.45),
                borderRadius: BorderRadius.circular(24),
                border: Border.all(color: Colors.white.withValues(alpha: 0.28), width: 1.5),
                boxShadow: [BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius: 18, offset: const Offset(0,8))],
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 12, sigmaY: 12),
                child: Padding(
                  padding: widget.isDesktop ? const EdgeInsets.symmetric(vertical: 32, horizontal: 40) : const EdgeInsets.all(24),
                  child: Column(crossAxisAlignment: CrossAxisAlignment.stretch, children:[
                    Row(mainAxisAlignment: MainAxisAlignment.center, children:[
                      Icon(Icons.auto_awesome, color: Colors.deepOrangeAccent, size: widget.isDesktop?28:20),
                      const SizedBox(width: 8),
                      Expanded(child: Text('Lucky Heatmap', textAlign: TextAlign.center, maxLines: 1, overflow: TextOverflow.ellipsis,
                        style: AppFonts.titleStyle.copyWith(fontSize: widget.isDesktop?22:18, fontWeight: FontWeight.w900, color: Colors.deepOrangeAccent, letterSpacing: 1.1))),
                      IconButton(icon: const Icon(Icons.close), onPressed: widget.onClose ?? ()=> Navigator.of(context).pop()),
                    ]),
                    const SizedBox(height: 18),
                    LayoutBuilder(builder: (context, constraints){
                      final isMobile = constraints.maxWidth < 600;
                      return Wrap(spacing: 12, runSpacing: 12, alignment: WrapAlignment.center, children: [
                        _buildStatsCard(isMobile, monthName, totalDraws, topNumbers, avgSum, drawsForMonth),
                        _buildVariantCountSelector(isMobile),
                      ]);
                    }),
                    const SizedBox(height: 12),
                    SizedBox(
                      width: double.infinity,
                      child: ElevatedButton(
                        onPressed: isLoading ? null : _onGeneratePressed,
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.deepOrangeAccent,
                          foregroundColor: Colors.white,
                          padding: EdgeInsets.symmetric(vertical: widget.isDesktop?16:14, horizontal: 20),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                        ),
                        child: Row(mainAxisAlignment: MainAxisAlignment.center, mainAxisSize: MainAxisSize.max, children: [
                          const Icon(Icons.auto_awesome, color: Colors.white, size: 18),
                          const SizedBox(width: 10),
                          Text('Generează variante', style: AppFonts.bodyStyle.copyWith(fontWeight: FontWeight.bold, fontSize: widget.isDesktop?16:14, color: Colors.white)),
                        ]),
                      ),
                    ),
                    if (generatedVariants.isNotEmpty) ...[
                      const SizedBox(height: 14),
                      OutlinedButton.icon(
                        onPressed: _exportVariants,
                        icon: const Icon(Icons.save_alt, size: 18),
                        label: Text('Exportă variantele', style: AppFonts.bodyStyle.copyWith(fontWeight: FontWeight.w600, fontSize: widget.isDesktop?14:12)),
                        style: OutlinedButton.styleFrom(
                          foregroundColor: Colors.deepOrangeAccent,
                          side: BorderSide(color: Colors.deepOrangeAccent.withValues(alpha: 0.6)),
                          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
                          padding: EdgeInsets.symmetric(vertical: widget.isDesktop?12:10, horizontal: 20),
                        ),
                      ),
                    ],
                    if (generatedVariants.isNotEmpty && _userFeedback.isNotEmpty) ...[
                      const SizedBox(height: 12),
                      Container(
                        padding: const EdgeInsets.all(16),
                        decoration: BoxDecoration(color: Colors.amber.withValues(alpha: 0.15), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.amber.withValues(alpha: 0.3))),
                        child: Row(children: [
                          Icon(Icons.lightbulb_outline, color: Colors.amber[700], size: 20),
                          const SizedBox(width: 12),
                          Expanded(child: Text(_userFeedback, style: AppFonts.bodyStyle.copyWith(fontSize: 14, color: Colors.amber[800]))),
                        ]),
                      ),
                    ],
                    const SizedBox(height: 12),
                    Expanded(child: generatedVariants.isNotEmpty ? _buildVariantsGrid() : _buildPlaceholder()),
                  ]),
                ),
              ),
            ),
          ),
        ),
      )
    ]);
  }

  Widget _buildStatsCard(bool isMobile, String month, int total, List<int> top, double avg, List<LotoDraw> draws){
    final years = (draws.map((d)=> d.date.year).toSet().toList()..sort());
    final span = years.isNotEmpty ? '${years.first}–${years.last}' : '-';
    return Container(
      constraints: BoxConstraints(minHeight: 80, maxWidth: isMobile? double.infinity : 340),
      padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 10),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.22), borderRadius: BorderRadius.circular(16), border: Border.all(color: Colors.deepOrangeAccent.withValues(alpha: 0.10))),
  child: Column(crossAxisAlignment: CrossAxisAlignment.start, children: [
        Text('Statistici luna $month', style: AppFonts.bodyStyle.copyWith(fontWeight: FontWeight.w700, fontSize: isMobile?12:14, color: Colors.deepOrangeAccent)),
        const SizedBox(height: 4),
        SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: [
          Text('Extrageri: $total', style: AppFonts.captionStyle), const SizedBox(width: 10),
          Text('Top 5: ${top.join(', ')}', style: AppFonts.captionStyle), const SizedBox(width: 10),
          Text('Suma medie: ${avg.toStringAsFixed(1)}', style: AppFonts.captionStyle),
        ])),
        const SizedBox(height: 2),
        Text('Ani: $span ($total extrageri)', style: AppFonts.captionStyle.copyWith(fontSize: 10), maxLines: 1, overflow: TextOverflow.ellipsis),
      ]),
    );
  }

  Widget _buildVariantCountSelector(bool isMobile){
    return Container(
      constraints: const BoxConstraints(minHeight: 60, minWidth: 140, maxWidth: 200),
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
      decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(12), border: Border.all(color: Colors.deepOrangeAccent.withValues(alpha: 0.12))),
  child: Row(mainAxisAlignment: MainAxisAlignment.center, children: [
        const Icon(Icons.format_list_numbered, color: Colors.deepOrangeAccent, size: 18),
        const SizedBox(width: 8),
        Expanded(child: Text('Număr variante:', style: AppFonts.captionStyle.copyWith(fontWeight: FontWeight.w600))),
        const SizedBox(width: 8),
        Container(
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(8), border: Border.all(color: Colors.deepOrangeAccent.withValues(alpha: 0.12))),
          child: Row(mainAxisSize: MainAxisSize.min, children: [
            IconButton(icon: const Icon(Icons.remove, size: 18), splashRadius: 18, onPressed: nVariants>1 ? ()=> setState(()=> nVariants--) : null),
            Padding(padding: const EdgeInsets.symmetric(horizontal: 8), child: Text('$nVariants', style: AppFonts.bodyStyle.copyWith(fontWeight: FontWeight.bold))),
            IconButton(icon: const Icon(Icons.add, size: 18), splashRadius: 18, onPressed: nVariants<10 ? ()=> setState(()=> nVariants++) : null),
          ]),
        ),
      ]),
    );
  }

  Widget _buildPlaceholder() => Center(child: Text('Generează variante pentru a le vedea aici!', style: AppFonts.captionStyle.copyWith(color: Colors.deepOrangeAccent)));

  Widget _buildVariantsGrid(){
    return SingleChildScrollView(child: Align(alignment: Alignment.topCenter, child: Wrap(spacing: 18, runSpacing: 18, children: List.generate(generatedVariants.length, (i)=> ConstrainedBox(constraints: const BoxConstraints(maxWidth: 480), child: _buildVariantCard(i))))));
  }

  Widget _buildVariantCard(int i){
    final variant = generatedVariants[i];
    final narrative = i < variantNarratives.length ? variantNarratives[i] : '';
    final List<int> mainNumbers = (variant is Map<String,dynamic>) ? (variant['main'] as List<int>) : (variant as List<int>);
    final sum = mainNumbers.fold(0,(a,b)=>a+b);
    final even = mainNumbers.where((n)=> n%2==0).length; final odd = mainNumbers.length - even;
    final rating = i < _variantRatings.length ? _variantRatings[i] : 0.0;
    final isUnique = !_isHistoricVariant(variant);
    const pastelOrange = Color(0xFFFF8800);
    const pastelGreen = Color(0xFF2ECC40);
    const pastelBlue = Color(0xFF007AFF);
    const pastelGray = Color(0xFFEDF0F2);
    const pastelYellow = Color(0xFFFFC300);
    return AnimatedOpacity(
      opacity: _variantVisible.length>i && _variantVisible[i] ? 1 : 0,
      duration: const Duration(milliseconds: 300),
      child: Container(
        decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.50), borderRadius: BorderRadius.circular(18), border: Border.all(color: Colors.white.withValues(alpha: 0.28), width:1.5), boxShadow:[BoxShadow(color: Colors.black.withValues(alpha: 0.10), blurRadius:18, offset: const Offset(0,8))]),
        child: ClipRRect(
          borderRadius: BorderRadius.circular(18),
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX:12,sigmaY:12),
            child: Padding(padding: const EdgeInsets.all(20), child: Column(crossAxisAlignment: CrossAxisAlignment.start, children:[
              Row(crossAxisAlignment: CrossAxisAlignment.start, children:[
                Expanded(child: Container(padding: const EdgeInsets.symmetric(horizontal:10,vertical:3), decoration: BoxDecoration(color: pastelOrange.withValues(alpha: 0.18), borderRadius: BorderRadius.circular(8), border: Border.all(color: pastelOrange.withValues(alpha: 0.3))), child: Text('VARIANTA ${i+1}', style: AppFonts.bodyStyle.copyWith(fontWeight: FontWeight.bold, color: pastelOrange))))
                , const SizedBox(width:8), _ratingBadge(rating, pastelYellow), if (isUnique)...[ const SizedBox(width:6), _uniqueBadge(pastelGreen) ],
              ]),
              const SizedBox(height:20),
              Center(child: SingleChildScrollView(scrollDirection: Axis.horizontal, child: Row(children: _buildNumberRow(mainNumbers, variant, pastelOrange, 18))))
              , const SizedBox(height:20),
              Row(children:[ Expanded(child: _miniStatCard(Icons.summarize,'$sum','sumă',pastelGreen)), const SizedBox(width:12), Expanded(child: _miniStatCard(Icons.balance,'$even/$odd','Pare/Impare',pastelBlue)) ])
              , const SizedBox(height:12),
              Container(width: double.infinity, decoration: BoxDecoration(color: pastelGray, borderRadius: BorderRadius.circular(8)), padding: const EdgeInsets.symmetric(horizontal:10,vertical:8), child: Row(children:[ const Icon(Icons.info_outline, color: Colors.grey, size:13), const SizedBox(width:4), Expanded(child: Text(narrative, style: AppFonts.captionStyle.copyWith(fontSize:11), maxLines:2, overflow: TextOverflow.ellipsis)) ])),
            ])),
          ),
        ),
      ),
    );
  }

  List<Widget> _buildNumberRow(List<int> mainNumbers, dynamic variant, Color accent, double size){
    final joker = (variant is Map<String,dynamic>) ? variant['joker'] : null;
    final all = List<int>.from(mainNumbers);
    return [
      for (final n in all) _numberBall(n, accent, size: size),
      if (joker != null) Padding(padding: const EdgeInsets.only(left:8), child: _numberBall(joker as int, Colors.purple, size: size)),
    ];
  }

  Widget _numberBall(int n, Color color,{double size=26}){
    return Container(margin: const EdgeInsets.symmetric(horizontal:3, vertical:4), width: size, height: size, alignment: Alignment.center, decoration: BoxDecoration(shape: BoxShape.circle, gradient: LinearGradient(colors: [color.withValues(alpha: 0.8), color], begin: Alignment.topLeft, end: Alignment.bottomRight), boxShadow:[BoxShadow(color: color.withValues(alpha: 0.5), blurRadius:6, offset: const Offset(0,3))]), child: Text('$n', style: TextStyle(color: Colors.white, fontSize: size*0.42, fontWeight: FontWeight.bold)) );
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
            )
          ],
        ),
      );

  Widget _uniqueBadge(Color pastelGreen) => Container(
        padding: const EdgeInsets.symmetric(horizontal: 7, vertical: 2),
        decoration: BoxDecoration(
          color: pastelGreen.withValues(alpha: 0.25),
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: pastelGreen, width: 1.2),
        ),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Icon(Icons.fiber_new, color: pastelGreen, size: 12),
            const SizedBox(width: 2),
            Text(
              'Unică',
              style: TextStyle(
                fontSize: 11,
                fontWeight: FontWeight.bold,
                color: pastelGreen,
              ),
            )
          ],
        ),
      );

  Widget _miniStatCard(IconData icon, String value, String label, Color color) =>
      Container(
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
              style: AppFonts.bodyStyle
                  .copyWith(fontWeight: FontWeight.bold, color: color),
            ),
            Text(label, style: AppFonts.captionStyle.copyWith(fontSize: 11))
          ],
        ),
      );

  Future<void> _onGeneratePressed() async {
    setState(()=> isLoading = true);
    generatedVariants.clear();
    variantNarratives.clear();
    _variantVisible = [];
    if (!widget.fastMode) await Future.delayed(const Duration(milliseconds: 120));
    await _generateVariantsLocal();
    if (!widget.fastMode) await Future.delayed(const Duration(milliseconds: 120));
    _calculateVariantRatings();
    _generateUserFeedback();
    if (widget.fastMode){
      setState((){
        _variantVisible = List.filled(generatedVariants.length,true);
        isLoading=false;
      });
    } else {
  // Asigură că lista este growable
  _variantVisible = List<bool>.from(_variantVisible);
      for (int i=0;i<generatedVariants.length;i++){
        await Future.delayed(const Duration(milliseconds:120));
        if (!mounted) return;
        setState((){
          if (_variantVisible.length <= i) {
            _variantVisible.add(true);
          } else {
            _variantVisible[i] = true;
          }
        });
      }
      if (mounted) setState(()=> isLoading=false);
    }
  }

  Future<void> _generateVariantsLocal() async {
    final now = DateTime.now();
    var drawsForMonth = widget.allDraws.where((d)=> d.date.month == now.month).toList();
    if (drawsForMonth.isEmpty) drawsForMonth = widget.allDraws;
    final nNumbers = _maxNumberForGame(widget.selectedGame);
    final freq = <int,int>{ for (int n=1;n<=nNumbers;n++) n:0 };
    for (final draw in drawsForMonth){ for (final n in draw.mainNumbers){ freq[n] = (freq[n]??0)+1; }}
    final ordered = (freq.entries.toList()..sort((a,b)=> b.value.compareTo(a.value))).map((e)=> e.key).toList();
    final count = widget.selectedGame == GameType.loto649 ? 6 : 5;
    for (int i=0;i<nVariants;i++){
      final variant = _generateSmartVariant(ordered, count, i, drawsForMonth: drawsForMonth);
      generatedVariants.add(variant);
      variantNarratives.add(_generateVariantNarrative(variant, freq));
    }
    setState(()=> _variantVisible = List.filled(generatedVariants.length, widget.fastMode));
  }

  String _generateVariantNarrative(dynamic variant, Map<int,int> freq){
    try{
      final List<int> nums = (variant is Map<String,dynamic>) ? (variant['main'] as List<int>) : (variant as List<int>);
      final freqs = nums.map((n)=> freq[n]??0).toList();
      final sumFreq = freqs.fold<int>(0,(a,b)=>a+b);
      final maxFreq = freqs.isEmpty?0: freqs.reduce((a,b)=> a>b?a:b);
      final minFreq = freqs.isNotEmpty? freqs.reduce((a,b)=> a<b?a:b) : 0;
      String nar = 'Frec totală: $sumFreq (max $maxFreq / min $minFreq)';
      if (variant is Map<String,dynamic> && variant.containsKey('joker')) nar += ' | Joker: ${variant['joker']}';
      return nar;
    }catch(_){
      return 'Narativă indisponibilă';
    }
  }

  dynamic _generateSmartVariant(List<int> pool,int count,int variantIndex,{List<LotoDraw>? drawsForMonth}){
    final random = Random();
    final nNumbers = _maxNumberForGame(widget.selectedGame);
    var draws = drawsForMonth ?? widget.allDraws.where((d)=> d.date.month == DateTime.now().month).toList();
    if (draws.isEmpty) draws = widget.allDraws;
    final freq = <int,int>{ for (int n=1;n<=nNumbers;n++) n:0 };
    for (final d in draws){ for (final n in d.mainNumbers){ freq[n] = (freq[n]??0)+1; }}
    final historic = _getHistoricCombinations(drawsForMonth: draws);
    final targetEven = count ~/2; final targetOdd = count - targetEven;
    final variant = <int>[]; final used=<int>{}; int even=0, odd=0, tries=0;
    while(variant.length < count && tries < 200){
      final pick = _weightedRandomPick(freq, random, used);
      if (pick%2==0 && even>=targetEven){ tries++; continue; }
      if (pick%2!=0 && odd>=targetOdd){ tries++; continue; }
      final temp=[...variant,pick];
      if (_isHistoricCombination(temp, historic)){ tries++; continue; }
      variant.add(pick); used.add(pick); if(pick%2==0) { even++; } else { odd++; } tries++;
    }
    while(variant.length < count){
      final pick = 1+random.nextInt(nNumbers);
      if (pick%2==0 && even>=targetEven) continue; if (pick%2!=0 && odd>=targetOdd) continue; if (!variant.contains(pick)){ variant.add(pick); if(pick%2==0) { even++; } else { odd++; } }
    }
    variant.sort();
    if (widget.selectedGame == GameType.joker){
      final jokerFreq = <int,int>{ for (int n=1;n<=20;n++) n:0 };
      for (final d in draws){ if (d.jokerNumber!=null){ jokerFreq[d.jokerNumber!] = (jokerFreq[d.jokerNumber!]??0)+1; }}
      final hasNonZero = jokerFreq.values.any((v)=> v>0);
      final joker = hasNonZero ? _weightedRandomPick(jokerFreq, random, {}) : 1 + random.nextInt(20);
      return { 'main': variant, 'joker': joker };
    }
    return variant;
  }

  Set<String> _getHistoricCombinations({List<LotoDraw>? drawsForMonth}){
    var draws = drawsForMonth ?? widget.allDraws.where((d)=> d.date.month == DateTime.now().month).toList();
    if (draws.isEmpty) draws = widget.allDraws;
    final set = <String>{};
    for (final d in draws){ final sorted = List<int>.from(d.mainNumbers)..sort(); set.add(sorted.join(',')); }
    return set;
  }

  bool _isHistoricCombination(List<int> variant, Set<String> historic){
    if (variant.length < 3) return false; // ignora combinatii prea mici
    final s = (List<int>.from(variant)..sort()).join(',');
    for (final h in historic){ if (h.contains(s)) return true; }
    return false;
  }

  int _weightedRandomPick(Map<int,int> freq, Random random, Set<int> exclude){
    final entries = freq.entries.where((e)=> !exclude.contains(e.key)).toList();
    if (entries.isEmpty) return 1;
    final maxFreq = entries.map((e)=> e.value).fold<int>(0,(a,b)=> a>b?a:b);
    int total=0; for (final e in entries){ final rarityBonus = maxFreq - e.value + 1; total += e.value + 1 + rarityBonus; }
    int r = random.nextInt(total); int sum=0; for (final e in entries){ final rarityBonus = maxFreq - e.value + 1; sum += e.value + 1 + rarityBonus; if (r < sum) return e.key; }
    return entries.first.key;
  }

  void _calculateVariantRatings(){
    _variantRatings.clear();
    for (final variant in generatedVariants){
      final List<int> nums = (variant is Map<String,dynamic>) ? (variant['main'] as List<int>) : (variant as List<int>);
      double rating = 0;
      rating += (nums.toSet().length / nums.length) * 2; // diversitate
      final sum = nums.fold(0,(a,b)=>a+b);
      final avg = _currentMonthAvgSum();
      final diff = (sum - avg).abs(); if (diff < 10) { rating +=2; } else if (diff < 20) rating +=1;
      final even = nums.where((n)=> n%2==0).length; final odd = nums.length - even; final balance = (even-odd).abs(); if (balance<=1) { rating+=2; } else if (balance<=2) rating+=1;
      final hotNums = _currentMonthTopNumbers(); final hotCount = nums.where((n)=> hotNums.contains(n)).length; rating += (hotCount / nums.length) * 2;
      if (!_isHistoricVariant(variant)) rating +=2;
      _variantRatings.add(rating);
    }
  }

  bool _isHistoricVariant(dynamic variant){
    final now = DateTime.now();
    final drawsForMonth = widget.allDraws.where((d)=> d.date.month== now.month).toList();
    final setVariant = Set.of((variant is Map<String,dynamic>) ? variant['main'] as List<int> : variant as List<int>);
    return drawsForMonth.any((draw){ final drawSet = Set.of(draw.mainNumbers); return drawSet.length == setVariant.length && drawSet.difference(setVariant).isEmpty; });
  }

  void _generateUserFeedback(){
    if (generatedVariants.isEmpty) return;
    final avg = _variantRatings.isNotEmpty ? _variantRatings.reduce((a,b)=>a+b)/_variantRatings.length : 0;
    final uniqueCount = generatedVariants.map((v)=> v.toString()).toSet().length;
    final historicHits = _countHistoricHits(generatedVariants);
    String fb; if (avg>=8) { fb='Excelent!'; } else if (avg>=6) fb='Bun!'; else if (avg>=4) fb='Decent.'; else fb='Slab.';
    if (uniqueCount < generatedVariants.length * .8) fb+=' Mai multă diversitate recomandată.';
    if (historicHits>0) fb+=' $historicHits în istoric!';
    setState(()=> _userFeedback = fb);
  }

  int _countHistoricHits(List<dynamic> variants){
    final now = DateTime.now();
    final drawsForMonth = widget.allDraws.where((d)=> d.date.month == now.month).toList();
    int hits=0; for (final v in variants){ final setV = Set.of((v is Map<String,dynamic>) ? v['main'] as List<int> : v as List<int>); if (drawsForMonth.any((draw){ final ds = Set.of(draw.mainNumbers); return ds.length==setV.length && ds.difference(setV).isEmpty; })) hits++; }
    return hits;
  }

  void _exportVariants(){
    final now = DateTime.now();
    final monthName = const ['Ianuarie','Februarie','Martie','Aprilie','Mai','Iunie','Iulie','August','Septembrie','Octombrie','Noiembrie','Decembrie'][now.month-1];
    final gameName = widget.selectedGame == GameType.loto649 ? 'Loto 6/49' : (widget.selectedGame == GameType.loto540 ? 'Loto 5/40' : 'Joker');
    String text='=== LUCKY HEATMAP GENERATOR ===\nJoc: $gameName\nLuna: $monthName ${now.year}\nVariante: ${generatedVariants.length}\n\n';
    for (int i=0;i<generatedVariants.length;i++){
      final variant = generatedVariants[i]; final nums = (variant is Map<String,dynamic>) ? variant['main'] as List<int> : variant as List<int>; final joker = (variant is Map<String,dynamic>)? variant['joker']:null; text+='Variantă ${i+1}: ${nums.join(' - ')}'; if (joker!=null) text+=' | Joker: $joker'; text+='\nNarativă: ${variantNarratives[i]}\n\n'; }
    text+='Unice: ${generatedVariants.map((v)=> v.toString()).toSet().length}/${generatedVariants.length}\n';
    text+='Istoric: ${_countHistoricHits(generatedVariants)}/${generatedVariants.length}\n';
    Clipboard.setData(ClipboardData(text: text));
    ScaffoldMessenger.of(context).showSnackBar(const SnackBar(content: Text('Variante copiate!')));
  }

  double _currentMonthAvgSum(){
    final now = DateTime.now(); final draws = widget.allDraws.where((d)=> d.date.month==now.month).toList(); if (draws.isEmpty) return 0; final sums = draws.map((d)=> d.mainNumbers.fold(0,(a,b)=>a+b)); return sums.reduce((a,b)=>a+b)/sums.length;
  }
  List<int> _currentMonthTopNumbers(){
    final now = DateTime.now(); final draws = widget.allDraws.where((d)=> d.date.month==now.month).toList(); if (draws.isEmpty) return []; final nNumbers = _maxNumberForGame(widget.selectedGame); final freq = <int,int>{ for (int n=1;n<=nNumbers;n++) n:0 }; for (final d in draws){ for (final n in d.mainNumbers){ freq[n]=(freq[n]??0)+1; }} return (freq.entries.toList()..sort((a,b)=> b.value.compareTo(a.value))).take(3).map((e)=>e.key).toList();
  }

  int _maxNumberForGame(GameType game){
    switch (game){
      case GameType.loto649: return 49;
      case GameType.loto540: return 40;
      case GameType.joker: return 45; // 5 din 45 + joker separat
    }
  }
}

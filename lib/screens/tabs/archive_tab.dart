import 'package:flutter/material.dart';
import 'dart:ui';
import '../../models/loto_draw.dart';
import '../../utils/constants.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_button.dart';
import '../../widgets/glass_number_ball.dart';

class ArchiveTab extends StatefulWidget {
  final GameType selectedGame;
  final List<LotoDraw> draws;
  final List<LotoDraw> filteredDraws;
  final bool isLoading;
  final String? error;
  final VoidCallback onLoadData;
  final Function(BuildContext, LotoDraw, List<LotoDraw>)
  onShowNarrativeAnalysis;

  const ArchiveTab({
    super.key,
    required this.selectedGame,
    required this.draws,
    required this.filteredDraws,
    required this.isLoading,
    this.error,
    required this.onLoadData,
    required this.onShowNarrativeAnalysis,
  });

  @override
  State<ArchiveTab> createState() => _ArchiveTabState();
}

class _ArchiveTabState extends State<ArchiveTab> {
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Toate extragerile';
  String _selectedSort = 'Data descendent';

  final List<String> _filterOptions = [
    'Toate extragerile',
    'Doar cu numere pare',
    'Doar cu numere impare',
    'Suma sub 100',
    'Suma peste 100',
  ];

  final List<String> _sortOptions = [
    'Data descendent',
    'Data ascendent',
    'Suma descendent',
    'Suma ascendent',
    'Medie descendent',
    'Medie ascendent',
  ];

  @override
  void initState() {
    super.initState();
    _searchController.addListener(_onSearchChanged);
  }

  @override
  void dispose() {
    _searchController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
    });
  }

  void _onFilterChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedFilter = value;
    });
  }

  void _onSortChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedSort = value;
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedFilter = 'Toate extragerile';
      _selectedSort = 'Data descendent';
    });
  }

  List<LotoDraw> _getFilteredDraws() {
    List<LotoDraw> filtered = List.from(widget.filteredDraws);

    // Filtrare dupa search
    if (_searchQuery.isNotEmpty) {
      filtered = filtered.where((draw) {
        final dateStr1 =
            '${draw.date.day.toString().padLeft(2, '0')}.${draw.date.month.toString().padLeft(2, '0')}.${draw.date.year}';
        final dateStr2 =
            '${draw.date.day.toString().padLeft(2, '0')}/${draw.date.month.toString().padLeft(2, '0')}/${draw.date.year}';
        final dateStr3 =
            '${draw.date.year}-${draw.date.month.toString().padLeft(2, '0')}-${draw.date.day.toString().padLeft(2, '0')}';
        final dateStr4 =
            '${draw.date.day.toString().padLeft(2, '0')}.${draw.date.month.toString().padLeft(2, '0')}';
        final dateStr5 =
            '${draw.date.month.toString().padLeft(2, '0')}.${draw.date.year}';
        final numbersStr = draw.mainNumbers
            .map((n) => n.toString().padLeft(2, '0'))
            .join(' ');
        final sumStr = draw.sum.toString();
        final avgStr = draw.average.toStringAsFixed(1);
        return dateStr1.contains(_searchQuery) ||
            dateStr2.contains(_searchQuery) ||
            dateStr3.contains(_searchQuery) ||
            dateStr4.contains(_searchQuery) ||
            dateStr5.contains(_searchQuery) ||
            numbersStr.contains(_searchQuery) ||
            sumStr.contains(_searchQuery) ||
            avgStr.contains(_searchQuery);
      }).toList();
    }

    // Filtrare dupa dropdown
    switch (_selectedFilter) {
      case 'Doar cu numere pare':
        filtered = filtered.where((draw) => draw.oddCount == 0).toList();
        break;
      case 'Doar cu numere impare':
        filtered = filtered.where((draw) => draw.evenCount == 0).toList();
        break;
      case 'Suma sub 100':
        filtered = filtered.where((draw) => draw.sum < 100).toList();
        break;
      case 'Suma peste 100':
        filtered = filtered.where((draw) => draw.sum > 100).toList();
        break;
      default:
        break;
    }

    // Sortare
    switch (_selectedSort) {
      case 'Data descendent':
        filtered.sort((a, b) => b.date.compareTo(a.date));
        break;
      case 'Data ascendent':
        filtered.sort((a, b) => a.date.compareTo(b.date));
        break;
      case 'Suma descendent':
        filtered.sort((a, b) => b.sum.compareTo(a.sum));
        break;
      case 'Suma ascendent':
        filtered.sort((a, b) => a.sum.compareTo(b.sum));
        break;
      case 'Medie descendent':
        filtered.sort((a, b) => b.average.compareTo(a.average));
        break;
      case 'Medie ascendent':
        filtered.sort((a, b) => a.average.compareTo(b.average));
        break;
    }

    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    if (widget.isLoading) {
      return const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            CircularProgressIndicator(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
            ),
            SizedBox(height: AppSizes.paddingMedium),
            Text('Se încarca datele...', style: AppFonts.bodyStyle),
          ],
        ),
      );
    }

    if (widget.error != null) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.error_outline,
              size: AppSizes.iconLarge,
              color: AppColors.errorRed,
            ),
            const SizedBox(height: AppSizes.paddingMedium),
            Text(AppStrings.errorMessage, style: AppFonts.subtitleStyle),
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              widget.error!,
              style: AppFonts.captionStyle,
              textAlign: TextAlign.center,
            ),
            const SizedBox(height: AppSizes.paddingLarge),
            GlassButton(
              onTap: widget.onLoadData,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLarge,
                vertical: AppSizes.paddingMedium,
              ),
              borderRadius: AppSizes.radiusMedium,
              child: Text(
                'Reîncearca',
                style: AppFonts.bodyStyle.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    if (widget.draws.isEmpty) {
      return Center(
        child: Text(
          'NU SUNT DATE',
          style: TextStyle(fontSize: 32, color: Colors.red),
        ),
      );
    }

    final filteredDraws = _getFilteredDraws();

    // Daca nu sunt rezultate dupa filtrare
    if (filteredDraws.isEmpty && _searchQuery.isNotEmpty) {
      return Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Icon(
              Icons.search_off,
              size: 64,
              color: Colors.grey.withValues(alpha: 0.6),
            ),
            const SizedBox(height: AppSizes.paddingMedium),
            Text(
              'Nu s-au gasit rezultate',
              style: AppFonts.subtitleStyle.copyWith(
                color: Colors.grey.withValues(alpha: 0.8),
              ),
            ),
            const SizedBox(height: AppSizes.paddingSmall),
            Text(
              'Încearca sa modifici criteriile de cautare',
              style: AppFonts.bodyStyle.copyWith(
                color: Colors.grey.withValues(alpha: 0.6),
              ),
            ),
            const SizedBox(height: AppSizes.paddingLarge),
            GlassButton(
              onTap: _resetFilters,
              padding: const EdgeInsets.symmetric(
                horizontal: AppSizes.paddingLarge,
                vertical: AppSizes.paddingMedium,
              ),
              borderRadius: AppSizes.radiusMedium,
              child: Text(
                'Reseteaza filtrele',
                style: AppFonts.bodyStyle.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w600,
                ),
              ),
            ),
          ],
        ),
      );
    }

    return LayoutBuilder(
      builder: (context, outerConstraints) {
        final isDesktop = outerConstraints.maxWidth > 700;
        final cardMaxWidth = isDesktop ? 900.0 : double.infinity;

        return Column(
          children: [
            Center(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  maxWidth: isDesktop ? cardMaxWidth : double.infinity,
                ),
                child: Padding(
                  padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 4),
                  child: Row(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      // SEARCH
                      Expanded(
                        child: SizedBox(
                          height: isDesktop ? 40 : 32,
                          child: TextField(
                            controller: _searchController,
                            decoration: InputDecoration(
                              hintText: 'Cauta dupa data, numar, suma, etc.',
                              prefixIcon: Icon(
                                Icons.search,
                                color: Colors.black.withValues(alpha: 0.5),
                                size: isDesktop ? 20 : 16,
                              ),
                              filled: true,
                              fillColor: Colors.white.withValues(alpha: 0.18),
                              contentPadding: EdgeInsets.symmetric(
                                vertical: 0,
                                horizontal: isDesktop ? 12 : 8,
                              ),
                              border: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  isDesktop ? 16 : 12,
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              enabledBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  isDesktop ? 16 : 12,
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.3),
                                ),
                              ),
                              focusedBorder: OutlineInputBorder(
                                borderRadius: BorderRadius.circular(
                                  isDesktop ? 16 : 12,
                                ),
                                borderSide: BorderSide(
                                  color: Colors.white.withValues(alpha: 0.5),
                                ),
                              ),
                            ),
                            style: TextStyle(
                              fontSize: isDesktop ? 11 : 10,
                              color: Colors.black,
                            ),
                          ),
                        ),
                      ),
                      SizedBox(width: isDesktop ? 8 : 4),
                      // FILTRU
                      _GlassMenuDropdown(
                        value: _selectedFilter,
                        options: _filterOptions,
                        icon: Icons.filter_list,
                        onChanged: _onFilterChanged,
                        showLabel: isDesktop,
                        height: isDesktop ? 40 : 32,
                        iconSize: isDesktop ? 20 : 16,
                        borderRadius: isDesktop ? 16 : 12,
                        fontSize: isDesktop ? 11 : 10,
                      ),
                      SizedBox(width: isDesktop ? 8 : 4),
                      // SORTARE
                      _GlassMenuDropdown(
                        value: _selectedSort,
                        options: _sortOptions,
                        icon: Icons.sort,
                        onChanged: _onSortChanged,
                        showLabel: isDesktop,
                        height: isDesktop ? 40 : 32,
                        iconSize: isDesktop ? 20 : 16,
                        borderRadius: isDesktop ? 16 : 12,
                        fontSize: isDesktop ? 11 : 10,
                      ),
                      SizedBox(width: isDesktop ? 8 : 4),
                      // RESET
                      SizedBox(
                        height: isDesktop ? 40 : 32,
                        child: GlassButton(
                          onTap: _resetFilters,
                          borderRadius: isDesktop ? 16 : 12,
                          padding: EdgeInsets.symmetric(
                            horizontal: isDesktop ? 8 : 4,
                            vertical: 0,
                          ),
                          child: Icon(
                            Icons.refresh,
                            color: Colors.black.withValues(alpha: 0.7),
                            size: isDesktop ? 20 : 16,
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            SizedBox(height: isDesktop ? 18 : 8),
            // Contor rezultate
            if (filteredDraws.isNotEmpty)
              Padding(
                padding: EdgeInsets.symmetric(horizontal: isDesktop ? 0 : 16),
                child: Text(
                  '${filteredDraws.length} extrageri gasite',
                  style: AppFonts.captionStyle.copyWith(
                    color: Colors.grey.withValues(alpha: 0.7),
                    fontSize: isDesktop ? 12 : 10,
                  ),
                ),
              ),
            SizedBox(height: isDesktop ? 12 : 8),
            Expanded(
              child: ListView.builder(
                padding: EdgeInsets.all(isDesktop ? AppSizes.paddingMedium : 4),
                itemCount: filteredDraws.length,
                itemBuilder: (context, index) {
                  final draw = filteredDraws[index];
                  return Center(
                    child: ConstrainedBox(
                      constraints: BoxConstraints(maxWidth: cardMaxWidth),
                      child: Padding(
                        padding: EdgeInsets.only(bottom: isDesktop ? 18 : 8),
                        child: Semantics(
                          label:
                              'Extragere din ${draw.date.day}/${draw.date.month}/${draw.date.year} cu numerele ${draw.mainNumbers.join(', ')}${draw.jokerNumber != null ? ' ?i joker ${draw.jokerNumber}' : ''}',
                          hint: 'Apasa pentru a vedea analiza narativa',
                          button: true,
                          child: GlassCard(
                            margin: EdgeInsets.zero,
                            padding: EdgeInsets.symmetric(
                              horizontal: isDesktop ? 12 : 4,
                              vertical: isDesktop ? 16 : 14,
                            ),
                            isInteractive: true,
                            onTap: () async {
                              widget.onShowNarrativeAnalysis(
                                context,
                                draw,
                                filteredDraws,
                              );
                            },
                            boxShadow: [
                              BoxShadow(
                                color: Colors.black.withValues(alpha: 0.10),
                                blurRadius: 16,
                                offset: const Offset(0, 4),
                              ),
                            ],
                            borderRadius: BorderRadius.circular(18),
                            child: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                // Data extragerii
                                Row(
                                  children: [
                                    Icon(
                                      Icons.calendar_today,
                                      color: Colors.black,
                                      size: AppSizes.iconSmall,
                                    ),
                                    const SizedBox(
                                      width: AppSizes.paddingSmall,
                                    ),
                                    Text(
                                      '${draw.date.day}/${draw.date.month}/${draw.date.year}',
                                      style: AppFonts.bodyStyle.copyWith(
                                        color: Colors.black,
                                        fontWeight: FontWeight.w600,
                                        fontSize: isDesktop ? 15 : 12,
                                      ),
                                    ),
                                    const Spacer(),
                                  ],
                                ),
                                const SizedBox(height: 8),
                                LayoutBuilder(
                                  builder: (context, constraints) {
                                    double maxWidth = constraints.maxWidth;
                                    int numBalls = draw.mainNumbers.length;
                                    bool hasJoker = draw.jokerNumber != null;
                                    int numBadges = 4 + (hasJoker ? 1 : 0);
                                    double ballMax = isDesktop ? 36 : 28,
                                        ballMin = isDesktop ? 28 : 20;
                                    double badgeFontMax = isDesktop ? 13 : 11,
                                        badgeFontMin = isDesktop ? 10 : 9;
                                    double badgePadMax = isDesktop ? 12 : 7,
                                        badgePadMin = isDesktop ? 7 : 4;
                                    double iconMax = isDesktop ? 16 : 13,
                                        iconMin = isDesktop ? 13 : 10;
                                    double spacing = isDesktop ? 6 : 3;
                                    if (!isDesktop &&
                                        numBalls + (hasJoker ? 1 : 0) > 6) {
                                      spacing = 2;
                                    }
                                    double ballsWidth =
                                        numBalls * ballMax +
                                        (numBalls - 1) * spacing;
                                    double jokerWidth = hasJoker
                                        ? (badgePadMax * 2 + 50)
                                        : 0;
                                    double badgeWidth =
                                        (badgePadMax * 2 + 60) * 4;
                                    double totalNeeded =
                                        ballsWidth +
                                        jokerWidth +
                                        badgeWidth +
                                        spacing * (numBadges + numBalls - 1);
                                    double scale = 1.0;
                                    if (totalNeeded > maxWidth) {
                                      scale = maxWidth / totalNeeded;
                                      if (scale < (ballMin / ballMax)) {
                                        scale = ballMin / ballMax;
                                      }
                                    }
                                    double ballSize = ballMax * scale;
                                    if (!isDesktop) {
                                      ballSize = ballSize < 28 ? 28 : ballSize;
                                    }
                                    double badgeFont = badgeFontMax * scale;
                                    double badgePad = badgePadMax * scale;
                                    double iconSize = iconMax * scale;
                                    bool mustWrap =
                                        (scale <= (ballMin / ballMax) &&
                                        totalNeeded * (ballMin / ballMax) >
                                            maxWidth);

                                    final statBadges = [
                                      _buildStatBadge(
                                        Icons.ssid_chart,
                                        'Suma',
                                        draw.sum.toString(),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: badgePad,
                                          vertical: badgePad / 2,
                                        ),
                                        fontSize: badgeFont,
                                        iconSize: iconSize,
                                      ),
                                      _buildStatBadge(
                                        Icons.check_circle,
                                        'Pare',
                                        draw.evenCount.toString(),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: badgePad,
                                          vertical: badgePad / 2,
                                        ),
                                        fontSize: badgeFont,
                                        iconSize: iconSize,
                                      ),
                                      _buildStatBadge(
                                        Icons.radio_button_unchecked,
                                        'Impare',
                                        draw.oddCount.toString(),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: badgePad,
                                          vertical: badgePad / 2,
                                        ),
                                        fontSize: badgeFont,
                                        iconSize: iconSize,
                                      ),
                                      _buildStatBadge(
                                        Icons.calculate,
                                        'Medie',
                                        draw.average.toStringAsFixed(1),
                                        padding: EdgeInsets.symmetric(
                                          horizontal: badgePad,
                                          vertical: badgePad / 2,
                                        ),
                                        fontSize: badgeFont,
                                        iconSize: iconSize,
                                      ),
                                    ];

                                    final jokerBadge = hasJoker
                                        ? _buildJokerBadge(
                                            draw.jokerNumber!,
                                            padding: EdgeInsets.symmetric(
                                              horizontal: badgePad,
                                              vertical: badgePad / 2,
                                            ),
                                            fontSize: badgeFont,
                                            iconSize: iconSize,
                                          )
                                        : null;

                                    final List<Widget> numberBalls = [
                                      ...draw.mainNumbers.map(
                                        (number) => Padding(
                                          padding: EdgeInsets.only(
                                            right: spacing,
                                          ),
                                          child: GlassNumberBall(
                                            number: number,
                                            size: ballSize,
                                          ),
                                        ),
                                      ),
                                    ];

                                    if (draw.jokerNumber != null) {
                                      numberBalls.add(
                                        Padding(
                                          padding: EdgeInsets.only(
                                            right: spacing,
                                          ),
                                          child: GlassNumberBall(
                                            number: draw.jokerNumber!,
                                            size: ballSize,
                                            isJoker: true,
                                          ),
                                        ),
                                      );
                                    }

                                    return (mustWrap || !isDesktop)
                                        ? Column(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.stretch,
                                            children: [
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: numberBalls,
                                              ),
                                              const SizedBox(height: 6),
                                              Row(
                                                mainAxisAlignment:
                                                    MainAxisAlignment
                                                        .spaceEvenly,
                                                children: statBadges,
                                              ),
                                            ],
                                          )
                                        : Row(
                                            crossAxisAlignment:
                                                CrossAxisAlignment.center,
                                            mainAxisAlignment:
                                                MainAxisAlignment.spaceBetween,
                                            children: [
                                              Row(
                                                crossAxisAlignment:
                                                    CrossAxisAlignment.center,
                                                children: numberBalls,
                                              ),
                                              const SizedBox(width: 12),
                                              Expanded(
                                                child: Wrap(
                                                  spacing: spacing,
                                                  alignment: WrapAlignment.end,
                                                  children: statBadges,
                                                ),
                                              ),
                                            ],
                                          );
                                  },
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                    ),
                  );
                },
              ),
            ),
          ],
        );
      },
    );
  }

  Widget _buildStatBadge(
    IconData icon,
    String label,
    String value, {
    EdgeInsetsGeometry? padding,
    double? fontSize,
    double? iconSize,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(14),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 12, vertical: 7),
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.28),
            borderRadius: BorderRadius.circular(14),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.5),
              width: 1.1,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.06),
                blurRadius: 6,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                icon,
                color: Colors.black.withValues(alpha: 0.7),
                size: iconSize ?? 16,
              ),
              const SizedBox(width: 3),
              Text(
                '$label:',
                style: AppFonts.captionStyle.copyWith(
                  color: Colors.black.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize ?? 13,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                value,
                style: AppFonts.bodyStyle.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize ?? 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildJokerBadge(
    int joker, {
    EdgeInsetsGeometry? padding,
    double? fontSize,
    double? iconSize,
  }) {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          margin: const EdgeInsets.only(right: 0),
          padding:
              padding ??
              const EdgeInsets.symmetric(horizontal: 14, vertical: 6),
          decoration: BoxDecoration(
            gradient: const LinearGradient(
              colors: [
                Color(0xB0FFFFFF),
                Color(0x806EE7B7), // pastel verde
                Color(0x80B2F0E6), // pastel bleu
              ],
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
            ),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.6),
              width: 1.4,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.08),
                blurRadius: 8,
                offset: const Offset(0, 2),
              ),
            ],
          ),
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                Icons.stars,
                color: Colors.black.withValues(alpha: 0.75),
                size: iconSize ?? 18,
              ),
              const SizedBox(width: 3),
              Text(
                'Joker:',
                style: AppFonts.captionStyle.copyWith(
                  color: Colors.black.withValues(alpha: 0.8),
                  fontWeight: FontWeight.w600,
                  fontSize: fontSize ?? 13,
                ),
              ),
              const SizedBox(width: 2),
              Text(
                joker.toString(),
                style: AppFonts.bodyStyle.copyWith(
                  color: Colors.black,
                  fontWeight: FontWeight.bold,
                  fontSize: fontSize ?? 13,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

// Dropdown cu efect glass pentru filtre/sortare
class _GlassMenuDropdown extends StatefulWidget {
  final String value;
  final List<String> options;
  final IconData icon;
  final void Function(String?) onChanged;
  final bool showLabel;
  final double height;
  final double iconSize;
  final double borderRadius;
  final double fontSize;

  const _GlassMenuDropdown({
    required this.value,
    required this.options,
    required this.icon,
    required this.onChanged,
    this.showLabel = true,
    this.height = 40,
    this.iconSize = 20,
    this.borderRadius = 16,
    this.fontSize = 11,
  });

  @override
  State<_GlassMenuDropdown> createState() => _GlassMenuDropdownState();
}

class _GlassMenuDropdownState extends State<_GlassMenuDropdown> {
  final GlobalKey _key = GlobalKey();

  void _showMenu() async {
    final RenderBox renderBox =
        _key.currentContext!.findRenderObject() as RenderBox;
    final Offset offset = renderBox.localToGlobal(Offset.zero);
    final Size size = renderBox.size;
    final selected = await showMenu<String>(
      context: context,
      position: RelativeRect.fromLTRB(
        offset.dx,
        offset.dy + size.height + 4,
        offset.dx + size.width,
        offset.dy,
      ),
      elevation: 0,
      color: Colors.transparent,
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(18)),
      items: [
        PopupMenuItem<String>(
          enabled: false,
          padding: EdgeInsets.zero,
          child: GlassCard(
            borderRadius: BorderRadius.circular(18),
            padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
            child: ConstrainedBox(
              constraints: BoxConstraints(
                maxWidth: MediaQuery.of(context).size.width - 32,
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: widget.options
                    .map(
                      (option) => InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => Navigator.of(context).pop(option),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 5,
                          ),
                          decoration: BoxDecoration(
                            color: option == widget.value
                                ? Colors.white.withValues(alpha: 0.18)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: Row(
                            children: [
                              if (option == widget.value)
                                Icon(
                                  Icons.check,
                                  color: Colors.black.withValues(alpha: 0.7),
                                  size: 18,
                                ),
                              if (option != widget.value) SizedBox(width: 18),
                              const SizedBox(width: 4),
                              Flexible(
                                child: Text(
                                  option,
                                  style: TextStyle(
                                    fontSize: widget.fontSize,
                                    color: Colors.black,
                                  ),
                                  overflow: TextOverflow.ellipsis,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),
                    )
                    .toList(),
              ),
            ),
          ),
        ),
      ],
    );
    if (selected != null) widget.onChanged(selected);
  }

  @override
  Widget build(BuildContext context) {
    final maxWidth = MediaQuery.of(context).size.width - 32;
    return GestureDetector(
      key: _key,
      onTap: _showMenu,
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 14, vertical: 0),
        borderRadius: BorderRadius.circular(widget.borderRadius),
        child: SizedBox(
          height: widget.height,
          child: Row(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(
                widget.icon,
                color: Colors.black.withValues(alpha: 0.7),
                size: widget.iconSize,
              ),
              if (widget.showLabel) ...[
                const SizedBox(width: 6),
                Text(
                  widget.value,
                  style: TextStyle(
                    fontSize: widget.fontSize,
                    color: Colors.black,
                  ),
                ),
              ],
              const Icon(Icons.arrow_drop_down, color: Colors.black54),
            ],
          ),
        ),
      ),
    );
  }
}

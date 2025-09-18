import 'package:flutter/material.dart';
import 'package:flutter/foundation.dart';
import 'dart:ui';
import '../models/loto_draw.dart';
import '../models/game_statistics.dart';
import '../utils/constants.dart';
import '../widgets/glass_card.dart';
import '../widgets/glass_background.dart';
import '../widgets/glass_number_ball.dart';
import '../services/narrative_analysis_service.dart';
import '../services/data_service.dart';
import 'tabs/settings_tab.dart';
import 'home/home_game_selector_header.dart';
import 'home/main_tab_view.dart';
import 'home/bottom_nav.dart';
import 'home/glass_error_message.dart';

/// Ecranul principal al aplica?iei cu structura modulara
/// Header cu selector joc, TabView per joc, BottomBar per joc, Buton global setari
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  GameType _selectedGame = GameType.joker;
  int _currentTabIndex =
      0; // 0 = Arhiva, 1 = Statistici, 2 = Generator, 3 = Setari

  // TabController pentru statistici
  late TabController _statsTabController;

  List<LotoDraw> _draws = [];
  List<LotoDraw> _filteredDraws = [];
  GameStatistics? _statistics;
  bool _isLoading = true;
  String? _error;

  // Selector global de perioada pentru tabul Statistici
  static const List<int> _periodOptions = [20, 50, 100, 500, 1000];
  String _selectedPeriod = 'Toate extragerile';
  int? _customFrom;
  int? _customTo;
  List<LotoDraw> _statsDraws = [];

  // Pentru search ?i filtre
  final TextEditingController _searchController = TextEditingController();
  String _searchQuery = '';
  String _selectedFilter = 'Toate extragerile';
  final List<String> _filterOptions = [
    'Toate extragerile',
    'Doar cu numere pare',
    'Doar cu numere impare',
    'Suma sub 100',
    'Suma peste 100',
  ];

  // Adaug op?iuni de sortare
  String _selectedSort = 'Data descendent';
  final List<String> _sortOptions = [
    'Data descendent',
    'Data ascendent',
    'Suma descendent',
    'Suma ascendent',
    'Medie descendent',
    'Medie ascendent',
  ];

  late AnimationController _animationController;
  late Animation<double> _fadeAnimation;
  late Animation<double> _slideAnimation;

  // Variabile pentru cache
  Map<String, dynamic>? _intervalStatsLegend;

  @override
  void initState() {
    super.initState();
    _animationController = AnimationController(
      duration: AppAnimations.medium,
      vsync: this,
    );
    _fadeAnimation = Tween<double>(begin: 0.0, end: 1.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.easeInOut,
      ),
    );
    _slideAnimation = Tween<double>(begin: 50.0, end: 0.0).animate(
      CurvedAnimation(
        parent: _animationController,
        curve: AppAnimations.easeInOut,
      ),
    );
    _searchController.addListener(_onSearchChanged);
    _loadData();
    _animationController.forward();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    _statsTabController = TabController(length: 9, vsync: this);
    _statsTabController.addListener(() {
      if (_statsTabController.indexIsChanging) {
        // Tab changed to: ${_statsTabController.index}
      }
    });
  }

  @override
  void dispose() {
    _animationController.dispose();
    _searchController.dispose();
    _statsTabController.dispose();
    super.dispose();
  }

  void _onSearchChanged() {
    setState(() {
      _searchQuery = _searchController.text.trim();
      _applyFilters();
    });
  }

  void _onFilterChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedFilter = value;
      _applyFilters();
    });
  }

  void _onSortChanged(String? value) {
    if (value == null) return;
    setState(() {
      _selectedSort = value;
      _applyFilters();
    });
  }

  void _resetFilters() {
    setState(() {
      _searchController.clear();
      _searchQuery = '';
      _selectedFilter = 'Toate extragerile';
      _selectedSort = 'Data descendent';
      _applyFilters();
    });
  }

  void _applyFilters() {
    List<LotoDraw> filtered = List.from(_draws);
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
    setState(() {
      _filteredDraws = filtered;
      _applyStatsPeriod();
    });
  }

  Future<void> _loadData() async {
    try {
      setState(() {
        _isLoading = true;
        _error = null;
      });
      final draws = await DataService().loadDraws(_selectedGame);
      if (kDebugMode) {
        print(
          '?? HomeScreen: Loaded ${draws.length} draws for ${_selectedGame.key}',
        );
      }
      draws.sort((a, b) => b.date.compareTo(a.date));
      for (final draw in draws) {
        draw.mainNumbers.sort();
      }
      setState(() {
        _draws = draws;
      });
      _applyFilters();
      setState(() {
        _isLoading = false;
      });
      _applyStatsPeriod();
    } catch (e) {
      setState(() {
        _error = e.toString();
        _isLoading = false;
      });
    }
  }

  void _onGameChanged(GameType gameType) {
    setState(() {
      _selectedGame = gameType;
      if (_currentTabIndex != 3) {
        _currentTabIndex = 0; // Revine la tabul Arhiva doar daca nu e pe Setari
      }
    });
    _loadData();
  }

  void _onTabChanged(int index) {
    setState(() {
      _currentTabIndex = index;
      if (index == 1) {
        _applyFilters();
      }
    });
  }

  void _applyStatsPeriod() {
    // Applying stats period filter

    setState(() {
      if (_selectedPeriod == 'Toate extragerile') {
        // Setting stats draws to all filtered draws
        _statsDraws = List.from(_filteredDraws);
      } else if (_selectedPeriod == 'Custom') {
        if (_customFrom != null &&
            _customTo != null &&
            _customFrom! < _customTo!) {
          final from = _customFrom!.clamp(0, _filteredDraws.length);
          final to = _customTo!.clamp(from, _filteredDraws.length);
          _statsDraws = _filteredDraws.sublist(from, to);
        } else {
          _statsDraws = List.from(_filteredDraws);
        }
      } else {
        final match = RegExp(r'U\w+ (\d+)').firstMatch(_selectedPeriod);
        if (match != null) {
          final n = int.parse(match.group(1)!);
          final safeN = n.clamp(0, _filteredDraws.length);
          _statsDraws = _filteredDraws.sublist(0, safeN);
        } else {
          _statsDraws = List.from(_filteredDraws);
        }
      }

      if (kDebugMode) {
        print('?? Stats draws length set to: ${_statsDraws.length}');
        print('?? Filtered draws length: ${_filteredDraws.length}');
        print('?? Selected period: $_selectedPeriod');
      }
    });
  }

  void _showStatsCustomDialog({void Function()? onAfterCustom}) async {
    int? n = 100;
    await showDialog(
      context: context,
      builder: (context) {
        return Material(
          color: Colors.transparent,
          child: Center(
            child: GlassCard(
              padding: const EdgeInsets.all(24),
              borderRadius: BorderRadius.circular(24),
              child: SizedBox(
                width: 320,
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text('Ultimele N extrageri', style: AppFonts.subtitleStyle),
                    const SizedBox(height: 16),
                    TextField(
                      keyboardType: TextInputType.number,
                      decoration: InputDecoration(
                        labelText: 'Numar extrageri',
                        border: OutlineInputBorder(),
                      ),
                      controller: TextEditingController(text: n.toString()),
                      onChanged: (v) => n = int.tryParse(v) ?? 100,
                    ),
                    const SizedBox(height: 18),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.end,
                      children: [
                        TextButton(
                          onPressed: () => Navigator.of(context).pop(),
                          child: const Text('Anuleaza'),
                        ),
                        const SizedBox(width: 8),
                        ElevatedButton(
                          onPressed: () {
                            setState(() {
                              _selectedPeriod = 'Custom';
                              _customFrom = 0;
                              _customTo = n;
                              _applyStatsPeriod();
                            });
                            Navigator.of(context).pop();
                            if (onAfterCustom != null) onAfterCustom();
                          },
                          child: const Text('Aplica'),
                        ),
                      ],
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _buildStatsGlassDropdown() {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    return GestureDetector(
      onTap: () async {
        final RenderBox box = context.findRenderObject() as RenderBox;
        final Offset offset = box.localToGlobal(Offset.zero);
        final selected = await showMenu<String>(
          context: context,
          position: RelativeRect.fromLTRB(
            offset.dx,
            offset.dy + 40,
            offset.dx + 200,
            offset.dy,
          ),
          color: Colors.transparent,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(18),
          ),
          items: [
            PopupMenuItem<String>(
              enabled: false,
              padding: EdgeInsets.zero,
              child: GlassCard(
                borderRadius: BorderRadius.circular(18),
                padding: const EdgeInsets.symmetric(vertical: 4, horizontal: 0),
                child: ConstrainedBox(
                  constraints: BoxConstraints(maxWidth: 220),
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    children: [
                      ..._periodOptions.map(
                        (n) => InkWell(
                          borderRadius: BorderRadius.circular(14),
                          onTap: () => Navigator.of(context).pop('Ultimele $n'),
                          child: Container(
                            width: double.infinity,
                            padding: const EdgeInsets.symmetric(
                              horizontal: 10,
                              vertical: 8,
                            ),
                            decoration: BoxDecoration(
                              color: _selectedPeriod == 'Ultimele $n'
                                  ? Colors.white.withValues(alpha: 0.18)
                                  : Colors.transparent,
                              borderRadius: BorderRadius.circular(14),
                            ),
                            child: Text(
                              'Ultimele $n',
                              style: TextStyle(
                                fontSize: isDesktop ? 13 : 11,
                                color: Colors.black,
                              ),
                            ),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () =>
                            Navigator.of(context).pop('Toate extragerile'),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedPeriod == 'Toate extragerile'
                                ? Colors.white.withValues(alpha: 0.18)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            'Toate extragerile',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                      InkWell(
                        borderRadius: BorderRadius.circular(14),
                        onTap: () => Navigator.of(context).pop('Custom'),
                        child: Container(
                          width: double.infinity,
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 8,
                          ),
                          decoration: BoxDecoration(
                            color: _selectedPeriod == 'Custom'
                                ? Colors.white.withValues(alpha: 0.18)
                                : Colors.transparent,
                            borderRadius: BorderRadius.circular(14),
                          ),
                          child: const Text(
                            'Custom',
                            style: TextStyle(color: Colors.black),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
            ),
          ],
        );
        if (selected != null) {
          if (selected == 'Custom') {
            _showStatsCustomDialog();
          } else {
            setState(() {
              _selectedPeriod = selected;
              _applyStatsPeriod();
            });
          }
        }
      },
      child: GlassCard(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 6),
        borderRadius: BorderRadius.circular(16),
        child: Row(
          mainAxisSize: MainAxisSize.min,
          children: [
            Text(
              _selectedPeriod,
              style: TextStyle(fontSize: 13, color: Colors.black),
            ),
            const SizedBox(width: 6),
            const Icon(Icons.arrow_drop_down, color: Colors.black54),
          ],
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 700;
    final cardMaxWidth = isDesktop ? 900.0 : double.infinity;
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: Stack(
        children: [
          const GlassBackground(),
          Positioned.fill(
            child: AnimatedBuilder(
              animation: _animationController,
              builder: (context, child) {
                return Transform.translate(
                  offset: Offset(0, _slideAnimation.value),
                  child: Opacity(
                    opacity: _fadeAnimation.value,
                    child: Column(
                      children: [
                        // HEADER centrat pe desktop
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: cardMaxWidth),
                            child: _buildHeader(),
                          ),
                        ),
                        SizedBox(height: isDesktop ? 18 : 8),
                        Expanded(child: _buildMainContent()),
                        // FOOTER centrat pe desktop
                        Center(
                          child: ConstrainedBox(
                            constraints: BoxConstraints(maxWidth: cardMaxWidth),
                            child: _buildBottomNavigation(),
                          ),
                        ),
                      ],
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildHeader() {
    final screenWidth = MediaQuery.of(context).size.width;
    final isDesktop = screenWidth > 700;
    final isTablet = screenWidth > 500 && screenWidth <= 700;

    return SafeArea(
      top: true,
      bottom: false,
      child: Container(
        padding: EdgeInsets.all(isDesktop ? 16 : 12),
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [
              Color(0xB0FFFFFF),
              Color(0x80B2F0E6),
              Color(0x80D1C4E9),
              Color(0x80FDE68A),
              Color(0x80B9F6CA),
            ],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          border: Border(
            top: BorderSide(
              color: Colors.white.withValues(alpha: 0.5),
              width: 1.5,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withValues(alpha: 0.10),
              blurRadius: 16,
              offset: const Offset(0, 4),
            ),
          ],
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(28),
            bottomRight: Radius.circular(28),
          ),
        ),
        child: Column(
          children: [
            // Header principal - adaptiv pentru mobile/desktop
            if (isDesktop) _buildDesktopHeader() else _buildMobileHeader(),
          ],
        ),
      ),
    );
  }

  Widget _buildDesktopHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo desktop
        Container(
          width: 80,
          height: 80,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.32),
            borderRadius: BorderRadius.circular(20),
            border: Border.all(color: Colors.white.withValues(alpha: 0.85), width: 2),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 16,
                offset: Offset(0, 4),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
            child: Padding(
              padding: EdgeInsets.all(4),
              child: Image.asset(
                'assets/images/logo_lotoro3.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/logo_lotoro1.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 48,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 24),
        // Selectorul de joc pe desktop
        Expanded(
          child: ClipRRect(
            borderRadius: BorderRadius.circular(22),
            child: BackdropFilter(
              filter: ImageFilter.blur(sigmaX: 14, sigmaY: 14),
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.white.withValues(alpha: 0.32),
                  borderRadius: BorderRadius.circular(22),
                  border: Border.all(
                    color: Colors.white.withValues(alpha: 0.5),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withValues(alpha: 0.08),
                      blurRadius: 12,
                      offset: Offset(0, 4),
                    ),
                  ],
                ),
                child: HomeGameSelectorHeader(
                  selectedGame: _selectedGame,
                  onChanged: _onGameChanged,
                ),
              ),
            ),
          ),
        ),
      ],
    );
  }

  Widget _buildMobileHeader() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        // Logo compact pentru mobile
        Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.32),
            borderRadius: BorderRadius.circular(12),
            border: Border.all(
              color: Colors.white.withValues(alpha: 0.85),
              width: 1.5,
            ),
            boxShadow: [
              BoxShadow(
                color: Colors.black.withValues(alpha: 0.10),
                blurRadius: 8,
                offset: Offset(0, 2),
              ),
            ],
          ),
          clipBehavior: Clip.antiAlias,
          child: BackdropFilter(
            filter: ImageFilter.blur(sigmaX: 8, sigmaY: 8),
            child: Padding(
              padding: EdgeInsets.all(2),
              child: Image.asset(
                'assets/images/logo_lotoro3.png',
                fit: BoxFit.cover,
                errorBuilder: (context, error, stackTrace) => Image.asset(
                  'assets/images/logo_lotoro1.png',
                  fit: BoxFit.cover,
                  errorBuilder: (context, error, stackTrace) => Icon(
                    Icons.image_not_supported,
                    size: 24,
                    color: Colors.redAccent,
                  ),
                ),
              ),
            ),
          ),
        ),
        const SizedBox(width: 12),
        // Selector de joc compact pentru mobile
        Expanded(child: _buildMobileGameSelector()),
      ],
    );
  }

  Widget _buildMobileGameSelector() {
    return ClipRRect(
      borderRadius: BorderRadius.circular(16),
      child: BackdropFilter(
        filter: ImageFilter.blur(sigmaX: 10, sigmaY: 10),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withValues(alpha: 0.25),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.white.withValues(alpha: 0.4), width: 1),
          ),
          child: Row(
            children: [
              _buildMobileGameButton(GameType.joker, 'Joker'),
              _buildMobileGameButton(GameType.loto649, '6/49'),
              _buildMobileGameButton(GameType.loto540, '5/40'),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildMobileGameButton(GameType game, String label) {
    final bool isSelected = _selectedGame == game;
    return Expanded(
      child: GestureDetector(
        onTap: () => _onGameChanged(game),
        child: AnimatedContainer(
          duration: const Duration(milliseconds: 200),
          curve: Curves.easeInOut,
          padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 8),
          decoration: BoxDecoration(
            color: isSelected
                ? Colors.white.withValues(alpha: 0.4)
                : Colors.transparent,
            borderRadius: BorderRadius.circular(12),
          ),
          child: Center(
            child: Text(
              label,
              style: TextStyle(
                color: isSelected ? Colors.black87 : Colors.black54,
                fontWeight: isSelected ? FontWeight.bold : FontWeight.w500,
                fontSize: 14,
              ),
            ),
          ),
        ),
      ),
    );
  }

  Widget _buildMainContent() {
    if (_currentTabIndex == 3) {
      return SettingsTab();
    }
    if (_isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
        ),
      );
    }
    if (_error != null) {
      return GlassErrorMessage(
        title: 'A aparut o eroare',
        details: _error,
        onRetry: _loadData,
      );
    }
    // TabView pentru con?inutul per joc
    return MainTabView(
      currentTabIndex: _currentTabIndex,
      selectedGame: _selectedGame,
      draws: _draws,
      filteredDraws: _filteredDraws,
      isLoading: _isLoading,
      error: _error,
      onLoadData: _loadData,
      onShowNarrativeAnalysisDialog: _showNarrativeAnalysisDialog,
      statsDraws: _statsDraws,
      selectedPeriod: _selectedPeriod,
      periodOptions: _periodOptions,
      statsTabController: _statsTabController,
      onPeriodChanged: (val) {
        setState(() {
          _selectedPeriod = val;
          _applyStatsPeriod();
        });
      },
      onCustomPeriod: (String customPeriod) {
        _selectedPeriod = customPeriod;
        _applyStatsPeriod();
      },
      onStatsChanged: (stats) {
        if (mounted) setState(() => _intervalStatsLegend = stats);
      },
      fadeAnimation: _fadeAnimation,
    );
  }

  Color _getGameColor(GameType gameType) {
    switch (gameType) {
      case GameType.joker:
        return AppColors.primaryGreen;
      case GameType.loto649:
        return AppColors.secondaryBlue;
      case GameType.loto540:
        return AppColors.accentPurple;
    }
  }

  Widget _buildBottomNavigation() {
    return BottomNav(currentIndex: _currentTabIndex, onTap: _onTabChanged);
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

  void _showNarrativeAnalysisDialog(
    BuildContext context,
    LotoDraw draw,
    List<LotoDraw> allDraws,
  ) {
    final analysisService = NarrativeAnalysisService();
    final insights = analysisService.getNarrativeAnalysis(
      draw: draw,
      allDraws: allDraws,
    );
    late OverlayEntry entry;
    entry = OverlayEntry(
      builder: (context) => Material(
        color: Colors.transparent,
        child: Stack(
          children: [
            // Background care se închide la click
            Positioned.fill(
              child: GestureDetector(
                onTap: () => entry.remove(),
                child: Container(color: Colors.black.withValues(alpha: 0.18)),
              ),
            ),
            // Dialog-ul care nu se închide la click
            Center(
              child: GestureDetector(
                onTap: () {}, // Previne propagarea click-ului
                child: NarrativeAnalysisDialog(
                  draw: draw,
                  insights: insights,
                  onClose: () => entry.remove(),
                ),
              ),
            ),
          ],
        ),
      ),
    );
    Overlay.of(context, rootOverlay: true).insert(entry);
  }

  // Adaug func?ia helper în _HomeScreenState:
  int _getMaxSumForGame(GameType gameType) {
    switch (gameType) {
      case GameType.joker:
        return 41 + 42 + 43 + 44 + 45; // 215
      case GameType.loto649:
        return 44 + 45 + 46 + 47 + 48 + 49; // 279
      case GameType.loto540:
        return 36 + 37 + 38 + 39 + 40; // 190
    }
  }
}

// Dropdown cu efect glass pentru filtre/sortare (meniul este un singur container glass)
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
    this.height = 48,
    this.iconSize = 20,
    this.borderRadius = 24,
    this.fontSize = 14,
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

class NarrativeAnalysisDialog extends StatelessWidget {
  final LotoDraw draw;
  final List<NarrativeInsight> insights;
  final VoidCallback onClose;
  const NarrativeAnalysisDialog({
    super.key,
    required this.draw,
    required this.insights,
    required this.onClose,
  });

  @override
  Widget build(BuildContext context) {
    final isDesktop = MediaQuery.of(context).size.width > 700;
    return SafeArea(
      child: Center(
        child: ConstrainedBox(
          constraints: BoxConstraints(
            maxWidth: isDesktop
                ? 540
                : MediaQuery.of(context).size.width * 0.98,
            maxHeight: isDesktop
                ? MediaQuery.of(context).size.height * 0.85
                : MediaQuery.of(context).size.height * 0.88,
          ),
          child: Stack(
            children: [
              GlassCard(
                padding: EdgeInsets.symmetric(
                  horizontal: isDesktop ? 32 : 10,
                  vertical: isDesktop ? 32 : 8,
                ),
                borderRadius: BorderRadius.circular(28),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withValues(
                      alpha: isDesktop ? 0.10 : 0.18,
                    ),
                    blurRadius: isDesktop ? 16 : 22,
                    offset: const Offset(0, 4),
                  ),
                ],
                child: SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.only(top: 8.0, right: 8.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        // Linia cu numere ?i badge Joker, fara X
                        SingleChildScrollView(
                          scrollDirection: Axis.horizontal,
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.center,
                            children: [
                              ...draw.mainNumbers.map(
                                (n) => Padding(
                                  padding: const EdgeInsets.only(right: 6),
                                  child: GlassNumberBall(
                                    number: n,
                                    size: isDesktop ? 36 : 32,
                                  ),
                                ),
                              ),
                              if (draw.jokerNumber != null) ...[
                                Padding(
                                  padding: const EdgeInsets.only(
                                    left: 8,
                                    right: 4,
                                  ),
                                  child: GlassNumberBall(
                                    number: draw.jokerNumber!,
                                    size: isDesktop ? 36 : 32,
                                    isJoker: true,
                                  ),
                                ),
                              ],
                            ],
                          ),
                        ),
                        const SizedBox(height: 16),
                        Text(
                          'Analiza narativa:',
                          style: AppFonts.subtitleStyle.copyWith(
                            fontSize: isDesktop ? 17 : 13,
                          ),
                        ),
                        const SizedBox(height: 10),
                        ...insights.asMap().entries.map((entry) {
                          final i = entry.key;
                          final insight = entry.value;
                          Color pastel;
                          switch (insight.type) {
                            case NarrativeInsightType.sum:
                              pastel = Color(0xFFFDE68A);
                              break;
                            case NarrativeInsightType.parity:
                              pastel = Color(0xFFB2F0E6);
                              break;
                            case NarrativeInsightType.hot:
                              pastel = Color(0xFFFCA5A5);
                              break;
                            case NarrativeInsightType.cold:
                              pastel = Color(0xFFA7C7E7);
                              break;
                            case NarrativeInsightType.decade:
                              pastel = Color(0xFFC4B5FD);
                              break;
                            case NarrativeInsightType.group:
                              pastel = Color(0xFFB9F6CA);
                              break;
                            case NarrativeInsightType.distance:
                              pastel = Color(0xFFFBBF24);
                              break;
                            case NarrativeInsightType.lastSeen:
                              pastel = Color(0xFF60A5FA);
                              break;
                            case NarrativeInsightType.minMax:
                              pastel = Color(0xFFC4B5FD);
                              break;
                            default:
                              pastel = Colors.black.withValues(alpha: 0.10);
                          }
                          // Highlight cifre importante cu badge
                          String text = insight.text;
                          Widget textWidget = Text(
                            text,
                            style: AppFonts.bodyStyle.copyWith(
                              fontSize: isDesktop ? 14 : 11,
                            ),
                          );
                          // Badge pentru cifre (suma, medie, min, max, hot/cold)
                          if (insight.type == NarrativeInsightType.sum ||
                              insight.type == NarrativeInsightType.hot ||
                              insight.type == NarrativeInsightType.cold ||
                              insight.type == NarrativeInsightType.minMax) {
                            final regex = RegExp(r'(\d+[\.,]?\d*)');
                            final spans = <InlineSpan>[];
                            int last = 0;
                            for (final match in regex.allMatches(text)) {
                              if (match.start > last) {
                                spans.add(
                                  TextSpan(
                                    text: text.substring(last, match.start),
                                  ),
                                );
                              }
                              spans.add(
                                WidgetSpan(
                                  alignment: PlaceholderAlignment.middle,
                                  child: Container(
                                    margin: const EdgeInsets.symmetric(
                                      horizontal: 2,
                                    ),
                                    padding: const EdgeInsets.symmetric(
                                      horizontal: 8,
                                      vertical: 4,
                                    ),
                                    decoration: BoxDecoration(
                                      color: pastel.withValues(
                                        alpha: isDesktop ? 0.45 : 0.7,
                                      ),
                                      borderRadius: BorderRadius.circular(10),
                                      boxShadow: [
                                        if (!isDesktop)
                                          BoxShadow(
                                            color: pastel.withValues(
                                              alpha: 0.25,
                                            ),
                                            blurRadius: 8,
                                            offset: const Offset(0, 2),
                                          ),
                                      ],
                                    ),
                                    child: Text(
                                      match.group(0)!,
                                      style: AppFonts.bodyStyle.copyWith(
                                        fontWeight: FontWeight.bold,
                                        fontSize: isDesktop ? 13 : 11,
                                      ),
                                    ),
                                  ),
                                ),
                              );
                              last = match.end;
                            }
                            if (last < text.length) {
                              spans.add(TextSpan(text: text.substring(last)));
                            }
                            textWidget = RichText(
                              text: TextSpan(
                                style: AppFonts.bodyStyle.copyWith(
                                  fontSize: isDesktop ? 14 : 11,
                                ),
                                children: spans,
                              ),
                            );
                          }
                          // Tooltip pentru insight-uri complexe
                          String? tooltip;
                          if (insight.type == NarrativeInsightType.hot) {
                            tooltip =
                                'Numerele hot sunt cele mai frecvente în toate extragerile.';
                          } else if (insight.type ==
                              NarrativeInsightType.cold) {
                            tooltip =
                                'Numerele reci sunt cele mai rare în toate extragerile.';
                          } else if (insight.type ==
                              NarrativeInsightType.distance) {
                            tooltip =
                                'Distan?a = diferen?a dintre doua numere consecutive ordonate.';
                          }
                          return Padding(
                            padding: const EdgeInsets.only(bottom: 10),
                            child: Row(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Tooltip(
                                  message: tooltip ?? '',
                                  child: Container(
                                    decoration: BoxDecoration(
                                      shape: BoxShape.circle,
                                      boxShadow: [
                                        BoxShadow(
                                          color: Colors.white.withValues(
                                            alpha: 0.35,
                                          ),
                                          blurRadius: 6,
                                          spreadRadius: 1,
                                        ),
                                      ],
                                    ),
                                    child: Icon(
                                      insight.icon ?? Icons.info_outline,
                                      color: pastel.withValues(alpha: 0.85),
                                      size: isDesktop ? 20 : 22,
                                    ),
                                  ),
                                ),
                                const SizedBox(width: 10),
                                Expanded(child: textWidget),
                              ],
                            ),
                          );
                        }),
                      ],
                    ),
                  ),
                ),
              ),
              // Butonul X absolut, în col?ul din dreapta sus
              Positioned(
                top: 10,
                right: 10,
                child: Material(
                  color: Colors.transparent,
                  child: InkWell(
                    borderRadius: BorderRadius.circular(18),
                    onTap: onClose,
                    child: Container(
                      width: isDesktop ? 36 : 32,
                      height: isDesktop ? 36 : 32,
                      decoration: BoxDecoration(
                        color: Colors.white.withValues(alpha: 0.13),
                        shape: BoxShape.circle,
                      ),
                      child: Icon(
                        Icons.close,
                        size: isDesktop ? 22 : 20,
                        color: Colors.black.withValues(alpha: 0.7),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

import 'package:flutter/material.dart';
import '../../models/loto_draw.dart';
import '../tabs/archive_tab.dart';
import '../tabs/statistics_tab.dart';
import '../tabs/generator_tab.dart';
import '../tabs/settings_tab.dart';
import '../../utils/constants.dart';

class MainTabView extends StatelessWidget {
  final int currentTabIndex;
  final GameType selectedGame;
  final List<LotoDraw> draws;
  final List<LotoDraw> filteredDraws;
  final bool isLoading;
  final String? error;
  final VoidCallback onLoadData;
  final void Function(BuildContext, LotoDraw, List<LotoDraw>)
  onShowNarrativeAnalysisDialog;
  final List<LotoDraw> statsDraws;
  final String selectedPeriod;
  final List<int> periodOptions;
  final TabController statsTabController;
  final void Function(String) onPeriodChanged;
  final ValueChanged<String> onCustomPeriod;
  final void Function(Map<String, dynamic>) onStatsChanged;
  final Animation<double> fadeAnimation;

  const MainTabView({
    super.key,
    required this.currentTabIndex,
    required this.selectedGame,
    required this.draws,
    required this.filteredDraws,
    required this.isLoading,
    required this.error,
    required this.onLoadData,
    required this.onShowNarrativeAnalysisDialog,
    required this.statsDraws,
    required this.selectedPeriod,
    required this.periodOptions,
    required this.statsTabController,
    required this.onPeriodChanged,
    required this.onCustomPeriod,
    required this.onStatsChanged,
    required this.fadeAnimation,
  });

  @override
  Widget build(BuildContext context) {
    if (currentTabIndex == 3) {
      return const SettingsTab();
    }
    if (isLoading) {
      return const Center(
        child: CircularProgressIndicator(
          valueColor: AlwaysStoppedAnimation<Color>(AppColors.primaryGreen),
        ),
      );
    }
    if (error != null) {
      return Center(child: Text(error!));
    }
    return IndexedStack(
      index: currentTabIndex,
      children: [
        ArchiveTab(
          selectedGame: selectedGame,
          draws: draws,
          filteredDraws: filteredDraws,
          isLoading: isLoading,
          error: error,
          onLoadData: onLoadData,
          onShowNarrativeAnalysis: onShowNarrativeAnalysisDialog,
        ),
        StatisticsTab(
          statsDraws: statsDraws,
          allDraws: filteredDraws,
          selectedPeriod: selectedPeriod,
          periodOptions: periodOptions,
          statsTabController: statsTabController,
          onPeriodChanged: onPeriodChanged,
          onCustomPeriod: onCustomPeriod,
          onStatsChanged: onStatsChanged,
          selectedGame: selectedGame,
        ),
        GeneratorTab(fadeAnimation: fadeAnimation),
        const SettingsTab(),
      ],
    );
  }
}

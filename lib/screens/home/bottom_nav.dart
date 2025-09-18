import 'package:flutter/material.dart';
import 'package:loto_ro/utils/constants.dart';
import '../../widgets/bottom_navigation.dart';

class BottomNav extends StatelessWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const BottomNav({super.key, required this.currentIndex, required this.onTap});

  @override
  Widget build(BuildContext context) {
    final items = [
      const BottomNavigationItem(
        label: AppStrings.archiveTab,
        icon: Icons.archive,
      ),
      const BottomNavigationItem(
        label: AppStrings.statisticsTab,
        icon: Icons.analytics,
      ),
      const BottomNavigationItem(
        label: AppStrings.generatorTab,
        icon: Icons.casino,
      ),
      const BottomNavigationItem(
        label: AppStrings.settingsTab,
        icon: Icons.settings,
      ),
    ];
    return GlassBottomNavigation(
      currentIndex: currentIndex,
      onTap: onTap,
      items: items,
    );
  }
}

import 'package:flutter/material.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_button.dart';
import '../../services/storage_service.dart';
import '../../services/performance_service.dart';
import '../../services/cache_service.dart';
import '../debug/debug_panel.dart';

/// Tab pentru setari ?i configura?ii
class SettingsTab extends StatefulWidget {
  const SettingsTab({super.key});

  @override
  State<SettingsTab> createState() => _SettingsTabState();
}

class _SettingsTabState extends State<SettingsTab> {
  final StorageService _storageService = StorageService();
  final PerformanceService _performanceService = PerformanceService();
  final CacheService _cacheService = CacheService();

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildAppInfo(),
          const SizedBox(height: 16),
          _buildPerformanceSection(),
          const SizedBox(height: 16),
          _buildCacheSection(),
          const SizedBox(height: 16),
          _buildDebugSection(),
          const SizedBox(height: 16),
          _buildDataSection(),
        ],
      ),
    );
  }

  Widget _buildAppInfo() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Image.asset(
                  'assets/images/logo_lotoro.png',
                  width: 48,
                  height: 48,
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        'LotoRO',
                        style: Theme.of(context).textTheme.headlineSmall,
                      ),
                      Text(
                        'Versiunea 2.0.0',
                        style: Theme.of(context).textTheme.bodyMedium,
                      ),
                    ],
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            Text(
              'Aplica?ie pentru analiza ?i generarea numerelor pentru jocurile de loterie din România.',
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceSection() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              '? Performan?a',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GlassButton(
                    onTap: () {
                      final stats = _performanceService.getPerformanceStats();
                      _showStatsDialog('Statistici Performan?a', stats);
                    },
                    child: const Text('Vezi Statistici'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlassButton(
                    onTap: () {
                      _performanceService.clearHistory();
                      ScaffoldMessenger.of(context).showSnackBar(
                        const SnackBar(
                          content: Text(
                            'Istoricul de performan?a a fost ?ters',
                          ),
                        ),
                      );
                    },
                    child: const Text('?terge Istoric'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheSection() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('??? Cache', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GlassButton(
                    onTap: () async {
                      final stats = _cacheService.getStats();
                      _showStatsDialog('Statistici Cache', stats);
                    },
                    child: const Text('Vezi Statistici'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlassButton(
                    onTap: () async {
                      await _cacheService.clear();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Cache-ul a fost ?ters'),
                          ),
                        );
                      }
                    },
                    child: const Text('?terge Cache'),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 8),
            GlassButton(
              onTap: () async {
                await _cacheService.optimize();
                if (mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(content: Text('Cache-ul a fost optimizat')),
                  );
                }
              },
              child: const Text('Optimizeaza Cache'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDebugSection() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('?? Debug', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            GlassButton(
              onTap: () {
                Navigator.push(
                  context,
                  MaterialPageRoute(builder: (context) => const DebugPanel()),
                );
              },
              child: const Text('Debug Panel'),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildDataSection() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text('?? Date', style: Theme.of(context).textTheme.headlineSmall),
            const SizedBox(height: 16),
            Row(
              children: [
                Expanded(
                  child: GlassButton(
                    onTap: () async {
                      final logs = _storageService.getLogs('settings');
                      _showLogsDialog(logs);
                    },
                    child: const Text('Vezi Logs'),
                  ),
                ),
                const SizedBox(width: 16),
                Expanded(
                  child: GlassButton(
                    onTap: () async {
                      await _storageService.clearLogs();
                      if (mounted) {
                        ScaffoldMessenger.of(context).showSnackBar(
                          const SnackBar(
                            content: Text('Logs-urile au fost ?terse'),
                          ),
                        );
                      }
                    },
                    child: const Text('?terge Logs'),
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  void _showStatsDialog(String title, Map<String, dynamic> stats) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: Text(title),
        content: SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            mainAxisSize: MainAxisSize.min,
            children: stats.entries.map((entry) {
              return Padding(
                padding: const EdgeInsets.symmetric(vertical: 4),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(entry.key),
                    Text(
                      entry.value.toString(),
                      style: const TextStyle(fontWeight: FontWeight.bold),
                    ),
                  ],
                ),
              );
            }).toList(),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Închide'),
          ),
        ],
      ),
    );
  }

  void _showLogsDialog(List<Map<String, dynamic>> logs) {
    showDialog(
      context: context,
      builder: (context) => AlertDialog(
        title: const Text('Logs'),
        content: SizedBox(
          width: double.maxFinite,
          height: 400,
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: logs.map((log) {
                return Padding(
                  padding: const EdgeInsets.symmetric(vertical: 2),
                  child: Text(
                    log.toString(),
                    style: Theme.of(context).textTheme.bodySmall,
                  ),
                );
              }).toList(),
            ),
          ),
        ),
        actions: [
          TextButton(
            onPressed: () => Navigator.pop(context),
            child: const Text('Închide'),
          ),
        ],
      ),
    );
  }
}

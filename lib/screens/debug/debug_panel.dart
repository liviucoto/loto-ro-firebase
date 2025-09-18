import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import '../../services/performance_service.dart';
import '../../services/cache_service.dart';
import '../../services/storage_service.dart';
import '../../widgets/glass_card.dart';
import '../../widgets/glass_button.dart';

/// Interfață de debugging pentru dezvoltatori
/// Oferă acces la metrics de performanță, cache și logs
class DebugPanel extends StatefulWidget {
  const DebugPanel({super.key});

  @override
  State<DebugPanel> createState() => _DebugPanelState();
}

class _DebugPanelState extends State<DebugPanel> with TickerProviderStateMixin {
  final PerformanceService _performanceService = PerformanceService();
  final CacheService _cacheService = CacheService();
  final StorageService _storageService = StorageService();

  late TabController _tabController;
  Map<String, dynamic> _performanceStats = {};
  Map<String, dynamic> _cacheStats = {};
  List<Map<String, dynamic>> _slowOperations = [];
  List<String> _logs = [];
  bool _isMonitoring = false;

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 4, vsync: this);
    _loadData();
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  Future<void> _loadData() async {
    setState(() {
      _performanceStats = _performanceService.getPerformanceStats();
      _cacheStats = _cacheService.getStats();
      _slowOperations = _performanceService.getSlowOperations();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('🔧 Debug Panel'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        actions: [
          IconButton(
            icon: Icon(_isMonitoring ? Icons.stop : Icons.play_arrow),
            onPressed: _toggleMonitoring,
            tooltip: _isMonitoring ? 'Stop Monitoring' : 'Start Monitoring',
          ),
          IconButton(
            icon: const Icon(Icons.refresh),
            onPressed: _loadData,
            tooltip: 'Refresh Data',
          ),
          IconButton(
            icon: const Icon(Icons.download),
            onPressed: _exportData,
            tooltip: 'Export Data',
          ),
        ],
        bottom: TabBar(
          controller: _tabController,
          tabs: const [
            Tab(icon: Icon(Icons.speed), text: 'Performance'),
            Tab(icon: Icon(Icons.storage), text: 'Cache'),
            Tab(icon: Icon(Icons.warning), text: 'Issues'),
            Tab(icon: Icon(Icons.list), text: 'Logs'),
          ],
        ),
      ),
      body: TabBarView(
        controller: _tabController,
        children: [
          _buildPerformanceTab(),
          _buildCacheTab(),
          _buildIssuesTab(),
          _buildLogsTab(),
        ],
      ),
    );
  }

  Widget _buildPerformanceTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildMonitoringControls(),
          const SizedBox(height: 16),
          _buildPerformanceMetrics(),
          const SizedBox(height: 16),
          _buildOperationDetails(),
        ],
      ),
    );
  }

  Widget _buildMonitoringControls() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Monitoring Controls',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                GlassButton(
                  onTap: _toggleMonitoring,
                  child: Text(
                    _isMonitoring ? 'Stop Monitoring' : 'Start Monitoring',
                  ),
                ),
                const SizedBox(width: 16),
                GlassButton(
                  onTap: _performanceService.clearHistory,
                  child: const Text('Clear History'),
                ),
                const SizedBox(width: 16),
                GlassButton(
                  onTap: _runBenchmark,
                  child: const Text('Run Benchmark'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceMetrics() {
    final memoryStats = _performanceStats['memory'] as Map<String, dynamic>?;

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Metrics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (memoryStats != null) ...[
              _buildMetricRow(
                'Memory Usage',
                '${memoryStats['current']?.toStringAsFixed(2)} MB',
              ),
              _buildMetricRow(
                'Average Memory',
                '${memoryStats['average']?.toStringAsFixed(2)} MB',
              ),
              _buildMetricRow(
                'Max Memory',
                '${memoryStats['max']?.toStringAsFixed(2)} MB',
              ),
              _buildMetricRow('Memory Samples', '${memoryStats['samples']}'),
            ],
            const SizedBox(height: 8),
            _buildMetricRow(
              'Monitored Operations',
              '${_performanceStats.length - (memoryStats != null ? 1 : 0)}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationDetails() {
    final operations = _performanceStats.entries
        .where((entry) => entry.key != 'memory')
        .toList();

    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Operation Details',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            ...operations.map((entry) {
              final operationName = entry.key;
              final stats = entry.value as Map<String, dynamic>;

              return _buildOperationCard(operationName, stats);
            }),
          ],
        ),
      ),
    );
  }

  Widget _buildOperationCard(String operationName, Map<String, dynamic> stats) {
    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(operationName, style: Theme.of(context).textTheme.titleMedium),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(child: _buildMetricRow('Count', '${stats['count']}')),
                Expanded(
                  child: _buildMetricRow(
                    'Avg Time',
                    '${stats['averageTime']}ms',
                  ),
                ),
                Expanded(
                  child: _buildMetricRow(
                    'Slow Ops',
                    '${stats['slowOperations']}',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildCacheStats(),
          const SizedBox(height: 16),
          _buildCacheControls(),
        ],
      ),
    );
  }

  Widget _buildCacheStats() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cache Statistics',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildMetricRow('Memory Items', '${_cacheStats['memoryItems']}'),
            _buildMetricRow('Cache Hits', '${_cacheStats['hits']}'),
            _buildMetricRow('Cache Misses', '${_cacheStats['misses']}'),
            _buildMetricRow('Hit Rate', '${_cacheStats['hitRate']}%'),
            _buildMetricRow('Evictions', '${_cacheStats['evictions']}'),
            _buildMetricRow(
              'Total Requests',
              '${_cacheStats['totalRequests']}',
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildCacheControls() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Cache Controls',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                GlassButton(
                  onTap: () async {
                    await _cacheService.clear();
                    _loadData();
                  },
                  child: const Text('Clear Cache'),
                ),
                const SizedBox(width: 16),
                GlassButton(
                  onTap: () async {
                    await _cacheService.cleanup();
                    _loadData();
                  },
                  child: const Text('Cleanup'),
                ),
                const SizedBox(width: 16),
                GlassButton(
                  onTap: () async {
                    await _cacheService.optimize();
                    _loadData();
                  },
                  child: const Text('Optimize'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildIssuesTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildSlowOperations(),
          const SizedBox(height: 16),
          _buildPerformanceAlerts(),
        ],
      ),
    );
  }

  Widget _buildSlowOperations() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Slow Operations',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (_slowOperations.isEmpty)
              const Text('No slow operations detected')
            else
              ..._slowOperations.map((op) => _buildSlowOperationCard(op)),
          ],
        ),
      ),
    );
  }

  Widget _buildSlowOperationCard(Map<String, dynamic> operation) {
    final percentage = double.tryParse(operation['slowPercentage'] ?? '0') ?? 0;
    final color = percentage > 20
        ? Colors.red
        : percentage > 10
        ? Colors.orange
        : Colors.yellow;

    return Card(
      margin: const EdgeInsets.only(bottom: 8),
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              operation['operation'],
              style: Theme.of(context).textTheme.titleMedium,
            ),
            const SizedBox(height: 8),
            Row(
              children: [
                Expanded(
                  child: _buildMetricRow(
                    'Slow Count',
                    '${operation['slowCount']}',
                  ),
                ),
                Expanded(
                  child: _buildMetricRow(
                    'Very Slow',
                    '${operation['verySlowCount']}',
                  ),
                ),
                Expanded(
                  child: _buildMetricRow(
                    'Percentage',
                    '${operation['slowPercentage']}%',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildPerformanceAlerts() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Performance Alerts',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            _buildAlertCard(
              'Memory Usage',
              (_performanceStats['memory']?['current'] ?? 0) > 50
                  ? 'High'
                  : 'Normal',
              (_performanceStats['memory']?['current'] ?? 0) > 50
                  ? Colors.red
                  : Colors.green,
            ),
            const SizedBox(height: 8),
            _buildAlertCard(
              'Cache Hit Rate',
              (double.tryParse(_cacheStats['hitRate'] ?? '0') ?? 0) < 50
                  ? 'Low'
                  : 'Good',
              (double.tryParse(_cacheStats['hitRate'] ?? '0') ?? 0) < 50
                  ? Colors.orange
                  : Colors.green,
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildAlertCard(String title, String status, Color color) {
    return Card(
      color: color.withValues(alpha: 0.1),
      child: Padding(
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Icon(Icons.circle, color: color, size: 12),
            const SizedBox(width: 8),
            Expanded(child: Text(title)),
            Text(
              status,
              style: TextStyle(color: color, fontWeight: FontWeight.bold),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogsTab() {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          _buildLogControls(),
          const SizedBox(height: 16),
          _buildLogList(),
        ],
      ),
    );
  }

  Widget _buildLogControls() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Log Controls',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            Row(
              children: [
                GlassButton(onTap: _loadLogs, child: const Text('Load Logs')),
                const SizedBox(width: 16),
                GlassButton(onTap: _clearLogs, child: const Text('Clear Logs')),
                const SizedBox(width: 16),
                GlassButton(
                  onTap: _exportLogs,
                  child: const Text('Export Logs'),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildLogList() {
    return GlassCard(
      child: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Text(
              'Application Logs',
              style: Theme.of(context).textTheme.headlineSmall,
            ),
            const SizedBox(height: 16),
            if (_logs.isEmpty)
              const Text('No logs available')
            else
              ..._logs.map((log) => _buildLogEntry(log)),
          ],
        ),
      ),
    );
  }

  Widget _buildLogEntry(String log) {
    return Card(
      margin: const EdgeInsets.only(bottom: 4),
      child: Padding(
        padding: const EdgeInsets.all(8),
        child: Text(log, style: Theme.of(context).textTheme.bodySmall),
      ),
    );
  }

  Widget _buildMetricRow(String label, String value) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 4),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          Text(label),
          Text(value, style: const TextStyle(fontWeight: FontWeight.bold)),
        ],
      ),
    );
  }

  void _toggleMonitoring() {
    setState(() {
      _isMonitoring = !_isMonitoring;
      if (_isMonitoring) {
        _performanceService.startMonitoring();
      } else {
        _performanceService.stopMonitoring();
      }
    });
  }

  Future<void> _runBenchmark() async {
    // Benchmark pentru o operație de test
    final result = await _performanceService.benchmarkOperation(
      'test_operation',
      () async {
        await Future.delayed(const Duration(milliseconds: 100));
        return 'test_result';
      },
      iterations: 5,
    );

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            'Benchmark completed: ${result['averageTime']}ms average',
          ),
        ),
      );
    }
  }

  Future<void> _exportData() async {
    final performanceData = _performanceService.exportPerformanceData();
    final cacheData = _cacheService.getStats();

    final exportData = {
      'timestamp': DateTime.now().toIso8601String(),
      'performance': performanceData,
      'cache': cacheData,
    };

    final jsonString = const JsonEncoder.withIndent('  ').convert(exportData);

    await Clipboard.setData(ClipboardData(text: jsonString));

    if (mounted) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Debug data copied to clipboard')),
      );
    }
  }

  Future<void> _loadLogs() async {
    // Încarcă logs din storage service
    final logs = _storageService.getLogs('debug');
    setState(() {
      _logs = logs.map((log) => log.toString()).toList();
    });
  }

  Future<void> _clearLogs() async {
    await _storageService.clearLogs();
    setState(() {
      _logs = [];
    });
  }

  Future<void> _exportLogs() async {
    final logsText = _logs.join('\n');
    await Clipboard.setData(ClipboardData(text: logsText));

    if (mounted) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Logs copied to clipboard')));
    }
  }
}

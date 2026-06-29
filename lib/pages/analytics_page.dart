import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../widgets/chart_widget.dart';

/// Analytics page — line charts of sensor trends.
class AnalyticsPage extends StatefulWidget {
  final HomeController homeCtrl;

  const AnalyticsPage({super.key, required this.homeCtrl});

  @override
  State<AnalyticsPage> createState() => _AnalyticsPageState();
}

class _AnalyticsPageState extends State<AnalyticsPage> {
  String _selectedRange = '实时';

  static const _ranges = ['实时', '今日', '7天', '30天'];

  @override
  void initState() {
    super.initState();
    widget.homeCtrl.addListener(_onUpdate);
  }

  @override
  void dispose() {
    widget.homeCtrl.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final history = widget.homeCtrl.history;

    return Scaffold(
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Header ──
              Row(
                children: [
                  Container(
                    padding: const EdgeInsets.all(10),
                    decoration: BoxDecoration(
                      color: Colors.green.withValues(alpha: 0.1),
                      borderRadius: BorderRadius.circular(14),
                    ),
                    child: const Icon(
                      Icons.analytics_outlined,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '数据分析',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '环境趋势可视化',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 20),

              // ── Time Range Chips ──
              SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Row(
                  children: _ranges.map((r) {
                    final selected = _selectedRange == r;
                    return Padding(
                      padding: const EdgeInsets.only(right: 10),
                      child: ChoiceChip(
                        label: Text(r),
                        selected: selected,
                        onSelected: (_) => setState(() => _selectedRange = r),
                        selectedColor: Colors.green,
                        labelStyle: TextStyle(
                          color: selected ? Colors.white : null,
                          fontWeight:
                              selected ? FontWeight.w600 : FontWeight.normal,
                        ),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                        ),
                      ),
                    );
                  }).toList(),
                ),
              ),
              const SizedBox(height: 20),

              // ── Charts ──
              SensorChart(
                history: history,
                title: '温度趋势',
                color: Colors.red,
                extractor: (s) => [s.temperature],
                unit: '°C',
              ),
              const SizedBox(height: 16),
              SensorChart(
                history: history,
                title: '湿度趋势',
                color: Colors.blue,
                extractor: (s) => [s.humidity],
                unit: '%',
              ),
              const SizedBox(height: 16),
              SensorChart(
                history: history,
                title: 'EC值趋势',
                color: Colors.purple,
                extractor: (s) => [s.ec],
                unit: 'mS/cm',
              ),

              const SizedBox(height: 24),

              // ── Summary Cards ──
              Text(
                '统计摘要',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),

              if (history.isNotEmpty) ...{
                _buildSummary(context, history),
              } else
                Card(
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(14)),
                  child: const Padding(
                    padding: EdgeInsets.all(24),
                    child: Center(child: Text('暂无数据')),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildSummary(BuildContext context, List history) {
    final avgTemp =
        history.map<double>((s) => s.temperature).reduce((a, b) => a + b) /
            history.length;
    final avgHumidity =
        history.map<double>((s) => s.humidity).reduce((a, b) => a + b) /
            history.length;
    final avgEc =
        history.map<double>((s) => s.ec).reduce((a, b) => a + b) /
            history.length;

    return Row(
      children: [
        _summaryCard(context, '平均温度', '${avgTemp.toStringAsFixed(1)}°C',
            Icons.thermostat, Colors.red),
        const SizedBox(width: 12),
        _summaryCard(context, '平均湿度', '${avgHumidity.toStringAsFixed(1)}%',
            Icons.water_drop, Colors.blue),
        const SizedBox(width: 12),
        _summaryCard(context, '平均EC', '${avgEc.toStringAsFixed(2)}',
            Icons.science, Colors.purple),
      ],
    );
  }

  Widget _summaryCard(
      BuildContext context, String label, String value, IconData icon, Color color) {
    final theme = Theme.of(context);
    return Expanded(
      child: Card(
        elevation: 1,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
        child: Padding(
          padding: const EdgeInsets.all(14),
          child: Column(
            children: [
              Icon(icon, color: color, size: 22),
              const SizedBox(height: 6),
              Text(
                value,
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              Text(
                label,
                style: theme.textTheme.labelSmall?.copyWith(
                  color: theme.colorScheme.outline,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

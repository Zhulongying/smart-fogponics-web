import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';
import '../models/sensor_model.dart';

/// Renders a line chart for the given sensor data history.
class SensorChart extends StatelessWidget {
  final List<SensorData> history;
  final String title;
  final Color color;
  final List<double> Function(SensorData) extractor;
  final String unit;

  const SensorChart({
    super.key,
    required this.history,
    required this.title,
    required this.color,
    required this.extractor,
    required this.unit,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    if (history.isEmpty) {
      return _buildEmpty(theme);
    }

    final spots = <FlSpot>[];
    for (int i = 0; i < history.length; i++) {
      final values = extractor(history[i]);
      if (values.isNotEmpty) {
        spots.add(FlSpot(i.toDouble(), values.first));
      }
    }

    return Card(
      elevation: 2,
      shadowColor: color.withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: Padding(
        padding: const EdgeInsets.fromLTRB(16, 16, 16, 12),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              children: [
                Container(
                  width: 8,
                  height: 8,
                  decoration: BoxDecoration(
                    color: color,
                    shape: BoxShape.circle,
                  ),
                ),
                const SizedBox(width: 8),
                Text(
                  title,
                  style: theme.textTheme.titleSmall?.copyWith(
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const Spacer(),
                Text(
                  unit,
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            SizedBox(
              height: 180,
              child: LineChart(
                LineChartData(
                  gridData: FlGridData(
                    show: true,
                    drawVerticalLine: false,
                    horizontalInterval: _interval(spots),
                    getDrawingHorizontalLine: (value) => FlLine(
                      color: theme.colorScheme.surfaceContainerHighest,
                      strokeWidth: 1,
                    ),
                  ),
                  titlesData: FlTitlesData(
                    topTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    rightTitles: const AxisTitles(
                        sideTitles: SideTitles(showTitles: false)),
                    leftTitles: AxisTitles(
                      sideTitles: SideTitles(
                        showTitles: true,
                        reservedSize: 36,
                        getTitlesWidget: (value, meta) => Text(
                          value.toStringAsFixed(1),
                          style: theme.textTheme.labelSmall?.copyWith(
                            color: theme.colorScheme.outline,
                          ),
                        ),
                      ),
                    ),
                    bottomTitles: const AxisTitles(
                      sideTitles: SideTitles(showTitles: false),
                    ),
                  ),
                  borderData: FlBorderData(show: false),
                  lineBarsData: [
                    LineChartBarData(
                      spots: spots,
                      isCurved: true,
                      curveSmoothness: 0.3,
                      color: color,
                      barWidth: 2.5,
                      dotData: FlDotData(
                        show: spots.length < 12,
                        getDotPainter: (spot, _, __, ___) =>
                            FlDotCirclePainter(
                          color: color,
                          radius: 3,
                          strokeWidth: 2,
                          strokeColor: Colors.white,
                        ),
                      ),
                      belowBarData: BarAreaData(
                        show: true,
                        gradient: LinearGradient(
                          begin: Alignment.topCenter,
                          end: Alignment.bottomCenter,
                          colors: [
                            color.withValues(alpha: 0.25),
                            color.withValues(alpha: 0.02),
                          ],
                        ),
                      ),
                    ),
                  ],
                  minY: _minY(spots),
                  maxY: _maxY(spots),
                  lineTouchData: LineTouchData(
                    touchTooltipData: LineTouchTooltipData(
                      getTooltipColor: (_) =>
                          theme.colorScheme.inverseSurface,
                      getTooltipItems: (touchedSpots) => touchedSpots.map((s) {
                        return LineTooltipItem(
                          '${s.y.toStringAsFixed(1)} $unit',
                          TextStyle(
                            color: color,
                            fontWeight: FontWeight.w600,
                            fontSize: 12,
                          ),
                        );
                      }).toList(),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildEmpty(ThemeData theme) {
    return Card(
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(16)),
      child: SizedBox(
        height: 200,
        child: Center(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              Icon(Icons.show_chart, size: 40, color: theme.colorScheme.outline),
              const SizedBox(height: 8),
              Text('等待数据...', style: theme.textTheme.bodyMedium),
            ],
          ),
        ),
      ),
    );
  }

  double _minY(List<FlSpot> spots) {
    if (spots.isEmpty) return 0;
    return spots.map((s) => s.y).reduce((a, b) => a < b ? a : b) * 0.9;
  }

  double _maxY(List<FlSpot> spots) {
    if (spots.isEmpty) return 100;
    return spots.map((s) => s.y).reduce((a, b) => a > b ? a : b) * 1.1;
  }

  double _interval(List<FlSpot> spots) {
    if (spots.length < 2) return 10;
    final min = spots.map((s) => s.y).reduce((a, b) => a < b ? a : b);
    final max = spots.map((s) => s.y).reduce((a, b) => a > b ? a : b);
    return ((max - min) / 4).abs();
  }
}

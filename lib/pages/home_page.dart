import 'package:flutter/material.dart';
import '../controllers/home_controller.dart';
import '../controllers/device_controller.dart';
import '../models/device_model.dart';
import '../widgets/sensor_card.dart';

/// Home page — real-time sensor monitoring dashboard.
class HomePage extends StatefulWidget {
  final HomeController homeCtrl;
  final DeviceController deviceCtrl;

  const HomePage({
    super.key,
    required this.homeCtrl,
    required this.deviceCtrl,
  });

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  @override
  void initState() {
    super.initState();
    widget.homeCtrl.addListener(_onUpdate);
    widget.deviceCtrl.addListener(_onUpdate);
  }

  @override
  void dispose() {
    widget.homeCtrl.removeListener(_onUpdate);
    widget.deviceCtrl.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final sensor = widget.homeCtrl.sensorData;
    final devices = widget.deviceCtrl.devices;

    return Scaffold(
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: () async {
            widget.homeCtrl.refreshNow();
          },
          child: SingleChildScrollView(
            physics: const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.fromLTRB(20, 12, 20, 24),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // ── Header ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          '智能雾培系统',
                          style: theme.textTheme.headlineSmall?.copyWith(
                            fontWeight: FontWeight.bold,
                          ),
                        ),
                        const SizedBox(height: 4),
                        Row(
                          children: [
                            _statusDot(widget.homeCtrl.mqttConnected),
                            const SizedBox(width: 6),
                            Text(
                              widget.homeCtrl.mqttConnected ? 'MQTT 已连接' : '未连接',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: widget.homeCtrl.mqttConnected
                                    ? Colors.green
                                    : theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                    Container(
                      padding: const EdgeInsets.all(10),
                      decoration: BoxDecoration(
                        color: Colors.green.withValues(alpha: 0.1),
                        borderRadius: BorderRadius.circular(14),
                      ),
                      child: const Icon(Icons.eco, color: Colors.green, size: 28),
                    ),
                  ],
                ),
                const SizedBox(height: 24),

                // ── Sensor Grid ──
                Text(
                  '环境监测',
                  style: theme.textTheme.titleMedium?.copyWith(
                    fontWeight: FontWeight.bold,
                  ),
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 0.9,
                  children: [
                    SensorCard(
                      title: '温度',
                      value: sensor.temperature.toStringAsFixed(1),
                      unit: '°C',
                      icon: Icons.thermostat,
                      color: Colors.red,
                      status: sensor.temperatureStatus,
                    ),
                    SensorCard(
                      title: '湿度',
                      value: sensor.humidity.toStringAsFixed(1),
                      unit: '%',
                      icon: Icons.water_drop,
                      color: Colors.blue,
                      status: sensor.humidityStatus,
                    ),
                    SensorCard(
                      title: '光照',
                      value: sensor.light.toStringAsFixed(0),
                      unit: 'lux',
                      icon: Icons.wb_sunny,
                      color: Colors.amber,
                      status: sensor.lightStatus,
                    ),
                    SensorCard(
                      title: 'EC值',
                      value: sensor.ec.toStringAsFixed(2),
                      unit: 'mS/cm',
                      icon: Icons.science,
                      color: Colors.purple,
                      status: sensor.ecStatus,
                    ),
                  ],
                ),
                const SizedBox(height: 28),

                // ── Device Status ──
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      '设备状态',
                      style: theme.textTheme.titleMedium?.copyWith(
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      '${devices.where((d) => d.isOn).length}/${devices.length} 运行中',
                      style: theme.textTheme.bodySmall?.copyWith(
                        color: theme.colorScheme.outline,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 12),
                GridView.count(
                  crossAxisCount: 2,
                  shrinkWrap: true,
                  physics: const NeverScrollableScrollPhysics(),
                  mainAxisSpacing: 12,
                  crossAxisSpacing: 12,
                  childAspectRatio: 1.6,
                  children: devices.map((d) => _deviceStatusCard(theme, d)).toList(),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Widget _statusDot(bool active) {
    return Container(
      width: 8,
      height: 8,
      decoration: BoxDecoration(
        color: active ? Colors.green : Colors.grey,
        shape: BoxShape.circle,
        boxShadow: [
          BoxShadow(
            color: (active ? Colors.green : Colors.grey).withValues(alpha: 0.4),
            blurRadius: 4,
            spreadRadius: 1,
          ),
        ],
      ),
    );
  }

  Widget _deviceStatusCard(ThemeData theme, Device device) {
    final bool on = device.isOn;
    return Card(
      elevation: 1,
      shadowColor: (on ? Colors.green : Colors.grey).withValues(alpha: 0.12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.all(14),
        child: Row(
          children: [
            Container(
              width: 40,
              height: 40,
              decoration: BoxDecoration(
                color: (on ? Colors.green : Colors.grey.shade200)
                    .withValues(alpha: on ? 0.15 : 1),
                borderRadius: BorderRadius.circular(10),
              ),
              alignment: Alignment.center,
              child: Text(device.icon, style: const TextStyle(fontSize: 20)),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    device.name,
                    style: theme.textTheme.titleSmall?.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                  const SizedBox(height: 2),
                  Text(
                    on ? '运行中' : '已关闭',
                    style: theme.textTheme.labelSmall?.copyWith(
                      color: on ? Colors.green : theme.colorScheme.outline,
                    ),
                  ),
                ],
              ),
            ),
            AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              width: 10,
              height: 10,
              decoration: BoxDecoration(
                color: on ? Colors.green : Colors.grey.shade300,
                shape: BoxShape.circle,
                boxShadow: on
                    ? [
                        BoxShadow(
                          color: Colors.green.withValues(alpha: 0.5),
                          blurRadius: 6,
                          spreadRadius: 1,
                        ),
                      ]
                    : null,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

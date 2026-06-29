import 'package:flutter/material.dart';
import '../controllers/device_controller.dart';
import '../widgets/device_tile.dart';

/// Control page — switch individual devices on/off plus auto mode.
class ControlPage extends StatefulWidget {
  final DeviceController deviceCtrl;

  const ControlPage({super.key, required this.deviceCtrl});

  @override
  State<ControlPage> createState() => _ControlPageState();
}

class _ControlPageState extends State<ControlPage> {
  @override
  void initState() {
    super.initState();
    widget.deviceCtrl.addListener(_onUpdate);
  }

  @override
  void dispose() {
    widget.deviceCtrl.removeListener(_onUpdate);
    super.dispose();
  }

  void _onUpdate() => setState(() {});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final devices = widget.deviceCtrl.devices;

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
                      Icons.toggle_on_outlined,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '设备控制',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '管理所有执行器设备',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 24),

              // ── Auto Mode Master Switch ──
              Card(
                elevation: 3,
                shadowColor: (widget.deviceCtrl.autoMode
                        ? Colors.green
                        : Colors.grey)
                    .withValues(alpha: 0.2),
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(16),
                  side: BorderSide(
                    color: widget.deviceCtrl.autoMode
                        ? Colors.green.withValues(alpha: 0.5)
                        : Colors.transparent,
                    width: 1.5,
                  ),
                ),
                child: Padding(
                  padding: const EdgeInsets.symmetric(
                      horizontal: 20, vertical: 14),
                  child: Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          gradient: widget.deviceCtrl.autoMode
                              ? LinearGradient(
                                  colors: [
                                    Colors.green.shade400,
                                    Colors.green.shade600,
                                  ],
                                )
                              : null,
                          color: widget.deviceCtrl.autoMode
                              ? null
                              : Colors.grey.shade200,
                          borderRadius: BorderRadius.circular(14),
                        ),
                        alignment: Alignment.center,
                        child: Icon(
                          Icons.auto_mode,
                          color: widget.deviceCtrl.autoMode
                              ? Colors.white
                              : Colors.grey,
                          size: 26,
                        ),
                      ),
                      const SizedBox(width: 16),
                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              '自动模式',
                              style: theme.textTheme.titleMedium?.copyWith(
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              widget.deviceCtrl.autoMode
                                  ? '系统自动调节所有设备'
                                  : '手动控制各设备',
                              style: theme.textTheme.bodySmall?.copyWith(
                                color: theme.colorScheme.outline,
                              ),
                            ),
                          ],
                        ),
                      ),
                      Switch.adaptive(
                        value: widget.deviceCtrl.autoMode,
                        onChanged: (v) => widget.deviceCtrl.setAutoMode(v),
                        activeColor: Colors.green,
                        activeTrackColor: Colors.green.withValues(alpha: 0.3),
                      ),
                    ],
                  ),
                ),
              ),
              const SizedBox(height: 20),

              // ── Device List ──
              Text(
                '设备列表',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              ...List.generate(devices.length, (i) {
                return Padding(
                  padding: EdgeInsets.only(
                      bottom: i < devices.length - 1 ? 10 : 0),
                  child: DeviceTile(
                    name: devices[i].name,
                    icon: devices[i].icon,
                    isOn: devices[i].isOn,
                    onChanged: (v) => widget.deviceCtrl.toggleDevice(i),
                  ),
                );
              }),

              const SizedBox(height: 24),

              // ── Quick Actions ──
              Text(
                '快捷操作',
                style: theme.textTheme.titleMedium?.copyWith(
                  fontWeight: FontWeight.bold,
                ),
              ),
              const SizedBox(height: 12),
              Row(
                children: [
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => widget.deviceCtrl.setAll(true),
                      icon: const Icon(Icons.power_settings_new, size: 18),
                      label: const Text('全部开启'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.green,
                        side: const BorderSide(color: Colors.green),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 14),
                  Expanded(
                    child: OutlinedButton.icon(
                      onPressed: () => widget.deviceCtrl.setAll(false),
                      icon: const Icon(Icons.power_off, size: 18),
                      label: const Text('全部关闭'),
                      style: OutlinedButton.styleFrom(
                        foregroundColor: Colors.red,
                        side: const BorderSide(color: Colors.red),
                        padding: const EdgeInsets.symmetric(vertical: 14),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(14),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
      ),
    );
  }
}

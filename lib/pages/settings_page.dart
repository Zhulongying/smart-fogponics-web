import 'package:flutter/material.dart';

/// Settings page — app configuration and info.
class SettingsPage extends StatelessWidget {
  const SettingsPage({super.key});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

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
                      Icons.settings_outlined,
                      color: Colors.green,
                      size: 28,
                    ),
                  ),
                  const SizedBox(width: 14),
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        '设置',
                        style: theme.textTheme.headlineSmall?.copyWith(
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      Text(
                        '系统配置与信息',
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: theme.colorScheme.outline,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              const SizedBox(height: 28),

              // ── MQTT Config Section ──
              _sectionTitle(theme, 'MQTT 配置'),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    ListTile(
                      leading: const Icon(Icons.link),
                      title: const Text('Broker 地址'),
                      subtitle: const Text('mqtt.example.com'),
                      trailing: const Icon(Icons.copy, size: 18),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(14),
                      ),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.numbers),
                      title: const Text('端口'),
                      subtitle: const Text('1883'),
                      trailing: const Icon(Icons.copy, size: 18),
                    ),
                    const Divider(height: 1, indent: 56),
                    ListTile(
                      leading: const Icon(Icons.topic),
                      title: const Text('Topic 前缀'),
                      subtitle: const Text('smart_fogponics/'),
                      trailing: const Icon(Icons.copy, size: 18),
                    ),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── System Info Section ──
              _sectionTitle(theme, '系统信息'),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: Column(
                  children: [
                    _infoTile(theme, '应用版本', 'v1.0.0 (build 1)'),
                    const Divider(height: 1, indent: 56),
                    _infoTile(theme, 'Flutter SDK', '3.x'),
                    const Divider(height: 1, indent: 56),
                    _infoTile(theme, '连接协议', 'MQTT (模拟模式)'),
                    const Divider(height: 1, indent: 56),
                    _infoTile(theme, '数据刷新', '每2秒'),
                  ],
                ),
              ),
              const SizedBox(height: 24),

              // ── About Section ──
              _sectionTitle(theme, '关于'),
              const SizedBox(height: 10),
              Card(
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(14)),
                child: const ListTile(
                  leading: Icon(Icons.eco, color: Colors.green),
                  title: Text('Smart Fogponics IoT'),
                  subtitle: Text('智能雾培控制系统 v1.0\n农业科技 · IoT · 数字孪生'),
                  isThreeLine: true,
                ),
              ),

              const SizedBox(height: 32),

              // ── Footer ──
              Center(
                child: Text(
                  '🌱 Smart Fogponics © 2026',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: theme.colorScheme.outline,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  Widget _sectionTitle(ThemeData theme, String title) {
    return Text(
      title,
      style: theme.textTheme.titleMedium?.copyWith(
        fontWeight: FontWeight.bold,
      ),
    );
  }

  Widget _infoTile(ThemeData theme, String label, String value) {
    return ListTile(
      leading: const Icon(Icons.info_outline, size: 20),
      title: Text(label, style: theme.textTheme.bodyMedium),
      subtitle: Text(
        value,
        style: theme.textTheme.bodySmall?.copyWith(
          color: theme.colorScheme.outline,
        ),
      ),
    );
  }
}

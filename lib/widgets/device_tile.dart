import 'package:flutter/material.dart';

/// A switch tile for controlling an IoT device (pump, fogger, etc.).
class DeviceTile extends StatelessWidget {
  final String name;
  final String icon;
  final bool isOn;
  final ValueChanged<bool> onChanged;

  const DeviceTile({
    super.key,
    required this.name,
    required this.icon,
    required this.isOn,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    return Card(
      elevation: 1,
      shadowColor: (isOn ? Colors.green : Colors.grey).withValues(alpha: 0.15),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(14)),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 4),
        child: ListTile(
          contentPadding: EdgeInsets.zero,
          leading: Container(
            width: 44,
            height: 44,
            decoration: BoxDecoration(
              color: (isOn ? Colors.green : Colors.grey.shade200)
                  .withValues(alpha: isOn ? 0.15 : 1),
              borderRadius: BorderRadius.circular(12),
            ),
            alignment: Alignment.center,
            child: Text(icon, style: const TextStyle(fontSize: 22)),
          ),
          title: Text(
            name,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),
          subtitle: Text(
            isOn ? '运行中' : '已关闭',
            style: theme.textTheme.bodySmall?.copyWith(
              color: isOn ? Colors.green : theme.colorScheme.outline,
              fontWeight: FontWeight.w500,
            ),
          ),
          trailing: Switch.adaptive(
            value: isOn,
            onChanged: onChanged,
            activeColor: Colors.green,
            activeTrackColor: Colors.green.withValues(alpha: 0.3),
          ),
        ),
      ),
    );
  }
}

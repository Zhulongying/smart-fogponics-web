/// Device model — represents a controllable IoT actuator.
class Device {
  final String name;
  final String icon; // emoji or icon label
  bool isOn;

  Device({
    required this.name,
    required this.icon,
    required this.isOn,
  });
}

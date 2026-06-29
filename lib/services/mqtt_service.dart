import 'dart:async';
import 'dart:math';
import '../models/sensor_model.dart';

/// Simulated MQTT service — generates realistic sensor data.
/// In production this would connect to a real MQTT broker.
class MQTTService {
  final _random = Random();
  Timer? _timer;

  /// Callback invoked every time new sensor data arrives.
  void Function(SensorData data)? onData;

  /// Connection state (simulated).
  bool _connected = false;
  bool get connected => _connected;

  /// Simulate connecting to the MQTT broker.
  Future<void> connect() async {
    await Future.delayed(const Duration(milliseconds: 800));
    _connected = true;
  }

  /// Start publishing simulated sensor data every [interval].
  void startStream({Duration interval = const Duration(seconds: 2)}) {
    _timer?.cancel();
    _timer = Timer.periodic(interval, (_) {
      if (!_connected) return;
      onData?.call(_generateData());
    });
    // Emit first value immediately.
    onData?.call(_generateData());
  }

  /// Stop the data stream.
  void stopStream() {
    _timer?.cancel();
    _timer = null;
  }

  /// Simulate disconnecting.
  void disconnect() {
    _connected = false;
    _timer?.cancel();
  }

  /// Simulate publishing a device command (pump, light, etc.).
  void publishCommand(String device, bool state) {
    // In production this would publish to the MQTT topic.
    // For now, simply print to console.
    print('[MQTT] → $device ${state ? "ON" : "OFF"}');
  }

  /// Generate plausible sensor values.
  SensorData _generateData() {
    return SensorData(
      temperature: 20 + _random.nextDouble() * 15, // 20–35 °C
      humidity: 40 + _random.nextDouble() * 40, // 40–80 %
      light: 100 + _random.nextDouble() * 700, // 100–800 lux
      ec: 1.0 + _random.nextDouble() * 1.5, // 1.0–2.5 mS/cm
    );
  }

  void dispose() {
    stopStream();
  }
}

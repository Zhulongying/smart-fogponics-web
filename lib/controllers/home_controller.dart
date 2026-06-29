import 'package:flutter/foundation.dart';
import '../models/sensor_model.dart';
import '../services/mqtt_service.dart';

/// Manages sensor data and exposes it to the UI.
class HomeController extends ChangeNotifier {
  final MQTTService _mqtt = MQTTService();

  SensorData _sensorData = SensorData(
    temperature: 26.0,
    humidity: 60.0,
    light: 450.0,
    ec: 1.6,
  );

  SensorData get sensorData => _sensorData;
  bool get mqttConnected => _mqtt.connected;

  /// Historical data for charts (last 20 points).
  final List<SensorData> _history = [];
  List<SensorData> get history => List.unmodifiable(_history);

  HomeController() {
    _mqtt.onData = (data) {
      _sensorData = data;
      _history.add(data);
      if (_history.length > 20) _history.removeAt(0);
      notifyListeners();
    };
    _init();
  }

  Future<void> _init() async {
    await _mqtt.connect();
    _mqtt.startStream();
    notifyListeners();
  }

  /// Manually refresh (forces an immediate data point).
  void refreshNow() {
    _mqtt.onData?.call(SensorData(
      temperature: 20 + (_mqtt.hashCode % 15),
      humidity: 40 + (_mqtt.hashCode % 40),
      light: 100 + (_mqtt.hashCode % 700),
      ec: 1.0 + (_mqtt.hashCode % 15) / 10,
    ));
  }

  @override
  void dispose() {
    _mqtt.dispose();
    super.dispose();
  }
}

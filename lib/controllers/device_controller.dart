import 'package:flutter/foundation.dart';
import '../models/device_model.dart';
import '../services/mqtt_service.dart';

/// Manages device (actuator) states — pump, fogger, light, fan.
class DeviceController extends ChangeNotifier {
  final MQTTService _mqtt = MQTTService();

  final List<Device> _devices = [
    Device(name: '水泵', icon: '💧', isOn: false),
    Device(name: '雾化器', icon: '🌫️', isOn: false),
    Device(name: '补光灯', icon: '💡', isOn: false),
    Device(name: '风扇', icon: '🌀', isOn: false),
  ];

  List<Device> get devices => _devices;

  bool _autoMode = false;
  bool get autoMode => _autoMode;

  void toggleDevice(int index) {
    _devices[index].isOn = !_devices[index].isOn;
    _mqtt.publishCommand(_devices[index].name, _devices[index].isOn);
    notifyListeners();
  }

  void setAutoMode(bool value) {
    _autoMode = value;
    notifyListeners();
  }

  /// Toggle all devices to a specific state.
  void setAll(bool state) {
    for (final d in _devices) {
      d.isOn = state;
    }
    notifyListeners();
  }
}

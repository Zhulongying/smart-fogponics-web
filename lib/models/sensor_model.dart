/// Sensor data model — holds real-time environmental readings.
class SensorData {
  double temperature;
  double humidity;
  double light;
  double ec;

  SensorData({
    required this.temperature,
    required this.humidity,
    required this.light,
    required this.ec,
  });

  /// Status helpers
  String get temperatureStatus {
    if (temperature < 18) return '偏低';
    if (temperature > 30) return '偏高';
    return '适宜';
  }

  String get humidityStatus {
    if (humidity < 50) return '偏低';
    if (humidity > 80) return '偏高';
    return '适宜';
  }

  String get lightStatus {
    if (light < 200) return '偏低';
    if (light > 700) return '偏高';
    return '适宜';
  }

  String get ecStatus {
    if (ec < 1.2) return '偏低';
    if (ec > 2.2) return '偏高';
    return '适宜';
  }

  /// Create a copy with optional overrides.
  SensorData copyWith({
    double? temperature,
    double? humidity,
    double? light,
    double? ec,
  }) {
    return SensorData(
      temperature: temperature ?? this.temperature,
      humidity: humidity ?? this.humidity,
      light: light ?? this.light,
      ec: ec ?? this.ec,
    );
  }
}

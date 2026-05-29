class WeatherModel {
  final String zone;
  final double tempC;
  final double rainMm;
  final String riskLevel; // bajo | medio | alto
  final String fetchedAt;
  final bool stale;

  const WeatherModel({
    required this.zone,
    required this.tempC,
    required this.rainMm,
    required this.riskLevel,
    required this.fetchedAt,
    this.stale = false,
  });

  factory WeatherModel.fromJson(Map<String, dynamic> j) => WeatherModel(
    zone: j['zone'],
    tempC: double.parse(j['temp_c'].toString()),
    rainMm: double.parse(j['rain_mm'].toString()),
    riskLevel: j['risk_level'],
    fetchedAt: j['fetched_at'],
    stale: j['stale'] ?? false,
  );
}

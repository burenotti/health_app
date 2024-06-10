class Metric {
  final String metricId;
  final String traineeId;
  final int height;
  final int weight;
  final int heartRate;
  final DateTime createdAt;

  Metric({
    required this.metricId,
    required this.traineeId,
    required this.height,
    required this.weight,
    required this.heartRate,
    required this.createdAt,
  });
}

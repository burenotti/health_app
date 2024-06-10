import 'package:dio/dio.dart';
import 'package:health_app/repositories/metric_repository/models.dart';

class MetricRepository {
  static const baseUrl = "http://192.168.1.7";

  final Dio dio;

  MetricRepository(this.dio);

  Options getOpts(String? accessToken) {
    return Options(
      contentType: "application/json",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Future<void> createMetric({
    required String accessToken,
    required String metricId,
    required int height,
    required int weight,
    required int heartRate,
  }) async {
    final response = await dio.post(
      "$baseUrl/metrics/$metricId",
      options: getOpts(accessToken),
      data: {
        "height": height,
        "weight": weight,
        "heart_rate": heartRate,
      },
    );
  }

  Future<Metric> getMetric({
    required String accessToken,
    required String metricId,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      "$baseUrl/metrics/$metricId",
      options: getOpts(accessToken),
    );

    final data = response.data!;

    return Metric(
      metricId: metricId,
      traineeId: data["trainee_id"],
      height: data["height"],
      weight: data["weight"],
      heartRate: data["heart_rate"],
      createdAt: DateTime.parse(data["created_at"]),
    );
  }

  Future<List<Metric>> listMetrics({
    required String accessToken,
    required String traineeId,
  }) async {
    final response = await dio.get<Map<String, dynamic>>(
      "$baseUrl/metrics/list/$traineeId",
      options: getOpts(accessToken),
    );

    final data = response.data!["metrics"] as List<dynamic>;

    return data
        .map((e) => Metric(
              metricId: e["metric_id"],
              traineeId: e["trainee_id"],
              height: e["height"],
              weight: e["weight"],
              heartRate: e["heart_rate"],
              createdAt: DateTime.parse(e["created_at"]),
            ))
        .toList();
  }
}

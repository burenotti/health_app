import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/repositories/metric_repository/metric_repository.dart';
import 'package:health_app/repositories/metric_repository/models.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'package:talker_flutter/talker_flutter.dart';

class MetricOverview extends StatefulWidget {
  final String traineeId;

  const MetricOverview({
    super.key,
    required this.traineeId,
  });

  @override
  State<MetricOverview> createState() => _MetricOverviewState();
}

class _MetricOverviewState extends State<MetricOverview> {
  final accountService = GetIt.I<AccountService>();
  final metricsRepo = GetIt.I<MetricRepository>();

  @override
  Widget build(BuildContext context) {
    final color = Theme.of(context).colorScheme.onSecondaryContainer;
    const size = 32.0;
    return Container(
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(16),
          color: Colors.black12,
        ),
        child: FutureBuilder<Metric?>(
          future: () async {
            final accessToken = accountService.account.token!.accessToken;
            try {
              final metrics = await metricsRepo.listMetrics(
                  accessToken: accessToken, traineeId: widget.traineeId);
              return metrics.isNotEmpty
                  ? metrics[0]
                  : Metric(
                      metricId: "default",
                      createdAt: DateTime.now(),
                      heartRate: 0,
                      height: 0,
                      traineeId: '',
                      weight: 0);
            } catch (e) {
              GetIt.I<Talker>().error(e);
            }
          }(),
          builder: (context, snapshot) {
            return Row(
              mainAxisAlignment: MainAxisAlignment.spaceAround,
              mainAxisSize: MainAxisSize.min,
              children: [
                if (!snapshot.hasData)
                  const CircularProgressIndicator()
                else ...[
                  getItem(
                    icon: Icon(Icons.monitor_heart, size: size, color: color),
                    value: (snapshot.data!.metricId != "default")
                        ? snapshot.data!.heartRate.toString()
                        : "?",
                    units: "у/м",
                    color: color,
                  ),
                  getItem(
                    icon: Icon(Icons.monitor_weight, size: size, color: color),
                    value: (snapshot.data!.metricId != "default")
                        ? snapshot.data!.weight.toString()
                        : "?",
                    units: "кг",
                    color: color,
                  ),
                  getItem(
                    icon: Icon(Icons.height, size: size, color: color),
                    value: (snapshot.data!.metricId != "default")
                        ? snapshot.data!.height.toString()
                        : "?",
                    units: "см",
                    color: color,
                  ),
                ]
              ],
            );
          },
        ));
  }

  Widget getItem({
    required Icon icon,
    required String value,
    required String units,
    Color? color,
  }) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 20.0, vertical: 4.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          icon,
          Text(
            "$value $units",
            style: TextStyle(color: color),
          ),
        ],
      ),
    );
  }
}

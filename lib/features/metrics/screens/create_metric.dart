import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/repositories/metric_repository/metric_repository.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'package:uuid/uuid.dart';

class CreateMetric extends StatefulWidget {
  const CreateMetric({super.key});

  @override
  State<CreateMetric> createState() => _CreateMetricState();
}

class _CreateMetricState extends State<CreateMetric> {
  final accountService = GetIt.I<AccountService>();
  final uuid = const Uuid();
  final metricRepo = GetIt.I<MetricRepository>();
  final weightController = TextEditingController();
  final heightController = TextEditingController();
  final heartRateController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            Navigator.of(context).pop();
          },
        ),
        title: const Text("Добавить измерение"),
        actions: [
          IconButton(
            onPressed: () async {
              final token = accountService.account.token!.accessToken;
              await metricRepo.createMetric(
                accessToken: token,
                metricId: uuid.v4(),
                height: int.parse(heightController.text),
                weight: int.parse(weightController.text),
                heartRate: int.parse(heartRateController.text),
              );
              if (context.mounted) {
                Navigator.of(context).pop();
              }
            },
            icon: const Icon(Icons.check),
          ),
        ],
      ),
      body: Form(
        child: Padding(
          padding: const EdgeInsets.only(top: 32.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              SizedBox(
                width: 110,
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.monitor_heart),
                    border: OutlineInputBorder(),
                    hintText: "ЧСС",
                  ),
                  controller: heartRateController,
                  keyboardType: TextInputType.number,
                ),
              ),
              Padding(
                padding: const EdgeInsets.symmetric(horizontal: 16.0),
                child: SizedBox(
                  width: 110,
                  child: TextFormField(
                    style: const TextStyle(
                      fontSize: 20.0,
                    ),
                    decoration: const InputDecoration(
                      prefixIcon: Icon(Icons.monitor_weight),
                      border: OutlineInputBorder(),
                      hintText: "КГ",
                    ),
                    controller: weightController,
                    keyboardType: TextInputType.number,
                  ),
                ),
              ),
              SizedBox(
                width: 110,
                child: TextFormField(
                  style: const TextStyle(
                    fontSize: 20.0,
                  ),
                  decoration: const InputDecoration(
                    prefixIcon: Icon(Icons.height),
                    border: OutlineInputBorder(),
                    hintText: "СМ",
                  ),
                  controller: heightController,
                  keyboardType: TextInputType.number,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}

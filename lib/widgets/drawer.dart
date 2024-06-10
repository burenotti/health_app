import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/features/metrics/screens/create_metric.dart';
import 'package:health_app/repositories/metric_repository/metric_repository.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'package:health_app/services/account_service/models.dart';
import 'package:health_app/widgets/avatar.dart';
import 'package:health_app/widgets/metric_overview.dart';

class AppDrawer extends StatefulWidget {
  const AppDrawer({super.key});

  @override
  State<AppDrawer> createState() => _AppDrawerState();
}

class _AppDrawerState extends State<AppDrawer> {
  final accountService = GetIt.I<AccountService>();
  // final metricsRepo = GetIt.I<MetricRepository>();

  @override
  Widget build(BuildContext context) {
    final account = accountService.account;
    final profileType = account.profile.type;
    final id = account.userId;
    final fullName = "${account.profile.firstName} ${account.profile.lastName}";
    return Drawer(
      child: Column(
        children: [
          Padding(
            padding: const EdgeInsets.only(top: 50.0),
            child: Column(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                Padding(
                  padding: const EdgeInsets.only(bottom: 16.0),
                  child: Avatar(name: fullName),
                ),
                Text(fullName),
                if (profileType == ProfileType.trainee)
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: MetricOverview(traineeId: id),
                  ),
              ],
            ),
          ),
          ListTile(
            leading: const Icon(Icons.add),
            title: const Text("Добавить измерение"),
            onTap: (){
              Navigator.of(context).popAndPushNamed("/metrics/add");
            },),
          ListTile(
            leading: const Icon(Icons.logout),
            title: const Text("Выйти"),
            onTap: () async {
              await accountService.logout();

              if (!context.mounted) {
                return;
              }

              Navigator.of(context).popAndPushNamed("/");
            },
          ),
        ],
      ),
    );
  }
}

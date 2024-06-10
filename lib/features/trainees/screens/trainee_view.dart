import 'package:flutter/material.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/repositories/metric_repository/models.dart';
import 'package:health_app/repositories/profile_repository/profile_repository.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'package:health_app/services/account_service/models.dart';
import 'package:health_app/widgets/avatar.dart';
import 'package:health_app/widgets/metric_overview.dart';
import 'package:talker_flutter/talker_flutter.dart';

class TraineeDTO {
  final String traineeId;

  TraineeDTO({required this.traineeId});
}

class TraineeView extends StatefulWidget {
  const TraineeView({super.key});

  @override
  State<TraineeView> createState() => _TraineeViewState();
}

class _TraineeViewState extends State<TraineeView> {
  final accountService = GetIt.I<AccountService>();
  final profileRepo = GetIt.I<ProfileRepository>();

  @override
  Widget build(BuildContext context) {
    return FutureBuilder<Trainee?>(future: () async {
      final traineeDto =
          ModalRoute.of(context)?.settings.arguments as TraineeDTO;
      final token = accountService.account.token!.accessToken;
      try {
        final profile =
            await profileRepo.getTrainee(token, traineeDto.traineeId);
        return Trainee(
          firstName: profile!.firstName,
          lastName: profile.lastName,
          birthDate: profile.birthDate,
        );
      } catch (e) {
        GetIt.I<Talker>().error(e);
        return null;
      }
    }(), builder: (context, snapshot) {
      return Scaffold(
        appBar: AppBar(
          leading: IconButton(
            icon: const Icon(Icons.arrow_back),
            onPressed: () {
              Navigator.of(context).pop();
            },
          ),
        ),
        body: Padding(
          padding: const EdgeInsets.only(top: 25.0),
          child: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.center,
              children: [
                if (!snapshot.hasData)
                  const CircularProgressIndicator()
                else ...[
                  Padding(
                    padding: const EdgeInsets.only(bottom: 24.0),
                    child: Avatar(name: snapshot.data!.firstName, size: 80,),
                  ),
                  Text(
                    snapshot.data!.fullName,
                    style: const TextStyle(fontSize: 24.0),
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: MetricOverview(
                      traineeId: (ModalRoute.of(context)?.settings.arguments
                              as TraineeDTO)
                          .traineeId,
                    ),
                  )
                ]
              ],
            ),
          ),
        ),
      );
    });
  }
}

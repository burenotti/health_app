import 'package:flutter/material.dart';
import 'package:flutter/scheduler.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'package:health_app/services/account_service/models.dart';

class Welcome extends StatefulWidget {
  const Welcome({super.key});

  @override
  State<Welcome> createState() => _WelcomeState();
}

class _WelcomeState extends State<Welcome> {
  final AccountService _accountService;

  _WelcomeState() : _accountService = GetIt.I<AccountService>();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: StreamBuilder<Account>(
          stream: _accountService.accountState,
          builder: (context, snapshot) {
            if (snapshot.data == null) {
              return const Center(
                child: LinearProgressIndicator(),
              );
            }

            final account = snapshot.data!;

            if (account.token == null) {
              SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
                Navigator.of(context).popAndPushNamed("/auth/login");
              });
              return Container();
            }

            final navigate = {
              ProfileType.unknown: "/profile/trainee/create",
              ProfileType.coach: "/coach/home",
              ProfileType.trainee: "/trainee/home",
            };

            SchedulerBinding.instance.addPostFrameCallback((timeStamp) {
              Navigator.of(context)
                  .popAndPushNamed(navigate[account.profile.type]!);
            });
            return Container();
          }),
    );
  }
}

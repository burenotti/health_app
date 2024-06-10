import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health_app/features/auth/auth.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/features/auth/screens/register_coach.dart';
import 'package:health_app/features/groups/screens/group_create.dart';
import 'package:health_app/features/groups/screens/group_details.dart';
import 'package:health_app/features/groups/screens/groups_list.dart';
import 'package:health_app/features/metrics/screens/create_metric.dart';
import 'package:health_app/features/trainees/screens/trainee_view.dart';
import 'package:health_app/repositories/group_repository/group_repository.dart';
import 'package:health_app/repositories/metric_repository/metric_repository.dart';
import 'package:health_app/repositories/profile_repository/profile_repo.dart';
import 'package:health_app/repositories/profile_repository/profile_repository.dart';
import 'package:health_app/repositories/user_repository/user_repo.dart';
import 'package:health_app/screens/welcome.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'package:talker_bloc_logger/talker_bloc_logger.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:talker_dio_logger/talker_dio_logger.dart';
import 'package:uuid/uuid.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  GetIt.I.registerSingleton(const Uuid());
  final talker = TalkerFlutter.init();
  GetIt.I.registerSingleton(talker);
  GetIt.I.registerSingleton(const FlutterSecureStorage());
  final dio = Dio(BaseOptions(
    validateStatus: (status) {
      return true;
    },
  ));
  final profileRepo = ProfileRepositoryImpl(dio);
  GetIt.I.registerSingleton<ProfileRepository>(profileRepo);
  final accountService = await AccountService.restore(
    storage: GetIt.I<FlutterSecureStorage>(),
    profileRepository: GetIt.I<ProfileRepository>(),
  );
  GetIt.I.registerSingleton(GroupRepository(dio));
  GetIt.I.registerSingleton(MetricRepository(dio));
  GetIt.I.registerSingleton(accountService);
  GetIt.I<Talker>().debug("Talker started...");


  dio.interceptors.add(
    TalkerDioLogger(
      talker: talker,
      settings: const TalkerDioLoggerSettings(
        printRequestData: true,
        printResponseData: true,
      ),
    ),
  );

  GetIt.I.registerLazySingleton(
    () => UserRepository(uuid: const Uuid(), dio: dio),
  );

  Bloc.observer = TalkerBlocObserver(
    talker: talker,
    settings: const TalkerBlocLoggerSettings(
      printStateFullData: true,
      printEventFullData: true,
    ),
  );

  FlutterError.onError =
      (details) => GetIt.I<Talker>().handle(details.exception, details.stack);

  runApp(const App());
}

class App extends StatelessWidget {
  const App({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      debugShowCheckedModeBanner: false,
      theme: ThemeData.dark(
        // colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      supportedLocales: const [
        Locale("ru"),
      ],
      localizationsDelegates: const [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      locale: const Locale("ru"),
      routes: {
        "/": (context) => const Welcome(),
        "/metrics/add": (context) => const CreateMetric(),
        "/coach/home": (context) => const GroupsList(),
        "/trainee/home": (context) => const GroupsList(),
        "/trainee": (context) => const TraineeView(),
        "/group": (context) => const GroupDetails(),
        "/group/create": (context) => const GroupCreateView(),
        "/auth/register": (context) => const RegisterTraineeScreen(),
        "/auth/login": (context) => const SignInScreen(),
        "/profile/trainee/create": (context) => const RegisterTraineeScreen(),
        "/profile/coach/create": (context) => const RegisterCoachScreen(),
      },
      navigatorObservers: [
        TalkerRouteObserver(GetIt.I<Talker>()),
      ],
    );
  }
}

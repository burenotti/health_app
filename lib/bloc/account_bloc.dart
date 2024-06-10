import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health_app/repositories/profile_repository/profile_repository.dart';
import 'package:health_app/repositories/user_repository/errors.dart';
import 'package:health_app/repositories/user_repository/models.dart';
import 'package:health_app/repositories/user_repository/user_repo.dart';

part 'account_event.dart';
part 'account_state.dart';

class AccountBloc extends Bloc<AccountEvent, AccountState> {
  final UserRepository userRepo;
  final ProfileRepository profileRepo;
  final FlutterSecureStorage storage;

  AccountBloc({
    required this.userRepo,
    required this.profileRepo,
    required this.storage,
  }) : super(AccountState.unknown()) {
    on<AccountStateChanged>((event, emit) async {
      if (event.account == null) {
        await deleteToken();
        emit(AccountState.unauthenticated());
      }
      
      await saveToken(event.account!.token!);
      emit(AccountState.authenticated(event.account!));
    });
  }

  // Future<User> signUp(String email, String password) async {
  //   try {
  //     await userRepo.signUp(email: email, password: password);
  //     final token = await authenticate(email, password);

  //   } on UserUnauthorizedError catch (e) {

  //   }
  // }

  // Future<void> authenticate(String email, String password) async {
  //   final tokenData = await userRepo.signIn(email: email, password: password);
  //   final token = Token(accessToken: tokenData.accessToken, refreshToken: tokenData.refreshToken);
  //   await saveToken(token);
  // }

  Future<void> saveToken(Token token) async {
    await storage.write(key: "access_token", value: token.accessToken);
    await storage.write(key: "refresh_token", value: token.refreshToken);
  }

  Future<void> deleteToken() async {
    await storage.write(key: "access_token", value: null);
    await storage.write(key: "refresh_token", value: null);
  }

  Future<Token?> getSavedToken() async {
    final accessToken = await storage.read(key: "access_token");
    if (accessToken == null || accessToken.isEmpty) {
      return null;
    }

    final refreshToken = await storage.read(key: "refresh_token");
    if (refreshToken == null || accessToken.isEmpty) {
      return null;
    }

    return Token(accessToken: accessToken, refreshToken: refreshToken);
  }
}

class Account {
  String userId;
  Profile profile;
  Token? token;

  Account({
    required this.userId,
    required this.profile,
    required this.token,
  });
}

enum ProfileType { trainee, coach, unknown }

abstract class Profile extends Equatable {
  final ProfileType type;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  int get age => (birthDate.difference(DateTime.now()).inDays / 365).floor();

  const Profile(
    this.type,
    this.firstName,
    this.lastName,
    this.birthDate,
  );

  @override
  List<Object?> get props => [type, firstName, lastName, birthDate];
}

class UnknownProfile extends Profile {
  UnknownProfile() : super(ProfileType.unknown, "", "", DateTime(0));
}

class Trainee extends Profile {
  const Trainee({
    required firstName,
    required lastName,
    required birthDate,
  }) : super(ProfileType.trainee, firstName, lastName, birthDate);
}

class Coach extends Profile {
  final String bio;
  final int? yearsExerience;

  const Coach({
    required firstName,
    required lastName,
    required birthDate,
    required this.yearsExerience,
    this.bio = "",
  }) : super(ProfileType.coach, firstName, lastName, birthDate);

  @override
  List<Object?> get props => super.props + [birthDate, yearsExerience];
}

class Token extends Equatable {
  final String accessToken;
  final String refreshToken;
  late final DateTime needsRefreshAt;

  Token({
    required this.accessToken,
    required this.refreshToken,
  }) {
    var payload = JWT.decode(accessToken).payload;
    needsRefreshAt =
        DateTime.fromMillisecondsSinceEpoch(payload["exp"] as int, isUtc: true);
  }

  bool isValid() {
    return needsRefreshAt.isBefore(DateTime.now());
  }

  @override
  List<Object?> get props => [refreshToken, accessToken];
}

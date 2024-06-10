import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';
import 'package:equatable/equatable.dart';

class Account {
  final String userId;
  final Profile profile;
  final Token? token;

  Account({
    required this.userId,
    required this.profile,
    required this.token,
  });

  Account setProfile(Profile profile) {
    return Account(
      userId: userId,
      profile: profile,
      token: token,
    );
  }
  
  Account setUserId(String userId) {
    return Account(
      userId: userId,
      profile: profile,
      token: token,
    );
  }

  Account setToken(Token? token) {
      return Account(
        userId: (token == null) ? userId : token.userId,
        profile: profile,
        token: token,
      );
  }
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

  String get fullName => "$firstName $lastName";
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
  late final String userId;

  Token({
    required this.accessToken,
    required this.refreshToken,
  }) {
    var payload = JWT.decode(accessToken).payload;
    needsRefreshAt =
        DateTime.fromMillisecondsSinceEpoch(payload["exp"] as int, isUtc: true);
    userId = payload["sub"];
  }

  bool isValid() {
    return needsRefreshAt.isBefore(DateTime.now());
  }

  @override
  List<Object?> get props => [refreshToken, accessToken];
}

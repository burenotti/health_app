import 'dart:async';
import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:health_app/repositories/profile_repository/profile_repository.dart';
import 'package:health_app/repositories/user_repository/user_repo.dart';
import 'package:uuid/uuid.dart';

import 'models.dart';

class AccountService {
  final ProfileRepository profileRepo;
  final FlutterSecureStorage storage;

  Account _account;

  late final StreamController<Account> _controller;

  AccountService._({
    required Account account,
    required this.profileRepo,
    required this.storage,
  }) : _account = account {
    _controller = StreamController.broadcast(
      sync: false,
      onListen: () {
        _controller.sink.add(_account);
      },
    );
  }

  Future<void> updateProfile() async {
    if (_account.token == null) {
      _account = _account.setProfile(UnknownProfile());
    }
    final profileData =
        await profileRepo.getMyProfile(_account.token!.accessToken);
    if (profileData == null) {
      _account = _account.setProfile(UnknownProfile());
      return;
    }

    if (profileData.type == "coach") {
      _account = _account.setProfile(Coach(
        firstName: profileData.firstName,
        lastName: profileData.lastName,
        birthDate: profileData.birthDate,
        yearsExerience: profileData.yearsExperience,
        bio: profileData.bio,
      ));
    }

    if (profileData.type == "trainee") {
      _account = _account.setProfile(Trainee(
        firstName: profileData.firstName,
        lastName: profileData.lastName,
        birthDate: profileData.birthDate,
      ));
    }
    _saveAccount(account);
    _controller.sink.add(account);
  }

  void setToken(String accessToken, String refreshToken) {
    _account = _account.setToken(Token(
      accessToken: accessToken,
      refreshToken: refreshToken,
    ));
    _saveAccount(_account);
    _controller.sink.add(_account);
  }

  void setUserId(String userId) {
    _account = _account.setUserId(userId);
    _saveAccount(_account);
    _controller.add(_account);
  }

  Stream<Account> get accountState => _controller.stream;
  Account get account => _account;

  static Future<AccountService> restore({
    required FlutterSecureStorage storage,
    required ProfileRepository profileRepository,
  }) async {
    var account = await AccountService._getSavedAccount(storage);
    return AccountService._(
      profileRepo: profileRepository,
      storage: storage,
      account: account,
    );
  }

  static Future<Account> _getSavedAccount(FlutterSecureStorage storage) async {
    final accountJson = await storage.read(key: "account");
    if (accountJson == null) {
      return Account(
        profile: UnknownProfile(),
        token: null,
        userId: const Uuid().v4(),
      );
    }

    final accountData = jsonDecode(accountJson) as Map<String, dynamic>;

    Profile profile = UnknownProfile();
    if (accountData["profile_type"] == "trainee") {
      profile = Trainee(
        firstName: accountData["first_name"],
        lastName: accountData["last_name"],
        birthDate: DateTime.parse(accountData["birth_date"]),
      );
    }

    if (accountData["profile_type"] == "coach") {
      profile = Coach(
        firstName: accountData["first_name"],
        lastName: accountData["last_name"],
        birthDate: DateTime.parse(accountData["birth_date"]),
        yearsExerience: accountData["years_experience"],
        bio: accountData["bio"] ?? "",
      );
    }

    return Account(
      userId: accountData["user_id"] as String,
      profile: profile,
      token: Token(
        accessToken: accountData["access_token"] as String,
        refreshToken: accountData["refresh_token"] as String,
      ),
    );
  }

  Future<void> _saveAccount(Account account) async {
    final profileType = {
      ProfileType.coach: "coach",
      ProfileType.trainee: "trainee",
      ProfileType.unknown: "unknown",
    };

    Map<String, dynamic> accountData = {
      "user_id": account.userId,
      "profile_type": profileType[account.profile.type],
      "first_name": account.profile.firstName,
      "last_name": account.profile.firstName,
      "birth_date": account.profile.birthDate.toUtc().toIso8601String(),
      "access_token": account.token?.accessToken,
      "refresh_token": account.token?.refreshToken,
    };

    if (account.profile.type is Coach) {
      final coach = account.profile as Coach;
      accountData["bio"] = coach.bio;
      accountData["years_experience"] = coach.yearsExerience;
    }
    await storage.write(key: "account", value: jsonEncode(accountData));
  }

  Future<void> logout() async {
    await deleteAccount();
    _account = _account.setToken(null).setProfile(UnknownProfile());
    _controller.sink.add(_account);
  }

  Future<void> deleteAccount() async {
    await storage.write(key: "account", value: null);
  }

  // Future<String> getAccessToken() async {
  //   if(_account.token == null) {
  //     return "";
  //   }

  //   if (_account.token!.needsRefreshAt.isBefore(DateTime.now())) {
  //     userre
  //   }
  // }
}

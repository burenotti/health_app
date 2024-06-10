import 'dart:core';

import 'package:health_app/repositories/profile_repository/models.dart';

abstract class ProfileRepository {
  Future<Profile?> getCoach(String accessToken, String id);
  Future<Profile?> getTrainee(String accessToken, String id);
  Future<Profile?> getMyProfile(String accessToken);

  Future<void> createCoach({
    required String accessToken,
    required String id,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    int yearsExerience = 0,
    String bio = "",
  });

  Future<void> createTrainee({
    required String accessToken,
    required String id,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  });
}

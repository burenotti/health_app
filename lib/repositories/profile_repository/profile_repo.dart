import 'package:dio/dio.dart';
import 'package:health_app/repositories/profile_repository/errors.dart';
import 'package:health_app/repositories/profile_repository/models.dart';
import 'package:health_app/repositories/profile_repository/profile_repository.dart';

class ProfileRepositoryImpl extends ProfileRepository {
  static const baseUrl = "http://192.168.1.7:80";

  final Dio dio;

  ProfileRepositoryImpl(this.dio);

  @override
  Future<Profile?> getCoach(String accessToken, String id) async {
    final response = await dio.get<Map<String, dynamic>>(
      "$baseUrl/coaches/$id",
      options: getOpts(accessToken),
    );

    if (response.statusCode! != 200) {
      throw wrapError(response);
    }

    return parseCoach(response.data!);
  }

  @override
  Future<Profile?> getTrainee(String accessToken, String id) async {
    final response = await dio.get<Map<String, dynamic>>(
      "$baseUrl/trainees/$id",
      options: getOpts(accessToken),
    );

    if (response.statusCode! != 200) {
      throw wrapError(response);
    }

    return parseTrainee(response.data!);
  }

  Options getOpts(String? accessToken) {
    return Options(
      contentType: "application/json",
      headers: {
        "Accept": "application/json",
        "Authorization": "Bearer $accessToken",
      },
    );
  }

  Profile parseTrainee(Map<String, dynamic> data) {
    return Profile.trainee(
      userId: data["user_id"]!,
      firstName: data["first_name"]!,
      lastName: data["last_name"]!,
      birthDate: DateTime.parse(data["birth_date"]!),
    );
  }

  Profile parseCoach(Map<String, dynamic> data) {
    return Profile.coach(
      userId: data["user_id"],
      firstName: data["first_name"]!,
      lastName: data["last_name"]!,
      birthDate: DateTime.parse(data["birth_date"]!),
      yearsExperience: data["years_experience"],
      bio: data.containsKey("bio") ? data["bio"] : "",
    );
  }

  Error wrapError(Response<dynamic> response) {
    final code = response.statusCode!;
    final data = response.data;
    final errors = {
      401: () => UnauthorizedError(message: data!["message"], temporary: false),
      404: () =>
          ProfileNotFoundError(message: data!["message"], temporary: false),
    };
    def() => ProfileRepositoryError(
          message:
              (data != null) ? data["message"] : "Unknown repository error",
          temporary: true,
        );

    return errors.containsKey(code) ? errors[code]!() : def();
  }

  @override
  Future<void> createCoach({
    required String accessToken,
    required String id,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    int yearsExerience = 0,
    String bio = "",
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      "$baseUrl/coaches/$id",
      options: getOpts(accessToken),
      data: {
        "first_name": firstName,
        "last_name": lastName,
        "birth_date": birthDate.toUtc().toIso8601String(),
        "years_experience": yearsExerience,
        "bio": bio,
      }
    );

    if (response.statusCode != 204) {
      throw wrapError(response);
    }
  }

  @override
  Future<void> createTrainee({
    required String accessToken,
    required String id,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      "$baseUrl/trainees/$id",
      options: getOpts(accessToken),
      data: {
        "first_name": firstName,
        "last_name": lastName,
        "birth_date": birthDate.toUtc().toIso8601String(),
      }
    );

    if (response.statusCode != 204) {
      throw wrapError(response);
    }
  }

  @override
  Future<Profile?> getMyProfile(String accessToken) async {
    final response = await dio.get(
      "$baseUrl/profiles/me",
      options: getOpts(accessToken),
    );

    if (response.statusCode == 404) {
      return null;
    }

    if (response.statusCode != 200) {
      throw wrapError(response);
    }

    if (response.data["type"] == "coach") {
      return parseCoach(response.data);
    }

    if (response.data["type"] == "trainee") {
      return parseTrainee(response.data);
    }

    return null;
  }
}

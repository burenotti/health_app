import 'package:dio/dio.dart';
import 'package:health_app/repositories/user_repository/errors.dart';
import 'package:uuid/uuid.dart';
import 'models.dart';
import 'abstract_user_repo.dart';

class UserRepository extends AbstractUserRepository {
  static const String baseURL = "http://192.168.1.7:80";

  UserRepository({
    required this.uuid,
    required this.dio,
  });

  final Dio dio;
  final Uuid uuid;

  @override
  Future<Token> signIn({
    required String email,
    required String password,
  }) async {
    const String url = "$baseURL/auth/login";
    var response = await dio.post(
      url,
      data: FormData.fromMap({"username": email, "password": password}),
    );
    return Token(
      accessToken: response.data!["access_token"]!,
      refreshToken: response.data!["refresh_token"]!,
    );
  }

  @override
  Future<void> signUp({
    required String userId,
    required String email,
    required String password,
  }) async {
    final response = await dio.post(
      "$baseURL/auth/sign-up",
      data: {
        "user_id": userId,
        "email": email,
        "password": password,
      },
    );

    if (response.statusCode! != 201) {
      throw wrapResponse(response);
    }
  }

  @override
  Future<void> logout({required String accessToken}) async {
    final response = await dio.post(
      "$baseURL/auth/logout",
      options: Options(
        headers: {
          "Authorization": "Bearer $accessToken",
        },
      ),
    );
    if (response.statusCode != 200) {
      throw wrapResponse(response);
    }
  }

  @override
  Future<Token> refresh({required String refreshToken}) async {
    final response = await dio.post(
      "$baseURL/auth/refresh",
      options: Options(
        headers: {"Authorization": "Refresh $refreshToken"},
      ),
    );

    if (response.statusCode! == 200) {
      return parseToken(response)!;
    } else {
      throw wrapResponse(response);
    }
  }

  Error wrapResponse(Response<dynamic> response) {
    final msg = getErrorMessage(response);
    final code = response.statusCode!;
    if (code == 400) {
      return UserUnauthorizedError(message: msg);
    } else if (code >= 400 && code <= 500) {
      return UserBadRequestError(message: msg);
    }
    return UserRepositoryError(message: msg);
  }

  String getErrorMessage(Response<dynamic> response) {
    var message = "unknown server error";

    if (response.data is! Map<String, dynamic>) {
      return message;
    }

    final data = response.data as Map<String, dynamic>;
    message = data.containsKey("message") ? data["message"] : message;

    return message;
  }

  Token? parseToken(Response<dynamic> response) {
    if (response.data is! Map<String, dynamic>) {
      return null;
    }

    final data = response.data as Map<String, dynamic>;
    return Token(
      accessToken: data["access_token"]!,
      refreshToken: data["refresh_token"]!,
    );
  }
}

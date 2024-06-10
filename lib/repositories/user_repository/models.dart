import 'dart:io';

import 'package:equatable/equatable.dart';
import 'package:dart_jsonwebtoken/dart_jsonwebtoken.dart';

class Token extends Equatable {
  Token({
    required this.accessToken,
    required this.refreshToken,
  }) {
    var payload = JWT.decode(accessToken).payload;
    userId = payload["sub"]!;
  }

  final String accessToken;
  final String refreshToken;
  late final String userId;
  late final DateTime needsRefreshAt;

  bool isValid() {
    return needsRefreshAt.isBefore(DateTime.now());
  }

  @override
  List<Object?> get props => [refreshToken, accessToken];
}

class User extends Equatable {
  User({required this.email, required this.userId, required this.token});

  final String email;
  final String userId;
  Token token;

  @override
  List<Object?> get props => [userId, email, token];
}

import 'package:dio/dio.dart';
import 'package:health_app/repositories/group_repository/models.dart';

class GroupRepository {
  static const baseUrl = "http://192.168.1.7";

  final Dio dio;

  GroupRepository(this.dio);

  Future<List<Group>> getGroupsList(String accessToken) async {
    final response = await dio.get<Map<String, dynamic>>(
      "$baseUrl/groups/list",
      queryParameters: {
        "limit": 150,
        "offset": 0,
      },
      options: getOpts(accessToken),
    );

    final groups = response.data!["groups"] as List<dynamic>;

    return groups
        .map((e) => Group(
              groupId: e["group_id"],
              name: e["name"],
              description: e["description"],
              coachId: e["coach_id"],
            ))
        .toList();
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

  Future<Group> getGroupById(String accessToken, String groupId) async {
    final response = await dio.get<Map<String, dynamic>>(
      "$baseUrl/groups/$groupId",
      options: getOpts(accessToken),
    );

    final data = response.data!;

    return Group(
      groupId: data["group_id"],
      name: data["name"],
      description: data["description"],
      coachId: data["coach_id"],
    );
  }

  Future<List<Member>> getGroupMembers(
      String accessToken, String groupId) async {
    final response = await dio.get<Map<String, dynamic>>(
      "$baseUrl/groups/$groupId/members",
      queryParameters: {
        "limit": 150,
        "offset": 0,
      },
      options: getOpts(accessToken),
    );

    final members = (response.data?["members"] ?? []) as List<dynamic>;

    return members
        .map((e) => Member(
              traineeId: e["trainee_id"],
              email: e["email"],
              firstName: e["first_name"],
              lastName: e["last_name"],
            ))
        .toList();
  }

  Future<void> createGroup({
    required String accessToken,
    required String id,
    required String name,
    required String description,
  }) async {
    final response = await dio.post(
      "$baseUrl/groups/$id",
      options: getOpts(accessToken),
      data: {
        "name": name,
        "description": description,
      },
    );
  }

  Future<Invite> createInvite({
    required String accessToken,
    required String groupId,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      "$baseUrl/groups/$groupId/invites",
      options: getOpts(accessToken),
    );
    final data = response.data!;
    return Invite(
      groupId: data["group_id"],
      inviteId: data["invite_id"],
      secret: data["secret"],
      validUntil: DateTime.parse(data["valid_until"]),
    );
  }

  Future<void> acceptInvite({
    required String accessToken,
    required String secret,
  }) async {
    final response = await dio.post<Map<String, dynamic>>(
      "$baseUrl/invites/accept",
      options: getOpts(accessToken),
      data: {"secret": secret},
    );
  }
}

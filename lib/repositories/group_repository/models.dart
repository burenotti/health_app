class Group {
  final String groupId;
  final String name;
  final String description;
  final String coachId;

  Group({
    required this.groupId,
    required this.name,
    required this.description,
    required this.coachId,
  });
}

class Member {
  final String traineeId;
  final String email;
  final String firstName;
  final String lastName;

  Member({
    required this.traineeId,
    required this.email,
    required this.firstName,
    required this.lastName,
  });

  String get fullName => "$firstName $lastName";
}

class Invite {
  final String groupId;
  final String inviteId;
  final String secret;
  final DateTime validUntil;

  Invite({
    required this.groupId,
    required this.inviteId,
    required this.secret,
    required this.validUntil,
  });
}

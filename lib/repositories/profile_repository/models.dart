import 'package:equatable/equatable.dart';

class Profile extends Equatable {
  final String type;
  final String userId;
  final String firstName;
  final String lastName;
  final DateTime birthDate;
  final String bio;
  final int? yearsExperience;

  int get age => (birthDate.difference(DateTime.now()).inDays / 365).floor();

  const Profile._({
    required this.type,
    required this.userId,
    required this.firstName,
    required this.lastName,
    required this.birthDate,
    required this.yearsExperience,
    required this.bio,
  });

  Profile.unknown(String userId)
      : this._(
          type: "unknown",
          userId: userId,
          firstName: "",
          lastName: "",
          birthDate: DateTime.fromMicrosecondsSinceEpoch(0),
          yearsExperience: 0,
          bio: "",
        );

  const Profile.trainee({
    required String userId,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
  }) : this._(
          type: "trainee",
          userId: userId,
          firstName: firstName,
          lastName: lastName,
          birthDate: birthDate,
          bio: "",
          yearsExperience: 0,
        );

  const Profile.coach({
    required String userId,
    required String firstName,
    required String lastName,
    required DateTime birthDate,
    required String bio,
    required int yearsExperience,
  }) : this._(
          type: "coach",
          userId: userId,
          firstName: firstName,
          lastName: lastName,
          birthDate: birthDate,
          bio: bio,
          yearsExperience: yearsExperience,
        );

  @override
  List<Object?> get props =>
      [userId, firstName, lastName, birthDate, yearsExperience, bio, type];
}

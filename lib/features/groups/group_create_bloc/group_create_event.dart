part of 'group_create_bloc.dart';

sealed class GroupCreateEvent extends Equatable {
  const GroupCreateEvent();

  @override
  List<Object> get props => [];
}

final class GroupCreate extends GroupCreateEvent {
  final String name;
  final String description;

  const GroupCreate({
    required this.name,
    required this.description,
  });
}

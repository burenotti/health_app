part of 'group_detail_bloc.dart';

sealed class GroupDetailEvent extends Equatable {
  const GroupDetailEvent();

  @override
  List<Object> get props => [];
}

final class GroupDetailRequired extends GroupDetailEvent {
  final String groupId;

  const GroupDetailRequired(this.groupId);
}
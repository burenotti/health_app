import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/repositories/group_repository/group_repository.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'package:talker_flutter/talker_flutter.dart';
import 'package:uuid/uuid.dart';

part 'group_create_event.dart';
part 'group_create_state.dart';

class GroupCreateBloc extends Bloc<GroupCreateEvent, GroupCreateState> {
  final accountService = GetIt.I<AccountService>();
  final groupRepo = GetIt.I<GroupRepository>();
  final uuid = const Uuid();

  GroupCreateBloc() : super(GroupCreateInitial()) {
    on<GroupCreate>((event, emit) async {
      emit(GroupCreateInProgress());
      try {
        final token = accountService.account.token!.accessToken;
        final id = uuid.v4();
        await groupRepo.createGroup(
          accessToken: token,
          id: id,
          name: event.name,
          description: event.description,
        );
        emit(GroupCreateDone(id));
      } on Exception catch (e) {
        GetIt.I<Talker>().error(e);
        emit(GroupCreateFailed());
      }
    });
  }
}

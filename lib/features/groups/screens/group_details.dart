import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/features/groups/group_detail_bloc/group_detail_bloc.dart';
import 'package:health_app/features/trainees/screens/trainee_view.dart';
import 'package:health_app/repositories/group_repository/group_repository.dart';
import 'package:health_app/repositories/group_repository/models.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'package:health_app/widgets/avatar.dart';

class GroupDTO {
  final String id;
  final String name;

  GroupDTO({
    required this.id,
    required this.name,
  });
}

class GroupDetails extends StatefulWidget {
  const GroupDetails({super.key});

  @override
  State<GroupDetails> createState() => _GroupDetailsState();
}

class _GroupDetailsState extends State<GroupDetails> {
  final bloc = GroupDetailBloc();
  final accountService = GetIt.I<AccountService>();
  final groupRepo = GetIt.I<GroupRepository>();

  @override
  Widget build(BuildContext context) {
    final groupData = ModalRoute.of(context)?.settings.arguments as GroupDTO?;
    if (groupData == null) {
      Navigator.of(context).popAndPushNamed("/");
      return const Placeholder();
    }
    bloc.add(GroupDetailRequired(groupData.id));

    return BlocBuilder<GroupDetailBloc, GroupDetailState>(
      bloc: bloc,
      builder: (context, state) {
        return Scaffold(
          appBar: AppBar(
            leading: IconButton(
              icon: const Icon(Icons.arrow_back),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            title: getGroupTitle(state),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: () async {
                  if (state is! GroupDetailLoadingSucceed) {
                    return;
                  }
                  final token = accountService.account.token!.accessToken;
                  final invite = await groupRepo.createInvite(
                    accessToken: token,
                    groupId: state.group.groupId,
                  );
                  if (!context.mounted) {
                    return;
                  }

                  showDialog(
                      context: context,
                      builder: (context) {
                        return getInviteDialog(invite.secret);
                      });
                },
              )
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {},
            child: getMembersView(state),
          ),
        );
      },
    );
  }

  Widget getMembersView(GroupDetailState state) {
    if (state is GroupDetailLoadingSucceed) {
      if (state.members.isEmpty) {
        return getNoMembersView();
      }
      return getMembersList(state.members);
    }
    return getMembersLoadingView();
  }

  Widget getMembersList(List<Member> members) {
    return ListView.builder(
      itemCount: members.length,
      itemBuilder: (context, index) {
        return ListTile(
          contentPadding:
              const EdgeInsets.symmetric(vertical: 8.0, horizontal: 8.0),
          leading: Avatar(name: members[index].firstName),
          title: Text(members[index].fullName),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () => processTapOnMember(members[index]),
        );
      },
    );
  }

  Dialog getInviteDialog(String value) {
    return Dialog(
      child: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            const Text(
              "Введите этот код на своем устройстве, чтобы присоединиться к группе",
              textAlign: TextAlign.center,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(vertical: 16.0),
              child: Text(
                value,
                style: const TextStyle(
                  fontSize: 24,
                ),
              ),
            ),
            TextButton(
              child: const Text("Закрыть"),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
          ],
        ),
      ),
    );
  }

  Text getGroupTitle(GroupDetailState state) {
    if (state is GroupDetailLoading) {
      return const Text("Загрузка...");
    }

    if (state is GroupDetailLoadingFailed) {
      return const Text("Ошибка...");
    }

    if (state is GroupDetailLoadingSucceed) {
      return Text(state.group.name);
    }

    return const Text("");
  }

  void processTapOnMember(Member member) {
    Navigator.of(context).pushNamed(
      "/trainee",
      arguments: TraineeDTO(
        traineeId: member.traineeId,
      ),
    );
  }

  Widget getNoMembersView() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          const Text("В группе пока нет учеников..."),
          TextButton.icon(
            label: const Text("Добавить"),
            icon: const Icon(Icons.add),
            onPressed: () {},
          )
        ],
      ),
    );
  }

  Widget getMembersLoadingView() {
    return const CircularProgressIndicator();
  }
}

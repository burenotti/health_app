import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:get_it/get_it.dart';
import 'package:health_app/features/groups/group_bloc/groups_bloc.dart';
import 'package:health_app/features/groups/screens/group_details.dart';
import 'package:health_app/repositories/group_repository/group_repository.dart';
import 'package:health_app/repositories/group_repository/models.dart';
import 'package:health_app/services/account_service/account_service.dart';
import 'package:health_app/services/account_service/models.dart';
import 'package:health_app/widgets/drawer.dart';

class GroupsList extends StatefulWidget {
  const GroupsList({super.key});

  @override
  State<GroupsList> createState() => _GroupsListState();
}

class _GroupsListState extends State<GroupsList> {
  final groupRepo = GetIt.I<GroupRepository>();
  final acconutService = GetIt.I<AccountService>();
  final inviteCodeController = TextEditingController();
  final bloc = GroupsBloc();

  @override
  Widget build(BuildContext context) {
    final profileType = acconutService.account.profile.type;

    return BlocBuilder<GroupsBloc, GroupsState>(
      bloc: bloc,
      builder: (context, state) {
        if (state is GroupsInitial) {
          bloc.add(GroupsListRequired());
        }

        return Scaffold(
          appBar: AppBar(
            title: const Text("Группы"),
            leading: Builder(builder: (context) {
              return IconButton(
                icon: const Icon(Icons.menu),
                onPressed: () => Scaffold.of(context).openDrawer(),
              );
            }),
            actions: [
              IconButton(
                icon: const Icon(Icons.add),
                onPressed: (profileType == ProfileType.coach)
                    ? processCreateGroup
                    : processAcceptInvite,
              )
            ],
          ),
          body: RefreshIndicator(
            onRefresh: () async {
              bloc.add(GroupsListRequired());
            },
            child: getGroupsView(state),
          ),
          drawer: const AppDrawer(),
        );
      },
    );
  }

  Widget getGroupsView(GroupsState state) {
    if (state is GroupsLoadingFailed) {
      return getFailedToLoadView();
    }
    if (state.groups.isEmpty) {
      return getNoGroupsView();
    }
    return getGroupsListView(state.groups);
  }

  Widget getFailedToLoadView() {
    return const Center(
      child: Text(
          "Не удалось загрузить группы, потяните вниз, чтобы попробовать снова"),
    );
  }

  Widget getGroupsListView(List<Group> groups) {
    return ListView.builder(
      itemCount: groups.length,
      itemBuilder: (context, index) {
        final group = groups[index];
        return ListTile(
          leading: const Icon(Icons.group),
          title: Text(group.name),
          subtitle: Text(group.description),
          trailing: const Icon(Icons.arrow_forward_ios),
          onTap: () {
            Navigator.of(context).pushNamed("/group",
                arguments: GroupDTO(id: group.groupId, name: group.name));
          },
        );
      },
    );
  }

  Widget getNoGroupsView() {
    final profileType = acconutService.account.profile.type;
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        crossAxisAlignment: CrossAxisAlignment.center,
        children: [
          if (profileType == ProfileType.coach) ...[
            const Text("У вас пока нет ни одной группы..."),
            TextButton(
              onPressed: processCreateGroup,
              child: const Text("Создать"),
            ),
          ],
          if (profileType == ProfileType.trainee) ...[
            const Text("Вы пока не вступили ни в одну группу..."),
            TextButton(
              onPressed: processAcceptInvite,
              child: const Text("Вступить"),
            ),
          ]
        ],
      ),
    );
  }

  void processCreateGroup() {
    Navigator.of(context).pushNamed("/group/create");
  }

  void processAcceptInvite() {
    showDialog(
        context: context,
        builder: (context) {
          return Dialog(
            child: Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const Text(
                    "Введите пригласительный код группы, чтобы вступить в нее",
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.symmetric(vertical: 16.0),
                    child: SizedBox(
                      width: 160,
                      child: TextFormField(
                        autocorrect: false,
                        controller: inviteCodeController,
                        textAlign: TextAlign.center,
                        decoration: const InputDecoration(
                          hintText: "Код",
                        ),
                        style: const TextStyle(fontSize: 24.0),
                      ),
                    ),
                  ),
                  Row(
                    mainAxisSize: MainAxisSize.max,
                    mainAxisAlignment: MainAxisAlignment.spaceAround,
                    crossAxisAlignment: CrossAxisAlignment.center,
                    children: [
                      TextButton(
                        child: const Text("Закрыть"),
                        onPressed: () {
                          Navigator.of(context).pop();
                        },
                      ),
                      TextButton(
                        child: const Text("Вступить"),
                        onPressed: () async {
                          final token =
                              acconutService.account.token!.accessToken;
                          await groupRepo.acceptInvite(
                            accessToken: token,
                            secret: inviteCodeController.text,
                          );
                          
                          if (context.mounted) {
                            bloc.add(GroupsListRequired());
                            Navigator.of(context).pop();
                          }
                        },
                      ),
                    ],
                  ),
                ],
              ),
            ),
          );
        });
  }
}

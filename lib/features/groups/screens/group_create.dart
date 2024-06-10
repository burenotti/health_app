import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:health_app/features/groups/group_create_bloc/group_create_bloc.dart';
import 'package:health_app/features/groups/screens/group_details.dart';

class GroupCreateView extends StatefulWidget {
  const GroupCreateView({super.key});

  @override
  State<GroupCreateView> createState() => _GroupCreateViewState();
}

class _GroupCreateViewState extends State<GroupCreateView> {
  final bloc = GroupCreateBloc();
  TextEditingController nameController = TextEditingController();
  TextEditingController descriptionController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<GroupCreateBloc, GroupCreateState>(
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
            title: const Text("Создать группу"),
            actions: [
              IconButton(
                onPressed: () {
                  bloc.add(GroupCreate(
                    name: nameController.text,
                    description: descriptionController.text,
                  ));
                },
                icon: const Icon(Icons.check),
              ),
            ],
          ),
          body: Form(
            child: Column(
              children: [
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Название группы",
                      border: OutlineInputBorder(),
                    ),
                    autocorrect: true,
                    controller: nameController,
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(
                      vertical: 8.0, horizontal: 16.0),
                  child: TextFormField(
                    decoration: const InputDecoration(
                      labelText: "Описание",
                      alignLabelWithHint: true,
                      border: OutlineInputBorder(),
                    ),
                    controller: descriptionController,
                    maxLines: 10,
                  ),
                ),
              ],
            ),
          ),
        );
      },
      listener: (BuildContext context, GroupCreateState state) {
        if (state is GroupCreateFailed) {
          ScaffoldMessenger.of(context)
              .showSnackBar(const SnackBar(content: Text("Произошла ошибка")));
        }

        if (state is GroupCreateDone) {
          Navigator.of(context).popAndPushNamed(
            "/group",
            arguments: GroupDTO(
              id: state.groupId,
              name: nameController.text,
            ),
          );
        }
      },
    );
  }
}

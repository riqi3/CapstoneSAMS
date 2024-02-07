// ignore_for_file: prefer_const_constructors

import 'package:capstone_sams/constants/Strings.dart';
import 'package:capstone_sams/global-widgets/snackbars/Snackbars.dart';
import 'package:capstone_sams/models/MedicalNotesModel.dart';
import 'package:capstone_sams/providers/MedicalNotesProvider.dart';
import 'package:capstone_sams/screens/medical_notes/EditTodoScreen.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:provider/provider.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import '../../../constants/theme/pallete.dart';

var removeNote = dangerSnackbar('${Strings.remove} note.');

class TodoWidget extends StatelessWidget {
  final Todo todo;

  const TodoWidget({Key? key, required this.todo}) : super(key: key);

  void toggleTodoStatus(BuildContext context) {
    final accountID = context.read<AccountProvider>().id;
    final provider = Provider.of<TodosProvider>(context, listen: false);
    final token = context.read<AccountProvider>().token!;
    provider.toggleTodoStatus(todo, accountID!, token);

    const snackBar = SnackBar(
      backgroundColor: Pallete.infoColor,
      content: Text(
        'Task updated!',
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void deleteTodo(BuildContext context, Todo todo) {
    final accountID = context.read<AccountProvider>().id;
    final provider = Provider.of<TodosProvider>(context, listen: false);
    final token = context.read<AccountProvider>().token!;
    provider.removeTodo(todo, accountID!, token);
    Navigator.of(context).pop();

    ScaffoldMessenger.of(context).showSnackBar(removeNote);
  }

  void editTodo(BuildContext context, Todo todo) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => EditTodoPage(todo: todo),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: todo.isDeleted == true ? false : true,
      child: Card(
        elevation: 10,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        child: Scrollable(
          viewportBuilder: (BuildContext context, ViewportOffset position) =>
              ClipRRect(
            borderRadius: BorderRadius.circular(10),
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                children: [
                  Checkbox(
                    activeColor: Pallete.mainColor,
                    checkColor: Colors.white,
                    value: todo.isDone,
                    onChanged: (_) => toggleTodoStatus(context),
                  ),
                  const SizedBox(
                    width: 10,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          todo.title,
                          overflow: TextOverflow.ellipsis,
                          style: TextStyle(
                            fontWeight: FontWeight.bold,
                            color: Colors.black,
                            fontSize: 22,
                          ),
                        ),
                        if (todo.content.isNotEmpty)
                          Container(
                            margin: const EdgeInsets.only(top: 4),
                            child: Text(
                              todo.content,
                              style: const TextStyle(
                                fontSize: 10,
                                height: 1.5,
                                color: Colors.grey,
                              ),
                            ),
                          ),
                      ],
                    ),
                  ),
                  PopupMenuButton(
                    itemBuilder: (context) => [
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(
                            Icons.edit,
                            color: Pallete.successColor,
                          ),
                          title: Text(
                            'Edit',
                            style: TextStyle(
                              color: Pallete.successColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onTap: () => editTodo(context, todo),
                        ),
                      ),
                      PopupMenuItem(
                        child: ListTile(
                          leading: Icon(
                            Icons.delete,
                            color: Pallete.dangerColor,
                          ),
                          title: Text(
                            'Delete',
                            style: TextStyle(
                              color: Pallete.dangerColor,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                          onTap: () => deleteTodo(context, todo),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

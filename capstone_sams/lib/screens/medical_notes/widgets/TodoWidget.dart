// ignore_for_file: prefer_const_constructors

import 'package:capstone_sams/models/medical_notes.dart';
import 'package:capstone_sams/providers/medical_notes_provider.dart';
import 'package:capstone_sams/screens/medical_notes/edit_todo_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter/rendering.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:provider/provider.dart';

class TodoWidget extends StatelessWidget {
  final Todo todo;

  const TodoWidget({Key? key, required this.todo}) : super(key: key);

  void deleteTodo(BuildContext context, Todo todo) {
    final provider = Provider.of<TodosProvider>(context, listen: false);
    provider.removeTodo(
        todo, 'accountID'); // Replace 'accountID' with actual account ID

    const snackBar = SnackBar(
      content: Text('Deleted the note'),
    );
    ScaffoldMessenger.of(context).showSnackBar(snackBar);
  }

  void editTodo(BuildContext context, Todo todo) => Navigator.of(context)
      .push(MaterialPageRoute(builder: (context) => EditTodoPage(todo: todo)));

  @override
  Widget build(BuildContext context) {
    return Card(
      elevation: 10,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      child: Scrollable(
        viewportBuilder: (BuildContext context, ViewportOffset position) =>
            ClipRRect(
          borderRadius: BorderRadius.circular(10),
          child: Slidable(
            key: Key(todo.noteNum),
            endActionPane: ActionPane(
              motion: const ScrollMotion(),
              dismissible: DismissiblePane(onDismissed: () {}),
              children: [
                SlidableAction(
                  onPressed: (context) => deleteTodo(context, todo),
                  backgroundColor: Colors.red,
                  foregroundColor: Colors.white,
                  icon: Icons.delete,
                  label: 'Delete',
                ),
              ],
            ),
            child: Container(
              padding: const EdgeInsets.all(20),
              color: Colors.white,
              child: Row(
                children: [
                  Checkbox(
                    activeColor: Theme.of(context).primaryColor,
                    checkColor: Colors.white,
                    value: todo.isDone,
                    onChanged: (_) {
                      final provider =
                          Provider.of<TodosProvider>(context, listen: false);
                      final isDone =
                          provider.toggleTodoStatus(todo, 'accountID');

                      if (isDone == true) {
                        const snackBar = SnackBar(
                          content: Text('Note Completed!'),
                        );
                        ScaffoldMessenger.of(context).showSnackBar(snackBar);
                      }
                    },
                  ),
                  const SizedBox(
                    width: 20,
                  ),
                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              todo.title,
                              style: TextStyle(
                                fontWeight: FontWeight.bold,
                                color: Colors.black,
                                fontSize: 22,
                              ),
                            ),
                            PopupMenuButton(
                              itemBuilder: (context) => [
                                PopupMenuItem(
                                  child: ListTile(
                                    leading:
                                        Icon(Icons.edit, color: Colors.green),
                                    title: Text(
                                      'Edit',
                                      style: TextStyle(color: Colors.green),
                                    ),
                                    onTap: () => editTodo(context, todo),
                                  ),
                                ),
                                PopupMenuItem(
                                  child: ListTile(
                                    leading: Icon(
                                      Icons.delete,
                                      color: Colors.red,
                                    ),
                                    title: Text(
                                      'Delete',
                                      style: TextStyle(color: Colors.red),
                                    ),
                                    onTap: () => deleteTodo(context, todo),
                                  ),
                                ),
                              ],
                            ),
                          ],
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
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

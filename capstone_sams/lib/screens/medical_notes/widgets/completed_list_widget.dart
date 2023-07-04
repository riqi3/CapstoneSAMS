import 'package:capstone_sams/providers/medical_notes_provider.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import 'todo_widget.dart';

class CompletedListWidget extends StatelessWidget {
  const CompletedListWidget({super.key});

  @override
  Widget build(BuildContext context) {
    final provider = Provider.of<TodosProvider>(context);
    final todos = provider.todosCompleted;

    return todos.isEmpty
        ? const Center(
            child: Text(
            'No completed notes.',
            style: TextStyle(fontSize: 12, fontWeight: FontWeight.bold),
          ))
        : ListView.separated(
            physics: const BouncingScrollPhysics(),
            padding: const EdgeInsets.all(16),
            itemBuilder: (context, index) {
              final todo = todos[index];
              return TodoWidget(todo: todo);
            },
            itemCount: todos.length,
            separatorBuilder: (BuildContext context, int index) {
              return Container(
                height: 8,
              );
            },
          );
  }
}

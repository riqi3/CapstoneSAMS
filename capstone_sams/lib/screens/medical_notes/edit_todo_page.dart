import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/screens/medical_notes/widgets/TodoFormWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';

import '../../models/medical_notes.dart';
import '../../providers/medical_notes_provider.dart';

class EditTodoPage extends StatefulWidget {
  final Todo todo;
  const EditTodoPage({super.key, required this.todo});

  @override
  State<EditTodoPage> createState() => _EditTodoPageState();
}

class _EditTodoPageState extends State<EditTodoPage> {
  final _formKey = GlobalKey<FormState>();
  late String title;
  late String description;

  @override
  void initState() {
    super.initState();
    title = widget.todo.title;
    description = widget.todo.content;
  }

  void saveTodo() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    } else {
      final accountID = context.read<AccountProvider>().id;
      final provider = Provider.of<TodosProvider>(context, listen: false);
      provider.updateTodo(
          Todo(
            noteNum: widget.todo.noteNum,
            title: title,
            content: description,
            isDone: widget.todo.isDone,
            account: accountID!,
          ),
          accountID!);
      Navigator.of(context).pop();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Todo"),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: saveTodo,
          ),
          IconButton(
              onPressed: () {
                final accountID = context.read<AccountProvider>().id;
                final provider =
                    Provider.of<TodosProvider>(context, listen: false);
                provider.removeTodo(widget.todo,
                    accountID!); // Replace 'accountID' with actual account ID
                Navigator.of(context).pop();
              },
              icon: const Icon(Icons.delete))
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Form(
          key: _formKey,
          child: TodoFormWidget(
            onChangedTitle: (title) => setState(() {
              this.title = title;
            }),
            onChangedDescription: (description) => setState(() {
              this.description = description;
            }),
            onSavedTodo: saveTodo,
            title: title,
            description: description,
          ),
        ),
      ),
    );
  }
}

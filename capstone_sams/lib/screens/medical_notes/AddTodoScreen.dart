// ignore_for_file: prefer_const_constructors

import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/screens/medical_notes/widgets/TodoFormWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:uuid/uuid.dart';

import '../../models/MedicalNotesModel.dart';
import '../../providers/MedicalNotesProvider.dart';

class AddTodoPage extends StatefulWidget {
  const AddTodoPage({Key? key}) : super(key: key);

  @override
  State<AddTodoPage> createState() => _AddTodoPageState();
}

class _AddTodoPageState extends State<AddTodoPage> {
  final _formKey = GlobalKey<FormState>();
  String title = '';
  String description = '';

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('Add Note'),
        actions: [
          IconButton(
            icon: Icon(Icons.check),
            onPressed: addTodo,
          ),
        ],
      ),
      body: Form(
        key: _formKey,
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: TodoFormWidget(
                onChangedTitle: (title) => setState(() => this.title = title),
                onChangedDescription: (description) =>
                    setState(() => this.description = description),
                onSavedTodo: addTodo,
              ),
            ),
          ],
        ),
      ),
    );
  }

  void addTodo() {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    } else {
      final accountID = context.read<AccountProvider>().id;
      final todo = Todo(
          title: title,
          content: description,
          noteNum: Uuid().v4(),
          isDone: false,
          account: accountID!);

      final provider = Provider.of<TodosProvider>(context, listen: false);
      provider.addTodo(todo, accountID);
      Navigator.of(context).pop();
    }
  }
}

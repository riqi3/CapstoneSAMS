import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/providers/AccountProvider.dart';
import 'package:capstone_sams/screens/medical_notes/widgets/TodoFormWidget.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../../models/MedicalNotesModel.dart';
import '../../providers/MedicalNotesProvider.dart';
import 'package:capstone_sams/screens/medical_notes/MedicalNotesScreen.dart';

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
  bool _isEditingTodo = false;
  @override
  void initState() {
    super.initState();
    title = widget.todo.title;
    description = widget.todo.content;
  }

  Future<void> saveTodo() async {
    final isValid = _formKey.currentState!.validate();

    if (!isValid) {
      return;
    } else {
      setState(() {
        _isEditingTodo = true;
      });

      final accountID = context.read<AccountProvider>().id;
      final provider = Provider.of<TodosProvider>(context, listen: false);
      final token = context.read<AccountProvider>().token!;

      try {
        await provider.updateTodo(
          Todo(
            noteNum: widget.todo.noteNum,
            title: title,
            content: description,
            isDone: widget.todo.isDone,
            account: accountID!,
          ),
          accountID,
          token,
        );

        if (mounted) {
          // Only update the UI if the widget is still mounted
          // Navigator.of(context).pop();
        int routesCount = 0;

        Navigator.pushAndRemoveUntil(
          context,
          MaterialPageRoute(
            builder: (context) => MedicalNotes(),
          ),
          (Route<dynamic> route) {
            if (routesCount < 3) {
              routesCount++;
              return false;
            }
            return true;
          },);

          final snackBar = SnackBar(
            backgroundColor: Pallete.successColor,
            content: Text(
              'Successfully updated the note',
              style: TextStyle(fontWeight: FontWeight.w700),
            ),
          );
          ScaffoldMessenger.of(context).showSnackBar(snackBar);
        }
      } catch (error) {
        print('Error: $error');
      } finally {
        await Future.delayed(Duration(seconds: 2));
        if (mounted) {
          setState(() {
            _isEditingTodo = false;
          });
        }
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Edit Todo"),
        actions: [
          _isEditingTodo
              ? Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: CircularProgressIndicator(
                    color: const Color.fromARGB(255, 110, 40, 40),
                    strokeWidth: 3,
                  ),
                )
              : IconButton(
                  icon: Icon(Icons.check),
                  onPressed: _isEditingTodo ? null : saveTodo,
                ),
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

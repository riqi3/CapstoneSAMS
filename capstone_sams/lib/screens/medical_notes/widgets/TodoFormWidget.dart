// ignore_for_file: prefer_const_constructors
import 'package:flutter/material.dart';

class TodoFormWidget extends StatefulWidget {
  final String title;
  final String description;
  final ValueChanged<String> onChangedTitle;
  final ValueChanged<String> onChangedDescription;
  final VoidCallback onSavedTodo;

  const TodoFormWidget({
    Key? key,
    this.title = '',
    this.description = '',
    required this.onChangedTitle,
    required this.onChangedDescription,
    required this.onSavedTodo,
  }) : super(key: key);

  @override
  _TodoFormWidgetState createState() => _TodoFormWidgetState();
}

class _TodoFormWidgetState extends State<TodoFormWidget> {
  late TextEditingController _descriptionController;

  @override
  void initState() {
    super.initState();
    _descriptionController = TextEditingController(text: widget.description);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: widget.title,
          onChanged: widget.onChangedTitle,
          validator: (title) {
            if (title!.isEmpty) {
              return 'The title cannot be empty';
            }
            return null;
          },
          decoration: InputDecoration(
            hintText: 'Title',
            hintStyle: TextStyle(fontSize: 30),
            border: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
        SizedBox(height: 16),
        TextFormField(
          controller: _descriptionController,
          maxLines: 3,
          onChanged: widget.onChangedDescription,
          decoration: InputDecoration(
            hintText: 'Description',
            border: InputBorder.none,
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
        ),
        SizedBox(height: 32),
      ],
    );
  }
}

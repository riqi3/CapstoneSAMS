// ignore_for_file: prefer_const_constructors

import 'package:flutter/material.dart';

class TodoFormWidget extends StatelessWidget {
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
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        TextFormField(
          initialValue: title,
          onChanged: onChangedTitle,
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
          maxLines: 3,
          onChanged: onChangedDescription,
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

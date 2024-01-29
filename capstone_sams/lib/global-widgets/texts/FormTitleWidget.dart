import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormTitleWidget extends StatelessWidget {
  String title;
  FormTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Text(
        title,
        style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
      ),
    );
  }
}

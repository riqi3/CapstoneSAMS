import 'package:flutter/material.dart';

class TitleValueText extends StatelessWidget {
  const TitleValueText({
    Key? key,
    required this.title,
    required this.value,
  }) : super(key: key);

  final String title, value;

  @override
  Widget build(BuildContext context) {
    return Row(
      children: <Widget>[
        Text(
          title,
          style: TextStyle(
            fontWeight: FontWeight.w500,
          ),
        ),
        Text(
          value,
        ),
      ],
    );
  }
}

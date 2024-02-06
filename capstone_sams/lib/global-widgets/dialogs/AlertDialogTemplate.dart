import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class AlertDiaglogTemplate extends StatelessWidget {
  String? title;
  String? content;
  String? buttonTitle;
  late final dynamic onpressed;
  AlertDiaglogTemplate({
    super.key,
    required this.title,
    required this.content,
    required this.onpressed,
    required this.buttonTitle,
  });

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15.0),
      ),
      title: Text(
        title.toString(),
        style:
            TextStyle(color: Pallete.dangerColor, fontWeight: FontWeight.bold),
      ),
      content: Text('${content}'),
      actions: <Widget>[
        TextButton(
          onPressed: () => Navigator.pop(context, 'Cancel'),
          child: const Text(
            'Cancel',
            style: TextStyle(
              color: Pallete.greyColor,
            ),
          ),
        ),
        TextButton(
          onPressed: onpressed,
          child: Text(
            '${buttonTitle}',
            style: TextStyle(
              color: Pallete.dangerColor,
            ),
          ),
        ),
      ],
    );
  }
}

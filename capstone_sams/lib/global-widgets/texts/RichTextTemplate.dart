import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class RichTextTemplate extends StatelessWidget {
  String title;
  String content;
  RichTextTemplate({
    super.key,
    required this.title,
    required this.content,
  });

  @override
  Widget build(BuildContext context) {
    return RichText(
      text: TextSpan(
        style: TextStyle(
          height: 1.25,
          fontSize: Sizing.header6,
          color: Pallete.textColor,
        ),
        children: <TextSpan>[
          TextSpan(text: title, style: TextStyle(fontWeight: FontWeight.bold)),
          TextSpan(text: content),
        ],
      ),
    );
  }
}

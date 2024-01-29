import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NoDataTextWidget extends StatelessWidget {
  String text;
  int? maxlines;
  NoDataTextWidget({
    super.key,
    required this.text,
    this.maxlines,
  });

  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      maxLines: maxlines,
      style: TextStyle(color: Pallete.greyColor),
    );
  }
}

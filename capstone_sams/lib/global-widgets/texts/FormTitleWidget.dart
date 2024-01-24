import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';


class FormTitleWidget extends StatelessWidget {
  final String title;
  const FormTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(
          top: Sizing.formSpacing * 2, bottom: Sizing.formSpacing),
      child: Text(
        title,
        style: TextStyle(
            color: Pallete.mainColor,
            fontSize: Sizing.header4,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}


import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardSectionTitleWidget extends StatelessWidget {
  CardSectionTitleWidget({
    super.key,
    required this.title,
  });

  final String title;

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: EdgeInsets.only(
          top: Sizing.sectionSymmPadding / 2,
          right: Sizing.sectionSymmPadding,
          left: Sizing.sectionSymmPadding,
          bottom: Sizing.sectionSymmPadding / 2),
      alignment: Alignment.centerLeft,
      decoration: BoxDecoration(
        color: Pallete.whiteColor,
      ),
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

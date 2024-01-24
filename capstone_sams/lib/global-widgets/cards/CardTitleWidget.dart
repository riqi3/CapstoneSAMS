import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';


class CardTitleWidget extends StatelessWidget {
  final String title;
  const CardTitleWidget({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: Pallete.mainColor,
        borderRadius: BorderRadius.only(
            topRight: Radius.circular(Sizing.borderRadius),
            topLeft: Radius.circular(Sizing.borderRadius)),
      ),
      alignment: Alignment.centerLeft,
      padding: EdgeInsets.symmetric(horizontal: Sizing.sectionSymmPadding),
      width: MediaQuery.of(context).size.width,
      height: Sizing.cardContainerHeight,
      child: Text(
        title,
        style: TextStyle(
            color: Pallete.whiteColor,
            fontSize: Sizing.header3,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}
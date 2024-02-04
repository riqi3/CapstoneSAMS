import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';

class BottomSheetTitle extends StatelessWidget {
  final String title;
  const BottomSheetTitle({
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
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
            color: Pallete.whiteColor,
            fontSize: Sizing.header3,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

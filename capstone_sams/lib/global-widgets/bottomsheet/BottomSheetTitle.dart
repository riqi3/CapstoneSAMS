import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart'; 

// ignore: must_be_immutable
class BottomSheetTitle extends StatefulWidget {
  final String title;
  bool? owner;
  Widget popup;
  BottomSheetTitle({
    super.key,
    required this.title,
    this.owner,
    required this.popup,
  });

  @override
  State<BottomSheetTitle> createState() => _BottomSheetTitleState();
}

class _BottomSheetTitleState extends State<BottomSheetTitle> {
  Widget diagnosisOwner(owner) {
    if (owner == false) {
      return Text(
        widget.title,
        overflow: TextOverflow.ellipsis,
        maxLines: 2,
        style: TextStyle(
          color: Pallete.whiteColor,
          fontSize: Sizing.header3,
          fontWeight: FontWeight.w600,
        ),
      );
    }
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceBetween,
      children: [
        Text(
          widget.title,
          overflow: TextOverflow.ellipsis,
          maxLines: 2,
          style: TextStyle(
            color: Pallete.whiteColor,
            fontSize: Sizing.header3,
            fontWeight: FontWeight.w600,
          ),
        ),
        widget.popup,
      ],
    );
  }

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
      child: diagnosisOwner(widget.owner),

      // Text(
      //   widget.title,
      //   overflow: TextOverflow.ellipsis,
      //   maxLines: 2,
      //   style: TextStyle(
      //       color: Pallete.whiteColor,
      //       fontSize: Sizing.header3,
      //       fontWeight: FontWeight.w600),
      // ),
    );
  }
}

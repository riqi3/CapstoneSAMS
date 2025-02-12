import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardTitleWidget extends StatefulWidget {
  final String title;
  CardTitleWidget({
    super.key,
    required this.title,
  });

  @override
  State<CardTitleWidget> createState() => _CardTitleWidgetState();
}

class _CardTitleWidgetState extends State<CardTitleWidget> {
  void addSubtitlea(bool addSubtitle) {
    if (addSubtitle != false) {
      setState(() {
        addSubtitle = true;
      });
    }
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
      child: Text(
        widget.title,
        style: TextStyle(
            color: Pallete.whiteColor,
            fontSize: Sizing.header3,
            fontWeight: FontWeight.w600),
      ),
    );
  }
}

import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';


class CardSectionInfoWidget extends StatelessWidget {
  final Widget widget;
  const CardSectionInfoWidget({
    super.key, required this.widget,
  });

  @override
  Widget build(BuildContext context) {
    return Material(
      borderRadius: BorderRadius.only(
          bottomLeft: Radius.circular(Sizing.borderRadius),
          bottomRight: Radius.circular(Sizing.borderRadius)),
      child: Container(
        width: MediaQuery.of(context).size.width + 10,
        decoration: BoxDecoration(
          color: Pallete.whiteColor,
          borderRadius: BorderRadius.only(
              bottomRight: Radius.circular(Sizing.borderRadius),
              bottomLeft: Radius.circular(Sizing.borderRadius)),
        ),
        padding: const EdgeInsets.only(
          left: Sizing.sectionSymmPadding,
          right: Sizing.sectionSymmPadding,
          bottom: Sizing.sectionSymmPadding,
        ),
        child: ShaderMask(
          shaderCallback: (Rect bounds) {
            return LinearGradient(
              colors: [Colors.black, Colors.transparent],
              stops: [0.95, 1],
            ).createShader(bounds);
          },
          child: widget,
        ),
      ),
    );
  }
}
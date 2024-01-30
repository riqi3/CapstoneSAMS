import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class CardSectionInfoWidget extends StatefulWidget {
  final Widget widget;
  bool? shader;
  CardSectionInfoWidget({
    super.key,
    required this.widget,
    this.shader,
  });

  @override
  State<CardSectionInfoWidget> createState() => _CardSectionInfoWidgetState();
}

class _CardSectionInfoWidgetState extends State<CardSectionInfoWidget> {
  Widget widgetEffects(shader) {
    if (shader == false) {
      return widget.widget;
    }
    return ShaderMask(
      shaderCallback: (Rect bounds) {
        return LinearGradient(
          colors: [Colors.white, Colors.transparent],
          stops: [0.95, 1],
        ).createShader(bounds);
      },
      child: widget.widget,
    );
  }

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
        child: widgetEffects(widget.shader),
      ),
    );
  }
}

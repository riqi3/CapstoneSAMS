import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class IconTextButtons extends StatelessWidget {
  String label;
  Widget icon;
  late final dynamic onpressed;
  IconTextButtons({
    super.key,
    required this.onpressed,
    required this.label,
    required this.icon,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: onpressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizing.borderRadius),
        ),
      ),
      icon: icon,
      label: Text('${label}'),
    );
  }
}

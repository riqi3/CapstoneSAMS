import 'package:flutter/material.dart';
import 'package:font_awesome_flutter/font_awesome_flutter.dart';

// ignore: must_be_immutable
class PopMenuItemTemplate extends StatelessWidget {
  IconData icon;
  Color color;
  String title;
  double? size;
  late final dynamic ontap;
  PopMenuItemTemplate({
    super.key,
    required this.icon,
    required this.color,
    required this.title,
    this.size,
    required this.ontap,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      leading: FaIcon(
        icon,
        size: size,
        color: color,
      ),
      title: Text(
        title,
        style: TextStyle(
          fontWeight: FontWeight.w700,
          color: color,
        ),
      ),
      onTap: ontap,
    );
  }
}

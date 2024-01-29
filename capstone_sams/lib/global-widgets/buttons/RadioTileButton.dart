import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:flutter/material.dart';

class RadioTileButton extends StatelessWidget {
  final String title;
  final String value;
  final String? groupvalue;
  late final bool? isInvalid;
  late final dynamic onchange;

  RadioTileButton({
    super.key,
    required this.title,
    required this.value,
    required this.groupvalue,
    required this.onchange,
    this.isInvalid,
  });

  @override
  Widget build(BuildContext context) {
    return RadioListTile(
      contentPadding: EdgeInsets.all(0),
      title: Text(
        title,
        style: TextStyle(
            color: isInvalid == true ? Pallete.dangerColor : Colors.black),
      ),
      fillColor: MaterialStateColor.resolveWith((states) =>
          isInvalid == true ? Pallete.dangerColor : Pallete.primaryColor),
      activeColor: MaterialStateColor.resolveWith((states) =>
          isInvalid == true ? Pallete.dangerColor : Pallete.greyColor),
      value: value,
      groupValue: groupvalue,
      onChanged: onchange,
    );
  }
}

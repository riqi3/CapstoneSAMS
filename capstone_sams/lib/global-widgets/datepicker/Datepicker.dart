import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:flutter/material.dart';

class Datepicker extends StatelessWidget {
  final String title;
  final TextEditingController controller;
  late final dynamic onchanged;
  late final dynamic ontap;
  late final bool? isInvalid;
  Datepicker({
    super.key,
    required this.title,
    required this.controller,
    required this.onchanged,
    required this.ontap,
    this.isInvalid,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: title,
        labelStyle: TextStyle(
            color: isInvalid == true
                ? Pallete.dangerColor
                : Pallete.textSecondaryColor),
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
              color: isInvalid == true
                  ? Pallete.dangerColor
                  : Pallete.textSecondaryColor),
        ),
        filled: true,
        fillColor: Pallete.palegrayColor,
        suffixIcon: Icon(Icons.calendar_today,
            color: isInvalid == true
                ? Pallete.dangerColor
                : Pallete.textSecondaryColor),
      ),
      readOnly: true,
      onTap: ontap,
      onChanged: onchanged,
      controller: controller,
    );
  }
}

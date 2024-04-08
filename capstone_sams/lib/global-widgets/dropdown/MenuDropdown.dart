import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class MenuDropdown extends StatelessWidget {
  String title;
  List<DropdownMenuEntry<String>> list;
  String? initialseletion;
  late final bool? isInvalid;
  late final dynamic onselected;
  MenuDropdown({
    super.key,
    required this.title,
    required this.list,
    required this.onselected,
    this.initialseletion,
    this.isInvalid,
  });

  @override
  Widget build(BuildContext context) {
    return DropdownMenu<String>(
      hintText: title,
      inputDecorationTheme: InputDecorationTheme(
        border: OutlineInputBorder(
          borderSide: BorderSide(
              color: isInvalid == true
                  ? Pallete.dangerColor
                  : Pallete.textSecondaryColor),
        ),
        fillColor: Pallete.palegrayColor,
        filled: true,
      ),
      initialSelection: initialseletion,
      onSelected: onselected,
      // (String? value) {
      //   setState(() {
      //     departmentValue = value!;
      //   });
      // },
      dropdownMenuEntries: list,
      //     departmentList.map<DropdownMenuEntry<String>>((String value) {
      //   return DropdownMenuEntry<String>(
      //     value: value,
      //     label: value,
      //   );
      // }).toList(),
    );
  }
}

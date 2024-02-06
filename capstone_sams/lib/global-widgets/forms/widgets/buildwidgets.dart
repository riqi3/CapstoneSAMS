import 'package:flutter/material.dart';

Widget buildQuestion(String question, Widget inputWidget) {
  return Container(
    margin: EdgeInsets.only(bottom: 16),
    child: Row(
      children: [
        Expanded(
          child: Text(question),
        ),
        SizedBox(width: 8),
        Expanded(
          child: Align(
            alignment: Alignment.centerRight,
            child: inputWidget,
          ),
        ),
      ],
    ),
  );
}

Widget buildDropdown(
    List<String> options, String currentValue, Function(String?) onChanged) {
  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey),
    ),
    child: DropdownButton<String>(
      value: currentValue,
      items: options.map((option) {
        return DropdownMenuItem<String>(
          value: option,
          child: Text(option),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}

Widget buildDropdownAge(int value, Function(int?) onChanged) {
  List<String> ageOptions =
      List.generate(120, (index) => (index + 1).toString());

  return Container(
    padding: EdgeInsets.symmetric(horizontal: 12),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(8),
      border: Border.all(color: Colors.grey),
    ),
    child: DropdownButton<int>(
      value: value,
      items: ageOptions.map((age) {
        return DropdownMenuItem<int>(
          value: int.parse(age),
          child: Text(age),
        );
      }).toList(),
      onChanged: onChanged,
    ),
  );
}

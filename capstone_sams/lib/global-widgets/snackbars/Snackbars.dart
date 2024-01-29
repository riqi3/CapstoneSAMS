import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:flutter/material.dart';

SnackBar successSnackbar(String text) {
  return SnackBar(
    backgroundColor: Pallete.successColor,
    content: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w700),
    ),
  );
}

SnackBar dangerSnackbar(String text) {
  return SnackBar(
    backgroundColor: Pallete.dangerColor,
    content: Text(
      text,
      style: TextStyle(fontWeight: FontWeight.w700),
    ),
  );
}

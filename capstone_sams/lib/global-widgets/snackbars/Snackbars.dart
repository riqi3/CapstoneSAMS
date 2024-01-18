import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:flutter/material.dart';

class successSnackBar extends StatelessWidget {
  final String string;
  const successSnackBar({
    super.key,
    required this.string,
  });

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: Pallete.successColor,
      content: Text(
        string,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

class dangerSnackBar extends StatelessWidget {
  final String string;
  const dangerSnackBar({
    super.key,
    required this.string,
  });

  @override
  Widget build(BuildContext context) {
    return SnackBar(
      backgroundColor: Pallete.dangerColor,
      content: Text(
        string,
        style: TextStyle(fontWeight: FontWeight.w700),
      ),
    );
  }
}

import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';


class CancelButton extends StatelessWidget {
  const CancelButton({
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      child: Text('Cancel'),
      onPressed: () =>
          Navigator.pop(context),
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.greyColor,
        shape: RoundedRectangleBorder(
          borderRadius:
              BorderRadius.circular(
                  Sizing.borderRadius),
        ),
      ),
    );
  }
}
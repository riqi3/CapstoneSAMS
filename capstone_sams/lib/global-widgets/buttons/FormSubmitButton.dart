import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormSubmitButton extends StatelessWidget {
  String title;
  IconData icon;
  bool isLoading;
  double? buttonsize;
  late final dynamic onpressed;
  FormSubmitButton({
    super.key,
    required this.title,
    required this.icon,
    required this.isLoading,
    required this.onpressed,
    this.buttonsize,
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
      icon: isLoading
          ? Container(
              width: 24,
              height: 24,
              padding: const EdgeInsets.all(4),
              child: const CircularProgressIndicator(
                color: Pallete.whiteColor,
                strokeWidth: 3,
              ),
            )
          : Icon(
              icon,
              color: Pallete.whiteColor,
            ),
      label: Text('${title}'),
    );
  }
}

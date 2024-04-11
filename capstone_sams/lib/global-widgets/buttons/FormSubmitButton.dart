import 'package:capstone_sams/constants/theme/pallete.dart';
import 'package:capstone_sams/constants/theme/sizing.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class FormSubmitButton extends StatefulWidget {
  String title;
  IconData icon;
  bool isLoading;
  double? buttonsize;
  bool? isDisabled;
  late final dynamic onpressed;
  FormSubmitButton({
    super.key,
    required this.title,
    required this.icon,
    required this.isLoading,
    required this.onpressed,
    this.buttonsize,
    this.isDisabled,
  });

  @override
  State<FormSubmitButton> createState() => _FormSubmitButtonState();
}

class _FormSubmitButtonState extends State<FormSubmitButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: widget.onpressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.mainColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizing.borderRadius),
        ),
      ),
      icon: widget.isLoading
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
              widget.icon,
              color: Pallete.whiteColor,
            ),
      label: Text('${widget.title}'),
    );
  }
}

// ignore: must_be_immutable
class DisabledSubmitButton extends StatefulWidget {
  String title;
  double? buttonsize;
  bool? isDisabled;
  late final dynamic onpressed;
  DisabledSubmitButton({
    super.key,
    required this.title,
    required this.onpressed,
    this.buttonsize,
    this.isDisabled,
  });

  @override
  State<DisabledSubmitButton> createState() => DisabledSubmitButtonState();
}

class DisabledSubmitButtonState extends State<DisabledSubmitButton> {
  @override
  Widget build(BuildContext context) {
    return ElevatedButton.icon(
      onPressed: widget.onpressed,
      style: ElevatedButton.styleFrom(
        backgroundColor: Pallete.greyColor,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(Sizing.borderRadius),
        ),
      ),
      icon: Container(
        width: 24,
        height: 24,
        padding: const EdgeInsets.all(4),
        child: const CircularProgressIndicator(
          color: Pallete.whiteColor,
          strokeWidth: 3,
        ),
      ),
      label: Text('${widget.title}'),
    );
  }
}

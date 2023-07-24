import 'package:capstone_sams/theme/theme.dart';
import 'package:flutter/material.dart';

class ShortTextfield extends StatelessWidget {
  const ShortTextfield({
    super.key,
    required this.controller,
    required this.validator,
    required this.hintText,
  });

  final TextEditingController controller;
  final String validator, hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      validator: (value) => value == '' ? validator : null,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}

class TextAreaField extends StatelessWidget {
  const TextAreaField({
    super.key,
    required this.controller,
    required this.validator,
    required this.hintText,
  });

  final TextEditingController controller;
  final String validator, hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      maxLines: 4,
      validator: (value) => value == '' ? validator : null,
      decoration: InputDecoration(
        hintText: hintText,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Pallete.greyColor,
          ),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(
            width: 1,
            color: Pallete.mainColor,
          ),
        ),
      ),
    );
  }
}

class PasswordTextfield extends StatelessWidget {
  const PasswordTextfield({
    super.key,
    required this.controller,
    required this.validator,
    required this.hintText,
  });

  final TextEditingController controller;
  final String validator, hintText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: true,
      validator: (value) => value == '' ? validator : null,
      decoration: InputDecoration(
        hintText: hintText,
      ),
    );
  }
}

import 'package:flutter/material.dart';

import '../../constants/theme/pallete.dart';

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
        filled: true,
        fillColor: Pallete.palegrayColor,
      ),
    );
  }
}

// ignore: must_be_immutable
class TextAreaField extends StatelessWidget {
  TextAreaField({
    super.key,
    required this.validator,
    required this.hintText,
    required this.onSaved,
  });

  final String validator, hintText;
  String? onSaved;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: TextInputType.multiline,
      minLines: 5,
      maxLines: null,
      onChanged: (value) => onSaved = value,
      validator: (value) => value == '' ? validator : null,
      decoration: InputDecoration(
        hintText: hintText,
        filled: true,
        fillColor: Pallete.palegrayColor,
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

class PasswordTextfield extends StatefulWidget {
  final TextEditingController controller;
  final String validator;
  final String hintText;

  const PasswordTextfield({
    required this.controller,
    required this.validator,
    required this.hintText,
  });

  @override
  _PasswordTextfieldState createState() => _PasswordTextfieldState();
}

class _PasswordTextfieldState extends State<PasswordTextfield> {
  bool _isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: _isObscure,
      validator: (value) => value!.isEmpty ? widget.validator : null,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: IconButton(
          icon: Icon(
            _isObscure ? Icons.visibility : Icons.visibility_off,
            color: Colors.grey,
          ),
          onPressed: () {
            setState(() {
              _isObscure = !_isObscure;
            });
          },
        ),
        filled: true,
        fillColor: Pallete.palegrayColor,
      ),
    );
  }
}

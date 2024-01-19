import 'package:capstone_sams/models/PatientModel.dart';
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

class FormTextField extends StatefulWidget {
  final String labeltext;
  final String? validator;
  final TextEditingController? controller;
  final TextInputType type;
  final int? maxlength;
  final int? maxlines;
  final String? countertext;
  late final dynamic onchanged;

  FormTextField({
    super.key,
    required this.labeltext,
    required this.type,
    required this.onchanged,
    this.controller,
    this.validator,
    this.countertext,
    this.maxlength,
    this.maxlines,
  });

  @override
  State<FormTextField> createState() => _FormTextFieldState();
}

class _FormTextFieldState extends State<FormTextField> {
  @override
  Widget build(BuildContext context) {
    return TextFormField(
      decoration: InputDecoration(
        labelText: '${widget.labeltext}',
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Pallete.primaryColor,
          ),
        ),
        counterText: widget.countertext,
        filled: true,
        fillColor: Pallete.palegrayColor,
      ),
      validator: (value) => value == '' ? widget.validator : null,
      keyboardType: widget.type,
      maxLength: widget.maxlength,
      maxLines: widget.maxlines,
      onChanged: (value) {
        widget.onchanged?.call(value);
      },
      // onSaved: (value) {
      //   if (widget.onsaved != null) {
      //     widget.onsaved!(value);
      //   } else {
      //     widget.onsaved = value;
      //   }
      // },
    );
  }
}

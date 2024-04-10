import 'package:capstone_sams/constants/Strings.dart';
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
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Pallete.greyColor,
          ),
        ),
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
        border: OutlineInputBorder(
          borderSide: BorderSide(
            color: Pallete.greyColor,
          ),
        ),
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
  final String? initialvalue;
  final int? maxlength;
  final int? maxlines;
  final String? countertext;
  late final dynamic onchanged;

  FormTextField({
    super.key,
    required this.labeltext,
    required this.type,
    this.initialvalue,
    this.onchanged,
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
  RegExp alphabeticPattern = RegExp(r'^[a-zA-Z]+$');
  String? _validateInput(String? value) {
    if (value == null || value.isEmpty) {
      return Strings.requiredField;
    }

    if (widget.type == TextInputType.number ||
        widget.type == TextInputType.phone) {
      if (double.tryParse(value) == null ||
          RegExp(r'[a-zA-Z]').hasMatch(value)) {
        return 'Enter a valid number for ${widget.labeltext}';
      }
    }

    if (widget.type == TextInputType.text ||
        widget.type == TextInputType.name ||
        widget.type == TextInputType.multiline) {
      if (value.contains(RegExp(r'\d')) ||
          !alphabeticPattern.hasMatch(value) ||
          double.tryParse(value) != null) {
        return 'Enter text for ${widget.labeltext}';
      }
    }

    return null;
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialvalue,
      decoration: InputDecoration(
        alignLabelWithHint: true,
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
      // validator: (value) => value == '' ? widget.validator : null,
      validator: _validateInput,
      // validator: (value) => widget.validator,
      keyboardType: widget.type,
      maxLength: widget.maxlength,
      maxLines: widget.maxlines,
      controller: widget.controller,
      onChanged: (value) {
        widget.onchanged?.call(value);
      },
    );
  }
}

class FormTextField2 extends StatefulWidget {
  final String labeltext;
  final String? validator;
  final TextEditingController? controller;
  final TextInputType type;
  final String? initialvalue;
  final int? maxlength;
  final int? maxlines;
  final String? countertext;
  late final dynamic onchanged;

  FormTextField2({
    super.key,
    required this.labeltext,
    required this.type,
    this.initialvalue,
    this.onchanged,
    this.controller,
    this.validator,
    this.countertext,
    this.maxlength,
    this.maxlines,
  });

  @override
  State<FormTextField2> createState() => _FormTextField2State();
}

class _FormTextField2State extends State<FormTextField2> {
  String? _validateInput(String? value) {
    if (value != null && value.isNotEmpty) {
      if (widget.type == TextInputType.number ||
          widget.type == TextInputType.phone) {
        if (double.tryParse(value) == null) {
          return 'Enter a valid number for ${widget.labeltext}';
        }
      }

      if (widget.type == TextInputType.emailAddress) {
        if (!_isValidEmail(value)) {
          return 'Enter a valid email address';
        }
      }

      if (widget.type == TextInputType.text ||
          widget.type == TextInputType.name ||
          widget.type == TextInputType.multiline) {
        if (RegExp(r'[a-zA-Z]').hasMatch(value)) {
          return 'Enter text only for ${widget.labeltext}';
        }
      }
    }

    return null;
  }

  bool _isValidEmail(String value) {
    final RegExp emailRegex = RegExp(r'^[\w-\.]+@([\w-]+\.)+[\w-]{2,4}$');
    return emailRegex.hasMatch(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      initialValue: widget.initialvalue,
      decoration: InputDecoration(
        alignLabelWithHint: true,
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
      // validator: (value) => value == '' ? widget.validator : null,
      validator: _validateInput,
      // validator: (value) => widget.validator,
      keyboardType: widget.type,
      maxLength: widget.maxlength,
      maxLines: widget.maxlines,
      controller: widget.controller,
      onChanged: (value) {
        widget.onchanged?.call(value);
      },
    );
  }
}

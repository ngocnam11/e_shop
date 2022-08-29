import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput({
    Key? key,
    required this.controller,
    this.isPass = false,
    required this.hintText,
    required this.textInputType,
    this.readOnly = false,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onSaved,
    this.onFieldSubmitted, this.errorText,
  }) : super(key: key);

  final TextEditingController controller;
  final bool isPass;
  final String hintText;
  final TextInputType textInputType;
  final bool readOnly;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final FormFieldSetter? onSaved;
  final void Function(String)? onFieldSubmitted;
  final String? errorText;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelText,
        border: OutlineInputBorder(
          borderSide: Divider.createBorderSide(context),
          borderRadius: BorderRadius.circular(8),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: Divider.createBorderSide(context),
          borderRadius: BorderRadius.circular(8),
        ),
        filled: true,
        contentPadding: const EdgeInsets.all(8),
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
      ),
      validator: validator,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: isPass,
      keyboardType: textInputType,
      readOnly: readOnly,
    );
  }
}

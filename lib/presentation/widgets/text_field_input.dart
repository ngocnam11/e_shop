import 'package:flutter/material.dart';

class TextFieldInput extends StatelessWidget {
  const TextFieldInput({
    super.key,
    this.controller,
    this.isPass = false,
    this.hintText,
    required this.textInputType,
    this.readOnly = false,
    this.labelText,
    this.prefixIcon,
    this.suffixIcon,
    this.validator,
    this.onSaved,
    this.onFieldSubmitted,
    this.errorText,
    this.focusNode,
    this.minLines = 1,
    this.maxLines = 1,
    this.contentPadding = const EdgeInsets.all(8),
    this.textInputAction,
    this.onChanged,
  });

  final TextEditingController? controller;
  final bool isPass;
  final String? hintText;
  final TextInputType textInputType;
  final bool readOnly;
  final String? labelText;
  final Widget? prefixIcon;
  final Widget? suffixIcon;
  final FormFieldValidator? validator;
  final FormFieldSetter? onSaved;
  final void Function(String)? onFieldSubmitted;
  final String? errorText;
  final FocusNode? focusNode;
  final int? minLines;
  final int? maxLines;
  final EdgeInsetsGeometry? contentPadding;
  final TextInputAction? textInputAction;
  final void Function(String)? onChanged;

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
        contentPadding: contentPadding,
        prefixIcon: prefixIcon,
        suffixIcon: suffixIcon,
        errorText: errorText,
        floatingLabelBehavior: FloatingLabelBehavior.auto,
      ),
      validator: validator,
      onSaved: onSaved,
      onFieldSubmitted: onFieldSubmitted,
      obscureText: isPass,
      keyboardType: textInputType,
      readOnly: readOnly,
      focusNode: focusNode,
      minLines: minLines,
      maxLines: maxLines,
      textInputAction: textInputAction,
      onChanged: onChanged,
    );
  }
}

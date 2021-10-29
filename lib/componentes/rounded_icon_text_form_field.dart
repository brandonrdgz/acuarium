import 'package:flutter/material.dart';

class RoundedIconTextFormField extends StatelessWidget {
  final bool enabled;
  final String labelText;
  final IconData? prefixIcon;
  final String? prefixText;
  final Widget? suffixIcon;
  final String? suffixText;
  final TextInputType? keyboardType;
  final String? initialValue;
  final int? maxLines;
  final bool obscureText;
  final bool enableSuggestions;
  final bool autocorrect;
  final bool readOnly;
  final int? maxLength;
  final TextEditingController? controller;
  final ValueChanged<String>? onChanged;
  final GestureTapCallback? onTap;
  final FormFieldValidator<String>? validator;

  RoundedIconTextFormField(
    {
      this.enabled = true,
      required this.labelText,
      this.prefixIcon,
      this.prefixText,
      this.suffixIcon,
      this.suffixText,
      this.keyboardType,
      this.initialValue,
      this.maxLines = 1,
      this.maxLength,
      this.obscureText = false,
      this.enableSuggestions = false,
      this.autocorrect = false,
      this.readOnly = false,
      this.controller,
      this.onChanged,
      this.onTap,
      required this.validator,
    }
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.all(8.0),
      child: TextFormField(
        enabled: enabled,
        textAlign: TextAlign.center,
        decoration: InputDecoration(
          labelText: labelText,
          errorMaxLines: 10,
          prefixIcon: Icon(prefixIcon),
          prefixText: prefixText,
          suffixIcon: suffixIcon,
          suffixText: suffixText,
          border: OutlineInputBorder(
            borderRadius: const BorderRadius.all(Radius.circular(16.0)),
            borderSide: BorderSide(
              color: Colors.red.shade200
            )
          )
        ),
        initialValue: initialValue,
        readOnly: readOnly,
        maxLength: maxLength,
        obscureText: obscureText,
        enableSuggestions: enableSuggestions,
        autocorrect: autocorrect,
        controller: controller,
        onChanged: onChanged,
        onTap: onTap,
        validator: validator,
        keyboardType: keyboardType,
      ),
    );
  }
}
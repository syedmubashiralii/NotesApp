import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

import '../utils.dart';

class MyTextField extends StatelessWidget {
  final TextEditingController controller;
  final String hintText;
  final bool showPasswordIcon;
  final IconData? prefixIcon;
  final bool? filled;
  final Color? fillColor;
  final TextInputType? keyboardType;
  final Color mainColor;
  final bool obscureText;
  final int maxLines;
  final int minLines;
  final bool readOnly;

  final List<TextInputFormatter>? inputFormatters;
  final String? labelText;
  final bool labelSameAsHint;
  final void Function()? onTap;
  final void Function(String)? onChanged;
  final void Function(String)? onFieldSubmitted;
  final String? Function(String?)? validator;
  final FocusNode? focusNode;
  final String? errorText;

  const MyTextField({
    Key? key,
    required this.controller,
    this.hintText = "Email",
    this.keyboardType,
    this.inputFormatters,
    this.showPasswordIcon = false,
    this.labelText,
    this.onFieldSubmitted,
    this.onChanged,
    this.labelSameAsHint = true,
    this.maxLines = 1,
    this.onTap,
    this.minLines = 1,
    this.focusNode,
    this.readOnly = false,
    this.validator,
    this.errorText,
    this.mainColor = ColorHelper.blackColor,
    this.fillColor = ColorHelper.whiteShader,
    this.obscureText = false,
    this.filled = true,
    this.prefixIcon,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      keyboardType: keyboardType,
      controller: controller,
      inputFormatters: inputFormatters,
      maxLines: maxLines,
      minLines: minLines,
      readOnly: readOnly,
      onTap: onTap,
      onChanged: onChanged,
      onFieldSubmitted: onFieldSubmitted,
      focusNode: focusNode,
      decoration: InputDecoration(
        hintText: hintText,
        labelText: labelSameAsHint ? hintText : labelText,
        errorText: errorText,
        errorStyle: const TextStyle(overflow: TextOverflow.visible),
        filled: filled,
        fillColor: fillColor,
        hintStyle: const TextStyle(),
        labelStyle: TextStyle(color: mainColor),
        prefixIcon:
            prefixIcon != null ? Icon(prefixIcon, color: mainColor) : null,
        // suffixIcon: widget.obscureText
        //     ? IconButton(
        //         icon: Icon(
        //           isObscure ? Icons.visibility : Icons.visibility_off,
        //           color: widget.mainColor,
        //         ),
        //         onPressed: () {
        //           setState(() {
        //             isObscure = !isObscure;
        //           });
        //         },
        //       )
        //     : null,
        enabledBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
        errorBorder: OutlineInputBorder(
          borderSide: const BorderSide(color: ColorHelper.error),
          borderRadius: BorderRadius.circular(10.0),
        ),
        focusedErrorBorder: OutlineInputBorder(
          borderSide: BorderSide(color: mainColor),
          borderRadius: BorderRadius.circular(10.0),
        ),
      ),
      validator: validator,
    );
  }
}

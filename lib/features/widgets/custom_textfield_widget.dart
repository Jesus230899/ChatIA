import 'package:dartz/dartz.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomTextFieldWidget extends StatelessWidget {
  final String? label;
  final String? hintText;
  final VoidCallback? onPressed;
  final TextEditingController? controller;
  final Function(String)? onChanged;
  final FormFieldValidator<String>? validator;
  final List<TextInputFormatter>? inputFormatters;
  final Widget? suffixIcon;
  final Widget? prefixIcon;
  final bool? obscureText;
  final double? borderRadius;
  final Color? borderColor;
  final Option<String>? value;
  final AutovalidateMode? autovalidateMode;
  final VoidCallback? onEditingComplete;
  final Widget? suffix;
  final TextInputType? keyboardType;

  const CustomTextFieldWidget({
    super.key,
    this.label,
    this.hintText,
    this.onPressed,
    this.controller,
    this.onChanged,
    this.validator,
    this.inputFormatters,
    this.suffixIcon,
    this.prefixIcon,
    this.obscureText,
    this.borderRadius,
    this.borderColor,
    this.value,
    this.autovalidateMode,
    this.onEditingComplete,
    this.suffix,
    this.keyboardType
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      onChanged: onChanged,
      enableSuggestions: false,
      autocorrect: false,
      decoration: decoration(context),
      keyboardType: keyboardType,
      validator: validator,
      inputFormatters: inputFormatters,
      onTap: onPressed,
      readOnly: onPressed != null,
      style: GoogleFonts.openSans(
        fontSize: 12,
      ),
      obscureText: obscureText ?? false,
      textCapitalization: TextCapitalization.none,

      maxLines: 1,
      autovalidateMode: autovalidateMode ?? AutovalidateMode.disabled,
      autofocus: false,
      onEditingComplete: onEditingComplete,
      scrollPadding: const EdgeInsets.all(20),
    );
  }

  InputDecoration decoration(BuildContext context) {
    return InputDecoration(
      label: _label(),
      contentPadding: EdgeInsets.symmetric(horizontal: 12),
      hintText: _hintText(),
      hintStyle: GoogleFonts.openSans(fontSize: 16, color: Colors.black),
      filled: false,
      // fillColor: fillColor,
      labelStyle: GoogleFonts.openSans(
        // fontWeight: FontWeight.w700,
        fontSize: 12,
        // color: colorText,
      ),
      // fillColor: color,
      // filled: color == null ? false : true,
      border: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
        borderSide: BorderSide(color: borderColor ?? const Color(0XFF5D5D5D)),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
        borderSide: BorderSide(color: borderColor ?? const Color(0XFF5D5D5D)),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
        borderSide: BorderSide(color: borderColor ?? const Color(0XFF5D5D5D)),
      ),
      errorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
        borderSide: const BorderSide(color: Colors.red),
      ),
      focusedErrorBorder: OutlineInputBorder(
        borderRadius: BorderRadius.all(Radius.circular(borderRadius ?? 8)),
        borderSide: const BorderSide(color: Colors.red),
      ),
      suffixIcon: suffixIcon,
      prefixIcon: prefixIcon,
      // suffixText: suffixText,
      suffix: suffix,
      errorStyle: GoogleFonts.openSans(color: Colors.red),
      errorMaxLines: 4,
    );
  }

  Widget? _label() {
    if (label == null) return null;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Text(label ?? ''),
        Visibility(
          visible: true,
          child: const Text(
            ' *',
            style: TextStyle(color: Colors.red, fontSize: 13),
          ),
        ),
      ],
    );
  }

  String? _hintText() {
    if (hintText == null) return null;
    if (hintText != null) return '$hintText *';
    return hintText;
  }
}

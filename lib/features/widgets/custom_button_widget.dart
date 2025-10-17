// ignore_for_file: must_be_immutable

import 'package:chatia/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

class CustomButtonWidget extends StatelessWidget {
  final String? text;
  final VoidCallback onPressed;
  final bool? isLoading;
  final bool? locked;
  final double? height;
  final Widget? leading;
  final Widget? trailing;
  final Widget? child;

  CustomButtonWidget({
    super.key,
    this.text,
    required this.onPressed,
    this.isLoading = false,
    this.locked = false,
    this.height,
    this.leading,
    this.trailing,
    this.child,
  });

  bool singleTap = false;

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () async {
        if (locked! || isLoading!) return;
        if (!singleTap) {
          await Function.apply(onPressed, []);
          singleTap = true;
          await Future.delayed(const Duration(seconds: 1)).then((_) {
            singleTap = false;
          });
        }
      },
      child: Container(
        height: height ?? 50,
        decoration: BoxDecoration(
          gradient: locked == false
              ? const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Color(0xff001F3F), AppColors.primary],
                )
              : const LinearGradient(
                  begin: Alignment.centerLeft,
                  end: Alignment.centerRight,
                  colors: <Color>[Colors.grey, Colors.grey],
                ),
          borderRadius: BorderRadius.circular(30),
        ),
        padding: const EdgeInsets.symmetric(horizontal: 8),
        child: Center(child: _child()),
      ),
    );
  }

  Widget _child() {
    if (isLoading!) {
      return const CircularProgressIndicator.adaptive(
        backgroundColor: Colors.white,
      );
    }

    if (child != null) return child!;

    final widget = Text(
      text ?? '',
      style: GoogleFonts.openSans(
        fontSize: 16,
        color: Colors.white,
        fontWeight: FontWeight.w600,
      ),
      textAlign: TextAlign.center,
    );

    if (leading != null && trailing != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          leading!,
          const SizedBox(width: 10),
          widget,
          const SizedBox(width: 10),
          trailing!,
        ],
      );
    }
    if (leading != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [leading!, const SizedBox(width: 10), widget],
      );
    }
    if (trailing != null) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [widget, const SizedBox(width: 10), trailing!],
      );
    }

    return widget;
  }
}

import 'package:chatia/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AuthMessagesWidget extends StatelessWidget {
  final String title;
  final String subtitle;
  const AuthMessagesWidget({
    super.key,
    required this.title,
    required this.subtitle,
  });

  @override
  Widget build(BuildContext context) {
    Align message(String text, double size) => Align(
      alignment: Alignment.centerLeft,
      child: Text(
        text,
        style: TextStyle(
          fontSize: size,
          fontWeight: FontWeight.bold,
          color: AppColors.primary,
        ),
      ),
    );
    return Column(children: [message(title, 28), message(subtitle, 16)]);
  }
}

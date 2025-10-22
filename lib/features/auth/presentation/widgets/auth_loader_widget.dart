import 'package:chatia/core/theme/colors.dart';
import 'package:flutter/material.dart';

class AuthLoaderWidget extends StatelessWidget {
  final bool loading;
  const AuthLoaderWidget({super.key, required this.loading});

  @override
  Widget build(BuildContext context) {
    return Visibility(
      visible: loading,
      child: Align(
        alignment: Alignment.center,
        child: Container(
          color: Colors.white.withValues(alpha: 0.5),
          child: Center(
            child: CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation(AppColors.primary),
            ),
          ),
        ),
      ),
    );
  }
}

// ignore_for_file: use_build_context_synchronously

import 'package:animate_do/animate_do.dart';
import 'package:auto_route/auto_route.dart';
import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/core/resources/resource_icons.dart';
import 'package:chatia/core/routes/app_router.gr.dart';
import 'package:chatia/core/theme/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';

@RoutePage()
class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen> {
  @override
  void initState() {
    super.initState();
    Future.delayed(const Duration(seconds: 1), () async {
      final hasSession = await _hasSession();
      if (hasSession) {
        AutoRouter.of(context).replaceAll([HomeRoute()]);
      } else {
        AutoRouter.of(context).replaceAll([LoginRoute()]);
      }
    });
  }

  Future<bool> _hasSession() async {
    final storage = getIt<FlutterSecureStorage>();
    final user = await storage.read(key: dotenv.env['USER_DATA']!);
    return user != null;
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ShakeY(
              duration: const Duration(seconds: 3),
              infinite: true,
              child: ClipRRect(
                borderRadius: BorderRadiusGeometry.circular(180),
                child: Image.asset(ResourceIcons.chatia, height: 200),
              ),
            ),
            const SizedBox(height: 100),
            CircularProgressIndicator.adaptive(
              valueColor: AlwaysStoppedAnimation<Color>(AppColors.primary),
            ),
          ],
        ),
      ),
    );
  }
}

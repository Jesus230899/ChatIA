import 'package:auto_route/auto_route.dart';
import 'package:chatia/core/routes/app_router.gr.dart';

@AutoRouterConfig()
class AppRouter extends RootStackRouter {
  @override
  final List<AutoRoute> routes = [
    AutoRoute(page: SplashRoute.page, initial: true),
    AutoRoute(page: LoginRoute.page),
    AutoRoute(page: RegisterRoute.page),
    AutoRoute(page: HomeRoute.page),
    AutoRoute(page: StudyBotRoute.page),
  ];
}

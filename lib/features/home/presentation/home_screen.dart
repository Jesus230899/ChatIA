import 'package:auto_route/auto_route.dart';
import 'package:chatia/core/routes/app_router.gr.dart';
import 'package:chatia/features/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(body: _body(context));
  }

  Widget _body(BuildContext context) {
    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        Center(child: Text('Este es el home screen')),
        SizedBox(height: 40),
        CustomButtonWidget(
          onPressed: () => AutoRouter.of(context).push(StudyBotRoute()),
          text: 'Study Bot',
        ),
      ],
    );
  }
}

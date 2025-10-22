// ignore_for_file: must_be_immutable
import 'package:auto_route/auto_route.dart';
import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/core/resources/resource_icons.dart';
import 'package:chatia/core/routes/app_router.gr.dart';
import 'package:chatia/features/home/presentation/bloc/home_bloc.dart';
import 'package:chatia/features/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class HomeScreen extends StatelessWidget {
  HomeScreen({super.key});
  late Size size;
  final HomeBloc bloc = getIt<HomeBloc>();

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);

    return BlocProvider(
      create: (context) => bloc,
      child: BlocConsumer<HomeBloc, HomeState>(
        listener: (context, state) {},
        builder: (context, state) {
          return Scaffold(body: _body(context));
        },
      ),
    );
  }

  Widget _body(BuildContext context) {
    return SafeArea(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: SingleChildScrollView(
          physics: BouncingScrollPhysics(),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            children: [
              Text(
                "¡Bienvenido a ChatIA!",
                style: TextStyle(fontWeight: FontWeight.bold, fontSize: 23),
              ),
              SizedBox(height: 10),
              Text(
                "¡Tu aventura con la inteligencia artificial comienza aquí! Elige un bot y deja que ChatIA te ayude a aprender, inspirarte o simplemente pasar un buen rato.",
                style: TextStyle(fontSize: 13),
              ),
              SizedBox(height: 20),
              _chats(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _chats(BuildContext context) {
    return Column(
      spacing: 20,
      children: [
        _itemBot(
          title: 'StudyBot',
          description:
              "Tu compañero de estudio inteligente. Aprende sobre ciencia, resuelve tus dudas y lleva registro de todo lo que has aprendido.",
          onTap: () => AutoRouter.of(context).push(StudyBotRoute()),
          locked: false,
          icon: ResourceIcons.studyIcon,
        ),
        _itemBot(
          title: 'CineBot',
          description:
              "Tu asistente cinéfilo. Descubre nuevas películas, consulta información con un solo mensaje y guarda tus favoritas para ver después.",
          onTap: () {},
          locked: true,
        ),
        _itemBot(
          title: 'WeatherFriend',
          description:
              "Tu amigo del clima. Pregunta cómo estará el día en cualquier ciudad y guarda tus lugares favoritos para no perder detalle.",
          onTap: () {},
          locked: true,
        ),
        _itemBot(
          title: 'ChefBot',
          description:
              "Tu chef virtual. Dile qué ingredientes tienes y te mostrará recetas deliciosas para aprovecharlos al máximo.",
          onTap: () {},
          locked: true,
        ),
        _itemBot(
          title: 'LinguaChat',
          description:
              "Tu compañero de idiomas. Traduce frases, practica conversaciones y sigue tu progreso mientras mejoras cada día.",
          onTap: () {},
          locked: true,
        ),
      ],
    );
  }

  Widget _itemBot({
    required String title,
    required String description,
    required VoidCallback onTap,
    String? icon,
    required bool locked,
  }) {
    return Material(
      elevation: 2,
      borderRadius: BorderRadius.circular(20),
      child: Stack(
        children: [
          Container(
            padding: const EdgeInsets.all(15),
            width: double.infinity,
            decoration: BoxDecoration(borderRadius: BorderRadius.circular(20)),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    _nameAction(title: title, onTap: onTap),
                    ClipRRect(
                      borderRadius: BorderRadius.circular(180),
                      child: Image.asset(
                        icon ?? ResourceIcons.chatia,
                        height: 80,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 15),
                Text(description),
              ],
            ),
          ),
          _commingSoonBanner(locked),
        ],
      ),
    );
  }

  Widget _nameAction({required String title, required VoidCallback onTap}) {
    return Column(
      children: [
        Text(
          title,
          style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 18),
        ),
        const SizedBox(height: 20),
        CustomButtonWidget(
          onPressed: onTap,
          width: 100,
          height: 30,
          child: Text(
            'Abrir',
            style: TextStyle(
              color: Colors.white,
              fontWeight: FontWeight.bold,
              fontSize: 12,
            ),
          ),
        ),
      ],
    );
  }

  Widget _commingSoonBanner(bool locked) {
    return Visibility(
      visible: locked,
      child: Positioned.fill(
        child: Container(
          width: double.infinity,
          decoration: BoxDecoration(color: Colors.white.withValues(alpha: 0.7)),
          child: Center(
            child: Text(
              'Proximamente',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ),
    );
  }
}

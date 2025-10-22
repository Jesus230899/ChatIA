// ignore_for_file: must_be_immutable
import 'package:auto_route/auto_route.dart';
import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/core/resources/resource_icons.dart';
import 'package:chatia/core/routes/app_router.gr.dart';
import 'package:chatia/features/home/presentation/bloc/home_bloc.dart';
import 'package:chatia/features/widgets/custom_button_widget.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:url_launcher/url_launcher.dart';

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
          return Scaffold(
            body: _body(context),
            floatingActionButton: _floatingButton(context),
          );
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

  Widget _floatingButton(BuildContext context) {
    return FloatingActionButton.extended(
      onPressed: () => _showModalBottomSheet(context),
      label: Text('Más información'),
      icon: Icon(Icons.info_outline_rounded, color: Colors.white),
    );
  }

  void _showModalBottomSheet(BuildContext context) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      builder: (_) {
        return Material(
          child: SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 30),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Text(
                      'Sobre el desarrollador',
                      style: TextStyle(
                        fontWeight: FontWeight.bold,
                        fontSize: 20,
                      ),
                    ),
                    const SizedBox(height: 20),
                    _presentationText(),
                    const SizedBox(height: 10),
                    _habilities(),
                    const SizedBox(height: 10),
                    _aboutMe(),
                    const SizedBox(height: 20),
                    _contact(),
                    const SizedBox(height: 20),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
  }

  Widget _presentationText() {
    return RichText(
      text: TextSpan(
        text: '¡Hola! Soy ',
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: 'Jesús Aguilar Martínez',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                ' desarrollador de aplicaciones móviles multiplataforma con más de ',
          ),
          TextSpan(
            text: '4 años de experiencia',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                ' creando proyectos desde cero hasta su publicación. Me encanta diseñar y construir apps que realmente aporten valor, combinando buenas prácticas, seguridad y una experiencia de usuario agradable.',
          ),
        ],
      ),
    );
  }

  Widget _habilities() {
    return RichText(
      text: TextSpan(
        text: 'A lo largo de mi carrera he trabajado con ',
        style: TextStyle(color: Colors.black),
        children: [
          TextSpan(
            text: 'DDD (Domain-Driven Design), BLoC',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(
            text:
                ' para la gestión de estado y diversas librerías que hacen que el código sea más limpio, seguro y escalable, como ',
          ),
          TextSpan(
            text:
                'flutter_bloc, get_it, injectable, dartz, flutter_secure_storage',
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          TextSpan(text: ' , entre muchas otras.'),
        ],
      ),
    );
  }

  Widget _aboutMe() {
    return RichText(
      text: TextSpan(
        text:
            'Soy una persona curiosa, que siempre busca aprender algo nuevo y mejorar cada detalle. Mi meta es seguir creando soluciones que inspiren, ayuden y hagan la tecnología un poco más cercana para todos.',
        style: TextStyle(color: Colors.black),
        children: [],
      ),
    );
  }

  Widget _contact() {
    return Column(
      children: [
        RichText(
          text: TextSpan(
            text: 'Si tienes ',
            style: TextStyle(color: Colors.black),
            children: [
              TextSpan(
                text: 'sugerencias, comentarios o simplemente quieres saludar',
                style: TextStyle(fontWeight: FontWeight.bold),
              ),
              TextSpan(text: ' , ¡me encantaría saber de ti!'),
            ],
          ),
        ),
        const SizedBox(height: 30),
        CustomButtonWidget(onPressed: _sendEmail, text: 'Contactar por correo'),
        const SizedBox(height: 20),
        CustomButtonWidget(onPressed: _launchUrl, text: 'Ver mi LinkedIn'),
      ],
    );
  }

  Future<void> _launchUrl() async {
    const String url =
        "https://www.linkedin.com/in/developer-mobile-jesus-alberto-aguilar-martinez/";
    final Uri uri = Uri.parse(url);

    if (!await launchUrl(uri, mode: LaunchMode.externalApplication)) {
      throw Exception('No se pudo abrir: $url');
    }
  }

  Future<void> _sendEmail() async {
    final Uri emailUri = Uri(
      scheme: 'mailto',
      path: 'jesusalberto.aguilar01@gmail.com',
      queryParameters: {'subject': 'Contacto desde tu app'},
    );

    if (!await launchUrl(emailUri)) {
      throw Exception('No se pudo abrir el correo');
    }
  }
}

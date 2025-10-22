import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/core/theme/colors.dart';
import 'package:chatia/features/studybot/presentation/bloc/study_bloc/studybot_bloc.dart';
import 'package:chatia/features/studybot/presentation/bloc/study_form_bloc/study_form_bloc.dart';
import 'package:chatia/features/studybot/presentation/views/studybot_chat_view.dart';
import 'package:chatia/features/studybot/presentation/views/studybot_chats_view.dart';
import 'package:chatia/features/studybot/presentation/views/studybot_profile_view.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:google_fonts/google_fonts.dart';

@RoutePage()
class StudyBotScreen extends StatefulWidget {
  const StudyBotScreen({super.key});

  @override
  State<StudyBotScreen> createState() => _StudyBotScreenState();
}

class _StudyBotScreenState extends State<StudyBotScreen>
    with SingleTickerProviderStateMixin {
  late TabController _tabController;
  late Size size;

  final StudybotBloc bloc = getIt<StudybotBloc>();
  final StudyFormBloc formBloc = getIt<StudyFormBloc>();

  @override
  void initState() {
    super.initState();
    _tabController = TabController(length: 3, vsync: this);
  }

  @override
  void dispose() {
    _tabController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (_) => bloc),
        BlocProvider(create: (_) => formBloc),
      ],

      child: _bodyConsumer(),
    );
  }

  Widget _bodyConsumer() {
    return BlocConsumer<StudybotBloc, StudybotState>(
      listener: (context, state) {
        state.askGeminiResult.fold(() {}, (either) {
          either.fold((l) {
            ScaffoldMessenger.of(context).showSnackBar(
              SnackBar(content: Text("Hubo un error al contactar Gemini")),
            );
          }, (r) => null);
        });
      },
      builder: (_, state) {
        return _body();
      },
    );
  }

  Widget _body() {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: _appBar(),

      body: TabBarView(
        controller: _tabController,
        physics: NeverScrollableScrollPhysics(),
        children: [
          StudybotChatView(bloc: bloc),
          StudybotChatsView(bloc: bloc, size: size),
          StudybotProfileView(bloc: formBloc),
        ],
      ),
      bottomNavigationBar: _bottomBar(),
    );
  }

  Widget _bottomBar() {
    return TabBar(
      controller: _tabController,
      onTap: (val) {
        if (val == 1) {
          bloc.add(GetAllChatsEvent());
        }
        if (val == 2) {
          formBloc.add(LoadUserDataEvent());
        }
      },

      labelColor: AppColors.primary,
      unselectedLabelColor: AppColors.icon,
      tabs: [
        _itemTab(
          Platform.isAndroid ? Icons.chat : CupertinoIcons.chat_bubble_fill,
          'Chat',
        ),
        _itemTab(
          Platform.isAndroid ? Icons.content_paste_rounded : CupertinoIcons.doc,
          'Contenido',
        ),
        _itemTab(CupertinoIcons.profile_circled, 'Perfil'),
      ],
    );
  }

  Widget _itemTab(IconData icon, String text) {
    return SafeArea(
      top: false,
      child: Tab(icon: Icon(icon), text: text),
    );
  }

  AppBar _appBar() {
    return AppBar(
      title: Text(
        'StudyBot',
        style: GoogleFonts.openSans(fontWeight: FontWeight.bold),
      ),
      iconTheme: IconThemeData(color: AppColors.primary),
      centerTitle: true,
      backgroundColor: Colors.white,
      shadowColor: Colors.white,
      bottom: PreferredSize(
        preferredSize: const Size.fromHeight(1),
        child: Container(
          color: Colors.grey.shade400, // color de la línea
          height: 1, // grosor de la línea
        ),
      ),
      actions: [_actionBar()],
    );
  }

  Widget _actionBar() {
    return Visibility(
      visible: _tabController.index == 0,
      child: PopupMenuButton<String>(
        onSelected: (value) {
          if (value == 'guardar') {
            bloc.add(SaveChatEvent());
            ScaffoldMessenger.of(context).showSnackBar(
              const SnackBar(content: Text('Chat guardado correctamente')),
            );
          } else if (value == 'nuevo') {
            bloc.add(NewChatEvent());
          }
        },
        itemBuilder: (context) => [
          const PopupMenuItem(value: 'guardar', child: Text('Guardar chat')),
          const PopupMenuItem(value: 'nuevo', child: Text('Nuevo chat')),
        ],
      ),
    );
  }
}

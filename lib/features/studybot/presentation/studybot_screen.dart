import 'dart:io';

import 'package:auto_route/auto_route.dart';
import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/core/theme/colors.dart';
import 'package:chatia/features/studybot/presentation/bloc/studybot_bloc.dart';
import 'package:chatia/features/studybot/presentation/views/studybot_chat_view.dart';
import 'package:chatia/features/studybot/presentation/views/studybot_chats_view.dart';
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
    return BlocProvider(create: (context) => bloc, child: _bodyConsumer());
  }

  Widget _bodyConsumer() {
    return BlocConsumer<StudybotBloc, StudybotState>(
      listener: (context, state) {
        state.askGeminiResult.fold(() {}, (either) {
          either.fold((l) {
            ScaffoldMessenger.of(
              context,
            ).showSnackBar(SnackBar(content: Text('Error: ${l.message}')));
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
          Container(color: Colors.blue),
        ],
      ),
      bottomNavigationBar: TabBar(
        controller: _tabController,
        onTap: (val) {
          if (val == 1) {
            bloc.add(GetAllChatsEvent());
          }
        },
        labelColor: AppColors.primary,
        unselectedLabelColor: AppColors.icon,
        tabs: [
          SafeArea(
            child: Tab(
              icon: Icon(
                Platform.isAndroid
                    ? Icons.chat
                    : CupertinoIcons.chat_bubble_fill,
              ),
              text: 'Chat',
            ),
          ),
          SafeArea(
            child: Tab(
              icon: Icon(
                Platform.isAndroid
                    ? Icons.content_paste_rounded
                    : CupertinoIcons.doc,
              ),
              text: 'Contenido',
            ),
          ),
          SafeArea(
            child: Tab(
              icon: Icon(CupertinoIcons.profile_circled),
              text: 'Perfil',
            ),
          ),
        ],
      ),
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
    );
  }
}

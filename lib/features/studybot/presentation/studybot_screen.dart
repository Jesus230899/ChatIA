import 'package:auto_route/auto_route.dart';
import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/core/theme/colors.dart';
import 'package:chatia/features/studybot/presentation/bloc/studybot_bloc.dart';
import 'package:chatia/features/studybot/presentation/views/studybot_chat_view.dart';
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
          Container(color: Colors.green),
          Container(color: Colors.blue),
        ],
      ),
      bottomNavigationBar: SafeArea(
        child: TabBar(
          controller: _tabController,
          tabs: [
            Tab(icon: Icon(Icons.chat)),
            Tab(icon: Icon(Icons.info)),
            Tab(icon: Icon(Icons.settings)),
          ],
        ),
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

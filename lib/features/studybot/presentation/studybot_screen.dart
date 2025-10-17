import 'package:auto_route/auto_route.dart';
import 'package:chatia/core/injection/base_injection.dart';
import 'package:chatia/features/studybot/presentation/bloc/studybot_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

@RoutePage()
class StudyBotScreen extends StatefulWidget {
  const StudyBotScreen({super.key});

  @override
  State<StudyBotScreen> createState() => _StudyBotScreenState();
}

class _StudyBotScreenState extends State<StudyBotScreen> {
  final StudybotBloc bloc = getIt<StudybotBloc>();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) =>
          bloc..add(AskGeminiEvent(question: 'Que es la fotosintesis?')),
      child: _bodyConsumer(),
    );
  }

  Widget _bodyConsumer() {
    return BlocConsumer<StudybotBloc, StudybotState>(
      listener: (context, state) {},
      builder: (_, state) {
        return _body();
      },
    );
  }

  Widget _body() {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 20, vertical: 10),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text('Información del pokemon:'),
            const SizedBox(height: 80),
            if (bloc.state.loading)
              const CircularProgressIndicator.adaptive()
            else
              Text(bloc.state.message),
          ],
        ),
      ),
    );
  }
}

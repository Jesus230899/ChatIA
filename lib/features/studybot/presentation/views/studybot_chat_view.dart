import 'package:animate_do/animate_do.dart';
import 'package:chatia/core/resources/resource_icons.dart';
import 'package:chatia/core/theme/colors.dart';
import 'package:chatia/core/utils/text_cleanners.dart';
import 'package:chatia/features/studybot/data/models/gemini_message_model.dart';
import 'package:chatia/features/studybot/presentation/bloc/studybot_bloc.dart';
import 'package:chatia/features/widgets/jumping_dot_loader_widget.dart';
import 'package:chatia/features/widgets/message_chat_widget.dart';
import 'package:flutter/material.dart';

class StudybotChatView extends StatefulWidget {
  final StudybotBloc bloc;
  const StudybotChatView({super.key, required this.bloc});

  @override
  State<StudybotChatView> createState() => _StudybotChatViewState();
}

class _StudybotChatViewState extends State<StudybotChatView> {
  late Size size;
  final TextEditingController _textController = TextEditingController();

  @override
  void dispose() {
    _textController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    size = MediaQuery.sizeOf(context);
    return _body();
  }

  Widget _body() {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisAlignment: MainAxisAlignment.center,
        children: [_messages(), _textInput()],
      ),
    );
  }

  Widget _messages() {
    final chat = widget.bloc.state.chat.fold(() => null, (a) => a);
    if (chat == null) {
      return _emptyChat();
    }

    // if (widget.bloc.state.loadingMessage) {
    //   chat.contents.add(
    //     GeminiMessageModel(isUser: false, message: 'Pensando...'),
    //   );
    // }
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        reverse: true,
        itemCount: chat.contents.reversed.length,
        itemBuilder: (_, index) => MessageChatWidget(
          message: chat.contents.reversed.toList()[index].message,
          isUser: chat.contents.reversed.toList()[index].isUser,
          size: size,
        ),
        separatorBuilder: (_, index) => const SizedBox(height: 10),
      ),
    );
  }

  Widget _textInput() {
    return Container(
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border(top: BorderSide(color: Colors.grey.shade300)),
      ),
      child: Row(
        children: [_textField(), const SizedBox(width: 10), _textInputAction()],
      ),
    );
  }

  Widget _textField() {
    final radius = 30.0;
    return Expanded(
      child: TextField(
        style: TextStyle(fontSize: 12),
        controller: _textController,
        decoration: _fieldDecoration(radius),
      ),
    );
  }

  InputDecoration _fieldDecoration(double radius) {
    return InputDecoration(
      fillColor: Colors.grey.shade300,
      filled: true,
      hintText: 'Escribe tu pregunta...',
      hintStyle: TextStyle(fontSize: 12),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      enabledBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),
      focusedBorder: OutlineInputBorder(
        borderRadius: BorderRadius.circular(radius),
        borderSide: BorderSide(color: Colors.grey.shade300),
      ),

      contentPadding: const EdgeInsets.symmetric(horizontal: 15, vertical: 0),
    );
  }

  Widget _textInputAction() {
    return GestureDetector(
      onTap: () {
        final question = _textController.text.trim();
        if (question.isNotEmpty) {
          widget.bloc.add(AskGeminiEvent(question: question));
          _textController.clear();
          FocusScope.of(context).unfocus();
        }
      },
      child: CircleAvatar(
        radius: 23,
        backgroundColor: AppColors.primary,
        child: const Icon(Icons.arrow_right_alt_sharp, color: Colors.white),
      ),
    );
  }

  Widget _emptyChat() {
    return Expanded(
      child: FadeIn(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadius.circular(60),
              child: Image.asset(
                ResourceIcons.studyIcon,
                width: 100,
                height: 100,
              ),
            ),
            const SizedBox(height: 20),
            Text(
              '🌟 ¡Hey! Soy StudyBot, el robot más curioso del universo 🤖 ¿Listo para descubrir algo increíble sobre la ciencia? ¡Pregúntame lo que quieras!',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }
}

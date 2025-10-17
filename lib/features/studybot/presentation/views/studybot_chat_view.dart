import 'package:chatia/core/theme/colors.dart';
import 'package:chatia/core/utils/text_cleanners.dart';
import 'package:chatia/features/studybot/presentation/bloc/studybot_bloc.dart';
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
        children: [
          // if (widget.bloc.state.loading)
          //   Expanded(
          //     child: Center(child: const CircularProgressIndicator.adaptive()),
          //   )
          // else
          _messages(),

          _textInput(),
        ],
      ),
    );
  }

  Widget _messages() {
    final chat = widget.bloc.state.chat.fold(() => null, (a) => a);
    if (chat == null) {
      return const SizedBox.shrink();
    }
    return Expanded(
      child: ListView.separated(
        shrinkWrap: true,
        physics: const BouncingScrollPhysics(),
        reverse: true,
        itemCount: chat.contents.reversed.length,
        itemBuilder: (_, index) => _message(
          chat.contents.reversed.toList()[index].isUser,
          chat.contents.reversed.toList()[index].message,
        ),
        separatorBuilder: (_, index) => const SizedBox(height: 10),
      ),
    );
  }

  Widget _message(bool isUser, String message) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Text(
            isUser ? 'Tú' : 'StudyBot',
            style: TextStyle(
              fontWeight: FontWeight.bold,
              color: AppColors.icon,
              fontSize: 12,
            ),
          ),
          const SizedBox(height: 5),
          _messageContainer(isUser, message),
        ],
      ),
    );
  }

  Widget _messageContainer(bool isUser, String message) {
    return Container(
      constraints: BoxConstraints(maxWidth: size.width * 0.7),
      padding: EdgeInsets.all(10),
      decoration: BoxDecoration(
        color: isUser ? AppColors.primary : AppColors.message,
        borderRadius: BorderRadius.only(
          topLeft: const Radius.circular(10),
          topRight: const Radius.circular(10),
          bottomLeft: isUser
              ? const Radius.circular(10)
              : const Radius.circular(0),
          bottomRight: isUser
              ? const Radius.circular(0)
              : const Radius.circular(10),
        ),
      ),
      child: Text(
        getTextFromPrompt(prompt: message) ?? message,
        style: TextStyle(color: isUser ? Colors.white : Colors.black),
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
    return Expanded(
      child: TextField(
        controller: _textController,
        decoration: InputDecoration(
          hintText: 'Escribe tu pregunta...',
          border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          contentPadding: const EdgeInsets.symmetric(
            horizontal: 15,
            vertical: 10,
          ),
        ),
      ),
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
}

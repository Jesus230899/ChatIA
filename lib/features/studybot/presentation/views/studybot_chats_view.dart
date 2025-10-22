import 'dart:developer';

import 'package:animate_do/animate_do.dart';
import 'package:chatia/core/resources/resource_icons.dart';
import 'package:chatia/core/theme/colors.dart';
import 'package:chatia/core/utils/text_cleanners.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:chatia/features/studybot/data/models/gemini_message_model.dart';
import 'package:chatia/features/studybot/presentation/bloc/study_bloc/studybot_bloc.dart';
import 'package:chatia/features/widgets/message_chat_widget.dart';
import 'package:flutter/material.dart';
import 'package:modal_bottom_sheet/modal_bottom_sheet.dart';
import 'package:timeago/timeago.dart' as timeago;

class StudybotChatsView extends StatelessWidget {
  final StudybotBloc bloc;
  final Size size;
  const StudybotChatsView({super.key, required this.bloc, required this.size});

  @override
  Widget build(BuildContext context) {
    if (bloc.state.chats.isEmpty) {
      return _emptyChatsView();
    }
    return FadeIn(
      child: ListView.separated(
        itemBuilder: (context, index) => _itemChat(index, context),
        separatorBuilder: (context, index) {
          return Divider(color: AppColors.message);
        },
        itemCount: bloc.state.chats.length,
      ),
    );
  }

  Widget _emptyChatsView() {
    return FadeIn(
      child: Padding(
        padding: const EdgeInsets.all(20),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            ClipRRect(
              borderRadius: BorderRadiusGeometry.circular(180),
              child: Image.asset(
                ResourceIcons.studyIcon,
                width: 140,
                fit: BoxFit.cover,
              ),
            ),
            const SizedBox(height: 40),
            Text('¡Aún no tienes ningún chat!', textAlign: TextAlign.center),
            Text(
              'Inicia una conversación con uno de tus chatbots y comienza a explorar lo que pueden hacer por ti.',
              textAlign: TextAlign.center,
            ),
          ],
        ),
      ),
    );
  }

  Widget _itemChat(int index, BuildContext context) {
    final chat = bloc.state.chats[index];
    log(chat.id);
    return ListTile(
      title: _getTitle(chat) != null
          ? Text(_getTitle(chat)!, style: TextStyle(fontSize: 12))
          : null,
      onTap: () => _showModalBottomSheet(context, chat),
      subtitle: _buildSubtitle(chat),
    );
  }

  String? _getTitle(GeminiChatModel chat) {
    if (chat.title != null && chat.title!.isNotEmpty) {
      return chat.title!;
    }
    final DateTime? date = DateTime.tryParse(chat.contents.last.date ?? '');
    if (date == null) return null;
    timeago.setLocaleMessages('es', timeago.EsMessages());
    final String time = timeago.format(date, locale: 'es');
    return time;
  }

  Widget _buildSubtitle(GeminiChatModel chat) {
    final List<String> messages = [];
    for (final message in _getFirst3Messages(chat)) {
      messages.add(message.message);
    }
    return SizedBox(
      height: 50,
      child: ListView.builder(
        itemCount: messages.length,
        itemBuilder: (_, index) {
          return Text(
            messages[index],
            maxLines: 1,
            overflow: TextOverflow.ellipsis,
            style: TextStyle(color: AppColors.icon, fontSize: 12),
          );
        },
      ),
    );
  }

  List<GeminiMessageModel> _getFirst3Messages(GeminiChatModel chat) {
    List<GeminiMessageModel> first3Contents = [];
    for (int i = 0; i < chat.contents.length && i < 3; i++) {
      final content = chat.contents[i];
      final message =
          getTextFromPrompt(prompt: content.message) ?? content.message;
      first3Contents.add(
        GeminiMessageModel(
          isUser: content.isUser,
          message: content.isUser ? "Tú: $message" : "StudyBot: $message",
          date: content.date,
        ),
      );
    }
    return first3Contents.toList();
  }

  void _showModalBottomSheet(BuildContext context, GeminiChatModel chat) {
    showCupertinoModalBottomSheet(
      context: context,
      expand: false,
      builder: (_) {
        return Material(
          child: SafeArea(
            bottom: true,
            child: Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 5),
              child: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    Align(
                      alignment: Alignment.centerLeft,
                      child: IconButton(
                        icon: Icon(Icons.close, color: AppColors.icon),
                        onPressed: () => Navigator.of(context).pop(),
                      ),
                    ),
                    ListView.separated(
                      shrinkWrap: true,
                      physics: const BouncingScrollPhysics(),
                      reverse: true,
                      itemCount: chat.contents.reversed.length,
                      itemBuilder: (_, index) => MessageChatWidget(
                        message: chat.contents.reversed.toList()[index].message,
                        isUser: chat.contents.reversed.toList()[index].isUser,
                        size: size,
                      ),
                      separatorBuilder: (_, index) =>
                          const SizedBox(height: 10),
                    ),
                  ],
                ),
              ),
            ),
          ),
        );
      },
    );
    // showModalBottomSheet(
    //   context: context,
    //   builder: (_) {
    //     return SizedBox(
    //       height: size.height,
    //       child:
    //
    // ListView.separated(
    //         shrinkWrap: true,
    //         physics: const BouncingScrollPhysics(),
    //         reverse: true,
    //         itemCount: chat.contents.reversed.length,
    //         itemBuilder: (_, index) => MessageChatWidget(
    //           message: chat.contents.reversed.toList()[index].message,
    //           isUser: chat.contents.reversed.toList()[index].isUser,
    //           size: size,
    //         ),
    //         separatorBuilder: (_, index) => const SizedBox(height: 10),
    //       ),
    //     );
    //   },
    // );
  }
}

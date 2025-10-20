import 'package:chatia/core/resources/resource_icons.dart';
import 'package:chatia/core/theme/colors.dart';
import 'package:chatia/core/utils/text_cleanners.dart';
import 'package:chatia/features/widgets/jumping_dot_loader_widget.dart';
import 'package:flutter/material.dart';

class MessageChatWidget extends StatelessWidget {
  final String message;
  final bool isUser;
  final Size size;
  const MessageChatWidget({
    super.key,
    required this.message,
    required this.isUser,
    required this.size,
  });

  @override
  Widget build(BuildContext context) {
    return Align(
      alignment: isUser ? Alignment.centerRight : Alignment.centerLeft,
      child: Column(
        crossAxisAlignment: isUser
            ? CrossAxisAlignment.end
            : CrossAxisAlignment.start,
        children: [
          Row(
            mainAxisAlignment: isUser
                ? MainAxisAlignment.end
                : MainAxisAlignment.start,
            children: [
              const SizedBox(width: 45),
              Text(
                isUser ? 'Tú' : 'StudyBot',
                style: TextStyle(
                  fontWeight: FontWeight.bold,
                  color: AppColors.icon,
                  fontSize: 12,
                ),
              ),
              const SizedBox(width: 45),
            ],
          ),
          const SizedBox(height: 5),
          _messageContainer(isUser, message),
        ],
      ),
    );
  }

  Widget _messageContainer(bool isUser, String message) {
    return Row(
      mainAxisAlignment: isUser
          ? MainAxisAlignment.end
          : MainAxisAlignment.start,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Visibility(
          visible: !isUser,
          child: Row(
            children: [
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  ResourceIcons.studyIcon,
                  width: 40,
                  height: 40,
                ),
              ),
              const SizedBox(width: 5),
            ],
          ),
        ),
        _message(),
        Visibility(
          visible: isUser,
          child: Row(
            children: [
              const SizedBox(width: 5),
              ClipRRect(
                borderRadius: BorderRadius.circular(60),
                child: Image.asset(
                  ResourceIcons.studyIcon,
                  width: 40,
                  height: 40,
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }

  Widget _message() {
    return Container(
      constraints: BoxConstraints(maxWidth: size.width * 0.6),
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
      child: message == 'Pensando...' ? _thinkingMessage() : _messageText(),
    );
  }

  Widget _messageText() {
    return Text(
      _getMessageText(message),
      style: TextStyle(color: isUser ? Colors.white : Colors.black),
    );
  }

  Widget _thinkingMessage() {
    return Row(
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Text(
          getTextFromPrompt(prompt: message) ?? message,
          style: TextStyle(color: isUser ? Colors.white : Colors.black),
        ),
        const SizedBox(width: 5),
        JumpingDotLoader(dotColor: AppColors.primary),
      ],
    );
  }

  String _getMessageText(String messagee) {
    final cleanedText = getTextFromPrompt(prompt: messagee) ?? messagee;

    if (cleanedText.contains('#guardar_chat')) {
      return 'El chat se guardará automaticamente. Puedes acceder a él en la sección de "Contenido". Podemos seguir conversando aquí si lo deseas.';
    }
    return cleanedText;
  }
}

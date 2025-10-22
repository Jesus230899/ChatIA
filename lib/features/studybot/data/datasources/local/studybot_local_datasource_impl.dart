import 'dart:developer';

import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/storage/secure_prefs.dart';
import 'package:chatia/features/studybot/data/datasources/local/studybot_local_datasource.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:dartz/dartz.dart';

class StudybotLocalDatasourceImpl implements StudybotLocalDatasource {
  final SecurePrefs _securePrefs = SecurePrefs();
  static const String _chatsKey = 'gemini_chats';

  @override
  Future<Either<OperationFailure, Unit>> saveChat({
    required GeminiChatModel chat,
  }) async {
    try {
      log('========= StudybotLocalDatasourceImpl - saveChat  ===========');
      // Primero vamos a obtener la lista de los chats existentes
      final chats = await _securePrefs.getObjectList<GeminiChatModel>(
        _chatsKey,
        (json) => GeminiChatModel.fromJson(json),
      );
      log('lista de chats obtenidos ${chats.length}');
      // Verificamos si el chat ya existe en la lista
      final existingindex = chats.indexWhere(
        (existingChat) => existingChat.id == chat.id,
      );
      if (existingindex != -1) {
        // Si existe, actualizamos el chat en la lista
        chats[existingindex] = chat;
      } else {
        // Si no existe, lo añadimos a la lista
        chats.add(chat);
      }
      // Guardamos la lista actualizada de chats
      await _securePrefs.setObjectList(
        _chatsKey,
        chats,
        (chat) => chat.toJson(),
      );
      log('========= StudybotLocalDatasourceImpl - saveChat - End ===========');
      return right(unit);
    } catch (e) {
      log(
        '========= StudybotLocalDatasourceImpl - saveChat - Error $e  ===========',
      );
      return left(OperationFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<OperationFailure, List<GeminiChatModel>>> getAllChats() async {
    log('========= StudybotLocalDatasourceImpl - getAllChats  ===========');
    try {
      // Primero vamos a obtener la lista de los chats existentes
      final chats = await _securePrefs.getObjectList<GeminiChatModel>(
        _chatsKey,
        (json) => GeminiChatModel.fromJson(json),
      );
      log('lista de chats obtenidos ${chats.length}');
      log(
        '========= StudybotLocalDatasourceImpl - getAllChats - End ===========',
      );
      return right(chats);
    } catch (e) {
      log(
        '========= StudybotLocalDatasourceImpl - getAllChats - Error ===========',
      );
      return left(OperationFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<OperationFailure, Unit>> deleteAllChats() async {
    try {
      await _securePrefs.remove(_chatsKey);
      return right(unit);
    } catch (e) {
      return left(OperationFailure(message: e.toString()));
    }
  }
}

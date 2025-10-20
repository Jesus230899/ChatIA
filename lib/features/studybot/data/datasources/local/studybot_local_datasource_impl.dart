import 'dart:convert';
import 'dart:developer';

import 'package:chatia/core/failure/operation_failure.dart';
import 'package:chatia/core/storage/hive_boxes.dart';
import 'package:chatia/core/storage/secure_hive_manager.dart';
import 'package:chatia/features/studybot/data/datasources/local/studybot_local_datasource.dart';
import 'package:chatia/features/studybot/data/models/gemini_chat_model.dart';
import 'package:dartz/dartz.dart';
import 'package:hive_flutter/hive_flutter.dart';

class StudybotLocalDatasourceImpl implements StudybotLocalDatasource {
  final Box _box;
  // final Box<String> _box = Hive.box<String>(HiveBoxes.geminiChats);

  StudybotLocalDatasourceImpl()
    : _box = SecureHiveManager().getBox(HiveBoxes.geminiChats);

  @override
  Future<Either<OperationFailure, Unit>> saveChat({
    required GeminiChatModel chat,
  }) async {
    log('Entra en saveChat');
    try {
      // log('Entra en el datasource a guardar el chat con id: ${chat.id}');
      // log('Los datos guardados en el chat son   : ${jsonEncode(chat.toJson())}');
      await _box.put(chat.id, jsonEncode(chat.toJson()));
      return right(unit);
    } catch (e) {
      return left(OperationFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<OperationFailure, GeminiChatModel>> getChatById({
    required String id,
  }) async {
    try {
      final data = _box.get(id);
      if (data == null) return left(OperationFailure(code: 404));
      return right(GeminiChatModel.fromJson((jsonDecode(data))));
    } catch (e) {
      return left(OperationFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<OperationFailure, List<GeminiChatModel>>> getAllChats() async {
    try {
      final chats = _box.values
          .map((e) => GeminiChatModel.fromJson(jsonDecode(e)))
          .toList();
      return right(chats);
    } catch (e) {
      return left(OperationFailure(message: e.toString()));
    }
  }

  @override
  Future<Either<OperationFailure, Unit>> deleteChat({
    required String id,
  }) async {
    try {
      await _box.delete(id);
      return right(unit);
    } catch (e) {
      return left(OperationFailure(message: e.toString()));
    }
  }
}

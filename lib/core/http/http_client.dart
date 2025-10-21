// ignore_for_file: depend_on_referenced_packages

import 'dart:async';
import 'dart:convert';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

class HTTPClient {
  final baseURL = dotenv.env["BASE_URL_PIPEDREAM"] ?? '';

  Future<http.Response> _sendRequest(
    String method,
    String path, {
    Object? body,

    Map<String, String>? queryParameters,
  }) async {
    try {
      final url = Uri(
        scheme: 'https',
        host: baseURL,
        path: path,
        queryParameters: queryParameters,
      );

      final headers = {"Content-Type": "application/json"};

      switch (method.toUpperCase()) {
        case 'GET':
          return http.get(url, headers: headers);
        case 'POST':
          return http.post(url, headers: headers, body: jsonEncode(body));
        default:
          throw UnsupportedError('Método HTTP no soportado: $method');
      }
    } catch (e) {
      rethrow;
    }
  }

  Future<http.Response> get(
    String path, {
    Map<String, String>? queryParameters,
  }) async {
    return _sendRequest('GET', path, queryParameters: queryParameters);
  }

  Future<http.Response> post(
    String path, {
    Object? body,
    Map<String, String>? queryParameters,
  }) async {
    return _sendRequest(
      'POST',
      path,
      body: body,
      queryParameters: queryParameters,
    );
  }
}

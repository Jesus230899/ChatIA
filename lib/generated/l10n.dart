// GENERATED CODE - DO NOT MODIFY BY HAND
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';
import 'intl/messages_all.dart';

// **************************************************************************
// Generator: Flutter Intl IDE plugin
// Made by Localizely
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, lines_longer_than_80_chars
// ignore_for_file: join_return_with_assignment, prefer_final_in_for_each
// ignore_for_file: avoid_redundant_argument_values, avoid_escaping_inner_quotes

class S {
  S();

  static S? _current;

  static S get current {
    assert(
      _current != null,
      'No instance of S was loaded. Try to initialize the S delegate before accessing S.current.',
    );
    return _current!;
  }

  static const AppLocalizationDelegate delegate = AppLocalizationDelegate();

  static Future<S> load(Locale locale) {
    final name = (locale.countryCode?.isEmpty ?? false)
        ? locale.languageCode
        : locale.toString();
    final localeName = Intl.canonicalizedLocale(name);
    return initializeMessages(localeName).then((_) {
      Intl.defaultLocale = localeName;
      final instance = S();
      S._current = instance;

      return instance;
    });
  }

  static S of(BuildContext context) {
    final instance = S.maybeOf(context);
    assert(
      instance != null,
      'No instance of S present in the widget tree. Did you add S.delegate in localizationsDelegates?',
    );
    return instance!;
  }

  static S? maybeOf(BuildContext context) {
    return Localizations.of<S>(context, S);
  }

  /// `The request has been processed successfully`
  String get solicitudProcesada {
    return Intl.message(
      'The request has been processed successfully',
      name: 'solicitudProcesada',
      desc: '',
      args: [],
    );
  }

  /// `The request has been processed successfully, and the resource has been created`
  String get solicitudProcesadaCreada {
    return Intl.message(
      'The request has been processed successfully, and the resource has been created',
      name: 'solicitudProcesadaCreada',
      desc: '',
      args: [],
    );
  }

  /// `The request cannot be processed`
  String get solicitudNoProcesada {
    return Intl.message(
      'The request cannot be processed',
      name: 'solicitudNoProcesada',
      desc: '',
      args: [],
    );
  }

  /// `You do not have authorization to make this request`
  String get noAutorizacion {
    return Intl.message(
      'You do not have authorization to make this request',
      name: 'noAutorizacion',
      desc: '',
      args: [],
    );
  }

  /// `Query not getting executed`
  String get consultaNoRealizada {
    return Intl.message(
      'Query not getting executed',
      name: 'consultaNoRealizada',
      desc: '',
      args: [],
    );
  }

  /// `The request is not allowed`
  String get solicitudNoPermitida {
    return Intl.message(
      'The request is not allowed',
      name: 'solicitudNoPermitida',
      desc: '',
      args: [],
    );
  }

  /// `The request is unacceptable`
  String get solicitudNoAceptada {
    return Intl.message(
      'The request is unacceptable',
      name: 'solicitudNoAceptada',
      desc: '',
      args: [],
    );
  }

  /// `The request could not be completed due to a conflict in the request`
  String get solicitudConflicto {
    return Intl.message(
      'The request could not be completed due to a conflict in the request',
      name: 'solicitudConflicto',
      desc: '',
      args: [],
    );
  }

  /// `The requested resource is no longer on the server`
  String get recursoNoDisponible {
    return Intl.message(
      'The requested resource is no longer on the server',
      name: 'recursoNoDisponible',
      desc: '',
      args: [],
    );
  }

  /// `The server is temporarily unavailable`
  String get errorServidor {
    return Intl.message(
      'The server is temporarily unavailable',
      name: 'errorServidor',
      desc: '',
      args: [],
    );
  }

  /// `Unknown error`
  String get errorDesconocido {
    return Intl.message(
      'Unknown error',
      name: 'errorDesconocido',
      desc: '',
      args: [],
    );
  }
}

class AppLocalizationDelegate extends LocalizationsDelegate<S> {
  const AppLocalizationDelegate();

  List<Locale> get supportedLocales {
    return const <Locale>[
      Locale.fromSubtags(languageCode: 'en'),
      Locale.fromSubtags(languageCode: 'es'),
    ];
  }

  @override
  bool isSupported(Locale locale) => _isSupported(locale);
  @override
  Future<S> load(Locale locale) => S.load(locale);
  @override
  bool shouldReload(AppLocalizationDelegate old) => false;

  bool _isSupported(Locale locale) {
    for (var supportedLocale in supportedLocales) {
      if (supportedLocale.languageCode == locale.languageCode) {
        return true;
      }
    }
    return false;
  }
}

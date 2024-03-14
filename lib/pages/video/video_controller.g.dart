// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'video_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$VideoController on _VideoController, Store {
  late final _$tokenAtom =
      Atom(name: '_VideoController.token', context: context);

  @override
  List<String> get token {
    _$tokenAtom.reportRead();
    return super.token;
  }

  @override
  set token(List<String> value) {
    _$tokenAtom.reportWrite(value, super.token, () {
      super.token = value;
    });
  }

  late final _$episodeAtom =
      Atom(name: '_VideoController.episode', context: context);

  @override
  int get episode {
    _$episodeAtom.reportRead();
    return super.episode;
  }

  @override
  set episode(int value) {
    _$episodeAtom.reportWrite(value, super.episode, () {
      super.episode = value;
    });
  }

  @override
  String toString() {
    return '''
token: ${token},
episode: ${episode}
    ''';
  }
}

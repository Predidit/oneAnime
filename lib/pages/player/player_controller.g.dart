// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'player_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PlayerController on _PlayerController, Store {
  late final _$dataStatusAtom =
      Atom(name: '_PlayerController.dataStatus', context: context);

  @override
  String get dataStatus {
    _$dataStatusAtom.reportRead();
    return super.dataStatus;
  }

  bool _dataStatusIsInitialized = false;

  @override
  set dataStatus(String value) {
    _$dataStatusAtom.reportWrite(
        value, _dataStatusIsInitialized ? super.dataStatus : null, () {
      super.dataStatus = value;
      _dataStatusIsInitialized = true;
    });
  }

  late final _$initAsyncAction =
      AsyncAction('_PlayerController.init', context: context);

  @override
  Future<dynamic> init(int offset) {
    return _$initAsyncAction.run(() => super.init(offset));
  }

  @override
  String toString() {
    return '''
dataStatus: ${dataStatus}
    ''';
  }
}

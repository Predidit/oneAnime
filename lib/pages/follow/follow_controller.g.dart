// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'follow_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$FollowController on _FollowController, Store {
  late final _$followListAtom =
      Atom(name: '_FollowController.followList', context: context);

  @override
  ObservableList<AnimeInfo> get followList {
    _$followListAtom.reportRead();
    return super.followList;
  }

  @override
  set followList(ObservableList<AnimeInfo> value) {
    _$followListAtom.reportWrite(value, super.followList, () {
      super.followList = value;
    });
  }

  @override
  String toString() {
    return '''
followList: ${followList}
    ''';
  }
}

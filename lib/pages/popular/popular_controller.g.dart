// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'popular_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$PopularController on _PopularController, Store {
  late final _$cacheListAtom =
      Atom(name: '_PopularController.cacheList', context: context);

  @override
  ObservableList<AnimeInfo> get cacheList {
    _$cacheListAtom.reportRead();
    return super.cacheList;
  }

  @override
  set cacheList(ObservableList<AnimeInfo> value) {
    _$cacheListAtom.reportWrite(value, super.cacheList, () {
      super.cacheList = value;
    });
  }

  @override
  String toString() {
    return '''
cacheList: ${cacheList}
    ''';
  }
}

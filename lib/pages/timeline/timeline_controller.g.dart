// GENERATED CODE - DO NOT MODIFY BY HAND

part of 'timeline_controller.dart';

// **************************************************************************
// StoreGenerator
// **************************************************************************

// ignore_for_file: non_constant_identifier_names, unnecessary_brace_in_string_interps, unnecessary_lambdas, prefer_expression_function_bodies, lines_longer_than_80_chars, avoid_as, avoid_annotating_with_dynamic, no_leading_underscores_for_local_identifiers

mixin _$TimelineController on _TimelineController, Store {
  late final _$schedulesAtom =
      Atom(name: '_TimelineController.schedules', context: context);

  @override
  List<AnimeSchedule> get schedules {
    _$schedulesAtom.reportRead();
    return super.schedules;
  }

  @override
  set schedules(List<AnimeSchedule> value) {
    _$schedulesAtom.reportWrite(value, super.schedules, () {
      super.schedules = value;
    });
  }

  late final _$sessonNameAtom =
      Atom(name: '_TimelineController.sessonName', context: context);

  @override
  String get sessonName {
    _$sessonNameAtom.reportRead();
    return super.sessonName;
  }

  @override
  set sessonName(String value) {
    _$sessonNameAtom.reportWrite(value, super.sessonName, () {
      super.sessonName = value;
    });
  }

  @override
  String toString() {
    return '''
schedules: ${schedules},
sessonName: ${sessonName}
    ''';
  }
}

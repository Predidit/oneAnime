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

  late final _$danDanmakusAtom =
      Atom(name: '_VideoController.danDanmakus', context: context);

  @override
  Map<int, List<Danmaku>> get danDanmakus {
    _$danDanmakusAtom.reportRead();
    return super.danDanmakus;
  }

  @override
  set danDanmakus(Map<int, List<Danmaku>> value) {
    _$danDanmakusAtom.reportWrite(value, super.danDanmakus, () {
      super.danDanmakus = value;
    });
  }

  late final _$playingAtom =
      Atom(name: '_VideoController.playing', context: context);

  @override
  bool get playing {
    _$playingAtom.reportRead();
    return super.playing;
  }

  @override
  set playing(bool value) {
    _$playingAtom.reportWrite(value, super.playing, () {
      super.playing = value;
    });
  }

  late final _$isBufferingAtom =
      Atom(name: '_VideoController.isBuffering', context: context);

  @override
  bool get isBuffering {
    _$isBufferingAtom.reportRead();
    return super.isBuffering;
  }

  @override
  set isBuffering(bool value) {
    _$isBufferingAtom.reportWrite(value, super.isBuffering, () {
      super.isBuffering = value;
    });
  }

  late final _$currentPositionAtom =
      Atom(name: '_VideoController.currentPosition', context: context);

  @override
  Duration get currentPosition {
    _$currentPositionAtom.reportRead();
    return super.currentPosition;
  }

  @override
  set currentPosition(Duration value) {
    _$currentPositionAtom.reportWrite(value, super.currentPosition, () {
      super.currentPosition = value;
    });
  }

  late final _$bufferAtom =
      Atom(name: '_VideoController.buffer', context: context);

  @override
  Duration get buffer {
    _$bufferAtom.reportRead();
    return super.buffer;
  }

  @override
  set buffer(Duration value) {
    _$bufferAtom.reportWrite(value, super.buffer, () {
      super.buffer = value;
    });
  }

  late final _$durationAtom =
      Atom(name: '_VideoController.duration', context: context);

  @override
  Duration get duration {
    _$durationAtom.reportRead();
    return super.duration;
  }

  @override
  set duration(Duration value) {
    _$durationAtom.reportWrite(value, super.duration, () {
      super.duration = value;
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

  late final _$danmakuOnAtom =
      Atom(name: '_VideoController.danmakuOn', context: context);

  @override
  bool get danmakuOn {
    _$danmakuOnAtom.reportRead();
    return super.danmakuOn;
  }

  @override
  set danmakuOn(bool value) {
    _$danmakuOnAtom.reportWrite(value, super.danmakuOn, () {
      super.danmakuOn = value;
    });
  }

  late final _$volumeAtom =
      Atom(name: '_VideoController.volume', context: context);

  @override
  double get volume {
    _$volumeAtom.reportRead();
    return super.volume;
  }

  @override
  set volume(double value) {
    _$volumeAtom.reportWrite(value, super.volume, () {
      super.volume = value;
    });
  }

  late final _$brightnessAtom =
      Atom(name: '_VideoController.brightness', context: context);

  @override
  double get brightness {
    _$brightnessAtom.reportRead();
    return super.brightness;
  }

  @override
  set brightness(double value) {
    _$brightnessAtom.reportWrite(value, super.brightness, () {
      super.brightness = value;
    });
  }

  late final _$playerSpeedAtom =
      Atom(name: '_VideoController.playerSpeed', context: context);

  @override
  double get playerSpeed {
    _$playerSpeedAtom.reportRead();
    return super.playerSpeed;
  }

  @override
  set playerSpeed(double value) {
    _$playerSpeedAtom.reportWrite(value, super.playerSpeed, () {
      super.playerSpeed = value;
    });
  }

  late final _$androidFullscreenAtom =
      Atom(name: '_VideoController.androidFullscreen', context: context);

  @override
  bool get androidFullscreen {
    _$androidFullscreenAtom.reportRead();
    return super.androidFullscreen;
  }

  @override
  set androidFullscreen(bool value) {
    _$androidFullscreenAtom.reportWrite(value, super.androidFullscreen, () {
      super.androidFullscreen = value;
    });
  }

  late final _$followAtom =
      Atom(name: '_VideoController.follow', context: context);

  @override
  bool get follow {
    _$followAtom.reportRead();
    return super.follow;
  }

  @override
  set follow(bool value) {
    _$followAtom.reportWrite(value, super.follow, () {
      super.follow = value;
    });
  }

  @override
  String toString() {
    return '''
token: ${token},
danDanmakus: ${danDanmakus},
playing: ${playing},
isBuffering: ${isBuffering},
currentPosition: ${currentPosition},
buffer: ${buffer},
duration: ${duration},
episode: ${episode},
danmakuOn: ${danmakuOn},
volume: ${volume},
brightness: ${brightness},
playerSpeed: ${playerSpeed},
androidFullscreen: ${androidFullscreen},
follow: ${follow}
    ''';
  }
}

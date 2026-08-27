import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:oneanime/request/video.dart';
import 'package:oneanime/pages/player/player_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/request/danmaku.dart';
import 'package:oneanime/bean/danmaku/danmaku_module.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:hive/hive.dart';

part 'video_controller.g.dart';

class VideoController = _VideoController with _$VideoController;

abstract class _VideoController with Store {
  @observable
  List<String> token = [];

  /// Bumped by every danmaku load; a load holding a stale id lost the race to a
  /// newer episode and must not write into [danDanmakus].
  int _danmakuRequestId = 0;

  @observable
  Map<int, List<Danmaku>> danDanmakus = {};

  @observable
  bool playing = false;
  @observable
  bool isBuffering = true;
  @observable
  Duration currentPosition = Duration.zero;
  @observable
  Duration buffer = Duration.zero;
  @observable
  Duration duration = Duration.zero;

  // (弃用) 播放器状态监听 media_kit 的流监听似乎存在问题
  // late StreamSubscription<bool>? playingSubscription;
  // late StreamSubscription<Duration>? postionSubscription;
  // late StreamSubscription<Duration>? bufferSubscription;
  // late StreamSubscription<Duration>? durationSubscription;

  @observable
  int episode = 1;

  // 弹幕开关
  @observable
  bool danmakuOn = false;

  // 视频音量/亮度
  @observable
  double volume = 0;
  @observable
  double brightness = 0;

  // 播放器倍速
  @observable
  double playerSpeed = 1.0;

  String videoUrl = '';
  String videoCookie = '';
  String title = '';
  int link = 0;
  int offset = 0;

  @observable
  bool follow = false;

  Box setting = GStorage.setting;

  Future setPlaybackSpeed(double playerSpeed) async {
    final PlayerController playerController = Modular.get<PlayerController>();
    try {
      playerController.setRate(playerSpeed);
    } catch (e) {
      debugPrint(e.toString());
    }
    this.playerSpeed = playerSpeed;
  }

  Future changeEpisode(int episode) async {
    final PlayerController playerController = Modular.get<PlayerController>();
    final PopularController popularController =
        Modular.get<PopularController>();
    popularController.updateAnimeProgress(episode, title);
    var result = await VideoRequest.getVideoLink(token[token.length - episode]);
    videoUrl = result['link'];
    videoCookie = result['cookie'];
    playerController.videoUrl = videoUrl;
    playerController.videoCookie = videoCookie;
    this.episode = episode;
    playing = false;
    currentPosition = Duration.zero;
    duration = Duration.zero;
    // Loading must not block the switch, so an enclosing try/catch cannot help.
    unawaited(getDanDanmaku(title, episode).catchError((e) {
      debugPrint('弹幕加载错误 ${e.toString()}');
    }));
    playerSpeed = 1.0;
    await playerController.init(0);
  }

  void _addDanmakus(List<Danmaku> danmakus) {
    for (final danmaku in danmakus) {
      danDanmakus.putIfAbsent(danmaku.p.toInt(), () => []).add(danmaku);
    }
  }

  Future<void> getDanDanmaku(String title, int episode) async {
    final int requestId = ++_danmakuRequestId;
    danDanmakus.clear();

    final int? animeId = await DanmakuRequest.getDandanAnimeId(title);
    List<Danmaku> res = await _danmakuOf(animeId, episode);
    if (res.isEmpty &&
        setting.get(SettingBoxKey.danmakuEnhance, defaultValue: true)) {
      res = await _danmakuOf(await _bgmAnimeId(title), episode);
    }
    if (requestId != _danmakuRequestId) {
      return;
    }
    _addDanmakus(res);
    debugPrint('当前弹幕库 ${danDanmakus.length}');
  }

  Future<List<Danmaku>> _danmakuOf(int? animeId, int episode) async {
    if (animeId == null) {
      return [];
    }
    return DanmakuRequest.getDanmaku(animeId, episode);
  }

  /// The 弹弹Play keyword search misses many of the traditional Chinese titles
  /// Anime1 uses, so resolve those on Bangumi.tv and let 弹弹Play map the
  /// subject onto its own anime id.
  Future<int?> _bgmAnimeId(String title) async {
    String simplified = title;
    try {
      simplified = await Modular.get<PopularController>().chineseTW2S(title);
    } catch (e) {
      debugPrint('内部翻译错误 ${e.toString()}');
    }
    final int? subjectId = await DanmakuRequest.getBgmSubjectId(simplified);
    if (subjectId == null) {
      return null;
    }
    return DanmakuRequest.getDandanAnimeIdByBgmId(subjectId);
  }
}

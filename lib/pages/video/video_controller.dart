import 'dart:async';
import 'dart:collection';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:oneanime/bean/anime/anime_bangumi_info.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
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

  int bangumiID = 0;
  List<String> aniDanmakuToken = [];

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
  bool danmakuOn = GStorage.setting
      .get(SettingBoxKey.danmakuEnabledByDefault, defaultValue: false);

  // 界面管理
  @observable
  bool showPositioned = false;
  @observable
  bool showPosition = false;
  @observable
  bool showBrightness = false;
  @observable
  bool showVolume = false;

  // 视频音量/亮度
  @observable
  double volume = 0;
  @observable
  double brightness = 0;

  // 播放器倍速
  @observable
  double playerSpeed = 1.0;

  // 安卓全屏状态
  @observable
  bool androidFullscreen = false;

  String videoUrl = '';
  String videoCookie = '';
  String title = '';
  String from = '/tab/popular/';
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
    try {
      danDanmakus.clear();
      getDanDanmaku(title, episode);
    } catch (e) {
      debugPrint(e.toString());
    }
    playerSpeed = 1.0;
    await playerController.init(0);
  }

  Future getAniDanmakuList(String title) async {
    aniDanmakuToken = await DanmakuRequest.getAniDanmakuList(title);
  }

  void addDanmakus(List<Danmaku> danmakus) {
    for (var element in danmakus) {
      var danmakuList = danDanmakus[element.p.toInt()] ?? List.empty(growable: true);
      danmakuList.add(element);
      danDanmakus[element.p.toInt()] = danmakuList;
    }
  }

  Future getDanDanmaku(String title, int episode) async {
    // 极为糟糕的临时措施，但作者现在就要看高达
    // if (title.contains('鋼彈')) {
    //   title = title.replaceAll('鋼彈', '高达');
    // }
    bool danmakuEnhance =
        setting.get(SettingBoxKey.danmakuEnhance, defaultValue: true);
    bangumiID = await DanmakuRequest.getBangumiID(title);
    var res = await DanmakuRequest.getDanDanmaku(bangumiID, episode);
    addDanmakus(res);
    if (danmakuEnhance && res.length == 0) {
      final PopularController popularController =
          Modular.get<PopularController>();
      try {
        title = await popularController.chineseTW2S(title);
        debugPrint('内部翻译结果 $title');
      } catch (e) {
        debugPrint('内部翻译错误 ${e.toString()}');
      }
      String titleEnhance = '';
      BangumiInfo? bangumiInfo;
      try {
        bangumiInfo = await DanmakuRequest.getBangumiName(title);
        titleEnhance = bangumiInfo!.nameCN!;
      } catch (e) {
        debugPrint("请求Bangumi中文译名错误 ${e.toString()}");
      }
      if (titleEnhance != '') {
        dynamic res = [];
        if (titleEnhance != title) {
          bangumiID = await DanmakuRequest.getBangumiID(titleEnhance);
          res = await DanmakuRequest.getDanDanmaku(bangumiID, episode);
        } else {
          debugPrint('中文译名未转换');
        }
        if (res.length != 0) {
          addDanmakus(res);
        } else {
          try {
            titleEnhance = bangumiInfo!.name!;
          } catch (e) {
            debugPrint("请求Bangumi日文译名错误 ${e.toString()}");
          }
          if (titleEnhance != '') {
            bangumiID = await DanmakuRequest.getBangumiID(titleEnhance);
            var res = await DanmakuRequest.getDanDanmaku(bangumiID, episode);
            addDanmakus(res);
          }
        }
      }
    }
    debugPrint('当前弹幕库 ${danDanmakus.length}');
  }
}

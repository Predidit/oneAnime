import 'dart:async';
import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:oneanime/request/video.dart';
import 'package:oneanime/pages/player/player_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/request/danmaku.dart';
import 'package:oneanime/pages/video/danmaku_module.dart';

part 'video_controller.g.dart';

class VideoController = _VideoController with _$VideoController;

abstract class _VideoController with Store {
  @observable
  List<String> token = [];

  int bangumiID = 0;
  List<String> aniDanmakuToken = [];

  @observable
  List<Danmaku> danDanmakus = [];

  @observable
  bool playing = false;
  @observable
  Duration currentPosition = Duration.zero;
  @observable
  Duration buffer = Duration.zero;
  @observable
  Duration duration = Duration.zero;

  // 播放器状态监听
  // late StreamSubscription<bool>? playingSubscription;
  // late StreamSubscription<Duration>? postionSubscription;
  // late StreamSubscription<Duration>? bufferSubscription;
  // late StreamSubscription<Duration>? durationSubscription;

  @observable
  int episode = 1;

  // 弹幕开关
  @observable
  bool danmakuOn = false;

  // 界面管理
  @observable
  bool showPositioned = false;

  // 安卓全屏状态
  @observable
  bool androidFullscreen = false;

  String videoUrl = '';
  String videoCookie = '';
  String title = '';
  String from = '/tab/popular/';

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
    danDanmakus.clear();
    getDanDanmaku(title, episode);
    // playingSubscription?.cancel();
    // postionSubscription?.cancel();
    // bufferSubscription?.cancel();
    // durationSubscription?.cancel();
    // playingSubscription = null;
    // postionSubscription = null;
    // bufferSubscription = null;
    // durationSubscription = null;

    await playerController.init();

    // playingSubscription = playerController.mediaPlayer.stream.playing.listen(
    //   (bool playing) {
    //     playing = playing;
    //   },
    // );

    // postionSubscription = playerController.mediaPlayer.stream.position
    //     .listen((Duration position) {
    //   currentPosition = position;
    // });

    // bufferSubscription =
    //     playerController.mediaPlayer.stream.buffer.listen((Duration buffer) {
    //   buffer = buffer;
    // });

    // durationSubscription = playerController.mediaPlayer.stream.duration
    //     .listen((Duration duration) {
    //   duration = duration;
    // });
    // playingSubscription?.resume();
    // postionSubscription?.resume();
    // bufferSubscription?.resume();
    // durationSubscription?.resume();
  }

  Future getAniDanmakuList(String title) async {
    aniDanmakuToken = await DanmakuRequest.getAniDanmakuList(title);
  }

  Future getDanDanmaku(String title, int episode) async {
    bangumiID = await DanmakuRequest.getBangumiID(title);
    var res = await DanmakuRequest.getDanDanmaku(bangumiID, episode);
    danDanmakus.addAll(res);
    debugPrint('当前弹幕库 ${danDanmakus.length}');
  }
}

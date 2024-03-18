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
  List<Danmaku> danDanmakus = [];

  @observable
  int episode = 1;

  String videoUrl = '';
  String videoCookie = '';
  String title = '';
  String from = '/tab/popular/';

  Future changeEpisode(int episode) async {
    final PlayerController playerController = Modular.get<PlayerController>();
    final PopularController popularController = Modular.get<PopularController>();
    popularController.updateAnimeProgress(episode, title);
    var result = await VideoRequest.getVideoLink(token[token.length - episode]); 
    videoUrl = result['link'];
    videoCookie = result['cookie']; 
    playerController.videoUrl = videoUrl;
    playerController.videoCookie = videoCookie; 
    this.episode = episode;
    await playerController.init();
  }

  Future getAniDanmakuList(String title) async {
    aniDanmakuToken = await DanmakuRequest.getAniDanmakuList(title);
  }

  // Future getBangumiID(String title) async {
  //   bangumiID = await DanmakuRequest.getBangumiID(title);
  // }

  Future getDanDanmaku(String title, int episode) async {
    bangumiID = await DanmakuRequest.getBangumiID(title);
    var res = await DanmakuRequest.getDanDanmaku(bangumiID, episode);
    danDanmakus.addAll(res);
    debugPrint('当前弹幕库 ${danDanmakus.toString()}');
  }
}

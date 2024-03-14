import 'package:mobx/mobx.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:oneanime/request/video.dart';
import 'package:oneanime/pages/player/player_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

part 'video_controller.g.dart';

class VideoController = _VideoController with _$VideoController;

abstract class _VideoController with Store {
  @observable
  List<String> token = [];

  @observable
  int episode = 1;

  String videoUrl = '';
  String videoCookie = '';
  String title = '';

  Future changeEpisode(int episode) async {
    final PlayerController playerController = Modular.get<PlayerController>();
    var result = await VideoRequest.getVideoLink(token[token.length - episode]); 
    videoUrl = result['link'];
    videoCookie = result['cookie']; 
    playerController.videoUrl = videoUrl;
    playerController.videoCookie = videoCookie;
    this.episode = episode;
    await playerController.init();
  }
}

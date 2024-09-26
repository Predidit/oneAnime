import 'package:mobx/mobx.dart';
import 'package:video_player/video_player.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:oneanime/utils/constans.dart';
import 'package:flutter/foundation.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/utils/utils.dart';

part 'player_controller.g.dart';

class PlayerController = _PlayerController with _$PlayerController;

abstract class _PlayerController with Store {
  String videoUrl = '';
  String videoCookie = '';
  bool playResume = false;
  Box setting = GStorage.setting;
  late VideoPlayerController mediaPlayer;
  late DanmakuController danmakuController;

  // 当前播放器状态
  @observable
  late String dataStatus;

  @action
  Future init(int offset) async {
    dataStatus = 'loading';
    playResume = setting.get(SettingBoxKey.playResume, defaultValue: false);
    try {
      mediaPlayer.dispose();
      debugPrint('找到逃掉的 player');
    } catch (e) {
      debugPrint('未找到已经存在的 player');
    }
    debugPrint('VideoURL开始初始化');
    mediaPlayer = await createVideoController();
    bool aotoPlay = setting.get(SettingBoxKey.autoPlay, defaultValue: true);
    if (offset != 0 && playResume) {
      await mediaPlayer.seekTo(Duration(seconds: offset));
    }
    if (aotoPlay) {
      await mediaPlayer.play();
    }
    danmakuController.clear();
    debugPrint('VideoURL初始化完成');
    dataStatus = 'loaded';
  }

  void dispose() {
    try {
      mediaPlayer.dispose();
      debugPrint('捕获到一个逃掉的 player');
    } catch (e) {
      debugPrint('没有捕获到漏掉的 player');
    }
  }

  Future<VideoPlayerController> createVideoController() async {
    debugPrint('videoController 配置成功');

    var httpHeaders = {
      'user-agent':
          Utils.getRandomUA(),
      'referer': HttpString.baseUrl,
      'Cookie': videoCookie,
    };

    mediaPlayer = VideoPlayerController.networkUrl(Uri.parse(videoUrl),
        httpHeaders: httpHeaders);
    await mediaPlayer.initialize();
    return mediaPlayer;
  }

  Function get setRate {
    return mediaPlayer.setPlaybackSpeed;
  }

  bool get playing {
    return mediaPlayer.value.isPlaying;
  }

  bool get buffering {
    return mediaPlayer.value.isBuffering;
  }

  Duration get position {
    return mediaPlayer.value.position;
  }

  Duration get buffer {
    if (mediaPlayer.value.buffered.isEmpty) {
      return Duration.zero;
    }

    Duration maxDuration = mediaPlayer.value.buffered[0].end;
    return maxDuration;
  }

  Duration get duration {
    return mediaPlayer.value.duration;
  }

  bool get completed {
    return mediaPlayer.value.isCompleted;
  }

  Future seek(Duration duration) async {
    danmakuController.clear();
    await mediaPlayer.seekTo(duration);
  }

  Future pause() async {
    danmakuController.pause();
    await mediaPlayer.pause();
  }

  Future play() async {
    danmakuController.resume();
    await mediaPlayer.play();
  }

  Future playOrPause() async {
    if (mediaPlayer.value.isPlaying) {
      pause();
    } else {
      play();
    }
  }
}

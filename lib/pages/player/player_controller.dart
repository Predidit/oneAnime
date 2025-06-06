import 'dart:io';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:mobx/mobx.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
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
  late Player mediaPlayer;
  late VideoController videoController;
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
    mediaPlayer = await createVideoController(offset: offset);
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

  Future<Player> createVideoController({int offset = 0}) async {
    var httpHeaders = {
      'user-agent': Utils.getRandomUA(),
      'referer': HttpString.baseUrl,
      'Cookie': videoCookie,
    };
    bool hAenable = setting.get(SettingBoxKey.HAenable, defaultValue: true);
    bool aotoPlay = setting.get(SettingBoxKey.autoPlay, defaultValue: true);
    mediaPlayer = Player(
      configuration: const PlayerConfiguration(
        bufferSize: 15 * 1024 * 1024,
      ),
    );

    var pp = mediaPlayer.platform as NativePlayer;
    // media-kit 默认启用硬盘作为双重缓存，这可以维持大缓存的前提下减轻内存压力
    // media-kit 内部硬盘缓存目录按照 Linux 配置，这导致该功能在其他平台上被损坏
    // 该设置可以在所有平台上正确启用双重缓存
    await pp.setProperty("demuxer-cache-dir", await Utils.getPlayerTempPath());
    await pp.setProperty("af", "scaletempo2=max-speed=8");
    if (Platform.isAndroid) {
      await pp.setProperty("volume-max", "100");
      await pp.setProperty("ao", "opensles");
    }

    await mediaPlayer.setAudioTrack(
      AudioTrack.auto(),
    );

    videoController = VideoController(
      mediaPlayer,
      configuration: (Platform.isAndroid && hAenable)
          ? const VideoControllerConfiguration(
              vo: 'mediacodec_embed',
              hwdec: 'mediacodec',
              androidAttachSurfaceAfterVideoParameters: false,
            )
          : VideoControllerConfiguration(
              enableHardwareAcceleration: hAenable,
              hwdec: hAenable ? null : 'no',
              androidAttachSurfaceAfterVideoParameters: false,
            ),
    );
    mediaPlayer.setPlaylistMode(PlaylistMode.none);

    // error handle
    mediaPlayer.stream.error.listen((event) {
      SmartDialog.showToast(
        'Player intent error ${event.toString()} $videoUrl',
        displayType: SmartToastType.onlyRefresh,
      );
    });

    await mediaPlayer.open(
      Media(videoUrl,
          start: Duration(seconds: offset), httpHeaders: httpHeaders),
      play: aotoPlay,
    );
    return mediaPlayer;
  }

  Function get setRate {
    return mediaPlayer.setRate;
  }

  bool get playing {
    return mediaPlayer.state.playing;
  }

  bool get buffering {
    return mediaPlayer.state.buffering;
  }

  Duration get position {
    return mediaPlayer.state.position;
  }

  Duration get buffer {
    return mediaPlayer.state.buffer;
  }

  Duration get duration {
    return mediaPlayer.state.duration;
  }

  bool get completed {
    return mediaPlayer.state.completed;
  }

  Future seek(Duration duration) async {
    danmakuController.clear();
    await mediaPlayer.seek(duration);
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
    if (mediaPlayer.state.playing) {
      pause();
    } else {
      play();
    }
  }
}

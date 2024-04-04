import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:ns_danmaku/danmaku_controller.dart';
import 'package:ns_danmaku/ns_danmaku.dart';
import 'package:oneanime/utils/constans.dart';
import 'package:flutter/services.dart';
import 'package:flutter/foundation.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:auto_orientation/auto_orientation.dart';
import 'package:window_manager/window_manager.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:hive/hive.dart';

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
    mediaPlayer = await createVideoController();
    if (offset != 0 && playResume) {
      var sub = mediaPlayer.stream.buffer.listen(null);
      sub.onData((event) async {
        if (event.inSeconds > 0) {
          // This is a workaround for unable to await for `mediaPlayer.stream.buffer.first`
          // It seems that when the `buffer.first` is fired, the media is not fully loaded 
          // and the player will not seek properlly.
          await sub.cancel();
          await mediaPlayer.seek(Duration(seconds: offset));
        }
      });
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

  Future<Player> createVideoController() async {
    mediaPlayer = Player(
      configuration: const PlayerConfiguration(
        // 默认缓存 5M 大小
        bufferSize: 5 * 1024 * 1024, //panic
      ),
    );

    var pp = mediaPlayer.platform as NativePlayer;
    // 解除倍速限制
    await pp.setProperty("af", "scaletempo2=max-speed=8");
    //  音量不一致
    if (Platform.isAndroid) {
      await pp.setProperty("volume-max", "100");
      await pp.setProperty("ao", "audiotrack,opensles");
    }

    await mediaPlayer.setAudioTrack(
      AudioTrack.auto(),
    );

    videoController = VideoController(
      mediaPlayer,
      configuration: const VideoControllerConfiguration(
        enableHardwareAcceleration: true,
        androidAttachSurfaceAfterVideoParameters: false,
      ),
    );
    debugPrint('videoController 配置成功');

    var httpHeaders = {
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
      'referer': HttpString.baseUrl,
      'Cookie': videoCookie,
    };

    bool aotoPlay = setting.get(SettingBoxKey.autoPlay, defaultValue: true);

    mediaPlayer.setPlaylistMode(PlaylistMode.none);
    mediaPlayer.open(
      Media(videoUrl, httpHeaders: httpHeaders),
      play: aotoPlay,
    );
    return mediaPlayer;
  }

  Future<void> enterFullScreen() async {
    if (Platform.isWindows) {
      await windowManager.setFullScreen(true);
      return;
    }
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
    await landScape();
    await SystemChrome.setEnabledSystemUIMode(
    SystemUiMode.immersiveSticky,
  );
  }

  //退出全屏显示
  Future<void> exitFullScreen() async {
    debugPrint('退出全屏模式');
    if (Platform.isWindows) {
      await windowManager.setFullScreen(false);
    }
    dynamic document;
    late SystemUiMode mode = SystemUiMode.edgeToEdge;
    try {
      if (kIsWeb) {
        document.exitFullscreen();
      } else if (Platform.isAndroid || Platform.isIOS) {
        if (Platform.isAndroid &&
            (await DeviceInfoPlugin().androidInfo).version.sdkInt < 29) {
          mode = SystemUiMode.manual;
        }
        await SystemChrome.setEnabledSystemUIMode(
          mode,
          overlays: SystemUiOverlay.values,
        );
        // await SystemChrome.setPreferredOrientations([]);
        verticalScreen();
      } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        await const MethodChannel('com.alexmercerind/media_kit_video')
            .invokeMethod(
          'Utils.ExitNativeFullscreen',
        );
        // verticalScreen();
      }
    } catch (exception, stacktrace) {
      debugPrint(exception.toString());
      debugPrint(stacktrace.toString());
    }
  }

  //横屏
  Future<void> landScape() async {
    dynamic document;
    try {
      if (kIsWeb) {
        await document.documentElement?.requestFullscreen();
      } else if (Platform.isAndroid || Platform.isIOS) {
        // await SystemChrome.setEnabledSystemUIMode(
        //   SystemUiMode.immersiveSticky,
        //   overlays: [],
        // );
        // await SystemChrome.setPreferredOrientations(
        //   [
        //     DeviceOrientation.landscapeLeft,
        //     DeviceOrientation.landscapeRight,
        //   ],
        // );
        await AutoOrientation.landscapeAutoMode(forceSensor: true);
      } else if (Platform.isMacOS || Platform.isWindows || Platform.isLinux) {
        await const MethodChannel('com.alexmercerind/media_kit_video')
            .invokeMethod(
          'Utils.EnterNativeFullscreen',
        );
      }
    } catch (exception, stacktrace) {
      debugPrint(exception.toString());
      debugPrint(stacktrace.toString());
    }
  }

//竖屏
  Future<void> verticalScreen() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
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

  Future playOrPause() async {
    mediaPlayer.state.playing ? danmakuController.pause() : danmakuController.resume();
    await mediaPlayer.playOrPause();
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
}

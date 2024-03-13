import 'dart:io';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:media_kit/media_kit.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:oneanime/utils/constans.dart';

part 'player_controller.g.dart';

class PlayerController = _PlayerController with _$PlayerController;

abstract class _PlayerController with Store {
  String videoUrl = '';
  String videoCookie = '';
  late Player mediaPlayer;
  late VideoController videoController;

  // 当前播放器状态
  @observable
  late String dataStatus;

  @action
  Future init() async {
    dataStatus = 'loading';
    try {
      mediaPlayer.dispose();
      debugPrint('找到逃掉的 player');
    } catch (e) {
      debugPrint('未找到已经存在的 player');
    }
    debugPrint('VideoURL开始初始化');
    mediaPlayer = await createVideoController();
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

    mediaPlayer.setPlaylistMode(PlaylistMode.none);
    mediaPlayer.open(
      Media(videoUrl, httpHeaders: httpHeaders),  
      play: false,
    );
    return mediaPlayer;
  }
}

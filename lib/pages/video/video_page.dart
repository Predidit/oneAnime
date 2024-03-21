import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:oneanime/pages/player/player_controller.dart';
import 'package:oneanime/pages/player/player_item.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:provider/provider.dart';
import 'package:oneanime/bean/anime/anime_panel.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oneanime/pages/menu/side_menu.dart';
import 'package:ns_danmaku/ns_danmaku.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:window_manager/window_manager.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with WindowListener {
  // var _key = new GlobalKey<ScaffoldState>();
  dynamic navigationBarState;
  late DanmakuController danmakuController;
  final VideoController videoController = Modular.get<VideoController>();
  final PlayerController playerController = Modular.get<PlayerController>();

  // 弹幕设置
  final _danmuKey = GlobalKey();
  bool _running = true;
  bool _hideTop = false;
  bool _hideBottom = false;
  bool _hideScroll = false;
  bool _border = true;
  double _opacity = 1.0;
  double _duration = 8;
  double _fontSize = (Platform.isIOS || Platform.isAndroid) ? 16 : 25;

  Timer? hideTimer;
  Timer? playerTimer;

  void _handleTap() {
    videoController.showPositioned = true;
    if (hideTimer != null) {
      hideTimer!.cancel();
    }

    hideTimer = Timer(const Duration(seconds: 4), () {
      videoController.showPositioned = false;
      hideTimer = null;
    });
  }

  @override
  void onWindowRestore() {
    danmakuController.onClear();
  }

  @override
  void initState() {
    super.initState();
    // videoController.episode = 1;
    playerController.videoUrl = videoController.videoUrl;
    playerController.videoCookie = videoController.videoCookie;
    playerController.init();
    try {
      videoController.danDanmakus.clear();
      videoController.getDanDanmaku(
          videoController.title, videoController.episode);
    } catch (e) {
      debugPrint(e.toString());
    }
    playerTimer = getPlayerTimer();
  }

  @override
  void dispose() {
    try {
      playerTimer?.cancel();
    } catch (e) {
      debugPrint(e.toString());
    }
    windowManager.removeListener(this);
    playerController.dispose();
    super.dispose();
  }

  getPlayerTimer() {
    return Timer.periodic(Duration(seconds: 1), (timer) {
      videoController.playing = playerController.mediaPlayer.state.playing;
      videoController.isBuffering =
          playerController.mediaPlayer.state.buffering;
      videoController.currentPosition =
          playerController.mediaPlayer.state.position;
      videoController.buffer = playerController.mediaPlayer.state.buffer;
      videoController.duration = playerController.mediaPlayer.state.duration;
      if (videoController.currentPosition.inMicroseconds != 0 &&
          playerController.mediaPlayer.state.playing == true &&
          videoController.danmakuOn == true) {
        debugPrint('当前播放到 ${videoController.currentPosition.inSeconds}');
        videoController.danDanmakus.asMap().forEach((key, value) {
          if (value.p.toInt() == videoController.currentPosition.inSeconds) {
            danmakuController.addItems([DanmakuItem(value.m)]);
            return;
          }
        });
      }
      if (playerController.mediaPlayer.state.completed == true &&
          videoController.episode < videoController.token.length) {
        videoController.changeEpisode(videoController.episode + 1);
      }
      windowManager.addListener(this);
    });
  }

  void onBackPressed(BuildContext context) {
    if (videoController.androidFullscreen) {
      debugPrint('当前播放器全屏');
      try {
        playerController.exitFullScreen();
        videoController.androidFullscreen = false;
        return;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    debugPrint('当前播放器非全屏');
    navigationBarState.showNavigate();
    videoController.from == '/tab/popular/'
        ? navigationBarState.updateSelectedIndex(0)
        : (videoController.from == '/tab/follow/'
            ? navigationBarState.updateSelectedIndex(2)
            : navigationBarState.updateSelectedIndex(1));
    Modular.to.navigate(videoController.from);
  }

  @override
  Widget build(BuildContext context) {
    navigationBarState = Platform.isWindows
        ? Provider.of<SideNavigationBarState>(context, listen: false)
        : Provider.of<NavigationBarState>(context, listen: false);
    return PopScope(
      // key: _key,
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: SafeArea(
        child: Scaffold(
          body: Observer(builder: (context) {
            return Column(
              children: [
                Container(
                  color: Colors.black,
                  child: MouseRegion(
                    onHover: (_) {
                      _handleTap();
                    },
                    child: SizedBox(
                      height: videoController.androidFullscreen
                          ? (MediaQuery.of(context).size.height)
                          : (MediaQuery.of(context).size.width * 9.0 / (16.0)),
                      width: MediaQuery.of(context).size.width,
                      child: Stack(
                        alignment: Alignment.center,
                        children: [
                        const Center(child: PlayerItem()),
                        videoController.isBuffering
                            ? const Positioned.fill(
                                child: Center(
                                  child: CircularProgressIndicator(),
                                ),
                              )
                            : Container(),
                        GestureDetector(
                          onTap: _handleTap,
                          child: Container(
                            color: Colors.transparent,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        ),

                        // 播放器手势控制
                        Positioned.fill(
                            left: 16,
                            top: 25,
                            right: 15,
                            bottom: 15,
                            child: GestureDetector(
                              onHorizontalDragUpdate:
                                  (DragUpdateDetails details) {
                                videoController.showPosition = true;
                                if (playerTimer != null) {
                                  // debugPrint('检测到拖动, 定时器取消');
                                  playerTimer!.cancel();
                                }
                                playerController.mediaPlayer.pause();
                                final double scale =
                                    180000 / MediaQuery.sizeOf(context).width;
                                videoController.currentPosition = Duration(
                                    milliseconds: videoController
                                            .currentPosition.inMilliseconds +
                                        (details.delta.dx * scale).round());
                              },
                              onHorizontalDragEnd: (DragEndDetails details) {
                                playerController.mediaPlayer
                                    .seek(videoController.currentPosition);
                                playerController.mediaPlayer.play();
                                playerTimer = getPlayerTimer();
                                videoController.showPosition = false;
                              },
                            )),
                        // 顶部进度条
                        Positioned(
                            top: 25,
                            width: 200,
                            child: videoController.showPosition
                                ? Wrap(
                                    alignment: WrapAlignment.center,
                                    children: <Widget>[
                                      Container(
                                        padding: const EdgeInsets.all(8.0),
                                        decoration: BoxDecoration(
                                          color: Colors.black.withOpacity(0.5),
                                          borderRadius:
                                              BorderRadius.circular(8.0), // 圆角
                                        ),
                                        child: Text(
                                          '${videoController.currentPosition.inMinutes}:${(videoController.currentPosition.inSeconds) % 60}/${videoController.duration.inMinutes}:${(videoController.duration.inSeconds) % 60}',
                                          style: const TextStyle(
                                            color: Colors.white,
                                          ),
                                        ),
                                      ),
                                    ],
                                  )
                                : Container()),
                        Positioned.fill(
                          child: DanmakuView(
                            key: _danmuKey,
                            createdController: (DanmakuController e) {
                              danmakuController = e;
                              debugPrint('弹幕控制器创建成功');
                            },
                            option: DanmakuOption(
                              opacity: _opacity,
                              fontSize: _fontSize,
                              duration: _duration,
                              borderText: _border,
                            ),
                            statusChanged: (e) {
                              setState(() {
                                _running = e;
                              });
                            },
                          ),
                        ),
                        (videoController.showPositioned ||
                                !playerController.mediaPlayer.state.playing)
                            ? Positioned(
                                top: 0,
                                left: 0,
                                child: IconButton(
                                  color: Colors.white,
                                  icon: const Icon(Icons.arrow_back),
                                  onPressed: () {
                                    if (videoController.androidFullscreen ==
                                        true) {
                                      playerController.exitFullScreen();
                                      videoController.androidFullscreen = false;
                                      return;
                                    }
                                    navigationBarState.showNavigate();
                                    videoController.from == '/tab/popular/'
                                        ? navigationBarState
                                            .updateSelectedIndex(0)
                                        : (videoController.from ==
                                                '/tab/follow/'
                                            ? navigationBarState
                                                .updateSelectedIndex(2)
                                            : navigationBarState
                                                .updateSelectedIndex(1));
                                    Modular.to.navigate(videoController.from);
                                  },
                                ),
                              )
                            : Container(),

                        // 自定义播放器底部组件
                        (videoController.showPositioned ||
                                !playerController.mediaPlayer.state.playing)
                            ? Positioned(
                                bottom: 0,
                                left: 0,
                                right: 0,
                                child: Row(
                                  children: [
                                    IconButton(
                                      color: Colors.white,
                                      icon: Icon(videoController.playing
                                          ? Icons.pause
                                          : Icons.play_arrow),
                                      onPressed: () {
                                        if (videoController.playing) {
                                          playerController.mediaPlayer.pause();
                                        } else {
                                          playerController.mediaPlayer.play();
                                        }
                                      },
                                    ),
                                    Expanded(
                                      child: ProgressBar(
                                        timeLabelLocation:
                                            TimeLabelLocation.none,
                                        progress:
                                            videoController.currentPosition,
                                        buffered: videoController.buffer,
                                        total: videoController.duration,
                                        onSeek: (duration) {
                                          playerController.mediaPlayer
                                              .seek(duration);
                                        },
                                      ),
                                    ),
                                    IconButton(
                                      color: Colors.white,
                                      icon: Icon(videoController.danmakuOn
                                          ? Icons.comment
                                          : Icons.comments_disabled),
                                      onPressed: () {
                                        if (videoController
                                                .danDanmakus.length ==
                                            0) {
                                          SmartDialog.showToast('当前剧集没有找到弹幕的说');
                                          return;
                                        }
                                        videoController.danmakuOn =
                                            !videoController.danmakuOn;
                                        debugPrint(
                                            '弹幕开关变更为 ${videoController.danmakuOn}');
                                      },
                                    ),
                                    IconButton(
                                      color: Colors.white,
                                      icon: Icon(
                                          videoController.androidFullscreen
                                              ? Icons.fullscreen
                                              : Icons.fullscreen_exit),
                                      onPressed: () {
                                        if (videoController.androidFullscreen) {
                                          playerController.exitFullScreen();
                                        } else {
                                          playerController.enterFullScreen();
                                        }
                                        videoController.androidFullscreen =
                                            !videoController.androidFullscreen;
                                      },
                                    ),
                                  ],
                                ),
                              )
                            : Container(),
                      ]),
                    ),
                  ),
                ),

                videoController.androidFullscreen
                    ? Container()
                    : BangumiPanel(
                        sheetHeight: MediaQuery.sizeOf(context).height -
                            MediaQuery.of(context).padding.top -
                            MediaQuery.sizeOf(context).width * 9 / 16,
                      ),
                // SizedBox(child: Text("${videoController.androidFullscreen}")),
              ],
            );
          }),
        ),
      ),
    );
  }
}

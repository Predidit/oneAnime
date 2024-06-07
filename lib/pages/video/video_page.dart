import 'dart:io';
import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter/gestures.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/pages/history/history_controller.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:oneanime/pages/player/player_controller.dart';
import 'package:oneanime/pages/player/player_item.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:provider/provider.dart';
import 'package:oneanime/bean/anime/anime_panel.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oneanime/pages/menu/side_menu.dart';
import 'package:canvas_danmaku/canvas_danmaku.dart';
import 'package:audio_video_progress_bar/audio_video_progress_bar.dart';
import 'package:window_manager/window_manager.dart';
import 'package:screen_brightness/screen_brightness.dart';
import 'package:flutter_volume_controller/flutter_volume_controller.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/bean/appbar/drag_to_move_bar.dart' as dtb;
import 'package:oneanime/utils/storage.dart';
import 'package:oneanime/utils/utils.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> with WindowListener {
  // var _key = new GlobalKey<ScaffoldState>();
  dynamic navigationBarState;
  Box setting = GStorage.setting;
  late DanmakuController danmakuController;
  final FocusNode _focusNode = FocusNode();
  final VideoController videoController = Modular.get<VideoController>();
  final PopularController popularController = Modular.get<PopularController>();
  final PlayerController playerController = Modular.get<PlayerController>();
  final HistoryController historyController = Modular.get<HistoryController>();

  // 弹幕
  final _danmuKey = GlobalKey();

  Timer? hideTimer;
  Timer? playerTimer;
  Timer? mouseScrollerTimer;

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

  void _handleMouseScroller() {
    videoController.showVolume = true;
    if (mouseScrollerTimer != null) {
      mouseScrollerTimer!.cancel();
    }

    mouseScrollerTimer = Timer(const Duration(seconds: 2), () {
      videoController.showVolume = false;
      mouseScrollerTimer = null;
    });
  }

  @override
  void onWindowRestore() {
    danmakuController.onClear();
  }

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      FocusScope.of(context).requestFocus(_focusNode);
    });
    videoController.danmakuOn =
        setting.get(SettingBoxKey.danmakuEnabledByDefault, defaultValue: false);
    bool alwaysOntop =
        setting.get(SettingBoxKey.alwaysOntop, defaultValue: true);
    if (alwaysOntop) {
      windowManager.setAlwaysOnTop(true);
    }
    init();
  }

  void init() async {
    videoController.playerSpeed = 1.0;
    playerController.videoUrl = videoController.videoUrl;
    playerController.videoCookie = videoController.videoCookie;
    await playerController.init(videoController.offset);
    videoController.offset = 0;
    try {
      videoController.danDanmakus.clear();
      await videoController.getDanDanmaku(
          videoController.title, videoController.episode);
    } catch (e) {
      debugPrint(e.toString());
    }
    playerTimer = getPlayerTimer();
    try {
      await playerController.setRate(videoController.playerSpeed);
    } catch (e) {
      debugPrint(e.toString());
    }
  }

  @override
  void dispose() {
    _focusNode.dispose();
    try {
      playerTimer?.cancel();
    } catch (e) {
      debugPrint(e.toString());
    }
    historyController.updateHistory(
        videoController.link, videoController.currentPosition.inSeconds);
    windowManager.setAlwaysOnTop(false);
    windowManager.removeListener(this);
    playerController.dispose();
    super.dispose();
  }

  getPlayerTimer() {
    return Timer.periodic(const Duration(seconds: 1), (timer) {
      videoController.playing = playerController.playing;
      videoController.isBuffering = playerController.buffering;
      videoController.currentPosition = playerController.position;
      videoController.buffer = playerController.buffer;
      videoController.duration = playerController.duration;
      if (videoController.currentPosition.inMicroseconds != 0 &&
          playerController.playing == true &&
          videoController.danmakuOn == true) {
        // debugPrint('当前播放到 ${videoController.currentPosition.inSeconds}');
        videoController.danDanmakus[videoController.currentPosition.inSeconds]
            ?.asMap()
            .forEach((idx, danmaku) async {
          await Future.delayed(
              Duration(
                  milliseconds: idx *
                      1000 ~/
                      videoController
                          .danDanmakus[
                              videoController.currentPosition.inSeconds]!
                          .length),
              () => mounted && playerController.playing
                  ? danmakuController.addDanmaku(DanmakuContentItem(danmaku.m))
                  : null);
        });
      }
      if (playerController.completed == true &&
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
        danmakuController.onClear();
      } catch (_) {}
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
    switch (videoController.from) {
      case '/tab/timeline/':
        {
          navigationBarState.updateSelectedIndex(1);
        }
        break;
      case '/tab/follow/':
        {
          navigationBarState.updateSelectedIndex(2);
        }
        break;
      case '/tab/history/':
        {
          navigationBarState.updateSelectedIndex(3);
        }
        break;
      default:
        {
          navigationBarState.updateSelectedIndex(0);
        }
        break;
    }
    Modular.to.navigate(videoController.from);
  }

  Future<void> setVolume(double value) async {
    try {
      FlutterVolumeController.updateShowSystemUI(false);
      await FlutterVolumeController.setVolume(value);
    } catch (_) {}
  }

  Future<void> setBrightness(double value) async {
    try {
      await ScreenBrightness().setScreenBrightness(value);
    } catch (_) {}
  }

  // 切换选集
  void showChangeChapter() {
    SmartDialog.show(
      useAnimation: false,
      builder: (context) {
      return AlertDialog(
        title: const Text('切换选集'),
        content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
          return Wrap(
            spacing: 8,
            runSpacing: 4,
            children: [
              for (int i = 1;
                  i <= videoController.token.length;
                  i++) ...<Widget>[
                if (i == videoController.episode) ...<Widget>[
                  FilledButton(
                    onPressed: () async {
                      SmartDialog.dismiss();
                    },
                    child: Text('第${i.toString()}话'),
                  ),
                ] else ...[
                  FilledButton.tonal(
                    onPressed: () async {
                      videoController.changeEpisode(i);
                      SmartDialog.dismiss();
                    },
                    child: Text('第${i.toString()}话'),
                  ),
                ]
              ]
            ],
          );
        }),
      );
    });
  }

  // 选择倍速
  void showSetSpeedSheet() {
    final double currentSpeed = videoController.playerSpeed;
    final List<double> speedsList = [
      0.25,
      0.5,
      0.75,
      1.0,
      1.25,
      1.5,
      1.75,
      2.0
    ];
    SmartDialog.show(
        useAnimation: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('播放速度'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return Wrap(
                spacing: 8,
                runSpacing: 2,
                children: [
                  for (final double i in speedsList) ...<Widget>[
                    if (i == currentSpeed) ...<Widget>[
                      FilledButton(
                        onPressed: () async {
                          await videoController.setPlaybackSpeed(i);
                          SmartDialog.dismiss();
                        },
                        child: Text(i.toString()),
                      ),
                    ] else ...[
                      FilledButton.tonal(
                        onPressed: () async {
                          await videoController.setPlaybackSpeed(i);
                          SmartDialog.dismiss();
                        },
                        child: Text(i.toString()),
                      ),
                    ]
                  ]
                ],
              );
            }),
            actions: <Widget>[
              TextButton(
                onPressed: () => SmartDialog.dismiss(),
                child: Text(
                  '取消',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                ),
              ),
              TextButton(
                onPressed: () async {
                  await videoController.setPlaybackSpeed(1.0);
                  SmartDialog.dismiss();
                },
                child: const Text('默认速度'),
              ),
            ],
          );
        });
  }

  /// 发送弹幕 由于接口限制, 暂时未提交云端
  void showShootDanmakuSheet() {
    final TextEditingController textController = TextEditingController();
    bool isSending = false; // 追踪是否正在发送
    SmartDialog.show(
        useAnimation: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('发送弹幕'),
            content: StatefulBuilder(
                builder: (BuildContext context, StateSetter setState) {
              return TextField(
                controller: textController,
              );
            }),
            actions: [
              TextButton(
                onPressed: () => SmartDialog.dismiss(),
                child: Text(
                  '取消',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                ),
              ),
              StatefulBuilder(
                  builder: (BuildContext context, StateSetter setState) {
                return TextButton(
                  onPressed: isSending
                      ? null
                      : () async {
                          final String msg = textController.text;
                          if (msg.isEmpty) {
                            SmartDialog.showToast('弹幕内容不能为空');
                            return;
                          } else if (msg.length > 100) {
                            SmartDialog.showToast('弹幕内容不能超过100个字符');
                            return;
                          }
                          setState(() {
                            isSending = true; // 开始发送，更新状态
                          });
                          // Todo 接口方限制

                          setState(() {
                            isSending = false; // 发送结束，更新状态
                          });
                          SmartDialog.showToast('发送成功');
                          danmakuController.addDanmaku(DanmakuContentItem(msg));
                          SmartDialog.dismiss();
                        },
                  child: Text(isSending ? '发送中...' : '发送'),
                );
              })
            ],
          );
        });
  }

  @override
  Widget build(BuildContext context) {
    navigationBarState =
        Platform.isWindows || Platform.isLinux || Platform.isMacOS
            ? Provider.of<SideNavigationBarState>(context, listen: false)
            : Provider.of<NavigationBarState>(context, listen: false);

    // 弹幕设置
    // bool _running = true;
    bool _showStroke =
        setting.get(SettingBoxKey.danmakuBorder, defaultValue: true);
    double _opacity =
        setting.get(SettingBoxKey.danmakuOpacity, defaultValue: 1.0);
    int _duration = 8;
    double _fontSize = setting.get(SettingBoxKey.danmakuFontSize,
        defaultValue: (Platform.isIOS || Platform.isAndroid) ? 16.0 : 25.0);
    double danmakuArea =
        setting.get(SettingBoxKey.danmakuArea, defaultValue: 1.0);

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
                    child: FocusTraversalGroup(
                      child: FocusScope(
                        node: FocusScopeNode(),
                        child: Listener(
                          onPointerSignal: (pointerSignal) {
                            if (pointerSignal is PointerScrollEvent) {
                              _handleMouseScroller();
                              final scrollDelta = pointerSignal.scrollDelta;
                              debugPrint('滚轮滑动距离: ${scrollDelta.dy}');
                              final double volume = videoController.volume -
                                  scrollDelta.dy / 6000;
                              final double result = volume.clamp(0.0, 1.0);
                              setVolume(result);
                              videoController.volume = result;
                            }
                          },
                          child: KeyboardListener(
                            autofocus: true,
                            focusNode: _focusNode,
                            onKeyEvent: (KeyEvent event) {
                              if (event is KeyDownEvent) {
                                // 当空格键被按下时
                                _handleTap();
                                if (event.logicalKey ==
                                    LogicalKeyboardKey.space) {
                                  debugPrint('空格键被按下');
                                  try {
                                    playerController.playOrPause();
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                }
                                // 右方向键被按下
                                if (event.logicalKey ==
                                    LogicalKeyboardKey.arrowRight) {
                                  debugPrint('右方向键被按下');
                                  try {
                                    if (playerTimer != null) {
                                      playerTimer!.cancel();
                                    }
                                    videoController.currentPosition = Duration(
                                        seconds: videoController
                                                .currentPosition.inSeconds +
                                            10);
                                    playerController
                                        .seek(videoController.currentPosition);
                                    playerTimer = getPlayerTimer();
                                  } catch (e) {
                                    debugPrint(e.toString());
                                  }
                                }
                                // 左方向键被按下
                                if (event.logicalKey ==
                                    LogicalKeyboardKey.arrowLeft) {
                                  if (videoController
                                          .currentPosition.inSeconds >
                                      10) {
                                    try {
                                      if (playerTimer != null) {
                                        playerTimer!.cancel();
                                      }
                                      videoController.currentPosition =
                                          Duration(
                                              seconds: videoController
                                                      .currentPosition
                                                      .inSeconds -
                                                  10);
                                      playerController.seek(
                                          videoController.currentPosition);
                                      playerTimer = getPlayerTimer();
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                  }
                                }
                                // Esc键被按下
                                if (event.logicalKey ==
                                    LogicalKeyboardKey.escape) {
                                  if (videoController.androidFullscreen) {
                                    try {
                                      danmakuController.onClear();
                                    } catch (_) {}
                                    playerController.exitFullScreen();
                                    videoController.androidFullscreen =
                                        !videoController.androidFullscreen;
                                  }
                                }
                              }
                            },
                            child: SizedBox(
                              height: videoController.androidFullscreen
                                  ? (MediaQuery.of(context).size.height)
                                  : (MediaQuery.of(context).size.width *
                                      9.0 /
                                      (16.0)),
                              width: MediaQuery.of(context).size.width,
                              child:
                                  Stack(alignment: Alignment.center, children: [
                                const Center(child: PlayerItem()),
                                videoController.isBuffering
                                    ? const Positioned.fill(
                                        child: Center(
                                          child: CircularProgressIndicator(),
                                        ),
                                      )
                                    : Container(),
                                GestureDetector(
                                  onTap: () async {
                                    _handleTap;
                                    try {
                                      videoController.volume =
                                          await FlutterVolumeController
                                                  .getVolume() ??
                                              videoController.volume;
                                    } catch (e) {
                                      debugPrint(e.toString());
                                    }
                                  },
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
                                    child: Platform.isWindows ||
                                            Platform.isLinux ||
                                            Platform.isMacOS
                                        ? Container()
                                        : GestureDetector(
                                            onHorizontalDragUpdate:
                                                (DragUpdateDetails details) {
                                            videoController.showPosition = true;
                                            if (playerTimer != null) {
                                              // debugPrint('检测到拖动, 定时器取消');
                                              playerTimer!.cancel();
                                            }
                                            playerController.pause();
                                            final double scale = 180000 /
                                                MediaQuery.sizeOf(context)
                                                    .width;
                                            videoController.currentPosition =
                                                Duration(
                                                    milliseconds: videoController
                                                            .currentPosition
                                                            .inMilliseconds +
                                                        (details.delta.dx *
                                                                scale)
                                                            .round());
                                          }, onHorizontalDragEnd:
                                                (DragEndDetails details) {
                                            playerController.seek(
                                                videoController
                                                    .currentPosition);
                                            playerController.play();
                                            playerTimer = getPlayerTimer();
                                            videoController.showPosition =
                                                false;
                                          }, onVerticalDragUpdate:
                                                (DragUpdateDetails
                                                    details) async {
                                            final double totalWidth =
                                                MediaQuery.sizeOf(context)
                                                    .width;
                                            final double totalHeight =
                                                MediaQuery.sizeOf(context)
                                                    .height;
                                            final double tapPosition =
                                                details.localPosition.dx;
                                            final double sectionWidth =
                                                totalWidth / 2;
                                            final double delta =
                                                details.delta.dy;

                                            /// 非全屏时禁用
                                            if (!videoController
                                                .androidFullscreen) {
                                              return;
                                            }
                                            if (tapPosition < sectionWidth) {
                                              // 左边区域
                                              videoController.showBrightness =
                                                  true;
                                              try {
                                                videoController.brightness =
                                                    await ScreenBrightness()
                                                        .current;
                                              } catch (e) {
                                                debugPrint(e.toString());
                                              }
                                              final double level =
                                                  (totalHeight) * 3;
                                              final double brightness =
                                                  videoController.brightness -
                                                      delta / level;
                                              final double result =
                                                  brightness.clamp(0.0, 1.0);
                                              setBrightness(result);
                                            } else {
                                              // 右边区域
                                              videoController.showVolume = true;
                                              final double level =
                                                  (totalHeight) * 3;
                                              final double volume =
                                                  videoController.volume -
                                                      delta / level;
                                              final double result =
                                                  volume.clamp(0.0, 1.0);
                                              setVolume(result);
                                              videoController.volume = result;
                                            }
                                          }, onVerticalDragEnd:
                                                (DragEndDetails details) {
                                            videoController.showBrightness =
                                                false;
                                            videoController.showVolume = false;
                                          })),
                                // 顶部进度条
                                Positioned(
                                    top: 25,
                                    width: 200,
                                    child: videoController.showPosition
                                        ? Wrap(
                                            alignment: WrapAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                padding:
                                                    const EdgeInsets.all(8.0),
                                                decoration: BoxDecoration(
                                                  color: Colors.black
                                                      .withOpacity(0.5),
                                                  borderRadius:
                                                      BorderRadius.circular(
                                                          8.0), // 圆角
                                                ),
                                                child: Text(
                                                  videoController
                                                              .currentPosition
                                                              .compareTo(
                                                                  playerController
                                                                      .position) >
                                                          0
                                                      ? '快进 ${videoController.currentPosition.inSeconds - playerController.position.inSeconds} 秒'
                                                      : '快退 ${playerController.position.inSeconds - videoController.currentPosition.inSeconds} 秒',
                                                  style: const TextStyle(
                                                    color: Colors.white,
                                                  ),
                                                ),
                                              ),
                                            ],
                                          )
                                        : Container()),
                                // 亮度条
                                Positioned(
                                    top: 25,
                                    child: videoController.showBrightness
                                        ? Wrap(
                                            alignment: WrapAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0), // 圆角
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      const Icon(
                                                          Icons.brightness_7,
                                                          color: Colors.white),
                                                      Text(
                                                        ' ${(videoController.brightness * 100).toInt()} %',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          )
                                        : Container()),
                                // 音量条
                                Positioned(
                                    top: 25,
                                    child: videoController.showVolume
                                        ? Wrap(
                                            alignment: WrapAlignment.center,
                                            children: <Widget>[
                                              Container(
                                                  padding:
                                                      const EdgeInsets.all(8.0),
                                                  decoration: BoxDecoration(
                                                    color: Colors.black
                                                        .withOpacity(0.5),
                                                    borderRadius:
                                                        BorderRadius.circular(
                                                            8.0), // 圆角
                                                  ),
                                                  child: Row(
                                                    children: <Widget>[
                                                      const Icon(
                                                          Icons.volume_down,
                                                          color: Colors.white),
                                                      Text(
                                                        ' ${(videoController.volume * 100).toInt()}%',
                                                        style: const TextStyle(
                                                          color: Colors.white,
                                                        ),
                                                      ),
                                                    ],
                                                  )),
                                            ],
                                          )
                                        : Container()),
                                Positioned(
                                  top: 0,
                                  left: 0,
                                  right: 0,
                                  height: videoController.androidFullscreen
                                      ? MediaQuery.sizeOf(context).height *
                                          danmakuArea
                                      : (MediaQuery.sizeOf(context).width *
                                          9 /
                                          16 *
                                          danmakuArea),
                                  child: DanmakuScreen(
                                    key: _danmuKey,
                                    createdController: (DanmakuController e) {
                                      danmakuController = e;
                                      playerController.danmakuController = e;
                                      debugPrint('弹幕控制器创建成功');
                                    },
                                    option: DanmakuOption(
                                        fontSize: _fontSize,
                                        duration: _duration,
                                        opacity: _opacity,
                                        showStroke: _showStroke),
                                  ),
                                ),

                                // 自定义顶部组件
                                (videoController.showPositioned ||
                                        !playerController
                                            .mediaPlayer.state.playing)
                                    ? Positioned(
                                        top: 0,
                                        left: 0,
                                        right: 0,
                                        child: Row(
                                          children: [
                                            IconButton(
                                              color: Colors.white,
                                              icon:
                                                  const Icon(Icons.arrow_back),
                                              onPressed: () {
                                                if (videoController
                                                        .androidFullscreen ==
                                                    true) {
                                                  playerController
                                                      .exitFullScreen();
                                                  videoController
                                                          .androidFullscreen =
                                                      false;
                                                  return;
                                                }
                                                navigationBarState
                                                    .showNavigate();
                                                videoController.from ==
                                                        '/tab/popular/'
                                                    ? navigationBarState
                                                        .updateSelectedIndex(0)
                                                    : (videoController.from ==
                                                            '/tab/follow/'
                                                        ? navigationBarState
                                                            .updateSelectedIndex(
                                                                2)
                                                        : navigationBarState
                                                            .updateSelectedIndex(
                                                                1));
                                                Modular.to.navigate(
                                                    videoController.from);
                                              },
                                            ),
                                            const Expanded(
                                              child: dtb.DragToMoveArea(
                                                  child: SizedBox(height: 40)),
                                            ),
                                            TextButton(
                                              style: ButtonStyle(
                                                padding:
                                                    MaterialStateProperty.all(
                                                        EdgeInsets.zero),
                                              ),
                                              onPressed: () =>
                                                  showSetSpeedSheet(),
                                              child: Text(
                                                '${videoController.playerSpeed}X',
                                                style: const TextStyle(
                                                  color: Colors.white,
                                                  fontSize: 12,
                                                ),
                                              ),
                                            ),
                                            IconButton(
                                              icon: (videoController.follow)
                                                  ? Icon(Icons.favorite,
                                                      color: Colors.white)
                                                  : Icon(Icons.favorite_border,
                                                      color: Colors.white),
                                              onPressed: () {
                                                popularController.updateFollow(
                                                    videoController.link,
                                                    !(videoController.follow));
                                                videoController.follow =
                                                    !videoController.follow;
                                                SmartDialog.showToast(
                                                    videoController.follow
                                                        ? '自己追的番要好好看完哦'
                                                        : '取消追番成功',
                                                    displayType:
                                                        SmartToastType.last);
                                              },
                                              splashColor: Theme.of(context)
                                                  .colorScheme
                                                  .tertiary
                                                  .withOpacity(0.5),
                                            ),
                                          ],
                                        ),
                                      )
                                    : Container(),

                                // 自定义播放器底部组件
                                (videoController.showPositioned ||
                                        !playerController
                                            .mediaPlayer.state.playing)
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
                                                  playerController.pause();
                                                } else {
                                                  playerController.play();
                                                }
                                              },
                                            ),
                                            (videoController
                                                        .androidFullscreen ==
                                                    true)
                                                ? IconButton(
                                                    color: Colors.white,
                                                    icon: const Icon(
                                                        Icons.skip_next),
                                                    onPressed: () {
                                                      if (videoController
                                                              .episode ==
                                                          videoController
                                                              .token.length) {
                                                        SmartDialog.showToast(
                                                            '已经是最新一集',
                                                            displayType:
                                                                SmartToastType
                                                                    .last);
                                                        return;
                                                      }
                                                      SmartDialog.showToast(
                                                          '第 ${videoController.episode + 1} 话');
                                                      videoController
                                                          .changeEpisode(
                                                              videoController
                                                                      .episode +
                                                                  1);
                                                    },
                                                  )
                                                : Container(),
                                            Expanded(
                                              child: ProgressBar(
                                                timeLabelLocation:
                                                    TimeLabelLocation.none,
                                                progress: videoController
                                                    .currentPosition,
                                                buffered:
                                                    videoController.buffer,
                                                total: videoController.duration,
                                                onSeek: (duration) {
                                                  playerController
                                                      .seek(duration);
                                                },
                                              ),
                                            ),
                                            ((Platform.isAndroid ||
                                                        Platform.isIOS) &&
                                                    !videoController
                                                        .androidFullscreen)
                                                ? Container()
                                                : Container(
                                                    padding:
                                                        const EdgeInsets.only(
                                                            left: 10.0),
                                                    child: Text(
                                                      Utils.durationToString(
                                                              videoController
                                                                  .currentPosition) +
                                                          " / " +
                                                          Utils.durationToString(
                                                              playerController
                                                                  .duration),
                                                      style: TextStyle(
                                                        color: Colors.white,
                                                        fontSize: Platform
                                                                    .isWindows ||
                                                                Platform
                                                                    .isLinux ||
                                                                Platform.isMacOS
                                                            ? 16.0
                                                            : 12.0,
                                                      ),
                                                    ),
                                                  ),
                                            // (videoController.androidFullscreen ==
                                            //             true &&
                                            //         videoController.danmakuOn ==
                                            //             true)
                                            //     ? IconButton(
                                            //         color: Colors.white,
                                            //         icon:
                                            //             const Icon(Icons.notes),
                                            //         onPressed: () {
                                            //           if (videoController
                                            //                   .danDanmakus
                                            //                   .length ==
                                            //               0) {
                                            //             SmartDialog.showToast(
                                            //                 '当前剧集不支持弹幕发送的说',
                                            //                 displayType:
                                            //                     SmartToastType
                                            //                         .last);
                                            //             return;
                                            //           }
                                            //           showShootDanmakuSheet();
                                            //         },
                                            //       )
                                            //     : Container(),
                                            (videoController.androidFullscreen ==
                                                        true)
                                                ? IconButton(
                                                    color: Colors.white,
                                                    icon:
                                                        const Icon(Icons.filter_none),
                                                    onPressed: () {
                                                      showChangeChapter();
                                                    },
                                                  )
                                                : Container(),
                                            IconButton(
                                              color: Colors.white,
                                              icon: Icon(videoController
                                                      .danmakuOn
                                                  ? Icons.comment
                                                  : Icons.comments_disabled),
                                              onPressed: () {
                                                if (videoController
                                                        .danDanmakus.length ==
                                                    0) {
                                                  SmartDialog.showToast(
                                                      '当前剧集没有找到弹幕的说',
                                                      displayType:
                                                          SmartToastType.last);
                                                  return;
                                                }
                                                danmakuController.clear();
                                                videoController.danmakuOn =
                                                    !videoController.danmakuOn;
                                                debugPrint(
                                                    '弹幕开关变更为 ${videoController.danmakuOn}');
                                              },
                                            ),
                                            IconButton(
                                              color: Colors.white,
                                              icon: Icon(videoController
                                                      .androidFullscreen
                                                  ? Icons.fullscreen_exit
                                                  : Icons.fullscreen),
                                              onPressed: () {
                                                if (videoController
                                                    .androidFullscreen) {
                                                  try {
                                                    danmakuController.onClear();
                                                  } catch (_) {}
                                                  playerController
                                                      .exitFullScreen();
                                                } else {
                                                  playerController
                                                      .enterFullScreen();
                                                }
                                                videoController
                                                        .androidFullscreen =
                                                    !videoController
                                                        .androidFullscreen;
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
                      ),
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

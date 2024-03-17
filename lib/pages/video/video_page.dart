import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:oneanime/pages/player/player_controller.dart';
import 'package:oneanime/pages/player/player_item.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:provider/provider.dart';
import 'package:oneanime/bean/anime/anime_panel.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:oneanime/pages/menu/side_menu.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  dynamic navigationBarState;
  final VideoController videoController = Modular.get<VideoController>();
  final PlayerController playerController = Modular.get<PlayerController>();

  @override
  void initState() {
    super.initState();
    // videoController.episode = 1;
    playerController.videoUrl = videoController.videoUrl;
    playerController.videoCookie = videoController.videoCookie;
    playerController.init();
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  void onBackPressed(BuildContext context) {
    if (MediaQuery.of(context).orientation == Orientation.landscape) {
      debugPrint('当前播放器全屏');
      try {
        playerController.exitFullScreen();
        Modular.to.pop(context);
        return;
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    debugPrint('当前播放器非全屏');
    navigationBarState.showNavigate();
    videoController.from == '/tab/popular/' ? navigationBarState.updateSelectedIndex(0) : (videoController.from == '/tab/follow/' ? navigationBarState.updateSelectedIndex(2) : navigationBarState.updateSelectedIndex(1));
    Modular.to.navigate(videoController.from);
  }

  @override
  Widget build(BuildContext context) {
    navigationBarState = Platform.isWindows
              ? Provider.of<SideNavigationBarState>(context, listen: false)
              : Provider.of<NavigationBarState>(context, listen: false);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: Platform.isWindows
          ? Scaffold(
              body: Observer(builder: (context) {
                return Stack(children: [
                  Container(
                    child: Column(
                      children: [
                        const PlayerItem(),
                        BangumiPanel(
                          sheetHeight: MediaQuery.sizeOf(context).height -
                              MediaQuery.of(context).padding.top -
                              MediaQuery.sizeOf(context).width * 9 / 16,
                        )
                      ],
                    ),
                  ),
                  Positioned(
                    top: 0,
                    left: 0,
                    right: 0,
                    child: Column(
                      children: [
                        AppBar(
                          iconTheme: IconThemeData(color: Colors.white), 
                          backgroundColor: Colors.transparent, // 设置为透明
                          elevation: 0, // 去除阴影
                          // title: Text(videoController.title),
                          leading: IconButton(
                            icon: const Icon(Icons.arrow_back),
                            onPressed: () {
                              navigationBarState.showNavigate();
                              videoController.from == '/tab/popular/' ? navigationBarState.updateSelectedIndex(0) : (videoController.from == '/tab/follow/' ? navigationBarState.updateSelectedIndex(2) : navigationBarState.updateSelectedIndex(1));
                              Modular.to.navigate(videoController.from);
                            },
                          ),
                        ),
                      ],
                    ),
                  )
                ]);
              }),
            )
          : Scaffold(
              appBar: AppBar(
                title: Text(videoController.title),
                leading: IconButton(
                  icon: const Icon(Icons.arrow_back),
                  onPressed: () {
                    navigationBarState.showNavigate();
                    videoController.from == '/tab/popular/' ? navigationBarState.updateSelectedIndex(0) : (videoController.from == '/tab/follow/' ? navigationBarState.updateSelectedIndex(2) : navigationBarState.updateSelectedIndex(1));
                    Modular.to.navigate(videoController.from);
                  },
                ),
              ),
              body: Observer(builder: (context) {
                return Column(
                  children: [
                    const PlayerItem(),
                    BangumiPanel(
                      sheetHeight: MediaQuery.sizeOf(context).height -
                          MediaQuery.of(context).padding.top -
                          MediaQuery.sizeOf(context).width * 9 / 16,
                    )
                  ],
                );
              }),
            ),
    );
  }
}

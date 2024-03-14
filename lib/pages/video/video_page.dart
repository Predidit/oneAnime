import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:oneanime/pages/player/player_controller.dart';
import 'package:oneanime/pages/player/player_item.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:provider/provider.dart';
import 'package:oneanime/bean/anime/anime_panel.dart';
import 'package:flutter_mobx/flutter_mobx.dart';

class VideoPage extends StatefulWidget {
  const VideoPage({super.key});

  @override
  State<VideoPage> createState() => _VideoPageState();
}

class _VideoPageState extends State<VideoPage> {
  final VideoController videoController = Modular.get<VideoController>();
  final PlayerController playerController = Modular.get<PlayerController>();

  @override
  void initState() {
    super.initState();
    playerController.videoUrl = videoController.videoUrl;
    playerController.videoCookie = videoController.videoCookie;
    playerController.init();
  }

  @override
  void dispose() {
    playerController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final navigationBarState = Provider.of<NavigationBarState>(context);
    return Scaffold(
      appBar: AppBar(
        title: Text(videoController.title),
        leading: IconButton(
          icon: const Icon(Icons.arrow_back),
          onPressed: () {
            navigationBarState.showNavigate();
            navigationBarState.updateSelectedIndex(0);
            Modular.to.navigate('/tab/popular/');
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
    );
  }
}

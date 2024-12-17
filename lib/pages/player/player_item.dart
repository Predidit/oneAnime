import 'package:oneanime/pages/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/video/video_controller.dart' as videoPage;

class PlayerItem extends StatefulWidget {
  const PlayerItem({super.key});

  @override
  State<PlayerItem> createState() => _PlayerItemState();
}

class _PlayerItemState extends State<PlayerItem> {
  final PlayerController playerController = Modular.get<PlayerController>();
  final videoPage.VideoController videoPageController =
      Modular.get<videoPage.VideoController>();

  @override
  void initState() {
    super.initState();
    // playerController.init;
  }

  @override
  void dispose() {
    //player.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Observer(builder: (context) {
      return playerController.dataStatus == 'loaded'
          ? Video(
              controller: playerController.videoController,
              controls: NoVideoControls,
              subtitleViewConfiguration: SubtitleViewConfiguration(
                style: TextStyle(
                  color: Colors.pink,
                  fontSize: 48.0,
                  background: Paint()..color = Colors.transparent,
                  decoration: TextDecoration.none,
                  fontWeight: FontWeight.bold,
                  shadows: const [
                    Shadow(
                      offset: Offset(1.0, 1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(255, 255, 255, 255),
                    ),
                    Shadow(
                      offset: Offset(-1.0, -1.0),
                      blurRadius: 3.0,
                      color: Color.fromARGB(125, 255, 255, 255),
                    ),
                  ],
                ),
                textAlign: TextAlign.center,
                padding: const EdgeInsets.all(24.0),
              ),
            )
          : const Center(child: CircularProgressIndicator());
    });
  }
}

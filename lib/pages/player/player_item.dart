import 'package:oneanime/pages/player/player_controller.dart';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:video_player/video_player.dart';
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
    return Column(
      children: [
        Observer(builder: (context) {
          return Expanded(
            child: playerController.dataStatus == 'loaded'
                ? AspectRatio(
                    aspectRatio: playerController.mediaPlayer.value.aspectRatio,
                    child: VideoPlayer(
                      playerController.mediaPlayer,
                    ),
                  )
                : const Center(child: CircularProgressIndicator()),
          );
        }),
      ],
    );
  }
}

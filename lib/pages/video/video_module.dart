import 'package:oneanime/pages/video/video_page.dart';
import 'package:oneanime/pages/player/player_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';

class VideoModule extends Module {
  @override
  void binds(i) {
    i.addSingleton(PlayerController.new);
  }

  @override
  void routes(r) {
    r.child("/", child: (_) => const VideoPage());
  }
}

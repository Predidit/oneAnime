import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/init_page.dart';
import 'package:oneanime/pages/router.dart';
import 'package:oneanime/pages/index_page.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:oneanime/pages/timeline/timeline_controller.dart';
import 'package:oneanime/pages/my/my_controller.dart';
import 'package:oneanime/pages/follow/follow_controller.dart';
import 'package:oneanime/pages/video/video_module.dart';


class IndexModule extends Module {
  @override
  List<Module> get imports => menu.moduleList;

  @override
  void binds(i) {
    i.addSingleton(PopularController.new);
    i.addSingleton(VideoController.new);
    i.addSingleton(TimelineController.new);
    i.addSingleton(MyController.new);
    // i.addSingleton(FollowController.new);
  }

  @override
  void routes(r) {
    r.child("/",
        child: (_) => const InitPage(),
        children: [
          ChildRoute(
            "/error",
            child: (_) => Scaffold(
              appBar: AppBar (title: const Text("oneAnime")),
              body: const Center(child: Text("初始化失败")),
            ),
          ),
        ],
        transition: TransitionType.noTransition);
    r.child("/tab", child: (_) {
      return const IndexPage();
    }, children: menu.routes, transition: TransitionType.noTransition);
    // r.module("/video", module: VideoModule());
  }
}

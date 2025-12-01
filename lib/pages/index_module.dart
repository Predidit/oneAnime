import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/init_page.dart';
import 'package:oneanime/pages/router.dart';
import 'package:oneanime/pages/index_page.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:oneanime/pages/timeline/timeline_controller.dart';
import 'package:oneanime/pages/my/my_controller.dart';
import 'package:oneanime/pages/history/history_controller.dart';
import 'package:oneanime/pages/video/video_module.dart';
import 'package:oneanime/pages/history/history_module.dart';
import 'package:oneanime/pages/settings/setting_module.dart';
import 'package:oneanime/pages/error/error.dart';

class IndexModule extends Module {
  @override
  List<Module> get imports => menu.moduleList;

  @override
  void binds(i) {
    i.addSingleton(PopularController.new);
    i.addSingleton(VideoController.new);
    i.addSingleton(TimelineController.new);
    i.addSingleton(MyController.new);
    i.addSingleton(HistoryController.new);
  }

  @override
  void routes(r) {
    r.child(
      "/",
      child: (_) => const InitPage(),
      transition: TransitionType.noTransition,
      children: [
        ChildRoute("/error", child: (_) => const ErrorPage('未知错误')),
      ],
    );
    r.child("/tab", child: (_) {
      return const IndexPage();
    },
        transition: TransitionType.fadeIn,
        duration: const Duration(milliseconds: 70),
        children: menu.routes);
    r.module("/video", module: VideoModule());
    r.module("/history", module: HistoryModule());
    r.module("/settings", module: SettingsModule());
  }
}

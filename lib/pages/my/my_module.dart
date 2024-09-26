import 'package:oneanime/pages/my/my_page.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/about/about_modular.dart';
import 'package:oneanime/pages/settings/player_settings_page.dart';
import 'package:oneanime/pages/settings/danmaku_settings.dart';
import 'package:oneanime/pages/settings/theme_settings_page.dart';
import 'package:oneanime/pages/settings/other_settings_page.dart';
import 'package:oneanime/pages/settings/displaymode_settings.dart';

class MyModule extends Module {
  @override
  void routes(r) {
    r.child("/", child: (_) => const MyPage());
    r.child("/player",
        child: (_) => const PlayerSettingsPage(),
        transition: TransitionType.noTransition);
    r.child("/danmaku",
        child: (_) => const DanmakuSettingsPage(),
        transition: TransitionType.noTransition);
    r.child("/theme",
        child: (_) => const ThemeSettingsPage(),
        transition: TransitionType.noTransition);
    r.child("/theme/display",
        child: (_) => const SetDiaplayMode(),
        transition: TransitionType.noTransition);
    r.child("/other",
        child: (_) => const OtherSettingsPage(),
        transition: TransitionType.noTransition);
    r.module("/about", module: AboutModule(), transition: TransitionType.noTransition);
  }
}

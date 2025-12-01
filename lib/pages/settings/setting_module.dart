import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/about/about_modular.dart';
import 'package:oneanime/pages/settings/player_settings_page.dart';
import 'package:oneanime/pages/settings/danmaku_settings.dart';
import 'package:oneanime/pages/settings/theme_settings_page.dart';
import 'package:oneanime/pages/settings/other_settings_page.dart';
import 'package:oneanime/pages/settings/displaymode_settings.dart';

class SettingsModule extends Module {
  @override
  void routes(r) {
    r.child(
      "/player",
      child: (_) => const PlayerSettingsPage(),
    );
    r.child(
      "/danmaku",
      child: (_) => const DanmakuSettingsPage(),
    );
    r.child(
      "/theme",
      child: (_) => const ThemeSettingsPage(),
    );
    r.child(
      "/theme/display",
      child: (_) => const SetDiaplayMode(),
    );
    r.child(
      "/other",
      child: (_) => const OtherSettingsPage(),
    );
    r.module("/about", module: AboutModule());
  }
}

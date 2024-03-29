import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/utils/storage.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  Box setting = GStorage.setting;

  @override
  Widget build(BuildContext context) {
    dynamic color;
    dynamic defaultThemeColor = setting.get(SettingBoxKey.themeColor, defaultValue: 'default');
    if (defaultThemeColor == 'default') {
      color = null;
    } else {
      color = Color(int.parse(defaultThemeColor, radix: 16));
    }
    var app = AdaptiveTheme(
      light: ThemeData(useMaterial3: true, brightness: Brightness.light, colorSchemeSeed: color),
      dark: ThemeData(useMaterial3: true, brightness: Brightness.dark, colorSchemeSeed: color),
      initial: AdaptiveThemeMode.system,
      builder: (theme, darkTheme) => MaterialApp.router(
        title: "oneAnime",
        localizationsDelegates: GlobalMaterialLocalizations.delegates,
        supportedLocales: const [Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: "CN")],
        locale: const Locale.fromSubtags(languageCode: 'zh', scriptCode: 'Hans', countryCode: "CN"),
        theme: theme,
        darkTheme: darkTheme,
        routerConfig: Modular.routerConfig,
        builder: FlutterSmartDialog.init(),
        // navigatorObservers: [Asuka.asukaHeroController],
      ),
    );
    Modular.setObservers([FlutterSmartDialog.observer]);
    return app;
  }
}

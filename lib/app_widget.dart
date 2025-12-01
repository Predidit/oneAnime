import 'dart:io';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:flutter_displaymode/flutter_displaymode.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/utils/utils.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:oneanime/i18n/strings.g.dart';
import 'package:oneanime/utils/constans.dart';
import 'package:oneanime/bean/settings/theme_provider.dart';
import 'package:provider/provider.dart';

class AppWidget extends StatefulWidget {
  const AppWidget({super.key});

  @override
  State<AppWidget> createState() => _AppWidgetState();
}

class _AppWidgetState extends State<AppWidget> {
  Box setting = GStorage.setting;

  @override
  Widget build(BuildContext context) {
    final ThemeProvider themeProvider = Provider.of<ThemeProvider>(context);
    dynamic color;
    dynamic defaultThemeColor =
        setting.get(SettingBoxKey.themeColor, defaultValue: 'default');
    if (defaultThemeColor == 'default') {
      color = null;
    } else {
      color = Color(int.parse(defaultThemeColor, radix: 16));
    }
    bool oledEnhance =
        setting.get(SettingBoxKey.oledEnhance, defaultValue: false);
    bool useSystemFont =
        setting.get(SettingBoxKey.useSystemFont, defaultValue: false);
    final defaultThemeMode =
        setting.get(SettingBoxKey.themeMode, defaultValue: 'system');
    if (defaultThemeMode == 'dark') {
      themeProvider.setThemeMode(ThemeMode.dark, notify: false);
    }
    if (defaultThemeMode == 'light') {
      themeProvider.setThemeMode(ThemeMode.light, notify: false);
    }
    if (defaultThemeMode == 'system') {
      themeProvider.setThemeMode(ThemeMode.system, notify: false);
    }
    themeProvider.setFontFamily(useSystemFont, notify: false);
    var defaultDarkTheme = ThemeData(
        useMaterial3: true,
        fontFamily: themeProvider.currentFontFamily,
        brightness: Brightness.dark,
        colorSchemeSeed: color,
        pageTransitionsTheme: pageTransitionsTheme2024);
    var oledDarkTheme = Utils.oledDarkTheme(defaultDarkTheme);
    themeProvider.setTheme(
      ThemeData(
          useMaterial3: true,
          fontFamily: themeProvider.currentFontFamily,
          brightness: Brightness.light,
          colorSchemeSeed: color,
          pageTransitionsTheme: pageTransitionsTheme2024),
      oledEnhance ? oledDarkTheme : defaultDarkTheme,
      notify: false,
    );
    var app = MaterialApp.router(
      title: "oneAnime",
      locale: TranslationProvider.of(context).flutterLocale,
      supportedLocales: AppLocaleUtils.supportedLocales,
      localizationsDelegates: GlobalMaterialLocalizations.delegates,
      theme: themeProvider.light,
      darkTheme: themeProvider.dark,
      themeMode: themeProvider.themeMode,
      routerConfig: Modular.routerConfig,
      builder: FlutterSmartDialog.init(),
    );
    Modular.setObservers([FlutterSmartDialog.observer]);

    // 强制设置高帧率
    if (Platform.isAndroid) {
      try {
        late List modes;
        FlutterDisplayMode.supported.then((value) {
          modes = value;
          var storageDisplay = setting.get(SettingBoxKey.displayMode);
          DisplayMode f = DisplayMode.auto;
          if (storageDisplay != null) {
            f = modes.firstWhere((e) => e.toString() == storageDisplay);
          }
          DisplayMode preferred = modes.toList().firstWhere((el) => el == f);
          FlutterDisplayMode.setPreferredMode(preferred);
        });
      } catch (e) {
        debugPrint('高帧率设置失败 ${e.toString()}');
      }
    }

    return app;
  }
}

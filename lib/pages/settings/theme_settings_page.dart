import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:adaptive_theme/adaptive_theme.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';
import 'package:oneanime/bean/settings/color_type.dart';
import 'package:oneanime/bean/settings/settings.dart';
import 'package:oneanime/utils/utils.dart';
import 'package:oneanime/i18n/strings.g.dart';

class ThemeSettingsPage extends StatefulWidget {
  const ThemeSettingsPage({super.key});

  @override
  State<ThemeSettingsPage> createState() => _ThemeSettingsPageState();
}

class _ThemeSettingsPageState extends State<ThemeSettingsPage> {
  dynamic navigationBarState;
  Box setting = GStorage.setting;
  late Translations i18n;
  late dynamic defaultDanmakuArea;
  late dynamic defaultThemeMode;
  late dynamic defaultThemeColor;
  late bool oledEnhance;
  final PopularController popularController = Modular.get<PopularController>();

  @override
  void initState() {
    super.initState();
    i18n = Translations.of(context);
    defaultThemeMode =
        setting.get(SettingBoxKey.themeMode, defaultValue: 'system');
    defaultThemeColor =
        setting.get(SettingBoxKey.themeColor, defaultValue: 'default');
    oledEnhance = setting.get(SettingBoxKey.oledEnhance, defaultValue: false);
  }

  void onBackPressed(BuildContext context) {
    Modular.to.navigate('/tab/my/');
  }

  void setTheme(Color? color) {
    var defaultDarkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
      colorSchemeSeed: color,
    );
    var oledDarkTheme = Utils.oledDarkTheme(defaultDarkTheme);
    AdaptiveTheme.of(context).setTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
        colorSchemeSeed: color,
      ),
      dark: oledEnhance ? oledDarkTheme : defaultDarkTheme,
    );
    defaultThemeColor = color?.value.toRadixString(16) ?? 'default';
    setting.put(SettingBoxKey.themeColor, defaultThemeColor);
  }

  void resetTheme() {
    var defaultDarkTheme = ThemeData(
      useMaterial3: true,
      brightness: Brightness.dark,
    );
    var oledDarkTheme = Utils.oledDarkTheme(defaultDarkTheme);
    AdaptiveTheme.of(context).setTheme(
      light: ThemeData(
        useMaterial3: true,
        brightness: Brightness.light,
      ),
      dark: oledEnhance ? oledDarkTheme : defaultDarkTheme,
    );
    defaultThemeColor = 'default';
    setting.put(SettingBoxKey.themeColor, 'default');
  }

  void updateTheme(String theme) async {
    if (theme == 'dark') {
      AdaptiveTheme.of(context).setDark();
    }
    if (theme == 'light') {
      AdaptiveTheme.of(context).setLight();
    }
    if (theme == 'system') {
      AdaptiveTheme.of(context).setSystem();
    }
    await setting.put(SettingBoxKey.themeMode, theme);
    setState(() {
      defaultThemeMode = theme;
    });
  }

  void updateOledEnhance() {
    dynamic color;
    oledEnhance = setting.get(SettingBoxKey.oledEnhance, defaultValue: false);
    if (defaultThemeColor == 'default') {
      color = null;
    } else {
      color = Color(int.parse(defaultThemeColor, radix: 16));
    }
    setTheme(color);
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: Scaffold(
        appBar: SysAppBar(title: Text(i18n.my.themeSettings.title)),
        body: Column(
          children: [
            ListTile(
              onTap: () async {
                final List<Map<String, dynamic>> colorThemes = colorThemeTypes;
                SmartDialog.show(
                    useAnimation: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(i18n.my.themeSettings.colorPalette),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Wrap(
                            alignment: WrapAlignment.center,
                            spacing: 22,
                            runSpacing: 18,
                            children: [
                              ...colorThemes.map(
                                (e) {
                                  final index = colorThemes.indexOf(e);
                                  return GestureDetector(
                                    onTap: () {
                                      index == 0
                                          ? resetTheme()
                                          : setTheme(e['color']);
                                      SmartDialog.dismiss();
                                    },
                                    child: Column(
                                      children: [
                                        Container(
                                          width: 46,
                                          height: 46,
                                          decoration: BoxDecoration(
                                            color: e['color'].withOpacity(0.8),
                                            borderRadius:
                                                BorderRadius.circular(50),
                                            border: Border.all(
                                              width: 2,
                                              color:
                                                  e['color'].withOpacity(0.8),
                                            ),
                                          ),
                                          child: const AnimatedOpacity(
                                            opacity: 0,
                                            duration:
                                                Duration(milliseconds: 200),
                                            child: Icon(
                                              Icons.done,
                                              color: Colors.black,
                                              size: 20,
                                            ),
                                          ),
                                        ),
                                        const SizedBox(height: 3),
                                        Text(
                                          e['label'],
                                          style: TextStyle(
                                            fontSize: 12,
                                            color: Theme.of(context)
                                                .colorScheme
                                                .outline,
                                          ),
                                        ),
                                      ],
                                    ),
                                  );
                                },
                              )
                            ],
                          );
                        }),
                      );
                    });
              },
              dense: false,
              title: Text(i18n.my.themeSettings.colorPalette),
            ),
            Platform.isAndroid
                ? ListTile(
                    onTap: () async {
                      Modular.to.pushNamed('/tab/my/theme/display');
                    },
                    dense: false,
                    title: Text(i18n.my.themeSettings.refreshRate),
                    // trailing: const Icon(Icons.navigate_next),
                  )
                : Container(),
            ListTile(
              onTap: () {
                SmartDialog.show(
                    useAnimation: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(i18n.my.themeSettings.themeMode),
                        content: StatefulBuilder(
                          builder:
                              (BuildContext context, StateSetter setState) {
                            return Wrap(
                              spacing: 8,
                              runSpacing: 2,
                              children: [
                                defaultThemeMode == 'system'
                                    ? FilledButton(
                                        onPressed: () {
                                          updateTheme('system');
                                          SmartDialog.dismiss();
                                        },
                                        child: Text(i18n.my.themeSettings.themeModeSystem))
                                    : FilledButton.tonal(
                                        onPressed: () {
                                          updateTheme('system');
                                          SmartDialog.dismiss();
                                        },
                                        child: Text(i18n.my.themeSettings.themeModeSystem)),
                                defaultThemeMode == 'light'
                                    ? FilledButton(
                                        onPressed: () {
                                          updateTheme('light');
                                          SmartDialog.dismiss();
                                        },
                                        child: Text(i18n.my.themeSettings.themeModeLight))
                                    : FilledButton.tonal(
                                        onPressed: () {
                                          updateTheme('light');
                                          SmartDialog.dismiss();
                                        },
                                        child: Text(i18n.my.themeSettings.themeModeLight)),
                                defaultThemeMode == 'dark'
                                    ? FilledButton(
                                        onPressed: () {
                                          updateTheme('dark');
                                          SmartDialog.dismiss();
                                        },
                                        child: Text(i18n.my.themeSettings.themeModeDark))
                                    : FilledButton.tonal(
                                        onPressed: () {
                                          updateTheme('dark');
                                          SmartDialog.dismiss();
                                        },
                                        child: Text(i18n.my.themeSettings.themeModeDark)),
                              ],
                            );
                          },
                        ),
                      );
                    });
              },
              dense: false,
              title: Text(i18n.my.themeSettings.themeMode),
              subtitle: Text(
                  defaultThemeMode == 'light'
                      ? i18n.my.themeSettings.themeModeLight
                      : (defaultThemeMode == 'dark' ? i18n.my.themeSettings.themeModeDark : i18n.my.themeSettings.themeModeSystem),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            InkWell(
              child: SetSwitchItem(
                title: i18n.my.themeSettings.OLEDEnhance,
                subTitle: i18n.my.themeSettings.OLEDEnhanceSubtitle,
                setKey: SettingBoxKey.oledEnhance,
                callFn: (_) => {updateOledEnhance()},
                defaultVal: false,
              ),
            ),
            (Platform.isWindows || Platform.isLinux || Platform.isMacOS)
                ? InkWell(
                    child: SetSwitchItem(
                      title: i18n.my.themeSettings.alwaysOntop,
                      subTitle: i18n.my.themeSettings.alwaysOntopSubtitle,
                      setKey: SettingBoxKey.alwaysOntop,
                      defaultVal: true,
                    ),
                  )
                : Container(),
          ],
        ),
      ),
    );
  }
}

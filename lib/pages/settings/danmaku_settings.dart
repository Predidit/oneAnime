import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/bean/settings/settings.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';
import 'package:oneanime/i18n/strings.g.dart';

class DanmakuSettingsPage extends StatefulWidget {
  const DanmakuSettingsPage({super.key});

  @override
  State<DanmakuSettingsPage> createState() => _DanmakuSettingsPageState();
}

class _DanmakuSettingsPageState extends State<DanmakuSettingsPage> {
  dynamic navigationBarState;
  Box setting = GStorage.setting;
  late Translations i18n;
  late dynamic defaultDanmakuArea;
  late dynamic defaultDanmakuOpacity;
  late dynamic defaultDanmakuDuration;
  late dynamic defaultDanmakuFontSize;
  final PopularController popularController = Modular.get<PopularController>();

  @override
  void initState() {
    super.initState();
    defaultDanmakuArea =
        setting.get(SettingBoxKey.danmakuArea, defaultValue: 1.0);
    defaultDanmakuOpacity =
        setting.get(SettingBoxKey.danmakuOpacity, defaultValue: 1.0);
    defaultDanmakuDuration =
        setting.get(SettingBoxKey.danmakuDuration, defaultValue: 8);
    defaultDanmakuFontSize = setting.get(SettingBoxKey.danmakuFontSize,
        defaultValue: (Platform.isIOS || Platform.isAndroid) ? 16.0 : 25.0);
  }

  void onBackPressed(BuildContext context) {
    Modular.to.navigate('/tab/my/');
  }

  void updateDanmakuArea(double i) async {
    await setting.put(SettingBoxKey.danmakuArea, i);
    setState(() {
      defaultDanmakuArea = i;
    });
  }

  void updateDanmakuOpacity(double i) async {
    await setting.put(SettingBoxKey.danmakuOpacity, i);
    setState(() {
      defaultDanmakuOpacity = i;
    });
  }

  void updateDanmakuDuration(int i) async {
    await setting.put(SettingBoxKey.danmakuDuration, i);
    setState(() {
      defaultDanmakuDuration = i;
    });
  }

  void updateDanmakuFontSize(double i) async {
    await setting.put(SettingBoxKey.danmakuFontSize, i);
    setState(() {
      defaultDanmakuFontSize = i;
    });
  }

  @override
  Widget build(BuildContext context) {
    i18n = Translations.of(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: Scaffold(
        appBar: SysAppBar(title: Text(i18n.my.danmakuSettings.title)),
        body: Column(
          children: [
           InkWell(
              child: SetSwitchItem(
                title: i18n.my.danmakuSettings.defaultEnable,
                subTitle: i18n.my.danmakuSettings.defaultEnableSubtitle,
                setKey: SettingBoxKey.danmakuEnabledByDefault,
                defaultVal: false,
              ),
            ),
            InkWell(
              child: SetSwitchItem(
                title: i18n.my.danmakuSettings.enhance,
                setKey: SettingBoxKey.danmakuEnhance,
                defaultVal: true,
              ),
            ),
            InkWell(
              child: SetSwitchItem(
                title: i18n.my.danmakuSettings.stroke,
                setKey: SettingBoxKey.danmakuBorder,
                defaultVal: true,
              ),
            ),
            ListTile(
              onTap: () async {
                final List<double> danFontList = [
                  10.0,
                  11.0,
                  12.0,
                  13.0,
                  14.0,
                  15.0,
                  16.0,
                  17.0,
                  18.0,
                  19.0,
                  20.0,
                  21.0,
                  22.0,
                  23.0,
                  24.0,
                  25.0,
                  26.0,
                  27.0,
                  28.0,
                  29.0,
                  30.0,
                  31.0,
                  32.0,
                ];
                SmartDialog.show(
                    useAnimation: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(i18n.my.danmakuSettings.fontSize),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Wrap(
                            spacing: 8,
                            runSpacing: 2,
                            children: [
                              for (final double i in danFontList) ...<Widget>[
                                if (i == defaultDanmakuFontSize) ...<Widget>[
                                  FilledButton(
                                    onPressed: () async {
                                      updateDanmakuFontSize(i);
                                      SmartDialog.dismiss();
                                    },
                                    child: Text(i.toString()),
                                  ),
                                ] else ...[
                                  FilledButton.tonal(
                                    onPressed: () async {
                                      updateDanmakuFontSize(i);
                                      SmartDialog.dismiss();
                                    },
                                    child: Text(i.toString()),
                                  ),
                                ]
                              ]
                            ],
                          );
                        }),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => SmartDialog.dismiss(),
                            child: Text(
                              i18n.dialog.dismiss,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              updateDanmakuFontSize(
                                  (Platform.isIOS || Platform.isAndroid)
                                      ? 16.0
                                      : 25.0);
                              SmartDialog.dismiss();
                            },
                            child: Text(i18n.dialog.setDefault),
                          ),
                        ],
                      );
                    });
              },
              dense: false,
              title: Text(i18n.my.danmakuSettings.fontSize),
              subtitle: Text('$defaultDanmakuFontSize',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            ListTile(
              onTap: () async {
                final List<double> danOpacityList = [
                  0.1,
                  0.2,
                  0.3,
                  0.4,
                  0.5,
                  0.6,
                  0.7,
                  0.8,
                  0.9,
                  1.0,
                ];
                SmartDialog.show(
                    useAnimation: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(i18n.my.danmakuSettings.transparency),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Wrap(
                            spacing: 8,
                            runSpacing: 2,
                            children: [
                              for (final double i
                                  in danOpacityList) ...<Widget>[
                                if (i == defaultDanmakuOpacity) ...<Widget>[
                                  FilledButton(
                                    onPressed: () async {
                                      updateDanmakuOpacity(i);
                                      SmartDialog.dismiss();
                                    },
                                    child: Text(i.toString()),
                                  ),
                                ] else ...[
                                  FilledButton.tonal(
                                    onPressed: () async {
                                      updateDanmakuOpacity(i);
                                      SmartDialog.dismiss();
                                    },
                                    child: Text(i.toString()),
                                  ),
                                ]
                              ]
                            ],
                          );
                        }),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => SmartDialog.dismiss(),
                            child: Text(
                              i18n.dialog.dismiss,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              updateDanmakuOpacity(1.0);
                              SmartDialog.dismiss();
                            },
                            child: Text(i18n.dialog.setDefault),
                          ),
                        ],
                      );
                    });
              },
              dense: false,
              title: Text(i18n.my.danmakuSettings.transparency),
              subtitle: Text('$defaultDanmakuOpacity',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            ListTile(
              onTap: () async {
                final List<int> danDurationList = [
                  5,
                  6,
                  7,
                  8,
                  9,
                  10,
                  11,
                  12,
                  13,
                  14,
                  15,
                  16,
                ];
                SmartDialog.show(
                    useAnimation: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(i18n.my.danmakuSettings.duration),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Wrap(
                            spacing: 8,
                            runSpacing: 2,
                            children: [
                              for (final int i in danDurationList) ...<Widget>[
                                if (i == defaultDanmakuOpacity) ...<Widget>[
                                  FilledButton(
                                    onPressed: () async {
                                      updateDanmakuDuration(i);
                                      SmartDialog.dismiss();
                                    },
                                    child: Text(i.toString()),
                                  ),
                                ] else ...[
                                  FilledButton.tonal(
                                    onPressed: () async {
                                      updateDanmakuDuration(i);
                                      SmartDialog.dismiss();
                                    },
                                    child: Text(i.toString()),
                                  ),
                                ]
                              ]
                            ],
                          );
                        }),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => SmartDialog.dismiss(),
                            child: Text(
                              i18n.dialog.dismiss,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              updateDanmakuDuration(8);
                              SmartDialog.dismiss();
                            },
                            child: Text(i18n.dialog.setDefault),
                          ),
                        ],
                      );
                    });
              },
              dense: false,
              title: Text(i18n.my.danmakuSettings.duration),
              subtitle: Text('$defaultDanmakuDuration',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            ListTile(
              onTap: () async {
                final List<double> danAreaList = [
                  0.25,
                  0.5,
                  1.0,
                ];
                SmartDialog.show(
                    useAnimation: false,
                    builder: (context) {
                      return AlertDialog(
                        title: Text(i18n.my.danmakuSettings.area),
                        content: StatefulBuilder(builder:
                            (BuildContext context, StateSetter setState) {
                          return Wrap(
                            spacing: 8,
                            runSpacing: 2,
                            children: [
                              for (final double i in danAreaList) ...<Widget>[
                                if (i == defaultDanmakuArea) ...<Widget>[
                                  FilledButton(
                                    onPressed: () async {
                                      updateDanmakuArea(i);
                                      SmartDialog.dismiss();
                                    },
                                    child: Text(i.toString()),
                                  ),
                                ] else ...[
                                  FilledButton.tonal(
                                    onPressed: () async {
                                      updateDanmakuArea(i);
                                      SmartDialog.dismiss();
                                    },
                                    child: Text(i.toString()),
                                  ),
                                ]
                              ]
                            ],
                          );
                        }),
                        actions: <Widget>[
                          TextButton(
                            onPressed: () => SmartDialog.dismiss(),
                            child: Text(
                              i18n.dialog.dismiss,
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              updateDanmakuArea(1.0);
                              SmartDialog.dismiss();
                            },
                            child: Text(i18n.dialog.setDefault),
                          ),
                        ],
                      );
                    });
              },
              dense: false,
              title: Text(i18n.my.danmakuSettings.area),
              subtitle: Text(i18n.my.danmakuSettings.areaSubtitleOccupy(value: defaultDanmakuArea),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
          ],
        ),
      ),
    );
  }
}

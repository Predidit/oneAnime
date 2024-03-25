import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_mobx/flutter_mobx.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/menu/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:oneanime/request/api.dart';
import 'package:oneanime/bean/settings/settings.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:oneanime/pages/my/my_controller.dart';
import 'package:hive/hive.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  dynamic navigationBarState;
  Box setting = GStorage.setting;
  late dynamic defaultDanmakuArea;
  late dynamic defaultThemeMode;
  final _mineController = Modular.get<MyController>();

  @override
  void initState() {
    super.initState();
    defaultDanmakuArea =
        setting.get(SettingBoxKey.danmakuArea, defaultValue: 1.0);
    defaultThemeMode =
        setting.get(SettingBoxKey.themeMode, defaultValue: 'system');
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在widget构建完成后调用的函数
      navigationBarState = Platform.isWindows
          ? Provider.of<SideNavigationBarState>(context, listen: false)
          : Provider.of<NavigationBarState>(context, listen: false);
      navigationBarState.showNavigate();
    });
  }

  void onBackPressed(BuildContext context) {
    navigationBarState.showNavigate();
    navigationBarState.updateSelectedIndex(0);
    Modular.to.navigate('/tab/popular/');
  }

  void updateDanmakuArea(double i) async {
    await setting.put(SettingBoxKey.danmakuArea, i);
    setState(() {
      defaultDanmakuArea = i;
    });
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

  @override
  Widget build(BuildContext context) {
    // This method is rerun every time setState is called, for instance as done
    // by the _incrementCounter method above.
    //
    // The Flutter framework has been optimized to make rerunning build methods
    // fast, so that you can just rebuild anything that needs updating rather
    // than having to individually change instances of widgets.
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: Scaffold(
        appBar: AppBar(title: const Text('设置')),
        body: Column(
          children: [
            ListTile(
              title: Text('播放设置',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  )),
            ),
            const InkWell(
              child: SetSwitchItem(
                title: '硬件解码',
                setKey: SettingBoxKey.HAenable,
                defaultVal: true,
              ),
            ),
            const InkWell(
              child: SetSwitchItem(
                title: '自动播放',
                setKey: SettingBoxKey.autoPlay,
                defaultVal: true,
              ),
            ),
            ListTile(
              title: Text('弹幕设置',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  )),
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
                        title: const Text('弹幕区域'),
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
                              '取消',
                              style: TextStyle(
                                  color: Theme.of(context).colorScheme.outline),
                            ),
                          ),
                          TextButton(
                            onPressed: () async {
                              updateDanmakuArea(1.0);
                              SmartDialog.dismiss();
                            },
                            child: const Text('默认设置'),
                          ),
                        ],
                      );
                    });
              },
              dense: false,
              title: const Text('弹幕区域'),
              subtitle: Text('当前占据 $defaultDanmakuArea 屏幕',
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            ListTile(
              title: Text('其他',
                  style: TextStyle(
                    fontSize: 12.0,
                    fontWeight: FontWeight.bold,
                    color: Theme.of(context).colorScheme.primary,
                  )),
            ),
            ListTile(
              onTap: () {
                SmartDialog.show(
                    useAnimation: false,
                    builder: (context) {
                      return AlertDialog(
                        title: const Text('主题模式'),
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
                                        child: const Text("跟随系统"))
                                    : FilledButton.tonal(
                                        onPressed: () {
                                          updateTheme('system');
                                          SmartDialog.dismiss();
                                        },
                                        child: const Text("跟随系统")),
                                defaultThemeMode == 'light'
                                    ? FilledButton(
                                        onPressed: () {
                                          updateTheme('light');
                                          SmartDialog.dismiss();
                                        },
                                        child: const Text("浅色"))
                                    : FilledButton.tonal(
                                        onPressed: () {
                                          updateTheme('light');
                                          SmartDialog.dismiss();
                                        },
                                        child: const Text("浅色")),
                                defaultThemeMode == 'dark'
                                    ? FilledButton(
                                        onPressed: () {
                                          updateTheme('dark');
                                          SmartDialog.dismiss();
                                        },
                                        child: const Text("深色"))
                                    : FilledButton.tonal(
                                        onPressed: () {
                                          updateTheme('dark');
                                          SmartDialog.dismiss();
                                        },
                                        child: const Text("深色")),
                              ],
                            );
                          },
                        ),
                      );
                    });
              },
              dense: false,
              title: const Text('主题模式'),
              subtitle: Text(
                  defaultThemeMode == 'light'
                      ? '浅色'
                      : (defaultThemeMode == 'dark' ? '深色' : '跟随系统'),
                  style: Theme.of(context)
                      .textTheme
                      .labelMedium!
                      .copyWith(color: Theme.of(context).colorScheme.outline)),
            ),
            (Platform.isAndroid || Platform.isAndroid)
                ? const InkWell(
                    child: SetSwitchItem(
                      title: '搜索优化',
                      subTitle: '自动翻译关键词',
                      setKey: SettingBoxKey.searchEnhanceEnable,
                      defaultVal: true,
                    ),
                  )
                : Container(),
            ListTile(
              onTap: () {
                _mineController.checkUpdata();
              },
              dense: false,
              title: const Text('检查更新'),
              subtitle: Text('当前版本 ${Api.version}',
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

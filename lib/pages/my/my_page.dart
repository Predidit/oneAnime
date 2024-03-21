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

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  dynamic navigationBarState;
  Box setting = GStorage.setting;
  late dynamic defaultDanmakuArea;
  final _mineController = Modular.get<MyController>();

  @override
  void initState() {
    super.initState();
    defaultDanmakuArea =
        setting.get(SettingBoxKey.danmakuArea, defaultValue: 1.0);
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
                double? result = await showDialog(
                  context: context,
                  builder: (context) {
                    return SelectDialog<double>(
                        title: '弹幕区域',
                        value: defaultDanmakuArea,
                        values: [0.25, 0.5, 1.0].map((e) {
                          return {'title': '$e 屏幕', 'value': e};
                        }).toList());
                  },
                );
                if (result != null) {
                  defaultDanmakuArea = result;
                  setting.put(SettingBoxKey.danmakuArea, result);
                  setState(() {});
                }
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

import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/menu/side_menu.dart';
import 'package:provider/provider.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:oneanime/request/api.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:oneanime/pages/my/my_controller.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';
import 'package:oneanime/bean/settings/settings.dart';
import 'package:url_launcher/url_launcher.dart';

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
  late dynamic defaultThemeColor;
  final PopularController popularController = Modular.get<PopularController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      // 在widget构建完成后调用的函数
      navigationBarState = Platform.isWindows || Platform.isLinux || Platform.isMacOS
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
        appBar: const SysAppBar(title: Text('我的')),
        body: Column(
          children: [
            const InkWell(
              child: SetSwitchItem(
                title: '隐身模式',
                subTitle: '不保留观看记录',
                setKey: SettingBoxKey.privateMode,
                defaultVal: false,
              ),
            ),
            ListTile(
              onTap: () async {
                Modular.to.pushNamed('/tab/history/');
              },
              dense: false,
              title: const Text('历史记录'),
              // trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () async {
                Modular.to.pushNamed('/tab/my/player');
              },
              dense: false,
              title: const Text('播放设置'),
              // trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () async {
                Modular.to.pushNamed('/tab/my/danmaku');
              },
              dense: false,
              title: const Text('弹幕设置'),
              // trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () async {
                Modular.to.pushNamed('/tab/my/theme');
              },
              dense: false,
              title: const Text('外观设置'),
              // trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () async {
                Modular.to.pushNamed('/tab/my/other');
              },
              dense: false,
              title: const Text('其他设置'),
              // trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () {
                Modular.to.pushNamed('/tab/my/about');
              },
              dense: false,
              title: const Text('关于'),
            ),
          ],
        ),
      ),
    );
  }
}

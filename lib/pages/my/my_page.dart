import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:provider/provider.dart';
import 'package:oneanime/pages/menu/menu.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';
import 'package:oneanime/bean/settings/settings.dart';
import 'package:oneanime/i18n/strings.g.dart';

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late NavigationBarState navigationBarState;
  late Translations i18n;
  Box setting = GStorage.setting;
  late dynamic defaultDanmakuArea;
  late dynamic defaultThemeMode;
  late dynamic defaultThemeColor;
  final PopularController popularController = Modular.get<PopularController>();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      navigationBarState = Provider.of<NavigationBarState>(context, listen: false);
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
    i18n = Translations.of(context);
    return PopScope(
      canPop: false,
      onPopInvoked: (bool didPop) async {
        onBackPressed(context);
      },
      child: Scaffold(
        appBar: SysAppBar(title: Text(i18n.menu.my)),
        body: Column(
          children: [
            InkWell(
              child: SetSwitchItem(
                title: i18n.my.private,
                subTitle: i18n.my.privateSubtitle,
                setKey: SettingBoxKey.privateMode,
                defaultVal: false,
              ),
            ),
            ListTile(
              onTap: () async {
                Modular.to.pushNamed('/history/');
              },
              dense: false,
              title: Text(i18n.my.history.title),
              // trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () async {
                Modular.to.pushNamed('/settings/player');
              },
              dense: false,
              title: Text(i18n.my.playerSettings.title),
              // trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () async {
                Modular.to.pushNamed('/settings/danmaku');
              },
              dense: false,
              title: Text(i18n.my.danmakuSettings.title),
              // trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () async {
                Modular.to.pushNamed('/settings/theme');
              },
              dense: false,
              title: Text(i18n.my.themeSettings.title),
              // trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () async {
                Modular.to.pushNamed('/settings/other');
              },
              dense: false,
              title: Text(i18n.my.otherSettings.title),
              // trailing: const Icon(Icons.navigate_next),
            ),
            ListTile(
              onTap: () {
                Modular.to.pushNamed('/settings/about');
              },
              dense: false,
              title: Text(i18n.my.about.title),
            ),
          ],
        ),
      ),
    );
  }
}

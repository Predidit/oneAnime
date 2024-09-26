import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/bean/settings/settings.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';
import 'package:oneanime/i18n/strings.g.dart';

class PlayerSettingsPage extends StatefulWidget {
  const PlayerSettingsPage({super.key});

  @override
  State<PlayerSettingsPage> createState() => _PlayerSettingsPageState();
}

class _PlayerSettingsPageState extends State<PlayerSettingsPage> {
  dynamic navigationBarState;
  Box setting = GStorage.setting;
  late Translations i18n;
  final PopularController popularController = Modular.get<PopularController>();

  @override
  void initState() {
    super.initState();
  }

  void onBackPressed(BuildContext context) {
    Modular.to.navigate('/tab/my/');
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
        appBar: SysAppBar(title: Text(i18n.my.playerSettings.title)),
        body: Column(
          children: [
            InkWell(
              child: SetSwitchItem(
                title: i18n.my.playerSettings.hardwareAcceleration,
                setKey: SettingBoxKey.HAenable,
                defaultVal: true,
                needReboot: true,
              ),
            ),
            InkWell(
              child: SetSwitchItem(
                title: i18n.my.playerSettings.autoPlay,
                setKey: SettingBoxKey.autoPlay,
                defaultVal: true,
              ),
            ),
            InkWell(
              child: SetSwitchItem(
                title: i18n.my.playerSettings.autoJump,
                subTitle: i18n.my.playerSettings.autoJumpSubtitle,
                setKey: SettingBoxKey.playResume,
                defaultVal: false,
              ),
            ),
          ],
        ),
      ),
    );
  }
}

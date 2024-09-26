import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/bean/settings/settings.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:oneanime/bean/appbar/sys_app_bar.dart';
import 'package:oneanime/request/request.dart';
import 'package:oneanime/i18n/strings.g.dart';

class OtherSettingsPage extends StatefulWidget {
  const OtherSettingsPage({super.key});

  @override
  State<OtherSettingsPage> createState() => _OtherSettingsPageState();
}

class _OtherSettingsPageState extends State<OtherSettingsPage> {
  dynamic navigationBarState;
  Box setting = GStorage.setting;
  static Box localCache = GStorage.localCache;
  late bool enableSystemProxy;
  late String defaultSystemProxyHost;
  late String defaultSystemProxyPort;
  late Translations i18n;
  final PopularController popularController = Modular.get<PopularController>();

  @override
  void initState() {
    super.initState();
    enableSystemProxy =
        setting.get(SettingBoxKey.enableSystemProxy, defaultValue: false);
  }

  void onBackPressed(BuildContext context) {
    Modular.to.navigate('/tab/my/');
  }

  // 设置代理
  void twoFADialog() {
    var systemProxyHost = '';
    var systemProxyPort = '';

    defaultSystemProxyHost =
        localCache.get(LocalCacheKey.systemProxyHost, defaultValue: '');
    defaultSystemProxyPort =
        localCache.get(LocalCacheKey.systemProxyPort, defaultValue: '');

    SmartDialog.show(
      useAnimation: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text(i18n.my.otherSettings.proxySettings),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              TextField(
                decoration: InputDecoration(
                  isDense: true,
                  labelText: defaultSystemProxyHost != ''
                      ? defaultSystemProxyHost
                      : i18n.my.otherSettings.proxyHost,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  hintText: defaultSystemProxyHost,
                ),
                onChanged: (e) {
                  systemProxyHost = e;
                },
              ),
              const SizedBox(height: 10),
              TextField(
                keyboardType: TextInputType.number,
                decoration: InputDecoration(
                  isDense: true,
                  labelText: defaultSystemProxyPort != ''
                      ? defaultSystemProxyPort
                      : i18n.my.otherSettings.proxyPort,
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(6.0),
                  ),
                  hintText: defaultSystemProxyPort,
                ),
                onChanged: (e) {
                  systemProxyPort = e;
                },
              ),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () async {
                SmartDialog.dismiss();
              },
              child: Text(
                i18n.dialog.dismiss,
                style: TextStyle(color: Theme.of(context).colorScheme.outline),
              ),
            ),
            TextButton(
              onPressed: () async {
                localCache.put(
                    LocalCacheKey.systemProxyHost,
                    systemProxyHost == ''
                        ? defaultSystemProxyHost
                        : systemProxyHost);
                localCache.put(
                    LocalCacheKey.systemProxyPort,
                    systemProxyPort == ''
                        ? defaultSystemProxyPort
                        : systemProxyPort);
                SmartDialog.dismiss();
                if (enableSystemProxy) {
                  Request.setProxy();
                }
              },
              child: Text(i18n.dialog.confirm),
            )
          ],
        );
      },
    );
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
        appBar: SysAppBar(title: Text(i18n.my.otherSettings.title)),
        body: Column(
          children: [
            (popularController.libopencc != '' || Platform.isAndroid || Platform.isIOS)
                ? InkWell(
                    child: SetSwitchItem(
                      title: i18n.my.otherSettings.searchEnhace,
                      subTitle: i18n.my.otherSettings.searchEnhaceSubtitle,
                      setKey: SettingBoxKey.searchEnhanceEnable,
                      defaultVal: true,
                    ),
                  )
                : Container(),
            ListTile(
              enableFeedback: true,
              onTap: () => twoFADialog(),
              title: Text(i18n.my.otherSettings.proxySettings),
              trailing: Transform.scale(
                alignment: Alignment.centerRight,
                scale: 0.8,
              ),
            ),
            InkWell(
              child: SetSwitchItem(
                title: i18n.my.otherSettings.proxyEnable,
                callFn: (_) {
                  enableSystemProxy = !enableSystemProxy;
                  if (enableSystemProxy) {
                    Request.setProxy();
                  } else {
                    Request.disableProxy();
                  }
                },
                setKey: SettingBoxKey.enableSystemProxy,
                defaultVal: false,
              ),
            ),
            InkWell(
              child: SetSwitchItem(
                title: i18n.my.otherSettings.autoUpdate,
                setKey: SettingBoxKey.autoUpdate,
                defaultVal: false,
              ),
            )
          ],
        ),
      ),
    );
  }
}

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
          title: const Text('设置代理'),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              const SizedBox(height: 6),
              TextField(
                decoration: InputDecoration(
                  isDense: true,
                  labelText: defaultSystemProxyHost != ''
                      ? defaultSystemProxyHost
                      : '请输入Host, 使用 . 分割',
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
                      : '请输入Port',
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
                '取消',
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
              child: const Text('确认'),
            )
          ],
        );
      },
    );
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
        appBar: const SysAppBar(title: Text('设置')),
        body: Column(
          children: [
            (popularController.libopencc != '' || Platform.isAndroid || Platform.isIOS)
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
              enableFeedback: true,
              onTap: () => twoFADialog(),
              title: const Text('配置代理'),
              trailing: Transform.scale(
                alignment: Alignment.centerRight,
                scale: 0.8,
              ),
            ),
            InkWell(
              child: SetSwitchItem(
                title: '启用代理',
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
            const InkWell(
              child: SetSwitchItem(
                title: '自动更新',
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

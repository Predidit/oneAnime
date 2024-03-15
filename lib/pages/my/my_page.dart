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

class MyPage extends StatefulWidget {
  const MyPage({super.key});

  @override
  State<MyPage> createState() => _MyPageState();
}

class _MyPageState extends State<MyPage> {
  late final navigationBarState;
  final _mineController = Modular.get<MyController>();

  @override
  void initState() {
    super.initState();
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
            const InkWell(
              child: SetSwitchItem(
                title: '硬件解码',
                setKey: SettingBoxKey.HAenable,
                defaultVal: true,
              ),
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

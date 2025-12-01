import 'dart:io';
import 'dart:ffi';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/pages/my/my_controller.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:oneanime/opencc_generated_bindings.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:flutter/services.dart' show rootBundle;

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  Box setting = GStorage.setting;
  late bool autoUpdate;
  late bool HAenable;
  final MyController _mineController = Modular.get<MyController>();

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    openccInit();
    autoUpdate = setting.get(SettingBoxKey.autoUpdate, defaultValue: false);
    if (autoUpdate) {
      update();
    }
    _checkStatements();
  }

  _checkStatements() async {
    String statementsText = '';
    bool firstRun =
        await setting.get(SettingBoxKey.firstRun, defaultValue: true);
    try {
      statementsText =
          await rootBundle.loadString("assets/statements/statements.txt");
    } catch (_) {}
    if (firstRun) {
      SmartDialog.show(
        useAnimation: false,
        backDismiss: false,
        clickMaskDismiss: false,
        builder: (context) {
          return AlertDialog(
            title: const Text('免责声明'),
            scrollable: true,
            content: Text(statementsText),
            actions: [
              TextButton(
                onPressed: () {
                  exit(0);
                },
                child: Text(
                  '退出',
                  style:
                      TextStyle(color: Theme.of(context).colorScheme.outline),
                ),
              ),
              TextButton(
                onPressed: () async {
                  setting.put(SettingBoxKey.firstRun, false);
                  SmartDialog.dismiss();
                  Modular.to.navigate('/tab/popular/');
                },
                child: const Text('已阅读并同意'),
              ),
            ],
          );
        },
      );
    } else {
      Modular.to.navigate('/tab/popular/');
    }
  }

  void openccInit() {
    if (Platform.isWindows) {
      final PopularController popularController =
          Modular.get<PopularController>();
      if (popularController.libopencc == '') {
        String fullPath = "opencc.dll";
        try {
          final lib = DynamicLibrary.open(fullPath);
          popularController.libopencc = opencc(lib);
          debugPrint('动态库加载成功');
        } catch (e) {
          setting.put(SettingBoxKey.searchEnhanceEnable, false);
          debugPrint('动态库加载失败 ${e.toString()}');
        }
      }
    }
    if (Platform.isLinux) {
      final PopularController popularController =
          Modular.get<PopularController>();
      if (popularController.libopencc == '') {
        String fullPath = "lib/opencc.so";
        try {
          final lib = DynamicLibrary.open(fullPath);
          popularController.libopencc = opencc(lib);
          debugPrint('动态库加载成功');
        } catch (e) {
          setting.put(SettingBoxKey.searchEnhanceEnable, false);
          debugPrint('动态库加载失败 ${e.toString()}');
        }
      }
    }
  }

  void update() {
    _mineController.checkUpdata(type: 'auto');
  }

  @override
  Widget build(BuildContext context) {
    return const RouterOutlet();
  }
}

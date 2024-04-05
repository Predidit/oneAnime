import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/pages/my/my_controller.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/opencc_generated_bindings.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';
import 'package:adaptive_theme/adaptive_theme.dart';

class InitPage extends StatefulWidget {
  const InitPage({super.key});

  @override
  State<InitPage> createState() => _InitPageState();
}

class _InitPageState extends State<InitPage> {
  Box setting = GStorage.setting;
  late bool autoUpdate;
  final MyController _mineController = Modular.get<MyController>();

  @override
  void initState() {
    _init();
    super.initState();
  }

  _init() {
    openccInit();
    autoUpdate =
        setting.get(SettingBoxKey.autoUpdate, defaultValue: false);
    if (autoUpdate) {
      update();
    }
    Modular.to.navigate('/tab/popular/');
  }

  void openccInit() {
    if (Platform.isWindows) {
      final PopularController popularController = Modular.get<PopularController>();
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
  }

  void update() {
    _mineController.checkUpdata(type: 'auto');
  }

  @override
  Widget build(BuildContext context) {
    return const RouterOutlet();
  }
}

class LoadingWidget extends StatelessWidget {
  const LoadingWidget({super.key, required this.value});

  final double value;

  @override
  Widget build(BuildContext context) {
    var size = MediaQuery.of(context).size;
    return Scaffold(
      appBar: AppBar(title: const Text("oneAnime")),
      body: Center(
        child: SizedBox(
          height: 200,
          child: Flex(
            direction: Axis.vertical,
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              SizedBox(
                width: size.width * 0.6,
                child: LinearProgressIndicator(
                  value: value,
                  backgroundColor: Colors.black12,
                  minHeight: 10,
                ),
              ),
              const Text("初始化中"),
            ],
          ),
        ),
      ),
    );
  }
}

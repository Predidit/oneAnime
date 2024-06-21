import 'dart:io';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/app_module.dart';
import 'package:oneanime/app_widget.dart';
import 'package:oneanime/request/request.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:flutter/services.dart';
import 'package:oneanime/pages/error/error.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    WindowOptions windowOptions = const WindowOptions(
      size: Size(1280, 800),
      center: true,
      // backgroundColor: Colors.white,
      skipTaskbar: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
    // windowManager.setMaximizable(false);
    // windowManager.setResizable(false);
  }
  if (Platform.isAndroid || Platform.isIOS) {
    // 小白条、导航栏沉浸
    SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
      systemNavigationBarColor: Colors.transparent,
      systemNavigationBarDividerColor: Colors.transparent,
      statusBarColor: Colors.transparent,
    ));
  }
  SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
  try {
    await GStorage.init();
  } catch (e) {
    runApp(MaterialApp(
        title: '初始化失败',
        builder: (context, child) {
          return ErrorPage(e.toString());
        }));
    return;
  }
  Request();
  await Request.setCookie();
  runApp(ModularApp(
    module: AppModule(),
    child: const AppWidget(),
  ));
}

import 'dart:io';
import 'package:window_manager/window_manager.dart';
import 'package:flutter/material.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/app_module.dart';
import 'package:oneanime/app_widget.dart';
import 'package:oneanime/request/request.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:flutter/services.dart';
import 'package:oneanime/utils/utils.dart';
import 'package:oneanime/pages/error/error.dart';
import 'package:media_kit/media_kit.dart';
import 'package:oneanime/i18n/strings.g.dart';

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  MediaKit.ensureInitialized();
  LocaleSettings.useDeviceLocale();
  if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
    await windowManager.ensureInitialized();
    bool isLowResolution = await Utils.isLowResolution();
    WindowOptions windowOptions = WindowOptions(
      size: isLowResolution ? const Size(800, 540) : const Size(1280, 800),
      center: true,
      skipTaskbar: false,
      windowButtonVisibility: false,
      titleBarStyle: TitleBarStyle.hidden,
    );
    windowManager.waitUntilReadyToShow(windowOptions, () async {
      await windowManager.show();
      await windowManager.focus();
    });
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
  // SystemChrome.setPreferredOrientations([DeviceOrientation.portraitUp]);
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
  runApp(TranslationProvider(
    child: ModularApp(
      module: AppModule(),
      child: const AppWidget(),
    ),
  ));
}

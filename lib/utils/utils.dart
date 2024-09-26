import 'dart:io';
import 'dart:math';
import 'package:hive/hive.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:oneanime/request/api.dart';
import 'package:flutter/foundation.dart';
import 'package:oneanime/utils/constans.dart';
import 'package:screen_pixel/screen_pixel.dart';
import 'package:device_info_plus/device_info_plus.dart';
import 'package:window_manager/window_manager.dart';

class Utils {
  static Future<bool> isLowResolution() async {
    try {
      Map<String, double>? screenInfo = await getScreenInfo();
      if (screenInfo != null) {
        if (screenInfo['height']! / screenInfo['ratio']! < 900) {
          return true;
        }
      }
      return false;
    } catch (_) {
      return false;
    }
  }

  static String getRandomUA() {
    final random = Random();
    String randomElement =
        userAgentsList[random.nextInt(userAgentsList.length)];
    return randomElement;
  }

  static Future<Map<String, double>?> getScreenInfo() async {
    final screenPixelPlugin = ScreenPixel();
    Map<String, double>? screenResolution;
    final MediaQueryData mediaQuery = MediaQueryData.fromView(
        WidgetsBinding.instance.platformDispatcher.views.first);
    final double screenRatio = mediaQuery.devicePixelRatio;
    Map<String, double>? screenInfo = {};

    try {
      screenResolution = await screenPixelPlugin.getResolution();
      screenInfo = {
        'width': screenResolution['width']!,
        'height': screenResolution['height']!,
        'ratio': screenRatio
      };
    } on PlatformException {
      screenInfo = null;
    }
    return screenInfo;
  }

  static videoCookieC(List<String> baseCookies) {
    String finalCookie = '';
    String baseCookieString = baseCookies.join('; ');
    baseCookieString.split('; ').forEach((cookieString) {
      if (cookieString.contains('=')) {
        List<String> cookieParts = cookieString.split('=');
        if (cookieParts[0] == 'e' ||
            cookieParts[0] == 'p' ||
            cookieParts[0] == 'h' ||
            cookieParts[0].startsWith('_ga')) {
          finalCookie = '$finalCookie${cookieParts[0]}=${cookieParts[1]}; ';
        }
      }
    });
    finalCookie = finalCookie.replaceAll(RegExp(r';\s*$'), '');
    return finalCookie;
  }

  static oledDarkTheme(ThemeData defaultDarkTheme) {
    return defaultDarkTheme.copyWith(
      scaffoldBackgroundColor: Colors.black,
      colorScheme: defaultDarkTheme.colorScheme.copyWith(
        onPrimary: Colors.black,
        onSecondary: Colors.black,
        surface: Colors.black,
        onSurface: Colors.white,
      ),
    );
  }

  static String durationToString(Duration duration) {
    String pad(int n) => n.toString().padLeft(2, '0');
    var minutes = pad(duration.inMinutes % 60);
    var seconds = pad(duration.inSeconds % 60);
    return "$minutes:$seconds";
  }

  static Future<String> latest() async {
    try {
      var resp = await Dio().get<Map<String, dynamic>>(Api.latestApp);
      if (resp.data?.containsKey("tag_name") ?? false) {
        return resp.data!["tag_name"];
      } else {
        throw resp.data?["message"];
      }
    } catch (e) {
      return Api.version;
    }
  }

  /// 判断是否为桌面设备
  static bool isDesktop() {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      return true;
    }
    return false;
  }

  /// 判断设备是否为宽屏
  static bool isWideScreen() {
    Box setting = GStorage.setting;
    bool isWideScreen =
        setting.get(SettingBoxKey.isWideScreen, defaultValue: false);
    return isWideScreen;
  }

  /// 判断设备是否为平板
  static bool isTablet() {
    return isWideScreen() && !isDesktop();
  }

  /// 判断设备是否需要紧凑布局
  static bool isCompact() {
    return !isDesktop() && !isWideScreen();
  }

  // 进入全屏显示
  static Future<void> enterFullScreen() async {
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await windowManager.setFullScreen(true);
      return;
    }
    await landScape();
    await SystemChrome.setEnabledSystemUIMode(
      SystemUiMode.immersiveSticky,
    );
  }

  //退出全屏显示
  static Future<void> exitFullScreen() async {
    debugPrint('退出全屏模式');
    if (Platform.isWindows || Platform.isLinux || Platform.isMacOS) {
      await windowManager.setFullScreen(false);
    }
    dynamic document;
    late SystemUiMode mode = SystemUiMode.edgeToEdge;
    try {
      if (kIsWeb) {
        document.exitFullscreen();
      } else if (Platform.isAndroid || Platform.isIOS) {
        if (Platform.isAndroid &&
            (await DeviceInfoPlugin().androidInfo).version.sdkInt < 29) {
          mode = SystemUiMode.manual;
        }
        await SystemChrome.setEnabledSystemUIMode(
          mode,
          overlays: SystemUiOverlay.values,
        );
        if (isCompact()) {
          verticalScreen();
        }
      }
    } catch (exception, stacktrace) {
      debugPrint(exception.toString());
      debugPrint(stacktrace.toString());
    }
  }

  //横屏
  static Future<void> landScape() async {
    dynamic document;
    try {
      if (kIsWeb) {
        await document.documentElement?.requestFullscreen();
      } else if (Platform.isAndroid || Platform.isIOS) {
        await SystemChrome.setPreferredOrientations(
          [
            DeviceOrientation.landscapeLeft,
            DeviceOrientation.landscapeRight,
          ],
        );
      }
    } catch (exception, stacktrace) {
      debugPrint(exception.toString());
      debugPrint(stacktrace.toString());
    }
  }

  //竖屏
  static Future<void> verticalScreen() async {
    await SystemChrome.setPreferredOrientations([
      DeviceOrientation.portraitUp,
    ]);
  }
}

import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:oneanime/request/api.dart';
import 'package:flutter/services.dart';
import 'package:screen_pixel/screen_pixel.dart';

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
          finalCookie =
              finalCookie + cookieParts[0] + '=' + cookieParts[1] + '; ';
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
        background: Colors.black,
        onBackground: Colors.black,
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
}

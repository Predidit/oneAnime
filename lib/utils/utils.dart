import 'package:dio/dio.dart';
import 'package:oneanime/request/api.dart';


class Utils {
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
          finalCookie = finalCookie + cookieParts[0] + '=' + cookieParts[1] + '; ';
        }
      }
    });
    finalCookie = finalCookie.replaceAll(RegExp(r';\s*$'), '');
    return finalCookie;
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

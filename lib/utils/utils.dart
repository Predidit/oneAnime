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
}

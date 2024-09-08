import 'package:dio/dio.dart';
import 'package:flutter_smart_dialog/flutter_smart_dialog.dart';
import 'package:connectivity_plus/connectivity_plus.dart';

class ApiInterceptor extends Interceptor {
  // static Box setting = GStorage.setting;
  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    handler.next(options);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {    
    handler.next(response);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    String url = err.requestOptions.uri.toString();
    if (!url.contains('heartBeat')) {
      SmartDialog.showToast(
        await dioError(err),
        displayType: SmartToastType.onlyRefresh,
      );
    }
    super.onError(err, handler);
    // super.onError(err, handler);
  }

  static Future<String> dioError(DioException error) async {
    switch (error.type) {
      case DioExceptionType.badCertificate:
        return 'Certificate error';
      case DioExceptionType.badResponse:
        return 'Server error, please try again later';
      case DioExceptionType.cancel:
        return 'Request has been canceled';
      case DioExceptionType.connectionError:
        return 'Network error, please check your network settings';
      case DioExceptionType.connectionTimeout:
        return 'Connection timeout, please check your network settings';
      case DioExceptionType.receiveTimeout:
        return 'Receive response timeout, please check your network settings';
      case DioExceptionType.sendTimeout:
        return '';
      case DioExceptionType.unknown:
        final String res = await checkConnect();
        return '$res or unknown error';
    }
  }

  static Future<String> checkConnect() async {
    final connectivityResult =
        await Connectivity().checkConnectivity();
    if (connectivityResult.contains(ConnectivityResult.mobile)) {
      return 'Using mobile data';
    }
    if (connectivityResult.contains(ConnectivityResult.wifi)) {
      return 'Using Wi-Fi';
    }
    if (connectivityResult.contains(ConnectivityResult.ethernet)) {
      return 'Using Ethernet';
    }
    if (connectivityResult.contains(ConnectivityResult.vpn)) {
      return 'Using VPN';
    }
    if (connectivityResult.contains(ConnectivityResult.other)) {
      return 'Using other network';
    }
    if (connectivityResult.contains(ConnectivityResult.none)) {
      return 'No network connection';
    }
    return '';
  }
}

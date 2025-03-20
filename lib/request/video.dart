import 'package:flutter/material.dart';
import 'package:oneanime/request/api.dart';
import 'package:oneanime/request/request.dart';
import 'package:html/parser.dart' show parse;
import 'package:dio/dio.dart';
import 'package:oneanime/utils/utils.dart';

class VideoRequest {
  /// Get page title to be displayed in app bar
  static Future getPageTitle(String url) async {
    final res = await Request().get(url);
    String resString = res.data;
    // debugPrint('从服务器获得的全链接响应 $resString');
    try {
      var document = parse(resString);
      final titles = document.getElementsByClassName('page-title');
      if (titles.isNotEmpty) {
        return titles.first.text;
      } else {
        return '';
      }
    } catch (e) {
      debugPrint('服务器响应不合法 ${e.toString()}');
      return '';
    }
  }

  /// Get full link instead of /cat for going to next page
  static Future getFullLink(String url) async {
    final res = await Request().get(url);
    String resString = res.data;
    // debugPrint('从服务器获得的全链接响应 $resString');
    try {
      var document = parse(resString);
      final link = document.getElementsByClassName('cat-links').first;
      return link.nodes[1].attributes['href'];
    } catch (e) {
      debugPrint('服务器响应不合法 ${e.toString()}');
      return '';
    }
  }

  static Future getVideoToken(String url) async {
    List<String> token = [];
    final res = await Request().get(url);
    String resString = res.data.toString();
    try {
      var document = parse(resString);
      final videoTags = document.getElementsByTagName('video');
      if (videoTags.isNotEmpty) {
        for (int i = 0; i < videoTags.length; i++) {
          final element = videoTags[i];
          token.add(element.attributes['data-apireq'] ?? '');
        }
        final videoTitle =
            document.getElementsByClassName('entry-title').first.text;
        if (videoTitle.endsWith('[01]')) {
          token = token.reversed.toList();
        }
        debugPrint('从网页上成功捕获视频凭据 ${token[0]}');
        debugPrint('合集总长度 ${videoTags.length}');
      } else {
        debugPrint('未从网页上找到视频源');
      }
      if (token.length == 14) {
        for (int p = 2; p <= ((token.length / 14).floor() + 1); p++) {
          final link = document.getElementsByClassName('cat-links').first;
          final resNext = await Request()
              .get('${link.nodes[1].attributes['href']!}/page/$p');
          document = parse(resNext.data);
          final videoTags = document.getElementsByTagName('video');
          if (videoTags.isNotEmpty) {
            for (int i = 0; i < videoTags.length; i++) {
              final element = videoTags[i];
              token.add(element.attributes['data-apireq'] ?? '');
            }
            debugPrint('从网页$p上成功捕获视频凭据 ${token[0]}');
            debugPrint('合集$p总长度 ${videoTags.length}');
          } else {
            debugPrint('未从网页$p上找到视频源');
          }
        }
      }
    } catch (e) {
      debugPrint('其他错误 ${e.toString()}');
      return token;
    }
    return token;
  }

  static Future getVideoLink(String token) async {
    // Todo 剧集切换
    String link = '';
    var result = {};
    List<String> cookies = [];
    final res = await Request().post(Api.videoAPI,
        data: 'd=$token',
        options: Options(contentType: 'application/x-www-form-urlencoded'));
    try {
      link = 'https:${res.data['s'][0]['src']}';
      cookies = res?.headers['set-cookie'];
      debugPrint('用于视频验权的cookie为 ${Utils.videoCookieC(cookies)}');
    } catch (e) {
      debugPrint(e.toString());
      result['link'] = link;
      result['cookie'] = '';
      return result;
    }
    result['link'] = link;
    result['cookie'] = Utils.videoCookieC(cookies);
    return result;
  }
}

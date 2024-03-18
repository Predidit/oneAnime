import 'package:dio/dio.dart';
import 'package:oneanime/request/request.dart';
import 'package:oneanime/request/api.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart';
import 'package:flutter/material.dart' as material;

class DanmakuRequest {
  static getAniDanmakuList(String title) async {
    List<String> dataList = [];
    var httpHeaders = {
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
      'referer': 'https://ani.gamer.com.tw/',
    };
    Map<String, String> keywordMap = {
      'keyword': title,
    };
    final res = await Request().get(Api.aniSearch,
        data: keywordMap, options: Options(headers: httpHeaders));
    String resString = res.data;
    Document document = htmlParser.parse(resString);
    Element? element = document.querySelector('a.theme-list-main');
    String? href = element?.attributes['href'];
    material.debugPrint('动画疯目录 URL 为 $href');
    final resNext = await Request().get(
        'https://ani.gamer.com.tw/' + (href ?? ''),
        options: Options(headers: httpHeaders));
    // material.debugPrint(res.data);
    Document documentNext = htmlParser.parse(resNext.data);
    Element? seasonElement = documentNext.querySelector('.season');
    if (seasonElement != null) {
      List<Element> aElements = seasonElement.querySelectorAll('a');
      dataList = aElements.map((element) => element.attributes['data-ani-video-sn'] ?? '').toList();
    }
    material.debugPrint('弹幕支持的总集数 ${dataList.length}');
    return dataList;
  }
}

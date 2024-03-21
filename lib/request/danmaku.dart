import 'dart:convert';
import 'package:dio/dio.dart';
import 'package:oneanime/request/request.dart';
import 'package:oneanime/request/api.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart';
import 'package:flutter/material.dart' as material;
import 'package:oneanime/pages/video/danmaku_module.dart';

class DanmakuRequest {
  // 获取动画疯sn集合, 需要进一步处理
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
      dataList = aElements
          .map((element) => element.attributes['data-ani-video-sn'] ?? '')
          .toList();
    }
    material.debugPrint('弹幕支持的总集数 ${dataList.length}');
    return dataList;
  }

  //获取弹弹Play集合，需要进一步处理
  static getBangumiID(String title) async {
    var httpHeaders = {
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
      'referer': '',
    };
    Map<String, String> keywordMap = {
      'keyword': title,
    };

    final res = await Request().get(Api.dandanSearch,
        data: keywordMap, options: Options(headers: httpHeaders));
    Map<String, dynamic> jsonData = res.data;
    List<dynamic> animes = jsonData['animes'];

    int maxAnimeId = 0;
    for (var anime in animes) {
      int animeId = anime['animeId'];
      if (animeId > maxAnimeId) {
        maxAnimeId = animeId;
      }
    }
    // 这里猜测了弹弹Play的分集命名规则，例如上面的番剧ID为1758，第一集弹幕库ID大概率为17580001，但是此命名规则并没有体现在官方API文档里，保险的做法是请求 Api.dandanInfo
    return maxAnimeId;
  }

  static getDanDanmaku(int bangumiID, int episode) async {
    List<Danmaku> danmakus = [];
    var httpHeaders = {
      'user-agent':
          'Mozilla/5.0 (Macintosh; Intel Mac OS X 13_3_1) AppleWebKit/605.1.15 (KHTML, like Gecko) Version/16.4 Safari/605.1.15',
      'referer': '',
    };
    Map<String, String> withRelated = {
      'withRelated': 'true',
    };
    material.debugPrint(
        "弹幕请求最终URL ${Api.dandanAPI + "$bangumiID" + episode.toString().padLeft(4, '0')}");
    final res = await Request().get(
        (Api.dandanAPI + "$bangumiID" + episode.toString().padLeft(4, '0')),
        data: withRelated,
        options: Options(headers: httpHeaders));
    
    Map<String, dynamic> jsonData = res.data;
    List<dynamic> comments = jsonData['comments'];

    for (var comment in comments) {
      Danmaku danmaku = Danmaku.fromJson(comment);
      danmakus.add(danmaku);
    }
    return danmakus;
  }
}
import 'package:dio/dio.dart';
import 'package:oneanime/request/request.dart';
import 'package:oneanime/request/api.dart';
import 'package:html/parser.dart' as htmlParser;
import 'package:html/dom.dart';
import 'package:flutter/material.dart' as material;
import 'package:oneanime/bean/danmaku/danmaku_module.dart';
import 'package:oneanime/bean/anime/anime_bangumi_info.dart';
import 'package:oneanime/utils/utils.dart';
import 'package:oneanime/utils/mortis.dart';

class DanmakuRequest {
  // 获取动画疯sn集合, 需要进一步处理
  static getAniDanmakuList(String title) async {
    List<String> dataList = [];
    var httpHeaders = {
      'user-agent': Utils.getRandomUA(),
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
        'https://ani.gamer.com.tw/${href ?? ''}',
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
    var path = Api.dandanAPISearch;
    var endPoint = Api.dandanAPIDomain + path;
    var timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var httpHeaders = {
      'user-agent': Utils.getRandomUA(),
      'referer': '',
      'X-Auth': 1,
      'X-AppId': mortis['id'],
      'X-Timestamp': timestamp.toString(),
      'X-Signature': Utils.generateDandanSignature(path, timestamp),
    };
    Map<String, String> keywordMap = {
      'keyword': title,
    };

    final res = await Request().get(endPoint,
        data: keywordMap, options: Options(headers: httpHeaders));
    Map<String, dynamic> jsonData = res.data;
    List<dynamic> animes = jsonData['animes'];

    // 8692 为 Anime1 上的最早番剧刀剑神域
    int minAnimeId = 100000;
    for (var anime in animes) {
      int animeId = anime['animeId'];
      if (animeId < minAnimeId && animeId >= 8692) {
        minAnimeId = animeId;
      }
    }
    return minAnimeId;
  }

  static getDanDanmaku(int bangumiID, int episode) async {
    List<Danmaku> danmakus = [];
    if (bangumiID == 100000) {
      return danmakus;
    }
    // 这里猜测了弹弹Play的分集命名规则，例如上面的番剧ID为1758，第一集弹幕库ID大概率为17580001，但是此命名规则并没有体现在官方API文档里，保险的做法是请求 Api.dandanInfo
    var path = Api.dandanAPIComment +
        bangumiID.toString() +
        episode.toString().padLeft(4, '0');
    var endPoint = Api.dandanAPIDomain + path;
    var timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    var httpHeaders = {
      'user-agent': Utils.getRandomUA(),
      'referer': '',
      'X-Auth': 1,
      'X-AppId': mortis['id'],
      'X-Timestamp': timestamp.toString(),
      'X-Signature': Utils.generateDandanSignature(path, timestamp),
    };
    Map<String, String> withRelated = {
      'withRelated': 'true',
    };
    material.debugPrint(
        "弹幕请求最终URL $endPoint");
    final res = await Request().get(
        (endPoint),
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

  static getBangumiName(String title) async {
    // Bangumi API 文档要求的UA格式
    var httpHeaders = {
      'user-agent':
          'Predidit/oneAnime/${Api.version} (Android) (https://github.com/Predidit/oneAnime)',
      'referer': '',
    };
    Map<String, String> keywordMap = {'type': '2', 'responseGroup': 'small'};

    final res = await Request().get(
        Api.bangumiSearch + Uri.encodeComponent(title),
        data: keywordMap,
        options: Options(headers: httpHeaders));
    Map<String, dynamic> jsonData = res.data;
    BangumiInfo bangumiInfo = BangumiInfo.fromJson({
      "name": jsonData['list'][0]['name'],
      "name_cn": jsonData['list'][0]['name_cn']
    });
    return bangumiInfo;
  }
}

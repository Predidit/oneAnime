import 'dart:convert';

import 'package:dio/dio.dart';
import 'package:oneanime/request/request.dart';
import 'package:oneanime/request/api.dart';
import 'package:flutter/material.dart' as material;
import 'package:oneanime/bean/danmaku/danmaku_module.dart';
import 'package:oneanime/utils/utils.dart';
import 'package:oneanime/utils/mortis.dart';

class DanmakuRequest {
  /// Request.get() reports network failures as a normal response carrying
  /// {'message': ...}, and the APIs may answer with HTML, so a response body is
  /// never cast directly.
  static Map<String, dynamic> _asJsonMap(dynamic data) {
    if (data is Map) {
      return Map<String, dynamic>.from(data);
    }
    if (data is String && data.isNotEmpty) {
      try {
        final decoded = jsonDecode(data);
        if (decoded is Map) {
          return Map<String, dynamic>.from(decoded);
        }
      } catch (e) {
        material.debugPrint('响应不是合法 JSON ${e.toString()}');
      }
    }
    return <String, dynamic>{};
  }

  static List<dynamic> _asJsonList(dynamic data) =>
      (data is List) ? data : <dynamic>[];

  static String _errorOf(Map<String, dynamic> json) =>
      (json['errorMessage'] ?? json['message'] ?? '').toString();

  /// 弹弹Play signs the path only, never the query string.
  static Future<Map<String, dynamic>> _dandanGet(String path,
      {Map<String, String>? query}) async {
    final timestamp = DateTime.now().millisecondsSinceEpoch ~/ 1000;
    final res = await Request().get(Api.dandanAPIDomain + path,
        data: query,
        options: Options(headers: {
          'user-agent': Utils.getRandomUA(),
          'referer': '',
          'X-Auth': 1,
          'X-AppId': mortis['id'],
          'X-Timestamp': timestamp.toString(),
          'X-Signature': Utils.generateDandanSignature(path, timestamp),
        }));
    return _asJsonMap(res.data);
  }

  /// 弹弹Play anime id for [title], or null when the keyword search misses.
  static Future<int?> getDandanAnimeId(String title) async {
    final jsonData =
        await _dandanGet(Api.dandanAPISearch, query: {'keyword': title});
    // 8692 is 刀剑神域, the earliest bangumi carried by Anime1.
    int? animeId;
    for (final anime in _asJsonList(jsonData['animes'])) {
      final id = _asJsonMap(anime)['animeId'];
      if (id is int && id >= 8692 && (animeId == null || id < animeId)) {
        animeId = id;
      }
    }
    if (animeId == null) {
      material.debugPrint('弹弹Play 搜索 $title 无结果 ${_errorOf(jsonData)}');
    }
    return animeId;
  }

  /// 弹弹Play anime id mapped from a Bangumi.tv subject, or null when 弹弹Play
  /// has not mapped that subject yet.
  static Future<int?> getDandanAnimeIdByBgmId(int subjectId) async {
    final jsonData =
        await _dandanGet(Api.dandanAPIBgmtv + subjectId.toString());
    final animeId = _asJsonMap(jsonData['bangumi'])['animeId'];
    if (animeId is! int) {
      material.debugPrint(
          '弹弹Play 未收录 Bangumi 条目 $subjectId ${_errorOf(jsonData)}');
      return null;
    }
    return animeId;
  }

  /// Bangumi.tv subject id for [title], or null when the search misses.
  static Future<int?> getBgmSubjectId(String title) async {
    final res = await Request().get(
        Api.bangumiSearch + Uri.encodeComponent(title),
        data: {'type': '2', 'responseGroup': 'small'},
        options: Options(headers: {
          // UA format required by the Bangumi API docs.
          'user-agent':
              'Predidit/oneAnime/${Api.version} (Android) (${Api.sourceUrl})',
          'referer': '',
        }));
    final list = _asJsonList(_asJsonMap(res.data)['list']);
    final id = list.isEmpty ? null : _asJsonMap(list.first)['id'];
    if (id is! int) {
      material.debugPrint('Bangumi 搜索 $title 无结果');
      return null;
    }
    return id;
  }

  /// Danmaku for one episode. Episode ids are the anime id followed by the
  /// 4 digit episode number (anime 1758 episode 1 -> 17580001); the rule is
  /// undocumented but every episode list the API publishes agrees with it.
  static Future<List<Danmaku>> getDanmaku(int animeId, int episode) async {
    final int episodeId = animeId * 10000 + episode;
    final jsonData = await _dandanGet(
        Api.dandanAPIComment + episodeId.toString(),
        query: {'withRelated': 'true'});
    final comments = _asJsonList(jsonData['comments']);
    if (comments.isEmpty) {
      material.debugPrint('弹幕库 $episodeId 为空 ${_errorOf(jsonData)}');
    }
    final List<Danmaku> danmakus = [];
    for (final comment in comments) {
      try {
        danmakus.add(Danmaku.fromJson(Map<String, dynamic>.from(comment)));
      } catch (e) {
        material.debugPrint('弹幕解析失败 ${e.toString()}');
      }
    }
    return danmakus;
  }
}

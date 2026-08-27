import 'package:oneanime/request/api.dart';
import 'package:oneanime/request/request.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:flutter/material.dart';
import 'package:oneanime/bean/anime/anime_sesson.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:html/parser.dart' show parse;
import 'package:oneanime/bean/anime/anime_schedule.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:oneanime/pages/timeline/timeline_controller.dart';
import 'package:oneanime/pages/popular/popular_controller.dart';

class ListRequest {
  static List<AnimeInfo> parseAnimeList(dynamic data) {
    if (data is! List) {
      return [];
    }

    final List<AnimeInfo> animeList = [];
    for (final item in data) {
      // Anime1 uses ID 0 for entries hosted on its adult site.
      if (item is List &&
          item.length >= 6 &&
          item[0] is int &&
          item[0] > 0 &&
          item.sublist(1, 6).every((field) => field is String)) {
        animeList.add(AnimeInfo.fromList(item));
      }
    }
    return animeList;
  }

  static Future getAnimeList() async {
    List<AnimeInfo> newList = [];
    final res = await Request().get(Api.animeList);
    final resJson = res.data;
    final List<AnimeInfo> list = parseAnimeList(resJson);
    if (resJson is! List) {
      debugPrint('非法的Json ${res.toString()}');
    }

    final PopularController popularController =
        Modular.get<PopularController>();

    if (list.isNotEmpty) {
      List<AnimeInfo> oldlist = popularController.list;

      debugPrint('检测到远方番剧数据库变动');
      newList.clear();
      newList.addAll(list);
      for (var oldAnime in oldlist) {
        var index =
            newList.indexWhere((newAnime) => newAnime.name == oldAnime.name);
        if (index != -1) {
          newList[index].follow = oldAnime.follow;
          newList[index].progress = oldAnime.progress;
        }
      }
      await GStorage.listCahce.clear();
      await GStorage.listCahce.addAll(newList);
      debugPrint('更新列表成功');
      return newList;
    }
    debugPrint('更新列表失败');
    return popularController.list;
  }

  static bool isSorted(List<AnimeInfo> animeList) {
    for (int i = 0; i < animeList.length - 1; i++) {
      if (animeList[i].link! < (animeList[i + 1].link ?? 0)) {
        return false;
      }
    }
    return true;
  }

  static Future getAnimeScedule(DateTime selectedDate) async {
    List<AnimeSchedule> schedules = [];
    final season = AnimeSeason(selectedDate).toString();
    final link = Api.domain + season;

    final TimelineController timelineController =
        Modular.get<TimelineController>();
    timelineController.sessonName = season;

    debugPrint('时间表链接为 $link');
    final res = await Request().get(link);
    String resString = res.data;
    try {
      var document = parse(resString);
      final tables = document.getElementsByTagName('table');
      final tbody = tables.first.nodes[1];
      for (var tr in tbody.nodes) {
        // anime1.me is also one line (so check the length to prevent it)
        if (tr.nodes.length > 1) {
          // It is in order so use an index to indicate the date
          int i = 0;
          for (var td in tr.nodes) {
            AnimeSchedule t = AnimeSchedule(td, i++);
            if (t.valid()) schedules.add(t);
          }
        }
      }

      return schedules;
    } catch (e) {
      debugPrint('服务器响应不合法 ${e.toString()}');
      return schedules;
    }
  }
}

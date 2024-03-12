import 'dart:convert';
import 'package:oneanime/request/api.dart';
import 'package:oneanime/request/request.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:flutter/material.dart';

class ListRequest {
  static Future getAnimeList() async {
    List<AnimeInfo> list = [];
    final res = await Request().get(Api.animeList);
    final resJson = res.data;
    if (resJson is List) {
      resJson.forEach((item) {
        // 0 means that it is 🔞
        if (item is List && item[0] > 0) {
          list.add(AnimeInfo.fromList(item));
        }
      });
    } else {
      debugPrint('非法的Json ${res.toString()}');
    }
    return list;
  }
}
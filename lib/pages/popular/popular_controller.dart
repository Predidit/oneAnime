import 'dart:io';
import 'dart:ffi';
import 'package:ffi/ffi.dart';

import 'package:flutter/material.dart';
import 'package:mobx/mobx.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:oneanime/request/list.dart';
import 'package:oneanime/request/video.dart';
import 'package:oneanime/pages/video/video_controller.dart';
import 'package:flutter_modular/flutter_modular.dart';
import 'package:hive/hive.dart';
import 'package:oneanime/utils/storage.dart';
import 'package:flutter_open_chinese_convert/flutter_open_chinese_convert.dart';

part 'popular_controller.g.dart';

class PopularController = _PopularController with _$PopularController;

abstract class _PopularController with Store {
  dynamic libopencc = '';
  static Box setting = GStorage.setting;
  List<AnimeInfo> list = GStorage.listCahce.values.toList();

  @observable
  ObservableList<AnimeInfo> cacheList = ObservableList<AnimeInfo>.of([]);

  double scrollOffset = 0.0;
  bool isLoadingMore = true;
  String keyword = '';

  Future getAnimeList() async {
    isLoadingMore = true;
    if (list.length >= 20) {
      cacheList.addAll(list.sublist(0, 20));
    } else {
      cacheList.addAll(list);
    }
    list = await ListRequest.getAnimeList();
    cacheList.clear();
    if (list.length >= 20) {
      cacheList.addAll(list.sublist(0, 20));
    } else {
      cacheList.addAll(list);
    }
    isLoadingMore = false;
  }

  Future onLoad() async {
    if (list.length > cacheList.length) {
      if ((list.length - cacheList.length) >= 20) {
        cacheList
            .addAll(list.sublist(cacheList.length, (cacheList.length + 20)));
        debugPrint('Popular 缓存添加完成');
      } else {
        cacheList.addAll(list.sublist(cacheList.length, list.length));
      }
    }
    isLoadingMore = false;
  }

  Future updateFollow(int link, bool status) async {
    list.asMap().forEach((index, item) {
      if (item.link == link) {
        list[index].follow = status;
        return;
      }
    });
    updateData();
  }

  Future updateAnimeProgress(int episode, String title) async {
    list.asMap().forEach((index, item) {
      if (item.name == title) {
        debugPrint('找到之前的观看记录');
        list[index].progress = episode;
        return;
      }
    });
    updateData();
  }

  Future updateData() async {
    await GStorage.listCahce.clear();
    await GStorage.listCahce.addAll(list);
  }

  Future getFullLink(String url) async {
    return await VideoRequest.getFullLink(url);
  }

  Future getPageTitle(String name) async {
    final VideoController videoController = Modular.get<VideoController>();
    videoController.title = name;
  }

  Future getVideoLink(String url, {int episode = 1}) async {
    final VideoController videoController = Modular.get<VideoController>();
    videoController.episode = episode;
    videoController.token = await VideoRequest.getVideoToken(url);
    var result = await VideoRequest.getVideoLink(
        videoController.token[videoController.token.length - episode]);
    videoController.videoUrl = result['link'];
    videoController.videoCookie = result['cookie'];
  }

  void filterList(String keyword) async {
    this.keyword = keyword;
    if (setting.get(SettingBoxKey.searchEnhanceEnable, defaultValue: true)) {
      keyword = await chineseS2TW(keyword);
    }
    cacheList.clear();
    cacheList.addAll(list.where((e) {
      return e.contains(keyword);
    }).toList());
  }

  AnimeInfo? lookupAnime(String name) {
    AnimeInfo? ret;
    list.asMap().forEach((key, value) {
      if (value.name == name) {
        ret = value;
      }
    });
    return ret;
  }

  Future<String> chineseS2TW(String keyword) async {
    if ((Platform.isAndroid || Platform.isIOS)) {
      try {
        debugPrint('开始转换关键词');
        keyword = await ChineseConverter.convert(keyword, S2TWp());
        debugPrint('转换后的关键词为 $keyword');
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    // OpenCC windows库调用
    if ((Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      if (libopencc == '') {
        return keyword;
      }
      try {
        Pointer<Utf8> cString = keyword.toNativeUtf8();
        Pointer<Utf8> resCString = libopencc.TranS2TW(cString);
        keyword = resCString.toDartString();
      } catch (e) {
        debugPrint(e.toString());
        debugPrint('发生错误 ${e.toString()}');
      }
    }
    return keyword;
  }

  Future<String> chineseTW2S(String keyword) async {
    if ((Platform.isAndroid || Platform.isIOS)) {
      try {
        debugPrint('开始转换关键词');
        keyword = await ChineseConverter.convert(keyword, TW2S());
        debugPrint('转换后的关键词为 $keyword');
      } catch (e) {
        debugPrint(e.toString());
      }
    }
    // OpenCC windows库调用
    if ((Platform.isWindows || Platform.isLinux || Platform.isMacOS)) {
      if (libopencc == '') {
        return keyword;
      }
      try {
        Pointer<Utf8> cString = keyword.toNativeUtf8();
        Pointer<Utf8> resCString = libopencc.TranTW2S(cString);
        keyword = resCString.toDartString();
      } catch (e) {
        debugPrint(e.toString());
        debugPrint('发生错误 ${e.toString()}');
      }
    }
    return keyword;
  }
}

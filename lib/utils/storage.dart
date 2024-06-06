import 'dart:ffi';
import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';
import 'package:oneanime/bean/anime/anime_info.dart';
import 'package:oneanime/bean/anime/anime_history.dart';

class GStorage {
  static late final Box<dynamic> localCache;
  static late final Box<dynamic> userInfo;
  static late final Box<dynamic> setting;
  static late final Box<AnimeInfo> listCahce;
  static late final Box<AnimeHistory> history;

  static Future<void> init() async {
    final Directory dir = await getApplicationSupportDirectory();
    final String path = dir.path;
    await Hive.initFlutter('$path/hive');
    debugPrint('缓存目录为 $path/hive');
    regAdapter();
    setting = await Hive.openBox('setting');
    listCahce = await Hive.openBox<AnimeInfo>('anime_info_box');
    history = await Hive.openBox('history');

    // 本地缓存
    localCache = await Hive.openBox(
      'localCache',
      compactionStrategy: (int entries, int deletedEntries) {
        return deletedEntries > 4;
      },
    );
    debugPrint('GStorage 初始化完成');
  }

  // Todo 所有者相关
  static void regAdapter() {
    Hive.registerAdapter(AnimeInfoAdapter());
    Hive.registerAdapter(AnimeHistoryAdapter());
  }

  static Future<void> close() async {
    userInfo.compact();
    userInfo.close();
    localCache.compact();
    localCache.close();
    setting.compact();
    setting.close();
  }
}

class LocalCacheKey {
  // 历史记录暂停状态 默认false 记录
  static const String historyPause = 'historyPause',
      // 代理host port
      systemProxyHost = 'systemProxyHost',
      systemProxyPort = 'systemProxyPort';
}

class SettingBoxKey {
  static const String HAenable = 'HAenable',
      searchEnhanceEnable = 'searchEnhanceEnable', 
      // Todo 检查更新
      autoUpdate = 'autoUpdate',
      alwaysOntop = 'alwaysOntop',
      danmakuEnhance = 'danmakuEnhance',
      danmakuBorder = 'danmakuBorder',
      danmakuOpacity = 'danmakuOpacity',
      danmakuFontSize = 'danmakuFontSize',
      danmakuTop = 'danmakuTop',
      danmakuScroll = 'danmakuScroll',
      danmakuBottom = 'danmakuBottom',
      danmakuArea = 'danmakuArea',
      danmakuEnabledByDefault = 'danmakuEnabledByDefault',
      themeMode = 'themeMode',
      themeColor = 'themeColor',
      privateMode = 'privateMode',
      autoPlay = 'autoPlay',
      playResume = 'playResume',
      oledEnhance = 'oledEnhance',
      displayMode = 'displayMode',
      enableSystemProxy = 'enableSystemProxy';
}

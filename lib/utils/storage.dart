import 'dart:io';

import 'package:flutter/material.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:path_provider/path_provider.dart';

class GStorage {
  static late final Box<dynamic> localCache;
  static late final Box<dynamic> userInfo;
  static late final Box<dynamic> setting;

  static Future<void> init() async {
    final Directory dir = await getApplicationSupportDirectory();
    final String path = dir.path;
    await Hive.initFlutter('$path/hive');
    regAdapter();
    setting = await Hive.openBox('setting');

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
  static void regAdapter() {}

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
      // Todo 检查更新
      autoUpdate = '';
}
